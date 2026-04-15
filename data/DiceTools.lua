--=====================================================================================
-- DiceTools Addon - Developer Utilities & Debugging Toolkit
--=====================================================================================

local DiceTools = {}
_G.DiceTools = DiceTools

-- Create a frame for events
local frame = CreateFrame("Frame", "DiceToolsFrame")

-- Event registration
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("ADDON_LOADED")

-- Event handler
local function OnEvent(self, event, ...)
    if event == "ADDON_LOADED" then
        local addonName = ...
        if addonName == "DiceTools" then
            print("|cff05dffaDiceTools|r v2.0.0 loaded. Type |cff05dffa/dt|r for commands.")
        end
    end
end

frame:SetScript("OnEvent", OnEvent)

--=====================================================================================
-- Slash Command Handling
--=====================================================================================

SLASH_DT1 = "/dt"
SlashCmdList["DT"] = function()
    print("|cff05dffaDiceTools|r Commands:")
    print("|cff05dffa/dt|r          - List this menu")
    print("|cff05dffa/info|r         - Show game version")
    print("|cff05dffa/rl|r           - Reload UI")
    print("|cff05dffa/clear|r        - Clear all chat windows")
    print("|cff05dffa/petinfo|r      - Dump Pet Journal details")
    print("|cff05dffa/renown|r       - Show Renown faction info")
    print("|cff05dffa/friendship|r   - Show Friendship reputation info")
    print("|cff05dffa/playerlevel|r  - Show player level and XP")
    print("|cff05dffa/charlevel|r    - Show character effective level and XP")
    print("|cff05dffa/tradepost|r    - List TradePost activities")
    print("|cff05dffa/questinfo|r <name/ID> - Look up quest details")
    print("|cff05dffa/questavailable|r    - List quests in current zone")
    print("|cff05dffa/zoneinfo|r <name>   - Get zone details")
    print("|cff05dffa/zonelist|r          - List all continents and zones")
    print("|cff05dffa/xpdetails|r         - Show XP and leveling info")
    print("|cff05dffa/xpsources|r         - List XP sources (placeholder)")
    print("|cff05dffa/api|r <function>    - Call a WoW API function by name")
end

SLASH_INFO1 = "/info"
SlashCmdList["INFO"] = function()
    local version, build, date, toc = GetBuildInfo()
    print("|cff05dffaDiceTools|r Game Info:")
    print("  Version: " .. tostring(version))
    print("  Build: " .. tostring(build))
    print("  Date: " .. tostring(date))
    print("  TOC: " .. tostring(toc))
end

SLASH_RL1 = "/rl"
SlashCmdList["RL"] = ReloadUI

SLASH_CLEAR1 = "/clear"
function SlashCmdList.CLEAR()
    for i = 1, NUM_CHAT_WINDOWS do
        _G["ChatFrame" .. i]:Clear()
    end
    print("|cff05dffaDiceTools|r Chat log cleared.")
end

--=====================================================================================
-- Pet Journal
--=====================================================================================

SLASH_PETINFO1 = "/petinfo"
SlashCmdList["PETINFO"] = function()
    local numPets = C_PetJournal.GetNumPets()
    if not numPets or numPets == 0 then
        print("|cff05dffaDiceTools|r No pets found in the Pet Journal.")
        return
    end

    print("|cff05dffaDiceTools|r Pet Journal (" .. numPets .. " pets):")
    for i = 1, numPets do
        local petID, speciesID, isOwned, customName, level, xp, maxXp, displayID, isFavorite, name, icon, petType, creatureID, canBattle, tradable, unique = C_PetJournal.GetPetInfoByIndex(i, false)

        print("  Pet #" .. i .. ": " .. tostring(name))
        print("    Level: " .. tostring(level) .. " | XP: " .. tostring(xp) .. "/" .. tostring(maxXp))
        print("    Type: " .. tostring(petType) .. " | Creature ID: " .. tostring(creatureID))
        print("    Battle: " .. tostring(canBattle) .. " | Favorite: " .. tostring(isFavorite))

        if petID then
            local success, health, maxHealth, power, speed, rarity = pcall(function()
                return C_PetJournal.GetPetStats(petID)
            end)
            if success and health then
                print("    Stats - HP: " .. health .. "/" .. maxHealth .. " | Power: " .. power .. " | Speed: " .. speed .. " | Rarity: " .. rarity)
            end
        end
    end
end

--=====================================================================================
-- Renown and Friendship
--=====================================================================================

SLASH_RENOWN1 = "/renown"
SlashCmdList["RENOWN"] = function()
    if not C_Reputation then
        print("|cff05dffaDiceTools|r C_Reputation API not available on this client.")
        return
    end

    local renownFactions = C_Reputation.GetRenownFactions()
    if not renownFactions or #renownFactions == 0 then
        print("|cff05dffaDiceTools|r No Renown factions found.")
        return
    end

    print("|cff05dffaDiceTools|r Renown Factions:")
    for _, factionID in ipairs(renownFactions) do
        local factionName = GetFactionInfoByID(factionID) or "Unknown"
        local currentLevel = C_Reputation.GetRenownLevel(factionID) or 0
        local maxLevel = C_Reputation.GetRenownMaxLevel(factionID) or 0
        print("  " .. tostring(factionName) .. " - Level: " .. currentLevel .. "/" .. maxLevel)
    end
