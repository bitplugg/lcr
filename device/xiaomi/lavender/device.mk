#
# LCR (Lavender Custom Recovery) - device.mk
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := device/xiaomi/lavender

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# Classic (non-dynamic) partitions, system-as-root, dedicated recovery partition
PRODUCT_SHIPPING_API_LEVEL := 28
PRODUCT_USE_DYNAMIC_PARTITIONS := false

# Do not enforce VINTF (recovery bundles its own vendor manifest)
PRODUCT_ENFORCE_VINTF_MANIFEST := false

# Properties
# NOTE: system.prop is auto-detected via $(TARGET_DEVICE_DIR)/system.prop.
# Do NOT set TARGET_SYSTEM_PROP with $(LOCAL_PATH): the variable is expanded
# lazily (by build/make/core/sysprop.mk) after LOCAL_PATH has been reset,
# which corrupts the path.

PRODUCT_PROPERTY_OVERRIDES += \
    ro.hardware.keystore=sdm660 \
    ro.hardware.gatekeeper=sdm660 \
    ro.adb.secure=0 \
    ro.secure=1
