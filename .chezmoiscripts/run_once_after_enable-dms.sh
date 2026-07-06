#!/bin/bash
set -eu

if command -v systemctl >/dev/null && systemctl --user list-unit-files dms.service >/dev/null 2>&1; then
    systemctl --user enable dms.service
fi
