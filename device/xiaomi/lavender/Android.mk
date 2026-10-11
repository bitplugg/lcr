#
# Copyright (C) 2019 The TeamWin Recovery Project
#
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_DEVICE),lavender)
include $(call all-makefiles-under,$(LOCAL_PATH))
endif
