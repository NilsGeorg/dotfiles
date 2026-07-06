#!/bin/bash

# settings
xdg-settings set default-web-browser librewolf.desktop

shelly remove firefox

# pipx
pipx ensurepath
pipx install terminaltexteffects

# go
go install -tags most github.com/xo/usql@latest