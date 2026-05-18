SHELL := /bin/bash

.PHONY: dump-schema check-data check-data-noninteractive

dump-schema:
	@source .env && pg_dump -U $$DB_USER -h $$DB_HOST -d $$DB_NAME -s -t 'public.*' > ./schema/schema.sql

check-data:
	@python3 scripts/check_survey_data.py

check-data-noninteractive:
	@python3 scripts/check_survey_data.py --no-interactive
