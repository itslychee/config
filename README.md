# ItsLychee/dotfiles

My personal dotfiles reside here, and that's really all to it. Issues and PRs
are welcome, as they increase pleasure and portability as I use my dotfiles across
my devices.

![Screenshot of my Arch setup utilizing my dotfiles](https://raw.githubusercontent.com/ItsLychee/dotfiles/main/screenshot.png)

## Packages

- Bspwm (WM)
- Dunst (Notification Daemon)
- Fish (Shell)
- Flameshot (Screenshot tool)
- Git (VCS)
- Htop (Process viewing)
- Mpd (Music daemon)
- Ncmpcpp (Frontend for Mpd)
- Picom (Window Compositor)
- Polybar (For status bars)
- Rofi (Application launching)
- Sxhkd (Simple X Hotkey Daemon, for Bspwm)
- Vim (Editor)
- Xorg (X settings)

## Required Fonts & Packages

- Font Awesome 5 Free
- Twemoji
- Noto Sans
- Termsyn (bitmap font)
- Iosevka
- **the respective package(s) you intend to use**
- xsetroot (for Xorg)


## Notes
- I use systemd's user manager for some processes, so you will have to enable lingering (`loginctl enable-linger $USER`) for processes to autostart on login.
- You will have to refresh the font cache on root-level (`fc-cache -fr`) so Bitmap fonts won't sporadically mess up in rendering.


## Bugs
- Flameshot sometimes doesn't start up, check this out later
- Bitmap onts sometimes mess up, for more in detail check above
