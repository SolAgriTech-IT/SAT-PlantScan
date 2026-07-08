# SAT-PlantScan Knowledge Base

Normalized JSON disease sheets reusable across all crops.

## Cassava (v1)

- `crops/cassava/manifest.json` — crop metadata
- `crops/cassava/diseases.json` — 13 standardized disease/pest/disorder sheets
- `crops/cassava/questionnaire.json` — biotic + abiotic dichotomous questions

Each disease sheet includes:

- Scientific and common names (FR/EN)
- Category, affected organs, symptoms, agents, vectors
- Prevention and control (from `/Ouvrages` and FAO references)
- Severity, capture targets, bibliographic references

## Schema

See `schema/disease_sheet.schema.json`.

## Sync to mobile app

```powershell
Copy-Item knowledge_base/crops/cassava/* app/assets/knowledge/crops/cassava/ -Force
```

Or run `scripts/setup_app.ps1`.
