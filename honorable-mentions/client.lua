-- client.lua

-- Handle the /showstats chat command
function on_showstats_command(msg)
    network_send(true, {packet = "showstats"})
    return true -- Prevents the command from being printed in chat
end

-- Register the chat command
hook_chat_command("showstats", "Show honorable mentions", on_showstats_command)