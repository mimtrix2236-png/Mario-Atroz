# MAURO ATROS — ZOMBIE WORLD

An original 2D side-scrolling zombie platform game, designed for Android phones in landscape mode and playable in the Godot editor.

## Game concept

Explore a ruined city, jump across rooftops and broken roads, stomp roaming zombies, collect bio-coins and antidote vials, and reach the evacuation beacon. The game uses original characters and environments. It borrows broad platform-game conventions (running, jumping, collectibles, enemies, checkpoints and scrolling stages), not Nintendo characters, art, audio, names or level layouts.

## Built with

- Godot 4.x (GDScript)
- 960 × 540 logical viewport, landscape orientation
- Procedurally drawn original pixel-inspired art (no external asset dependencies)
- On-screen touch controls plus keyboard controls for desktop testing

## Controls

- Move: left/right arrows or A/D; on mobile use the left/right touch pads.
- Jump: Space, Up or W; on mobile use the JUMP button.
- Stomp: land on a zombie from above.
- Collect glowing bio-coins and green antidote vials.
- Reach the orange evacuation beacon to complete the stage.

## Run

1. Install Godot 4.x.
2. Open this repository's folder in Godot using Import.
3. Open project.godot and press F6 or F5.

## Export to Android

The GitHub Actions workflow builds a debug APK and publishes it as the `Mauro-Atros-Android-APK` artifact on successful runs.

Godot Android export guide: https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html

## Project status

Playable prototype under active development. The planned expansion includes eight campaign levels, a level editor, Spanish/English localization, original chiptune music and additional game assets.

Android CI build workflow: `.github/workflows/android-apk.yml`.
