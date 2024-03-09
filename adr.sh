#!/bin/bash
# https://github.com/luisbelloch/adr.sh

set -eou pipefail

if [[ $# -eq 0 ]]; then
    >&2 echo "Usage: $0 <title words...>"
    exit 1
fi

prefix="${ADR_PREFIX:-adr}"
outdir="${ADR_FOLDER:-.}"
template="${ADR_TEMPLATE:-${outdir}/template.md}"

mkdir -p "$outdir"

if ! [[ -f "$template" ]]; then
    cat <<EOF > "$template"
# EX001. Your title goes here

## Status

[Proposed, Accepted, Deprecated, Superseded]

## Context

## Decision

## Consequences
EOF
fi

title=$(echo "$*" | tr '[:upper:]' '[:lower:]' | tr -s '[:blank:]' '_')
last_doc=$(find "$outdir" -type f -name "${prefix}*.md" | sort | tail -n 1)

if [[ -n $last_doc ]]; then
    last_number=$(echo $last_doc | sed -e "s/.*${prefix}\([0-9]*\).*/\1/")
    next_number=$((last_number + 1))
else
    next_number=1
fi

new_id=$(printf "%s%03d" "$prefix" "$next_number")
new_file_name=$(printf "%s_%s.md" "$new_id" "$title")

awk -v id="$new_id" -v title="$*" '
    /EX001/ {
        print "# " toupper(id) ". " toupper(substr(title, 1, 1)) substr(title, 2);
        next;
    }
    1' "$template" > "$outdir/$new_file_name"

>&2 echo "Created ADR: $new_file_name"
