#!/usr/bin/env bash

acpi --ac-adapter | xargs -i notify-send {}