end

SLASH_FRIENDSHIP1 = "/friendship"
SlashCmdList["FRIENDSHIP"] = function()
    local friendReps = C_GossipInfo.GetFriendshipReputation()
    if not friendReps or #friendReps == 0 then
        print("|cff05dffaDiceTools|r No friendship reputations found.")
        return
    end

    print("|cff05dffaDiceTools|r Friendship Reputations:")
    for _, repInfo in ipairs(friendReps) do
        local factionName = GetFactionInfoByID(repInfo.factionID) or "Unknown"
        print("  " .. factionName .. " - Standing: " .. repInfo.standing .. " / " .. repInfo.reactionThreshold)
    end
end

--=====================================================================================
-- Player Level and XP
--=====================================================================================

SLASH_PLAYERLEVEL1 = "/playerlevel"
SlashCmdList["PLAYERLEVEL"] = function()
    local playerLevel = UnitLevel("player")
    local playerXP = UnitXP("player")
    local maxXP = UnitXPMax("player")

    print("|cff05dffaDiceTools|r Player Info:")
    print("  Level: " .. playerLevel)
    print("  XP: " .. playerXP .. " / " .. maxXP)
    print("  XP to Next: " .. (maxXP - playerXP))
end

SLASH_CHARLEVEL1 = "/charlevel"
SlashCmdList["CHARLEVEL"] = function()
    local charLevel = UnitEffectiveLevel("player")
    local charXP = UnitXP("player")
    local maxXP = UnitXPMax("player")

    print("|cff05dffaDiceTools|r Character Info:")
    print("  Effective Level: " .. charLevel)
    print("  XP: " .. charXP .. " / " .. maxXP)
    print("  XP to Next: " .. (maxXP - charXP))
end

--=====================================================================================
-- TradePost
--=====================================================================================

SLASH_TRADEPOST1 = "/tradepost"
SlashCmdList["TRADEPOST"] = function()
    if not C_PerksActivities then
        print("|cff05dffaDiceTools|r TradePost API not available on this client.")
        return
    end

    local activities = C_PerksActivities.GetPerksActivities()
    if not activities or #activities == 0 then
        print("|cff05dffaDiceTools|r No TradePost activities found.")
        return
    end

    print("|cff05dffaDiceTools|r TradePost Activities:")
    for _, activity in ipairs(activities) do
        local info = C_PerksActivities.GetActivityInfo(activity)
        if info then
            local status = info.isComplete and "|cff2dc26bCompleted|r" or "|cffff6b6bIn Progress|r"
            print("  [" .. status .. "] " .. info.description)
        end
    end
end

--=====================================================================================
-- Quest Information
--=====================================================================================

SLASH_QUESTINFO1 = "/questinfo"
SlashCmdList["QUESTINFO"] = function(args)
    local questNameOrID = args and args:trim()
    if not questNameOrID or questNameOrID == "" then
        print("|cff05dffaDiceTools|r Usage: /questinfo <quest name or ID>")
        return
    end

    local questID = C_QuestLog.GetQuestIDByName(questNameOrID)
    if not questID then
        questID = tonumber(questNameOrID)
    end

    if not questID then
        print("|cff05dffaDiceTools|r Quest not found: " .. questNameOrID)
        return
    end

    local questInfo = C_QuestLog.GetQuestInfo(questID)
    if not questInfo then
        print("|cff05dffaDiceTools|r Quest not found: " .. questID)
        return
    end

    print("|cff05dffaDiceTools|r Quest: " .. questInfo.title)
    print("  Level: " .. tostring(questInfo.level))
    print("  Complete: " .. tostring(questInfo.isComplete))
    print("  Failed: " .. tostring(questInfo.isFailed))

    local objectives = C_QuestLog.GetQuestObjectives(questID)
    if objectives and #objectives > 0 then
        print("  Objectives:")
        for _, obj in ipairs(objectives) do
            if obj and obj.text then
                print("    - " .. obj.text .. " (" .. obj.numFulfilled .. "/" .. obj.numRequired .. ")")
            end
        end
    end

    local rewardXP = GetQuestLogRewardXP(questID)
    local rewardMoney = GetQuestLogRewardMoney(questID)
    local numChoices = GetNumQuestLogRewardChoices(questID)
    local numItems = GetNumQuestLogRewards(questID)

    if rewardXP > 0 or rewardMoney > 0 or numChoices > 0 or numItems > 0 then
        print("  Rewards:")
        if rewardXP > 0 then print("    XP: " .. rewardXP) end
        if rewardMoney > 0 then print("    Money: " .. rewardMoney) end
        if numChoices > 0 then
            for i = 1, numChoices do
                local name = GetQuestLogRewardChoiceInfo(i)
                if name then print("    Choice: " .. name) end
            end
        end
        if numItems > 0 then
            for i = 1, numItems do
                local name = GetQuestLogRewardInfo(i)
                if name then print("    Item: " .. name) end
            end
        end
    end
