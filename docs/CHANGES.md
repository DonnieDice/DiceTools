# Changes

## v2.1.0

- Version string is now read from TOC metadata instead of hardcoded (no more drift)
- Fixed `/renown` to use Midnight's `C_MajorFactions` API
- Fixed `/friendship` to use the correct single-faction `C_GossipInfo.GetFriendshipReputation(factionID)` signature
- Fixed `/questinfo` — removed calls to non-existent `C_QuestLog.GetQuestIDByName` / `GetQuestInfo`; now uses `GetTitleForQuestID` + quest state helpers
- Fixed `/zoneinfo` — removed unused `GetMapInfoAtPosition` call and added proper continent filter
- Enhanced `/api` — now parses arguments (numbers, booleans, strings, dotted paths) and shows all return values
- `IconTexture` path updated for `images/` → `media/` migration

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
