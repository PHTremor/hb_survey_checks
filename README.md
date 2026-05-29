# HB Survey Checks

CLI scripts to check whether survey data was added in PostgreSQL tables, what is missing, and how many records exist by module, table, and health center.

## Setup

1. Ensure VPN is connected.
2. Install dependencies:

```bash
python3 -m pip install -r requirements.txt
```

3. Ensure `.env` contains valid `DB_*` values.

## Run

Interactive mode:

```bash
make check-data
```

Non-interactive mode:

```bash
make check-data-noninteractive
```

### Interactive mode features

When running in interactive mode, the tool presents numbered lists for:

- **Districts**: Lists all districts from districts.district table (enter numbers: `1` or `1,3,5`)
- **Health centers**: After district selection, lists facilities from the selected district(s) (enter numbers: `2` or `2,4,7`)
- **Survey years**: Lists unique survey_year values from qr_codes (enter numbers: `2` or `1,2,3`)
- **Projects**: Lists active projects where status_id=1 from projects table (enter numbers: `4` or `1,2,4`)

Press Enter to skip any selection and use defaults/all data. For health centers, leaving it empty selects all health centers.

### Non-interactive (CLI) mode examples

```bash
python3 scripts/check_survey_data.py --district "Nyabihu" --year 2024 --no-interactive
```

```bash
python3 scripts/check_survey_data.py --district-id "5ad45f46-84ca-4820-82c0-562b0d3ff12b" --year "2025%" --no-interactive
```

With project selection:

```bash
python3 scripts/check_survey_data.py --district "Nyabihu" --projects "proj-id-1,proj-id-2" --no-interactive
```

## Outputs

Each run writes a timestamped folder under `reports/` named after the district and date:

- Example: `Nyabihu_20260518_145030/`

Contains:

The folder name format is: `{district_name}_{YYYYMMDD}_{HHMMSS}` where `district_name` comes from the districts.district table (or "all_districts" if no district filter is applied).

Example: `Nyabihu_20260518_145030/` (for Nyabihu district, May 18, 2026, 14:50:30)

Each folder contains:

- `health_center_summary.xlsx` — Multi-sheet workbook with:
    - **Overview** sheet: module-level totals with missing record counts
    - **Module sheets**: one per module, only for modules with missing data
        - Rows only shown where missing_records > 0
        - Sorted by health center and table
    - **Projects** sheet (when `--projects` flag is used): project data by health center
        - Columns: Project ID, Project Name, Health Center, Items Recorded
        - Shows actual recorded items per project per facility from project_data table
- `report.md` — Human-readable report grouped by health center and module
    - Only lists health centers and modules with missing data
    - Format: table_name (added:#/expected:#; missing:#)

## Notes

- Requested tables that do not exist in the schema are reported as `NOT_IMPLEMENTED`.
- Project checks are independent from `qr_codes` because surveys are not linked to projects in current schema.
- Year filtering accepts exact value, wildcard (`%`), or a 4-digit year prefix.
- **Excluded tables**:
    - Patient Satisfaction: only `patient_satisfaction_basic_infos` (other satisfaction tables excluded)
    - Pharmacy Management: `PharmacyDrugs` excluded
- **Excel workbook features**:
    - Overview sheet shows module-level summaries with total missing records
    - Empty module sheets (zero missing records) are hidden
    - All sheets have frozen headers, auto-filters, and auto-sized columns
    - Only rows with missing_records > 0 are shown in module sheets
- **Markdown report**: grouped by health center and module, only showing items with missing data
