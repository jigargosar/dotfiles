# World Clock — Rainmeter Skin

A clean, Windows 11 Widgets-style world clock with frosted dark translucent card design.

## Installation

1. Copy the `WorldClock` folder into your Rainmeter Skins directory:
   ```
   Documents\Rainmeter\Skins\WorldClock\
   ```
2. Right-click the Rainmeter tray icon → **Refresh All**
3. Navigate to **WorldClock** → Load `WorldClock.ini`

## Changing Cities

**Right-click** anywhere on the skin to open the context menu.

- **City 1** options appear first (Mumbai, New York, London, Tokyo, Dubai, Sydney, Singapore, Berlin)
- **City 2** options appear below the separator

Select any city and the skin refreshes instantly.

## Adding More Cities

Open `WorldClock.ini` in a text editor and add new `ContextTitle` / `ContextAction` entries following the existing pattern. You need:

| City | TimeZone | Label |
|------|----------|-------|
| The display name | UTC offset (e.g. 5.5 for IST, -5 for EST) | Short abbreviation |

**Important:** Set `DaylightSavingTime=0` is already configured in all time measures. When DST is active in a city, you'll need to adjust the UTC offset manually (e.g. New York becomes -4 during EDT). A future version could automate this.

## Frosted Glass Effect (Optional)

For a true Windows 11 acrylic blur behind the card, install the **FrostedGlass** plugin:

1. Download from: https://forum.rainmeter.net/viewtopic.php?t=44887
2. Place `FrostedGlass.dll` in `Rainmeter\Plugins\`
3. Add this section to `WorldClock.ini` above `[Variables]`:

```ini
[FrostedGlass]
Measure=Plugin
Plugin=FrostedGlass
Type=Acrylic
Border=All
Corner=Round
```

Then change the card background alpha to be more transparent (e.g. `CardBg=30,30,30,120`).

## Customization

All visual settings are in the `[Variables]` section:

- **CardW / CardH** — Widget dimensions
- **CardRadius** — Corner roundness
- **Padding** — Inner spacing
- **CardBg** — Background RGBA
- **TextPrimary / TextSecondary / TextDim** — Text colors
- **AccentColor** — AM/PM highlight color
- **FontFace** — Uses Segoe UI Variable (Win11 default); change if unavailable
