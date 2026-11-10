# MARIO ATROZ — ZOMBIE WORLD

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

1. Install Android Studio and the Android SDK (including platform tools and build tools).
2. In Godot, open Editor → Manage Export Templates and install the matching export templates.
3. Open Project → Export, add an Android preset, and configure the Android SDK paths in Editor → Editor Settings → Export → Android.
4. Set a unique package identifier (for example, com.marioatroz.zombieworld) and configure the signing key for a release build.
5. Export a debug APK for device testing, or a signed AAB for Google Play.

Godot Android export guide: https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html

## Design references

The level design uses general side-scrolling platform principles: introduce safe movement first, then combine gaps, elevated routes, enemy patrols, collectibles and a clear goal.

- Android Developers — game development basics: https://developer.android.com/games/guides/basics
- Godot — Android export: https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html
- Super Mario Bros. mechanical profile (broad genre conventions only): https://puzzlegenome.org/en/games/super-mario-bros/
- Platformer level fundamentals: https://learn.adafruit.com/makecode-arcade-platform-level/platformer-level-fundamentals

## Project status

Initial playable prototype. Art is drawn in code so the project opens without downloading third-party assets. Audio, extra stages, menus and device testing can be expanded in later iterations.
