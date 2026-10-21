# Battle Valkyries — source review and build

This is a source snapshot of the Battle Valkyries main mod for **Battle Brothers**, version **4.10.0**, prepared on **2026-10-21**. It contains the current working source (including changes not yet committed in the development repository), the English and Simplified Chinese translations, runtime assets, and the tools required to build the main mod.

## Requirements

- Windows x64.
- Windows PowerShell 5.1 or PowerShell 7.
- **Microsoft .NET Runtime 7.0 x64**, required by the bundled BBBuilder CLI (`tools/BBBuilder/BBBuilder.runtimeconfig.json` specifies `net7.0`). A .NET SDK is not required.
- Enough disk space for the source assets, two rendered copies if building both languages, and the resulting ZIP archives (allow at least 10 GB free).

The build uses the bundled BBBuilder CLI and native Battle Brothers mod-kit tools. Python, Node.js, a game installation, and unpacked base-game files are not required to create the ZIP. No dependency download is performed by the build scripts.

## Build

Open a terminal in this repository's root directory. Build the English release:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\build_variant.ps1 -Variant en
```

Build the Simplified Chinese release:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\build_variant.ps1 -Variant zh_CN
```

Outputs:

| Language | Installable archive |
| --- | --- |
| English | `dist/battle-valkyries.zip` |
| Simplified Chinese | `dist/battle_valkyries_zh.zip` |

The wrapper renders translation and package-identity placeholders, checks Brush layout version 17, then runs BBBuilder with `-rebuild`. BBBuilder checks Squirrel syntax and rebuilds the sprite atlas and Brush resources before creating the archive. The wrapper regenerates a local tool configuration on every run, directing the final archive into this repository's `dist/` directory. It does not install into a game directory or restart the game. Run builds sequentially; both languages share the local tool configuration.

Release builds exclude the development test-company origin and its registration hook. To include that origin for manual testing, append `-IncludeTestOrigin`:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\build_variant.ps1 -Variant en -IncludeTestOrigin
```

## Inspect without packaging

To expand the English source and translation placeholders without creating a ZIP:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\render_mods.ps1 -Variant en -ExcludeTestOrigin
```

Inspect the result in `mods/battle-valkyries/`. Replace `en` with `zh_CN` to inspect `mods/battle_valkyries_zh/`. Rendering replaces that language's generated directory; make source changes in `src/` instead.

## Source layout

| Path | Contents |
| --- | --- |
| `src/battle-valkyries/battle-valkyries/` | Configuration, hooks, gameplay systems, and managed skills |
| `src/battle-valkyries/scripts/` | Preload entry point and public game-script classes |
| `src/battle-valkyries/ui/` | Game UI JavaScript and CSS |
| `src/battle-valkyries/gfx/`, `sounds/`, `brushes/` | Runtime images, videos, audio, and Brush resources |
| `src/battle-valkyries/unpacked_brushes/` | Sprite sources and layout metadata for rebuilding the atlas |
| `i18n/en.json`, `i18n/zh_CN.json` | Localized strings for `$bv{key}` placeholders |
| `variants/en.json`, `variants/zh_CN.json` | Package identities for `$bvvar{key}` placeholders |
| `scripts/` | Rendering, Brush checks, and local package-build entry point |
| `tools/BBBuilder/` | Bundled third-party build tools and upstream tool documentation |

The independent alchemy/enchantment mod and standalone character expansion packs are outside this main-mod snapshot. Existing integration code for optional mods remains in the source.

## Manual game verification

To test a package, install Battle Brothers and the mod's declared dependencies, **Modern Hooks** and **MSU**, separately. Copy **one** language's ZIP from `dist/` into the game's `data/` directory. Keep it zipped and remove any older or alternate-language copy of Battle Valkyries before testing. Runtime registration and dependencies are visible in `src/battle-valkyries/scripts/!mods_preload/battle-valkyries.nut`.

A successful package build checks compilation and resource packaging. It does not establish in-game behavior, save compatibility, or compatibility with every optional mod combination. This source distribution does not include the game, third-party gameplay mods, or a game installation.

Snapshot verification on 2026-10-21: both release commands above completed successfully with the bundled BBBuilder 1.6.2. Each language passed compilation checks for 1,267 Squirrel files and produced a ZIP with 4,416 entries, including both rebuilt Brush atlases. The copied 6,112 source and runtime-asset files were checked against the development working tree using SHA-256. No in-game test was performed for this snapshot.

The bundled builder documentation is in `tools/BBBuilder/README.md`; the mod-kit attribution is retained there. Use the repository build wrapper above for this distribution's local output configuration.
