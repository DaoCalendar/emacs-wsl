@echo off
wsl zsh -c "export DISPLAY=:0.0 export LIBGL_ALWAYS_INDIRECT=1 && setxkbmap -layout us && setsid emacs"