#!/usr/bin/env bash

acpi --battery | xargs -i notify-send {}
