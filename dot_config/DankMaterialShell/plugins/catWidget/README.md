# Cat Widget for DMS

An animated running cat for the DankMaterialShell top bar. The cat's speed reflects your CPU usage — idle systems get a sleeping cat, busy systems get a zooming cat.

![preview](https://img.shields.io/badge/DMS-plugin-blue)

## Install

```bash
git clone https://github.com/xi-ve/cat-dms.git
cp -r cat-dms ~/.config/DankMaterialShell/plugins/CatWidget
```

Then in DMS: **Settings > Plugins > Scan for Plugins > Enable Cat Widget > Add to DankBar**.

## Settings

- **Cat Size** — Sprite size in the bar (12-48px)
- **Idle Threshold** — CPU % below which the cat sleeps (default 15%)
- **CPU Poll Interval** — How often to sample CPU (1-10 sec)
- **Show CPU %** — Display percentage next to the cat

## Credits

- Cat sprites and animation formula from [CatWalk](https://store.kde.org/p/2055225) by **Driglu4it** (Yuri Saurov), originally inspired by [RunCat](https://kyome.io/runcat/) by Kyome
- Built for [DankMaterialShell](https://danklinux.com/) by AvengeMedia
