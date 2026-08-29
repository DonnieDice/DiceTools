# DiceTools

![DiceTools icon](media/icon.png)

DiceTools is an in-game developer and debugging toolkit for World of Warcraft. It provides chat commands for inspecting client, character, pet, reputation, quest, map, and Trading Post data, plus a small global API caller for interactive diagnostics.

The current addon version is `2.1.2`. Its single TOC declares interfaces `11509`, `20506`, `50504`, and `120007` for Classic Era, Burning Crusade Classic, Mists of Pandaria Classic, and Retail respectively.

## Features

- Prints the game version, build, build date, and active TOC interface number.
- Clears every standard chat frame or reloads the UI.
- Walks the Pet Journal and prints each pet's level, XP, type, creature ID, battle/favorite state, and available health, power, speed, and rarity statistics.
- Lists major-faction Renown levels and progress when that client exposes the major-faction API.
- Looks up friendship reputation by numeric faction ID.
- Reports actual or effective character level, current XP, XP remaining, and rested XP.
- Lists Trading Post activities and whether each activity is complete when that API is available.
- Inspects a quest by numeric ID, including completion state, objectives, XP, money, reward choices, and fixed rewards returned by the client.
- Lists quests returned for the player's current map.
- Finds zones by a case-insensitive partial name or lists continents and their child zones.
- Resolves a global or namespaced WoW API function, calls it with simple arguments, and prints scalar or first-level table results.

Client-specific commands check for unavailable APIs where the implementation supports it. Output is written to the default chat stream; DiceTools has no graphical configuration panel.

## Installation

### Addon manager

Install DiceTools from [CurseForge](https://www.curseforge.com/wow/addons/dicetools).

### Manual installation

1. Download a package from [GitHub Releases](https://github.com/DonnieDice/DiceTools/releases).
2. Extract it into the selected WoW client's `Interface/AddOns` directory.
3. Confirm the installed directory is named `DiceTools` and directly contains `DiceTools.toc`.
4. Restart WoW or reload the UI, then enable DiceTools in the AddOns list.

DiceTools has no required addon dependencies. The TOC declares a `DiceTools` SavedVariables table, but the current addon does not expose persistent user settings.

## Commands

Type `/dt` in game to print the command list.

| Command | Behavior |
| --- | --- |
| `/dt` | Print the DiceTools command menu. |
| `/info` | Print game version, build, date, and TOC information. |
| `/rl` | Reload the UI. |
| `/clear` | Clear all standard chat windows. |
| `/petinfo` | Print details for every Pet Journal entry. Large collections produce substantial chat output. |
| `/renown` | Print available major-faction Renown data. |
| `/friendship <factionID>` | Print friendship data for a numeric faction ID. |
| `/playerlevel` | Print actual level and XP values. |
| `/charlevel` | Print effective level and XP values. |
| `/tradepost` | Print Trading Post activity descriptions and completion states. |
| `/questinfo <questID>` | Inspect a numeric quest ID. Name lookup is not supported by the current client call path. |
| `/questavailable` | List quests returned for the player's current map. |
| `/zoneinfo <name>` | Find the first zone whose name contains the supplied text. |
| `/zonelist` | Print all continents and zones returned under map `947`. |
| `/xpdetails` | Print level, XP progress percentage, XP remaining, and rested XP. |
| `/xpsources` | Report that XP-source inspection is not yet implemented. |
| `/api <function> [args...]` | Call a global or dot-separated API function and print its returns. |

### API explorer arguments

`/api` resolves paths such as `C_Map.GetBestMapForUnit`. Space-separated arguments are converted to numbers, booleans, or `nil` where possible; single- or double-quoted tokens have their outer quotes removed. The parser does not preserve spaces inside quoted arguments. Calls run through `pcall`, and returned tables are printed one level deep.

Examples:

```text
/api GetBuildInfo
/api UnitLevel player
/api C_Map.GetBestMapForUnit player
```

The API explorer executes arbitrary global WoW API functions. Use mutating functions only when you understand their effects and the game's protected-action restrictions.

## Troubleshooting

- If `/dt` is unknown, verify that `DiceTools/DiceTools.toc` exists, the addon is enabled for the current character, and the client did not mark it out of date.
- If a command reports that an API is unavailable, that feature is not exposed by the current client flavor. Other DiceTools commands may still work.
- If `/questinfo` rejects a quest name, use its numeric quest ID; the implementation intentionally reports that name lookup is unsupported.
- If `/api` cannot find a function, check its exact global path and capitalization. Protected or context-sensitive APIs may still fail when called.
- Use `/clear` cautiously because it clears all standard chat-frame contents for the current session.

## Project Status and Support

DiceTools is not marked deprecated or archived in the repository. The latest recorded change updates its interface metadata to `11509`, `20506`, `50504`, and `120007`; this statement reflects repository metadata rather than a promise of active maintenance or compatibility beyond those values.

- [Release history](docs/CHANGES.md)
- [GitHub issues](https://github.com/DonnieDice/DiceTools/issues)
- [RealmGX Discord](https://discord.gg/N7kdKAHVVF)

This repository does not currently include a license file. Do not infer reuse terms from earlier README text.
