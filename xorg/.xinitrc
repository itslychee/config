#!/bin/sh

xsetroot -cursor_name left_ptr
systemctl --user import-environment DISPLAY

exec bspwm
