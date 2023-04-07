local Translations = {
    notify = {
        ['coolcown_message'] = "Je kunt nu geen screenshot maken, cooldown active..",
    },
    menu = {
        ['title'] = "Screenshots",
        ['header'] = "Screenshot Menu",
        ['button'] = "Nu maken",
        ['select_player'] = "Selecteer een speler",
    },
    discord = {
        ['title_for_admin'] = "Screenshot requested by admin",
        ['title_for_user'] = "Screenshot from player",
        ['botname'] = "ScreenshotBot",
        ['message_admin'] = "```prolog\nAdmin %{admin_name}\nheeft een screenshot aanvraag gedaan op speler:\n\nID: %{id}\nCitizenid: %{citizenid}\nBurger Naam: %{fullname}\nFiveM: %{fivem}\n%{steam}\n%{license}\n%{discord}\n%{ip}\r```",
        ['message_user'] = "```prolog\nEen speler\nheeft een screenshot aanvraag gedaan:\n\nID: %{id}\nCitizenid: %{citizenid}\nBurger Naam: %{fullname}\nFiveM: %{fivem}\n%{steam}\n%{license}\n%{discord}\n%{ip}\r```",
        ['auto_message'] = "```prolog\nAuto Screenshots:\n\nID: %{id}\nCitizenid: %{citizenid}\nBurger Naam: %{fullname}\nFiveM: %{fivem}\n%{steam}\n%{license}\n%{discord}\n%{ip}\r```",
    },
    radialmenu = {
        ['title_menu'] = "Menu",
        ['screenshot_all'] = "Screenshot all",
        ['screenshot_myself'] = "Screenshot je zelf",
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})