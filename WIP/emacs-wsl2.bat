@echo off
@REM wsl bash -c "ip route | awk '/default via /' | cut -d ' ' -f3" > wsl-ip.txt
@REM Get the IP to use from wsl and set to variable.
@REM See https://stackoverflow.com/a/6362922/1365754
SETLOCAL
for /F "tokens=* USEBACKQ" %%F IN (`wsl bash -c "ip route | awk '/default via /' | cut -d ' ' -f3"`) DO (
set mywslip=%%F
)
echo %mywslip%
wsl zsh -c "export DISPLAY=%mywslip%:0.0 export LIBGL_ALWAYS_INDIRECT=1 && setxkbmap -layout us && setsid emacs"
ENDLOCAL