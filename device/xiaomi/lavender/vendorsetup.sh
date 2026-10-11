#
# LCR (Lavender Custom Recovery) - build environment addon
#
if [ -n "$BASH_SOURCE" ]; then
    _LCR_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
elif [ -n "$ZSH_VERSION" ]; then
    _LCR_DIR="$(cd "$(dirname "${(%):-%N}")" && pwd)"
else
    _LCR_DIR="$(cd "$(dirname "$0")" && pwd)"
fi

export LCR_DEVICE_DIR="$_LCR_DIR"
export ALLOW_MISSING_DEPENDENCIES=true

echo "LCR: build environment ready (lavender / lavenderin)"
