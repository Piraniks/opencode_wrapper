.PHONY: init create_uv_environment uv_test

init:
	@mkdir -p opencode.local
	@if [ ! -f opencode.local/opencode.json ]; then \
		printf '{\n  "$$schema": "https://opencode.ai/config.json"\n}\n' > opencode.local/opencode.json; \
		echo "created opencode.local/opencode.json"; \
	else \
		echo "opencode.local/opencode.json already exists"; \
	fi

create_uv_environment:
	uv sync --all-groups

uv_test:
	uv run pytest
