function on_hud_render()
    if gGlobalSyncTable.statsDisplayStartFrame and gGlobalSyncTable.frameCounter - gGlobalSyncTable.statsDisplayStartFrame < 300 then
        local screenWidth = djui_hud_get_screen_width()
        local screenHeight = djui_hud_get_screen_height()
        
        -- Prepare text lines
        local lines = {"Honorable Mentions"}
        if gGlobalSyncTable.mostCoinsIndex >= 0 then
            local name = gNetworkPlayers[gGlobalSyncTable.mostCoinsIndex].name or "Player " .. tostring(gGlobalSyncTable.mostCoinsIndex)
            table.insert(lines, "Most Coins: " .. name .. " (" .. tostring(gGlobalSyncTable.mostCoinsValue) .. ")")
        end
        if gGlobalSyncTable.mostTagsIndex >= 0 then
            local name = gNetworkPlayers[gGlobalSyncTable.mostTagsIndex].name or "Player " .. tostring(gGlobalSyncTable.mostTagsIndex)
            table.insert(lines, "Most Tags: " .. name .. " (" .. tostring(gGlobalSyncTable.mostTagsValue) .. ")")
        end

        -- Calculate maximum text width and box dimensions
        local maxWidth = 0
        for _, line in ipairs(lines) do
            local width = djui_hud_measure_text(line)
            if width > maxWidth then
                maxWidth = width
            end
        end

        local padding = 20
        local lineHeight = 20
        local boxWidth = maxWidth + 2 * padding
        local boxHeight = #lines * lineHeight + 2 * padding
        local boxX = (screenWidth - boxWidth) / 2
        local boxY = (screenHeight - boxHeight) / 2

        -- Draw transparent black background
        djui_hud_set_color(0, 0, 0, 180)
        djui_hud_render_rect(boxX, boxY, boxWidth, boxHeight)

        -- Draw text lines
        djui_hud_set_color(255, 255, 255, 255)
        for i, line in ipairs(lines) do
            local textX = boxX + padding
            local textY = boxY + padding + (i - 1) * lineHeight
            djui_hud_print_text(line, textX, textY, 1)
        end
    end
end

hook_event(HOOK_ON_HUD_RENDER, on_hud_render)