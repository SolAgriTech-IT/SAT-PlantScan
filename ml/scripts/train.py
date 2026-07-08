#!/usr/bin/env python3
"""Train EfficientNet-Lite0 classifier for SAT-PlantScan."""

from __future__ import annotations

import argparse
import json
from pathlib import Path

import tensorflow as tf
import yaml


def load_config(config_path: Path) -> dict:
    with config_path.open(encoding="utf-8") as handle:
        return yaml.safe_load(handle)


def build_model(num_classes: int, image_size: int) -> tf.keras.Model:
    base = tf.keras.applications.EfficientNetB0(
        include_top=False,
        weights="imagenet",
        input_shape=(image_size, image_size, 3),
        pooling="avg",
    )
    base.trainable = False
    inputs = tf.keras.Input(shape=(image_size, image_size, 3))
    x = tf.keras.applications.efficientnet.preprocess_input(inputs)
    x = base(x, training=False)
    x = tf.keras.layers.Dropout(0.25)(x)
    outputs = tf.keras.layers.Dense(num_classes, activation="softmax")(x)
    model = tf.keras.Model(inputs, outputs)
    model.compile(
        optimizer=tf.keras.optimizers.Adam(learning_rate=1e-3),
        loss="categorical_crossentropy",
        metrics=["accuracy"],
    )
    return model, base


def main() -> None:
    parser = argparse.ArgumentParser(description="Train SAT-PlantScan vision model")
    parser.add_argument(
        "--config",
        default=str(Path(__file__).resolve().parent.parent / "config" / "labels.yaml"),
    )
    args = parser.parse_args()

    config = load_config(Path(args.config))
    ml_root = Path(__file__).resolve().parent.parent
    dataset_dir = ml_root / config["output_dir"] / "dataset"
    if not dataset_dir.exists():
        raise SystemExit("Dataset not found. Run prepare_dataset.py first.")

    image_size = config["image_size"]
    train_ds = tf.keras.utils.image_dataset_from_directory(
        dataset_dir / "train",
        image_size=(image_size, image_size),
        batch_size=config["batch_size"],
        label_mode="categorical",
    )
    val_ds = tf.keras.utils.image_dataset_from_directory(
        dataset_dir / "val",
        image_size=(image_size, image_size),
        batch_size=config["batch_size"],
        label_mode="categorical",
    )

    class_names = train_ds.class_names
    num_classes = len(class_names)
    autotune = tf.data.AUTOTUNE
    train_ds = train_ds.cache().shuffle(256).prefetch(autotune)
    val_ds = val_ds.cache().prefetch(autotune)

    model, base = build_model(num_classes, image_size)
    callbacks = [
        tf.keras.callbacks.EarlyStopping(patience=5, restore_best_weights=True),
        tf.keras.callbacks.ReduceLROnPlateau(patience=3, factor=0.5),
    ]
    model.fit(
        train_ds,
        validation_data=val_ds,
        epochs=config["epochs"],
        callbacks=callbacks,
    )

    base.trainable = True
    for layer in base.layers[:-40]:
        layer.trainable = False
    model.compile(
        optimizer=tf.keras.optimizers.Adam(learning_rate=config["learning_rate"]),
        loss="categorical_crossentropy",
        metrics=["accuracy"],
    )
    model.fit(
        train_ds,
        validation_data=val_ds,
        epochs=max(5, config["epochs"] // 3),
        callbacks=callbacks,
    )

    artifacts = ml_root / config["output_dir"]
    artifacts.mkdir(parents=True, exist_ok=True)
    saved_model_dir = artifacts / "saved_model"
    model.save(saved_model_dir, include_optimizer=False)

    metadata = {
        "architecture": "EfficientNetB0",
        "justification": (
            "EfficientNet offers the best accuracy/latency trade-off for on-device "
            "multi-class leaf disease classification with transfer learning on small datasets."
        ),
        "class_names": class_names,
        "image_size": image_size,
    }
    (artifacts / "model_metadata.json").write_text(
        json.dumps(metadata, indent=2),
        encoding="utf-8",
    )
    print(f"Model saved to {saved_model_dir}")


if __name__ == "__main__":
    main()
