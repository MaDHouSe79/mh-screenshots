local Translations = {
    notify = {
        ['coolcown_message'] = "You can't take a screenshot right now, cooldown active..",
    },
    menu = {
        ['title'] = "Screenshots",
        ['header'] = "Screenshot Menu",
        ['button'] = "Create now",
        ['select_player'] = "Select a player",
    },
    discord = {
        ['title_for_admin'] = "Screenshot requested by admin",
        ['title_for_user'] = "Screenshot from player",
        ['botname'] = "ScreenshotBot",
        ['message_admin'] = "```prolog\nAdmin %{admin_name}\nmade a screenshot request on player:\n\nID: %{id}\nCitizenid: %{citizenid}\nNaam: %{fullname}\nFiveM: %{fivem}\n%{steam}\n%{license}\n%{discord}\n%{ip}\r```",
        ['message_user'] = "```prolog\nA player\nhas made a screenshot request:\n\nID: %{id}\nCitizenid:%{citizenid}\nNaam: %{fullname}\nFiveM: %{fivem}\n%{steam}\n%{license}\n%{discord}\n%{ip}\r```",
        ['auto_message'] = "```prolog\nAuto Screenshots:\n\nID: %{id}\nCitizenid: %{citizenid}\nNaam:%{fullname}\nFiveM: %{fivem}\n%{steam}\n%{license}\n%{discord}\n%{ip}\r```",
    },
    radialmenu = {
        ['title_menu'] = "Menu",
        ['screenshot_all'] = "Screenshot all",
        ['screenshot_myself'] = "Screenshot yourself",
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})