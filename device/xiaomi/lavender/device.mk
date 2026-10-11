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
TARGET_SYSTEM_PROP += $(LOCAL_PATH)/system.prop

PRODUCT_PROPERTY_OVERRIDES += \
    ro.hardware.keystore=sdm660 \
    ro.hardware.gatekeeper=sdm660 \
    ro.adb.secure=0 \
    ro.secure=1
