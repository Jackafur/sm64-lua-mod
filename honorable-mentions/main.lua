if network_is_server() then
    print("Honorable Mentions: Initializing server-side")
    gGlobalSyncTable.frameCounter = 0
    gGlobalSyncTable.statsDisplayStartFrame = nil
    gGlobalSyncTable.mostCoinsIndex = -1
    gGlobalSyncTable.mostCoinsValue = -1
    gGlobalSyncTable.mostTagsIndex = -1
    gGlobalSyncTable.mostTagsValue = 0

    local prevHiderCount = -1

    -- Increment frame counter
    function on_update()
        gGlobalSyncTable.frameCounter = gGlobalSyncTable.frameCounter + 1
        if gGlobalSyncTable.frameCounter % 30 == 0 then
            print("Frame counter: " .. gGlobalSyncTable.frameCounter .. ", gameState: " .. tostring(gGlobalSyncTable.gameState) .. ", timer: " .. tostring(gGlobalSyncTable.timer))
        end

        -- Count current hiders
        local currentHiderCount = 0
        for i = 0, 15 do
            if gNetworkPlayers[i].connected and not gPlayerSyncTable[i].seeker then
                currentHiderCount = currentHiderCount + 1
            end
        end

        -- If previous hider count was greater than 0 and now it's 0, trigger stats
        if prevHiderCount > 0 and currentHiderCount == 0 then
            calculate_honorable_mentions()
        end

        prevHiderCount = currentHiderCount
    end

    -- Calculate stats for display
    function calculate_honorable_mentions()
        print("Calculating honorable mentions")
        local maxCoins = -1
        local maxCoinsIndex = -1
        local maxTags = -1
        local maxTagsIndex = -1
        for i = 0, 15 do
            if gNetworkPlayers[i].connected then
                local coins = gMarioStates[i].numCoins
                if coins > maxCoins then
                    maxCoins = coins
                    maxCoinsIndex = i
                end
                local tags = gPlayerSyncTable[i].tags or 0
                if tags > maxTags then
                    maxTags = tags
                    maxTagsIndex = i
                end
            end
        end
        gGlobalSyncTable.mostCoinsIndex = maxCoinsIndex
        gGlobalSyncTable.mostCoinsValue = maxCoins
        gGlobalSyncTable.mostTagsIndex = maxTagsIndex
        gGlobalSyncTable.mostTagsValue = maxTags
        gGlobalSyncTable.statsDisplayStartFrame = gGlobalSyncTable.frameCounter
        print("Most coins: Player " .. tostring(maxCoinsIndex) .. " with " .. tostring(maxCoins) .. " coins")
        print("Most tags: Player " .. tostring(maxTagsIndex) .. " with " .. tostring(maxTags) .. " tags")
    end

    -- Handle client commands
    function on_packet_receive(data)
        if data.packet == "showstats" then
            print("Received showstats request")
            calculate_honorable_mentions()
        end
    end

    -- Hook for gameState changes (if it works)
    function on_game_state_change(tag, oldVal, newVal)
        print("main.lua: gameState changed from " .. tostring(oldVal) .. " to " .. tostring(newVal))
        if oldVal == 3 and newVal == 1 then
            calculate_honorable_mentions()
        end
    end

    hook_event(HOOK_UPDATE, on_update)
    hook_event(HOOK_ON_PACKET_RECEIVE, on_packet_receive)
    hook_on_sync_table_change(gGlobalSyncTable, "gameState", nil, on_game_state_change)
end

if not network_is_server() then
    print("Honorable Mentions: Initializing client-side")
    function on_showstats_command(msg)
        network_send(true, {packet = "showstats"})
        djui_chat_message_create("Requested stats")
        return true
    end

    hook_chat_command("showstats", "Show stats", on_showstats_command)
end