if network_is_server() then
    print("Honorable Mentions: Loading stats.lua")
    -- Initialize stats for all players
    local prevPositions = {}
    local prevActions = {}
    local debugCounter = 0

    for i = 0, 15 do
        gPlayerSyncTable[i].tags = 0
        gPlayerSyncTable[i].deaths = 0
        gPlayerSyncTable[i].airborneTime = 0
        gPlayerSyncTable[i].coins = 0
        gPlayerSyncTable[i].jumps = 0
        gPlayerSyncTable[i].distance = 0
        gPlayerSyncTable[i].active = false
        gPlayerSyncTable[i].stars = 0
        gPlayerSyncTable[i].swimTime = 0
    end

    -- Reset stats at the start of each round
    function reset_stats()
        for i = 0, 15 do
            gPlayerSyncTable[i].tags = 0
            gPlayerSyncTable[i].deaths = 0
            gPlayerSyncTable[i].airborneTime = 0
            gPlayerSyncTable[i].coins = 0
            gPlayerSyncTable[i].jumps = 0
            gPlayerSyncTable[i].distance = 0
            gPlayerSyncTable[i].active = false
            gPlayerSyncTable[i].stars = 0
            gPlayerSyncTable[i].swimTime = 0
        end
        prevPositions = {}
        prevActions = {}
        print("Stats reset for all players")
    end

    -- Track stats during the active round
    function on_mario_update(m)
        if gGlobalSyncTable.gameState == 3 then
            debugCounter = debugCounter + 1
            if debugCounter % 30 == 0 then
                print("Tracking stats for player " .. m.playerIndex)
            end
            local i = m.playerIndex
            if (m.action & ACT_FLAG_AIR) ~= 0 then
                gPlayerSyncTable[i].airborneTime = gPlayerSyncTable[i].airborneTime + 1
            end
            if not prevActions[i] or (prevActions[i] ~= m.action and (m.action & ACT_GROUP_AIRBORNE) ~= 0) then
                gPlayerSyncTable[i].jumps = gPlayerSyncTable[i].jumps + 1
            end
            if not prevActions[i] or (m.action == ACT_DEATH_EXIT and prevActions[i] ~= ACT_DEATH_EXIT) then
                gPlayerSyncTable[i].deaths = gPlayerSyncTable[i].deaths + 1
            end
            if not prevPositions[i] then
                prevPositions[i] = {m.pos.x, m.pos.y, m.pos.z}
            else
                local dx = m.pos.x - prevPositions[i][1]
                local dy = m.pos.y - prevPositions[i][2]
                local dz = m.pos.z - prevPositions[i][3]
                local dist = math.sqrt(dx*dx + dy*dy + dz*dz)
                gPlayerSyncTable[i].distance = gPlayerSyncTable[i].distance + dist
                prevPositions[i] = {m.pos.x, m.pos.y, m.pos.z}
            end
            if m.controller.buttonDown ~= 0 or m.controller.stickX ~= 0 or m.controller.stickY ~= 0 then
                gPlayerSyncTable[i].active = true
            end
            if (m.action & ACT_FLAG_SWIMMING) ~= 0 then
                gPlayerSyncTable[i].swimTime = gPlayerSyncTable[i].swimTime + 1
            end
            prevActions[i] = m.action
        end
    end

    -- Track coins
    function on_interact(m, obj, interactionType)
        if gGlobalSyncTable.gameState == 3 then
            if interactionType == INTERACT_COIN then
                gPlayerSyncTable[m.playerIndex].coins = gPlayerSyncTable[m.playerIndex].coins + 1
            elseif interactionType == INTERACT_STAR_OR_KEY then
                gPlayerSyncTable[m.playerIndex].stars = gPlayerSyncTable[m.playerIndex].stars + 1
            end
        end
    end

    -- Track tags
    function on_pvp_attack(attacker, victim)
        local attackerIndex = attacker.playerIndex
        local victimIndex = victim.playerIndex
        local isSeeker = gPlayerSyncTable[attackerIndex].seeker or false
        print("PvP attack detected: Attacker " .. attackerIndex .. ", Victim " .. victimIndex .. ", gameState: " .. tostring(gGlobalSyncTable.gameState) .. ", Attacker is seeker: " .. tostring(isSeeker))
        if gGlobalSyncTable.gameState == 3 or isSeeker then
            gPlayerSyncTable[attackerIndex].tags = gPlayerSyncTable[attackerIndex].tags + 1
            print("Player " .. attackerIndex .. " tagged someone, tags: " .. gPlayerSyncTable[attackerIndex].tags)
        else
            print("Tag not counted, gameState is not 3 and attacker is not seeker")
        end
    end

    -- Reset stats when the round starts
    function on_game_state_change(tag, oldVal, newVal)
        print("stats.lua: gameState changed to " .. tostring(newVal))
        if newVal == 3 then
            reset_stats()
            print("Round started, state = " .. newVal)
        end
    end

    hook_event(HOOK_MARIO_UPDATE, on_mario_update)
    hook_event(HOOK_ON_INTERACT, on_interact)
    hook_event(HOOK_ON_PVP_ATTACK, on_pvp_attack)
    hook_on_sync_table_change(gGlobalSyncTable, "gameState", nil, on_game_state_change)
end