end

SLASH_QUESTAVAILABLE1 = "/questavailable"
SlashCmdList["QUESTAVAILABLE"] = function()
    local currentMapID = C_Map.GetBestMapForUnit("player")
    if not currentMapID then
        print("|cff05dffaDiceTools|r Unable to determine current map.")
        return
    end

    local quests = C_QuestLog.GetQuestsOnMap(currentMapID)
    if quests and #quests > 0 then
        print("|cff05dffaDiceTools|r Available quests in current zone:")
        for _, quest in ipairs(quests) do
            print("  - " .. quest.title)
        end
    else
        print("|cff05dffaDiceTools|r No available quests in the current zone.")
    end
end

--=====================================================================================
-- Zone Information
--=====================================================================================

SLASH_ZONEINFO1 = "/zoneinfo"
SlashCmdList["ZONEINFO"] = function(zoneName)
    if not zoneName or zoneName:trim() == "" then
        print("|cff05dffaDiceTools|r Usage: /zoneinfo <zone name>")
        return
    end

    local mapInfo = C_Map.GetMapInfoAtPosition(C_Map.GetBestMapForUnit("player"))
    -- Search by iterating map children of Azeroth (947)
    local continents = C_Map.GetMapChildrenInfo(947)
    if not continents then
        print("|cff05dffaDiceTools|r Unable to retrieve map data.")
        return
    end

    for _, continent in ipairs(continents) do
        local zones = C_Map.GetMapChildrenInfo(continent.mapID, Enum.UIMapType.Zone, true)
        if zones then
            for _, zone in ipairs(zones) do
                if zone.name and zone.name:lower():find(zoneName:lower(), 1, true) then
                    print("|cff05dffaDiceTools|r Zone: " .. zone.name)
                    print("  Map ID: " .. zone.mapID)
                    print("  Parent: " .. tostring(zone.parentMapID))
                    print("  Map Type: " .. tostring(zone.mapType))
                    return
                end
            end
        end
    end

    print("|cff05dffaDiceTools|r Zone not found: " .. zoneName)
end

SLASH_ZONELIST1 = "/zonelist"
SlashCmdList["ZONELIST"] = function()
    local continents = C_Map.GetMapChildrenInfo(947, Enum.UIMapType.Continent, true)
    if not continents or #continents == 0 then
        print("|cff05dffaDiceTools|r Unable to retrieve continent data.")
        return
    end

    print("|cff05dffaDiceTools|r Continents and Zones:")
    for _, continent in ipairs(continents) do
        print("  " .. continent.name)
        local zones = C_Map.GetMapChildrenInfo(continent.mapID, Enum.UIMapType.Zone, true)
        if zones then
            for _, zone in ipairs(zones) do
                print("    - " .. zone.name)
            end
        end
    end
end

--=====================================================================================
-- XP Details
--=====================================================================================

SLASH_XPDETAILS1 = "/xpdetails"
SlashCmdList["XPDETAILS"] = function()
    local playerLevel = UnitLevel("player")
    local playerXP = UnitXP("player")
    local maxXP = UnitXPMax("player")
    local restedXP = GetXPExhaustion() or 0

    local pct = maxXP > 0 and string.format("%.1f", (playerXP / maxXP) * 100) or "0"

    print("|cff05dffaDiceTools|r XP Details:")
    print("  Level: " .. playerLevel)
    print("  XP: " .. playerXP .. " / " .. maxXP .. " (" .. pct .. "%)")
    print("  XP to Next: " .. (maxXP - playerXP))
    print("  Rested XP: " .. restedXP)
end

SLASH_XPSOURCES1 = "/xpsources"
SlashCmdList["XPSOURCES"] = function()
    print("|cff05dffaDiceTools|r XP sources feature not yet implemented.")
end

--=====================================================================================
-- API Explorer
--=====================================================================================

SLASH_API1 = "/api"
SlashCmdList["API"] = function(apiFunction)
    if not apiFunction or apiFunction:trim() == "" then
        print("|cff05dffaDiceTools|r Usage: /api <function name>")
        return
    end

    local func = _G[apiFunction]
    if not func then
        print("|cff05dffaDiceTools|r Function not found: " .. apiFunction)
        return
    end

    local success, result = pcall(func)
    if success then
        print("|cff05dffaDiceTools|r Result of " .. apiFunction .. ":")
        if type(result) == "table" then
            for k, v in pairs(result) do
                print("  " .. tostring(k) .. " = " .. tostring(v))
            end
        else
            print("  " .. tostring(result))
        end
    else
        print("|cff05dffaDiceTools|r Error calling " .. apiFunction .. ": " .. tostring(result))
    end
end
