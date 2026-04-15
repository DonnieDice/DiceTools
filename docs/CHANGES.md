# Changes

## v2.0.0

- Complete overhaul of release workflow with proper version extraction, changelog parsing, and Discord notifications
- Added project IDs for CurseForge, Wago, and WoWInterface distribution
- Added CurseForge description via `docs/description.html`
- Multi-interface support: Retail (Midnight), MoP Classic, and Classic Era
- Cleaned up deprecated GitHub Actions syntax (`::set-output` → `$GITHUB_OUTPUT`)
- Removed broken `actions/create-release@v1` step; GitHub release handled by BigWigs packager
- Added release-type detection (release/beta/alpha)
- Moved `CHANGES.md` into `docs/` directory

## v1.0.1

- Removed - Version# - [CHANGES.md]
- Updated - Toc Version# - [DiceTools.toc]
- Added   - [/data]
- Added   - [/images]
- Moved   - [DiceTools.lua] - [/data]
- Updated - Path to data - [DiceTools.toc]
- Added   - Notes, Author, Email, OptionalDeps, IconTexture - [DiceTools.toc]
- Added   - [/workflows] - [.github]
- Added   - [release.yml] - [/workflows]

## v1.0.0

- Initial release
- Slash commands: `/dt`, `/info`, `/rl`, `/clear`, `/petinfo`, `/renown`, `/friendship`, `/playerlevel`, `/charlevel`, `/tradepost`, `/questinfo`, `/questavailable`, `/zoneinfo`, `/zonelist`, `/xpdetails`, `/xpsources`, `/api`
