#!/usr/bin/env bash
# add_patch_import.sh - Ensure monkey-patch loader is added to client/__init__.py

CLIENT_INIT="../kubernetes/client/__init__.py"

# Normalize Windows-style backslashes to Unix-style forward slashes
CLIENT_INIT="$(echo "$CLIENT_INIT" | sed 's|\\|/|g')"

# Ensure file exists
if [ ! -f "$CLIENT_INIT" ]; then
  echo "Error: $CLIENT_INIT does not exist." >&2
  exit 1
fi

PATCH_SNIPPET='try:
    import kubernetes.client.helpers.patch as _patch
    _patch.apply_patch()
except ImportError:
    pass'

# Check if snippet already exists
if grep -q "your_project.k8s_helpers.patch" "$CLIENT_INIT"; then
  echo "Patch snippet already present in $CLIENT_INIT, skipping."
else
  echo "" >> "$CLIENT_INIT"
  echo "$PATCH_SNIPPET" >> "$CLIENT_INIT"
  echo "Patch snippet added to $CLIENT_INIT."
fi
