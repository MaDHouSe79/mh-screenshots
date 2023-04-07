Config = {}

-- discords requested screenshot webhook cooldown timer
Config.CoolDown = 60000 -- 30 secs
Config.UseScreenshotTimer = true
Config.ScreenshotTimer = 600000 -- every 30 secs it will take a screenshot of a player and send it to discord.
Config.ShowIpInMessage = false
Config.AdminInteractions = {
    ['admin'] = { 
        [1] = {
            id = 'screenshots1',
            title = Lang:t('radialmenu.title_menu'),
            icon = 'image',
            type = 'client',
            event = 'mh-screenshots:client:ShowMenu',
            shouldClose = true
        },
        [2] = {
            id = 'screenshots2',
            title = Lang:t('radialmenu.screenshot_all'),
            icon = 'images',
            type = 'server',
            event = 'mh-screenshots:server:screenshotall',
            shouldClose = true
        },
        [3] = {
            id = 'screenshots2',
            title = Lang:t('radialmenu.screenshot_myself'),
            icon = 'images',
            type = 'server',
            event = 'mh-screenshots:server:screenshot',
            shouldClose = true
        },
    }
}