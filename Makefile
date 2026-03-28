.PHONY: generate lint breaking check test build

# Generate Swift code from proto files using Docker.
# Cleans old output first so stale files from renamed/deleted protos don't linger.
generate:
	rm -rf Sources/RecurrenceProtobuf/Generated
	mkdir -p Sources/RecurrenceProtobuf/Generated
	docker compose up --build

# Lint proto files.
lint:
	buf lint

# Check for breaking changes against the main branch.
breaking:
	buf breaking --against '.git#branch=main'

# Run lint + breaking change detection (mirrors CI).
check: lint breaking

# Build the Swift package.
build:
	swift build

# Run all tests.
test:
	swift test
