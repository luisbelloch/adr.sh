#!/bin/bash
# https://github.com/luisbelloch/adr.sh

set -eou pipefail

creates_initial_file() {
    (./adr.sh initial test) 1>/dev/null 2>&1
    assert test -f "adr001_initial_test.md"
}

created_file_shares_template() {
    assert cmp -s <(tail -n +2 adr001_initial_test.md) <(tail -n +2 template.md)
}

next_one_increases_numeration() {
    (./adr.sh second test) 1>/dev/null 2>&1
    assert test -f "adr002_second_test.md"
}

numeration_is_also_increased_in_copied_template() {
    (./adr.sh third case) 1>/dev/null 2>&1
    assert grep -q "ADR003" adr003_third_case.md
}

prefix_can_be_overriden() {
    (ADR_PREFIX=bar ./adr.sh new prefix) 1>/dev/null 2>&1
    assert grep -q "BAR001" bar001_new_prefix.md
}

use_default_template_when_it_does_not_exists() {
    (ADR_TEMPLATE=unknown.md ./adr.sh unknown template) 1>/dev/null 2>&1
    assert grep -q "ADR004. Unknown template" adr004_unknown_template.md
}

creates_output_dir_when_it_does_not_exists() {
    (ADR_FOLDER=tmp ./adr.sh new folder) 1>/dev/null 2>&1
    assert grep -q "ADR001. New folder" tmp/adr001_new_folder.md
}

clean() {
    find . -name "*.md" ! -name 'template.md' ! -name 'README.md' -type f -delete
    rm -rf tmp*
}

if [ -t 1 ] && tput colors &> /dev/null; then
    readonly c_ok="$(tput setaf 2)"
    readonly c_error="$(tput setaf 1)"
    readonly c_norm="$(tput sgr0)"
else
    readonly c_ok=""
    readonly c_error=""
    readonly c_norm=""
fi

stderr() { >&2 echo "$@"; }
pass() { stderr "${c_ok}PASS${c_norm} $@"; }
fail() { stderr "${c_error}FAIL${c_norm} $@"; }

assert() {
    if "$@"; then
        pass "$(caller 0 | awk '{print $2}')"
    else
        fail "$(caller 0 | awk '{print $2}')"
    fi
}

creates_initial_file
created_file_shares_template
next_one_increases_numeration
numeration_is_also_increased_in_copied_template
prefix_can_be_overriden
use_default_template_when_it_does_not_exists
creates_output_dir_when_it_does_not_exists

clean
