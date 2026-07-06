create_uv_environment:
	uv sync --all-groups

uv_test:
	uv run pytest
