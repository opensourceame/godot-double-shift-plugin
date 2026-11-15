# Godot Double Shift Quick Open

A Godot 4.4+ editor plugin: tap **Shift twice** to open the Quick Open dialog, like "Search Everywhere" in VS Code / JetBrains.

- Scenes open in the scene editor, scripts in the script editor, other resources in the Inspector.
- Only a clean Shift tap counts — typing capitals (Shift+A) won't trigger it.
- Adjust `DOUBLE_TAP_WINDOW_MS` in `plugin.gd` (default 300 ms) to tune the timing.

## Install

1. Copy `addons/double_shift_quick_open` into your project's `addons/` folder.
2. Enable it in **Project → Project Settings → Plugins**.
