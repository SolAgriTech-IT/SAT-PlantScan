# SAT-PlantScan ML Pipeline

## Architecture choice

**EfficientNet-B0 exported to TensorFlow Lite** (float32, optional quantization).

| Criterion | EfficientNet-Lite | MobileNetV3 | YOLOv11 |
|-----------|-------------------|-------------|---------|
| Multi-class leaf classification | Excellent | Good | Overkill (detection) |
| Small dataset + transfer learning | Excellent | Good | Needs more data |
| On-device latency | Low | Very low | Higher |
| Memory footprint | Moderate | Low | High |

YOLO is better when bounding boxes are required. SAT-PlantScan v1 performs **whole-image classification** after guided capture, so EfficientNet is the justified default.

## Workflow

```bash
cd ml
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt

python scripts/prepare_dataset.py
python scripts/train.py
python scripts/export_tflite.py
```

Outputs:

- `ml/artifacts/dataset/` — train/val/test splits with augmentation
- `ml/artifacts/saved_model/` — Keras saved model
- `ml/artifacts/sat_plantscan_cassava.tflite` — mobile model
- `app/assets/models/` — copied model + labels for Flutter

## Data augmentation

Applied automatically on the training split:

- rotation, flip, brightness, contrast, color jitter, blur, zoom crop

Synthetic `_gen` images from `Cultures/Cassava/process_images.py` are included when present.

## Generative synthetic data

Not enabled by default. With only ~230 images, classical augmentation is preferred to avoid generative bias. Enable generative augmentation only after measuring a validated performance gain on the held-out test split.
