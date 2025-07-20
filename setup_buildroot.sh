#!/bin/bash
TOPDIR=$(pwd)

if [ -z "$1" ] ; then
    echo "Usage: $0 <extract buildroot folder_name> <board_defconfig>"
    exit 1
fi

TAR_FILE="buildroot-2023.05.tar.gz"
TARGET_NAME="$1"
PRODUCT_CFG="${2:-rpi4_defconfig}"
TMP_PRODUCT_CFG_FILE="/tmp/expk_defconfig"


if [ ! -f "$TAR_FILE" ]; then
    echo "Error: $TAR_FILE not found"
    exit 2
fi

if [ -d "$TARGET_NAME" ]; then
    echo "$TARGET_NAME already exists, skip extraction"
else
    # List the top-level directory in tar.gz
    EXTRACTED_DIR=$(tar -tzf "$TAR_FILE" | head -n1 | cut -d/ -f1)

    # Extract tar.gz quietly
    tar -xzf "$TAR_FILE"

    # Rename if needed
    if [ "$EXTRACTED_DIR" != "$TARGET_NAME" ]; then
        mv "$EXTRACTED_DIR" "$TARGET_NAME"
    fi

    echo "Buildroot extracted and renamed to: $TARGET_NAME"
fi

BUILDROOT_DIR="$TOPDIR/$TARGET_NAME"
EX_DIR="$TOPDIR/expk"

echo "TOPDIR = $TOPDIR"
echo "BUILDROOT_DIR = $BUILDROOT_DIR"
echo "EX_DIR = $EX_DIR"

echo
tput smso 2> /dev/null
echo ">>> Binding expk/local.mk to buildroot"
tput rmso 2> /dev/null
rm -f "$BUILDROOT_DIR/local.mk"
ln -sf "$EX_DIR/local.mk" "$BUILDROOT_DIR/local.mk"
echo "Done"

cd "$BUILDROOT_DIR"
ln -snf "$EX_DIR" expk

if ! make BR2_EXTERNAL="$EX_DIR" "$PRODUCT_CFG"; then
    echo "Error: make product config failed."
    echo "command: make BR2_EXTERNAL=$EX_DIR $PRODUCT_CFG"
    echo "Have a check on $EX_DIR/configs."
    exit 1
fi
echo "make $PRODUCT_CFG to .config"
echo "$PRODUCT_CFG" > "$TMP_PRODUCT_CFG_FILE"
echo "Setup finished. You can now:"
echo "  cd $TARGET_NAME"
echo "  make"
