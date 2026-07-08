#!/usr/bin/env python3
"""Prepare SAT-PlantScan training dataset from Cultures/Cassava folders."""

from __future__ import annotations

import argparse
import random
import shutil
from pathlib import Path

import yaml
from PIL import Image, ImageEnhance, ImageFilter, ImageOps

IMAGE_EXTS = {".jpg", ".jpeg", ".png", ".webp", ".gif", ".bmp"}


def load_config(config_path: Path) -> dict:
    with config_path.open(encoding="utf-8") as handle:
        return yaml.safe_load(handle)


def is_image(path: Path) -> bool:
    return path.suffix.lower() in IMAGE_EXTS


def augment_image(image: Image.Image) -> Image.Image:
    ops = random.choice(
        [
            lambda img: img.rotate(random.choice([90, 180, 270]), expand=True),
            lambda img: ImageOps.mirror(img),
            lambda img: ImageOps.flip(img),
            lambda img: ImageEnhance.Brightness(img).enhance(random.uniform(0.7, 1.3)),
            lambda img: ImageEnhance.Contrast(img).enhance(random.uniform(0.8, 1.25)),
            lambda img: ImageEnhance.Color(img).enhance(random.uniform(0.85, 1.2)),
            lambda img: img.filter(ImageFilter.GaussianBlur(radius=0.6)),
        ]
    )
    return ops(image.convert("RGB"))


def collect_images(source_root: Path, folders: list[str]) -> list[Path]:
    images: list[Path] = []
    for folder in folders:
        target = source_root / folder
        if not target.exists():
            continue
        for path in target.rglob("*"):
            if path.is_file() and is_image(path):
                images.append(path)
    return images


def split_items(items: list[Path], val_ratio: float, test_ratio: float) -> tuple[list[Path], list[Path], list[Path]]:
    random.shuffle(items)
    total = len(items)
    test_count = max(1, int(total * test_ratio)) if total > 2 else 0
    val_count = max(1, int(total * val_ratio)) if total > 2 else 0
    test_items = items[:test_count]
    val_items = items[test_count : test_count + val_count]
    train_items = items[test_count + val_count :]
    if not train_items and items:
        train_items = items[:-1]
        val_items = items[-1:]
    return train_items, val_items, test_items


def copy_or_augment(
    items: list[Path],
    destination: Path,
    augmentation_factor: int,
    augment: bool,
) -> int:
    destination.mkdir(parents=True, exist_ok=True)
    written = 0
    for index, source in enumerate(items):
        target = destination / f"{source.stem}_{index}{source.suffix.lower()}"
        shutil.copy2(source, target)
        written += 1
        if augment:
            with Image.open(source) as img:
                for aug_index in range(augmentation_factor):
                    augmented = augment_image(img)
                    aug_target = destination / f"{source.stem}_{index}_aug{aug_index}.jpg"
                    augmented.save(aug_target, "JPEG", quality=92)
                    written += 1
    return written


def main() -> None:
    parser = argparse.ArgumentParser(description="Prepare SAT-PlantScan dataset")
    parser.add_argument(
        "--config",
        default=str(Path(__file__).resolve().parent.parent / "config" / "labels.yaml"),
    )
    parser.add_argument("--seed", type=int, default=42)
    args = parser.parse_args()

    random.seed(args.seed)
    config = load_config(Path(args.config))
    ml_root = Path(__file__).resolve().parent.parent
    source_root = (ml_root / config["dataset_source"]).resolve()
    output_root = (ml_root / config["output_dir"] / "dataset").resolve()
    if output_root.exists():
        shutil.rmtree(output_root)

    summary: dict[str, int] = {}
    for class_def in config["classes"]:
        class_id = class_def["id"]
        images = collect_images(source_root, class_def["folders"])
        if not images:
            print(f"WARNING: no images for class {class_id}")
            continue

        train_items, val_items, test_items = split_items(
            images,
            config["validation_split"],
            config["test_split"],
        )

        for split_name, split_items in [
            ("train", train_items),
            ("val", val_items),
            ("test", test_items),
        ]:
            count = copy_or_augment(
                split_items,
                output_root / split_name / class_id,
                augmentation_factor=config["augmentation_factor"],
                augment=split_name == "train",
            )
            summary[f"{split_name}/{class_id}"] = count

    print(f"Dataset prepared at {output_root}")
    for key, value in sorted(summary.items()):
        print(f"  {key}: {value}")


if __name__ == "__main__":
    main()
