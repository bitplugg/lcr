#
# LCR (Lavender Custom Recovery)
# Redmi Note 7 (lavender)
# SPDX-License-Identifier: Apache-2.0
#

# Release name
PRODUCT_RELEASE_NAME := lavender

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_minimal.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Inherit from lavender device
$(call inherit-product, device/xiaomi/lavender/device.mk)

# Inherit common TWRP configuration
$(call inherit-product, vendor/twrp/config/common.mk)

## Device identifier. This must come after all inclusions
PRODUCT_BRAND := Xiaomi
PRODUCT_DEVICE := lavender
PRODUCT_MANUFACTURER := Xiaomi
PRODUCT_NAME := twrp_lavender
PRODUCT_MODEL := Redmi Note 7 / Note 7S

PRODUCT_SYSTEM_PROPERTY_BLACKLIST += \
    ro.product.model \
    ro.build.product \
    ro.product.device
