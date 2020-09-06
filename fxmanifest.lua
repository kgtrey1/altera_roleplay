-- Altera Framework
-- Created by kgtrey1

fx_version      'bodacious'
game            'gta5'
description     'Altera Framework'
version         '0.2.5'

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'config.lua',
    'server/alter.lua',
    'server/class.lua',
    'server/shared.lua',
    'server/load.lua',
    'server/save.lua',
    'server/command.lua',
    'server/main.lua'
}

client_scripts {
    "rageui/RMenu.lua",
    "rageui/menu/RageUI.lua",
    "rageui/menu/Menu.lua",
    "rageui/menu/MenuController.lua",
    "rageui/components/Audio.lua",
    "rageui/components/Enum.lua",
    "rageui/components/Keys.lua",
    "rageui/components/Rectangle.lua",
    "rageui/components/Sprite.lua",
    "rageui/components/Text.lua",
    "rageui/components/Visual.lua",
    "rageui/menu/elements/ItemsBadge.lua",
    "rageui/menu/elements/ItemsColour.lua",
    "rageui/menu/elements/PanelColour.lua",
    "rageui/menu/items/UIButton.lua",
    "rageui/menu/items/UICheckBox.lua",
    "rageui/menu/items/UIList.lua",
    "rageui/menu/items/UIProgress.lua",
    "rageui/menu/items/UISeparator.lua",
    "rageui/menu/items/UISlider.lua",
    "rageui/menu/items/UISliderHeritage.lua",
    "rageui/menu/items/UISliderProgress.lua",
    "rageui/menu/panels/UIButtonPanel.lua",
    "rageui/menu/panels/UIColourPanel.lua",
    "rageui/menu/panels/UIGridPanel.lua",
    "rageui/menu/panels/UIPercentagePanel.lua",
    "rageui/menu/panels/UIStatisticsPanel.lua",
    "rageui/menu/windows/UIHeritage.lua",
}


client_scripts {
    'config.lua',
    'client/alter.lua',
    'client/class.lua',
    'client/streaming.lua',
    'client/world.lua',
    'client/shared.lua',
    'client/main.lua',
    'client/listenners.lua'
}


exports         'ARPFetchObject'
server_exports  'ARPFetchObject'