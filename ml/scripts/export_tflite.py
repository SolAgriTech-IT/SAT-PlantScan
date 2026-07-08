#!/usr/bin/env python3
"""Export trained SAT-PlantScan model to TensorFlow Lite."""

from __future__ import annotations

import argparse
import json
import shutil
from pathlib import Path

import tensorflow as tf
import yaml


def load_config(config_path: Path) -> dict:
    with config_path.open(encoding="utf-8") as handle:
        return yaml.safe_load(handle)


def main() -> None:
    parser = argparse.ArgumentParser(description="Export SAT-PlantScan TFLite model")
    parser.add_argument(
        "--config",
        default=str(Path(__file__).resolve().parent.parent / "config" / "labels.yaml"),
    )
    args = parser.parse_args()

    config = load_config(Path(args.config))
    ml_root = Path(__file__).resolve().parent.parent
    artifacts = ml_root / config["output_dir"]
    saved_model_dir = artifacts / "saved_model"
    if not saved_model_dir.exists():
        raise SystemExit("Saved model not found. Run train.py first.")

    converter = tf.lite.TFLiteConverter.from_saved_model(str(saved_model_dir))
    converter.optimizations = [tf.lite.Optimize.DEFAULT]
    tflite_model = converter.convert()

    tflite_path = artifacts / "sat_plantscan_cassava.tflite"
    tflite_path.write_bytes(tflite_model)

    metadata_path = artifacts / "model_metadata.json"
    metadata = json.loads(metadata_path.read_text(encoding="utf-8"))
    labels_path = artifacts / "labels.txt"
    labels_path.write_text("\n".join(metadata["class_names"]) + "\n", encoding="utf-8")

    app_assets = ml_root.parent / "app" / "assets" / "models"
    app_assets.mkdir(parents=True, exist_ok=True)
    shutil.copy2(tflite_path, app_assets / "sat_plantscan_cassava.tflite")
    shutil.copy2(labels_path, app_assets / "labels.txt")
    print(f"TFLite model exported to {tflite_path}")
    print(f"Copied to {app_assets}")


if __name__ == "__main__":
    main()
