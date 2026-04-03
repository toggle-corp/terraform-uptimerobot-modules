#!/usr/bin/env bash
set -euo pipefail

# ----------------------
# Script directory
# ----------------------
SCRIPT_DIRECTORY="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIRECTORY" || exit 1
echo "📂 Working from script directory: $SCRIPT_DIRECTORY"

# ----------------------
# Output functions
# ----------------------
echo_info()    { echo -e "\033[0;34mℹ️  $1\033[0m"; }
echo_warning() { echo -e "\033[1;33m⚠️  $1\033[0m"; }
echo_error()   { echo -e "\033[0;31m❌ $1\033[0m"; }
echo_success() { echo -e "\033[0;32m✅ $1\033[0m"; }

# ----------------------
# Flags
# ----------------------
VALID_MODE=false
if [[ "${1:-}" == "--validate" ]]; then
    VALID_MODE=true
    echo_info "Running in validation mode (--validate)"
fi

# ----------------------
# Terraform & provider content
# ----------------------
TERRAFORM_VERSION=">= 1.11.0"
export TERRAFORM_VERSION

PROVIDER_FILE_CONTENT=$(cat <<EOF
# GENERATED FILE — DO NOT EDIT
terraform {
  required_version = "$TERRAFORM_VERSION"

  required_providers {
    uptimerobot = {
      source  = "uptimerobot/uptimerobot"
      version = ">= 1.4"
    }
  }
}
EOF
)

EXIT_CODE=0

# ----------------------
# Helper: show diff
# ----------------------
show_diff() {
    local file="$1"
    local temp_file
    temp_file=$(mktemp)
    echo "$PROVIDER_FILE_CONTENT" > "$temp_file"

    if command -v delta >/dev/null 2>&1; then
        delta "$temp_file" "$file" || true
    else
        diff -u "$temp_file" "$file" || true
    fi

    rm -f "$temp_file"
}

# ----------------------
# 0️⃣ Validate / Update .terraform-version
# ----------------------
TF_FILE=".terraform-version"
if [ -f "$TF_FILE" ]; then
    CURRENT_TF_VERSION=$(<"$TF_FILE")
    if [ "$CURRENT_TF_VERSION" != "$TERRAFORM_VERSION" ]; then
        echo_warning "$TF_FILE version mismatch! Expected: $TERRAFORM_VERSION, Found: $CURRENT_TF_VERSION"
        EXIT_CODE=1
        if [ "$VALID_MODE" = false ]; then
            echo_warning "Updating $TF_FILE to $TERRAFORM_VERSION..."
            echo "$TERRAFORM_VERSION" > "$TF_FILE"
            echo_success "Updated $TF_FILE"
        fi
    else
        echo_success "$TF_FILE is up-to-date"
    fi
else
    echo_warning "$TF_FILE is missing!"
    EXIT_CODE=1
    if [ "$VALID_MODE" = false ]; then
        echo_warning "Creating $TF_FILE with version $TERRAFORM_VERSION..."
        echo "$TERRAFORM_VERSION" > "$TF_FILE"
        echo_success "Created $TF_FILE"
    fi
fi

# ----------------------
# 1️⃣ Check / Update each module
# ----------------------
for module in modules/*; do
    [ -d "$module" ] || continue

    target="$module/versions.tf"

    if [ ! -f "$target" ]; then
        echo_warning "$target is missing!"
        EXIT_CODE=1
        if [ "$VALID_MODE" = false ]; then
            echo_warning "Creating $target..."
            echo "$PROVIDER_FILE_CONTENT" > "$target"
            echo_success "Created $target"
        fi
        continue
    fi

    current_content=$(<"$target")

    if [[ "$PROVIDER_FILE_CONTENT" != "$current_content" ]]; then
        echo_warning "$target is outdated!"
        show_diff "$target"
        EXIT_CODE=1

        if [ "$VALID_MODE" = false ]; then
            echo_warning "Updating $target..."
            echo "$PROVIDER_FILE_CONTENT" > "$target"
            echo_success "Updated $target"
        fi
    else
        echo_success "$target is up-to-date"
    fi
done

# ----------------------
# 3️⃣ Exit
# ----------------------
if [ "$VALID_MODE" = true ] && [ "$EXIT_CODE" -ne 0 ]; then
    echo ""
    echo_error "Validation failed! Some files are outdated. Run without --validate to update."
fi

exit $EXIT_CODE
