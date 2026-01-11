FROM python:3.12-slim-bookworm

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Set working directory
WORKDIR /app

# Enable bytecode compilation
ENV UV_COMPILE_BYTECODE=1

# Copy dependency files
COPY pyproject.toml uv.lock ./

# Install dependencies
RUN uv sync --frozen --no-install-project --no-dev

# Copy the rest of the application
COPY . .

# Install the project itself
RUN uv sync --frozen --no-dev

# Set environment variables
ENV PATH="/app/.venv/bin:$PATH"
# Default to host.docker.internal for Mac/Windows compatibility
# For Linux, you might need to use --network="host" or the gateway IP
ENV JOPLIN_BASE_URL="http://host.docker.internal:41185"

# Run the application
CMD ["uv", "run", "src/mcp/joplin_mcp.py"]
