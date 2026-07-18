--[[
    Settings.lua — Obsidian UI Settings Script
    Repo: https://github.com/deividcomsono/Obsidian
    
    Drop this file into your forked repo and execute via:
        loadstring(game:HttpGet("https://raw.githubusercontent.com/PXG4E/Obsidian/main/Settings.lua"))()
    
    Or run locally in Roblox Studio via the Script Editor.
--]]

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library     = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager  = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

-- ─── Window ───────────────────────────────────────────────────────────────────

local Window = Library:CreateWindow({
    Title         = "Settings",
    Footer        = "",
    ShowCustomCursor = true,
    NotifySide    = "Right",
    AutoShow      = true,
    -- Center the window on screen
    Center        = true,
})

-- ─── Tabs (sidebar categories) ────────────────────────────────────────────────

local Tabs = {
    Audio         = Window:AddTab("Audio",         "music"),
    Gameplay      = Window:AddTab("Gameplay",      "gamepad-2"),
    Graphics      = Window:AddTab("Graphics",      "monitor"),
    Units         = Window:AddTab("Units",         "shield"),
    Enemies       = Window:AddTab("Enemies",       "skull"),
    Miscellaneous = Window:AddTab("Miscellaneous", "more-horizontal"),
    Keybinds      = Window:AddTab("Keybinds",      "keyboard"),
    Testing       = Window:AddTab("Testing",       "test-tube-2"),
    UISettings    = Window:AddTab("UI Settings",   "settings"),
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- AUDIO TAB
-- ═══════════════════════════════════════════════════════════════════════════════

local AudioLeft  = Tabs.Audio:AddLeftGroupbox("Volume")
local AudioRight = Tabs.Audio:AddRightGroupbox("Volume")

-- Music Volume
AudioLeft:AddSlider("MusicVolume", {
    Text     = "Music Volume",
    Tooltip  = "Adjusts all game music volume",
    Default  = 0,
    Min      = 0,
    Max      = 2,
    Rounding = 1,
    Compact  = false,
    HideMax  = true,

    Callback = function(Value)
        -- Wire to your game's SoundService music group:
        -- game:GetService("SoundService"):SetVolumeByName("Music", Value)
    end,
})

Options.MusicVolume:OnChanged(function()
    -- game:GetService("SoundService"):SetVolumeByName("Music", Options.MusicVolume.Value)
end)

-- SFX Volume
AudioRight:AddSlider("SFXVolume", {
    Text     = "SFX Volume",
    Tooltip  = "Adjusts all game sound effect volume",
    Default  = 1,
    Min      = 0,
    Max      = 2,
    Rounding = 1,
    Compact  = false,
    HideMax  = true,

    Callback = function(Value)
        -- game:GetService("SoundService"):SetVolumeByName("SFX", Value)
    end,
})

-- Ambient Volume (spans bottom row)
local AudioBottom = Tabs.Audio:AddLeftGroupbox("Ambient")

AudioBottom:AddSlider("AmbientVolume", {
    Text     = "Ambient Volume",
    Tooltip  = "Adjusts all ambient volume",
    Default  = 1.2,
    Min      = 0,
    Max      = 2,
    Rounding = 1,
    Compact  = false,
    HideMax  = true,

    Callback = function(Value)
        -- game:GetService("SoundService"):SetVolumeByName("Ambient", Value)
    end,
})

-- ═══════════════════════════════════════════════════════════════════════════════
-- GAMEPLAY TAB
-- ═══════════════════════════════════════════════════════════════════════════════

local GameplayLeft  = Tabs.Gameplay:AddLeftGroupbox("Actions & Toggles")
local GameplayRight = Tabs.Gameplay:AddRightGroupbox("Automation")

-- ── Left column ───────────────────────────────────────────────────────────────

-- Teleport To Spawn (action button)
GameplayLeft:AddButton({
    Text        = "Teleport To Spawn",
    Tooltip     = "Go to your current map's spawn point",
    DoubleClick = false,

    Func = function()
        local LocalPlayer = game:GetService("Players").LocalPlayer
        local SpawnLocation = workspace:FindFirstChildOfClass("SpawnLocation")
        if SpawnLocation then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = SpawnLocation.CFrame + Vector3.new(0, 3, 0)
            end
        end
    end,
})

-- Auto Vote Start
GameplayLeft:AddToggle("AutoVoteStart", {
    Text    = "Auto Vote Start",
    Tooltip = "Automatically vote to start games",
    Default = false,

    Callback = function(Value)
        -- hook into your vote system here
    end,
})

-- Display Pinned Quests
GameplayLeft:AddToggle("DisplayPinnedQuests", {
    Text    = "Display Pinned Quests",
    Tooltip = "Display all pinned quests in-game",
    Default = true,

    Callback = function(Value)
        -- toggle quest display GUI here
    end,
})

-- Show Max Range on Placement
GameplayLeft:AddToggle("ShowMaxRange", {
    Text    = "Show Max Range on Placement",
    Tooltip = "Show units' max range when placing",
    Default = true,

    Callback = function(Value)
        -- toggle range visualizer here
    end,
})

-- Auto Retry
GameplayLeft:AddToggle("AutoRetry", {
    Text    = "Auto Retry",
    Tooltip = "Automatically retry when a match ends",
    Default = false,
    Risky   = true, -- highlighted red as a "risky" setting

    Callback = function(Value)
        -- hook into match end event here
    end,
})

-- ── Right column ──────────────────────────────────────────────────────────────

-- Auto Skip Waves
GameplayRight:AddToggle("AutoSkipWaves", {
    Text    = "Auto Skip Waves",
    Tooltip = "Automatically vote to skip waves",
    Default = false,
    Risky   = true,

    Callback = function(Value)
        -- hook into wave vote system here
    end,
})

-- Show Match End Rewards
GameplayRight:AddToggle("ShowMatchEndRewards", {
    Text    = "Show Match End Rewards",
    Tooltip = "Show reward pop-ups after matches",
    Default = true,

    Callback = function(Value)
        -- toggle rewards GUI here
    end,
})

-- Select Unit on Placement
GameplayRight:AddToggle("SelectUnitOnPlacement", {
    Text    = "Select Unit on Placement",
    Tooltip = "Automatically select placed units",
    Default = true,

    Callback = function(Value)
        -- toggle unit selection logic here
    end,
})

-- Display Path Visualizers
GameplayRight:AddToggle("DisplayPathVisualizers", {
    Text    = "Display Path Visualizers",
    Tooltip = "Display path visualizers in-game",
    Default = true,

    Callback = function(Value)
        -- toggle path lines here
    end,
})

-- Auto Next
GameplayRight:AddToggle("AutoNext", {
    Text    = "Auto Next",
    Tooltip = "Automatically proceed to the next match",
    Default = false,
    Risky   = true,

    Callback = function(Value)
        -- hook into next-match event here
    end,
})

-- ═══════════════════════════════════════════════════════════════════════════════
-- GRAPHICS TAB
-- ═══════════════════════════════════════════════════════════════════════════════

local GraphicsLeft  = Tabs.Graphics:AddLeftGroupbox("Quality")
local GraphicsRight = Tabs.Graphics:AddRightGroupbox("Display")

GraphicsLeft:AddSlider("QualityLevel", {
    Text     = "Quality Level",
    Tooltip  = "Overall rendering quality (1 = lowest, 21 = highest)",
    Default  = 10,
    Min      = 1,
    Max      = 21,
    Rounding = 0,

    Callback = function(Value)
        settings().Rendering.QualityLevel = Enum.QualityLevel["Level" .. tostring(Value)]
    end,
})

GraphicsLeft:AddToggle("Shadows", {
    Text    = "Shadows",
    Tooltip = "Toggle in-game shadows",
    Default = true,

    Callback = function(Value)
        game:GetService("Lighting").GlobalShadows = Value
    end,
})

GraphicsRight:AddToggle("ShowFPS", {
    Text    = "Show FPS Counter",
    Tooltip = "Display an in-game FPS counter",
    Default = false,

    Callback = function(Value)
        -- toggle FPS label here
    end,
})

GraphicsRight:AddToggle("ReduceParticles", {
    Text    = "Reduce Particles",
    Tooltip = "Reduce particle effects for better performance",
    Default = false,

    Callback = function(Value)
        -- iterate Workspace descendants and reduce ParticleEmitter rates
    end,
})

-- ═══════════════════════════════════════════════════════════════════════════════
-- UNITS TAB
-- ═══════════════════════════════════════════════════════════════════════════════

local UnitsLeft  = Tabs.Units:AddLeftGroupbox("Placement")
local UnitsRight = Tabs.Units:AddRightGroupbox("Upgrades")

UnitsLeft:AddToggle("ShowUnitHealthBars", {
    Text    = "Show Unit Health Bars",
    Tooltip = "Display health bars above friendly units",
    Default = true,
    Callback = function(Value) end,
})

UnitsLeft:AddToggle("ShowUnitLevel", {
    Text    = "Show Unit Level",
    Tooltip = "Display level indicators above units",
    Default = true,
    Callback = function(Value) end,
})

UnitsRight:AddToggle("AutoUpgradeUnits", {
    Text    = "Auto Upgrade Units",
    Tooltip = "Automatically upgrade units when affordable",
    Default = false,
    Risky   = true,
    Callback = function(Value) end,
})

UnitsRight:AddToggle("ConfirmSell", {
    Text    = "Confirm Before Selling",
    Tooltip = "Show a confirmation dialog before selling a unit",
    Default = true,
    Callback = function(Value) end,
})

-- ═══════════════════════════════════════════════════════════════════════════════
-- ENEMIES TAB
-- ═══════════════════════════════════════════════════════════════════════════════

local EnemiesLeft  = Tabs.Enemies:AddLeftGroupbox("Display")
local EnemiesRight = Tabs.Enemies:AddRightGroupbox("Indicators")

EnemiesLeft:AddToggle("ShowEnemyHealthBars", {
    Text    = "Show Enemy Health Bars",
    Tooltip = "Display health bars above enemies",
    Default = true,
    Callback = function(Value) end,
})

EnemiesLeft:AddToggle("ShowEnemyNames", {
    Text    = "Show Enemy Names",
    Tooltip = "Display enemy type labels in-game",
    Default = false,
    Callback = function(Value) end,
})

EnemiesRight:AddToggle("BossWarning", {
    Text    = "Boss Warning",
    Tooltip = "Show a notification when a boss spawns",
    Default = true,
    Callback = function(Value) end,
})

EnemiesRight:AddToggle("EnemyPathPreview", {
    Text    = "Enemy Path Preview",
    Tooltip = "Highlight the path enemies will follow",
    Default = false,
    Callback = function(Value) end,
})

-- ═══════════════════════════════════════════════════════════════════════════════
-- MISCELLANEOUS TAB
-- ═══════════════════════════════════════════════════════════════════════════════

local MiscLeft  = Tabs.Miscellaneous:AddLeftGroupbox("General")
local MiscRight = Tabs.Miscellaneous:AddRightGroupbox("Notifications")

MiscLeft:AddToggle("ShowPing", {
    Text    = "Show Ping",
    Tooltip = "Display your current ping in-game",
    Default = false,
    Callback = function(Value) end,
})

MiscLeft:AddToggle("AutoReady", {
    Text    = "Auto Ready",
    Tooltip = "Automatically mark yourself as ready",
    Default = false,
    Risky   = true,
    Callback = function(Value) end,
})

MiscRight:AddToggle("WaveNotifications", {
    Text    = "Wave Notifications",
    Tooltip = "Show a notification at the start of each wave",
    Default = true,
    Callback = function(Value) end,
})

MiscRight:AddToggle("ChatNotifications", {
    Text    = "Chat Notifications",
    Tooltip = "Show in-chat event messages",
    Default = true,
    Callback = function(Value) end,
})

-- ═══════════════════════════════════════════════════════════════════════════════
-- KEYBINDS TAB
-- ═══════════════════════════════════════════════════════════════════════════════

local KeyLeft  = Tabs.Keybinds:AddLeftGroupbox("Movement & Interaction")
local KeyRight = Tabs.Keybinds:AddRightGroupbox("Units & Menus")

-- Reset all keybinds to defaults
KeyLeft:AddButton({
    Text        = "Reset Keybinds",
    Tooltip     = "Reset all keybinds to their default values",
    DoubleClick = true, -- safety: must click twice

    Func = function()
        local defaults = {
            Dash                  = "Q",
            InteractPrompt        = "E",
            RotateUnit            = "R",
            QuickPlacement        = "LeftShift",
            AutoUpgradeUnit       = nil,
            ChangeUnitTargeting   = "X",
            ToggleAutoUpgrade     = nil,
            ToggleQuestsMenu      = nil,
            Sprint                = "LeftShift",
            ToggleShiftLock       = "LeftControl",
            CancelUnitPlacement   = "Z",
            UpgradeUnit           = "X",
            SellUnit              = "X",
            ToggleAutoSkipWaves   = nil,
            TogglePlayMenu        = nil,
            ToggleAreasMenu       = nil,
        }
        for idx, key in pairs(defaults) do
            if Options[idx] then
                Options[idx]:SetValue({ key or "Unknown", "Toggle" })
            end
        end
        Library:Notify({
            Title       = "Keybinds Reset",
            Description = "All keybinds have been reset to their defaults.",
            Time        = 3,
        })
    end,
})

KeyLeft:AddDivider()

-- ── Left keybinds ─────────────────────────────────────────────────────────────

KeyLeft:AddLabel("Dash"):AddKeyPicker("Dash", {
    Default        = "Q",
    Mode           = "Press",
    Text           = "Dash",
    NoUI           = false,
    Callback       = function() end,
    ChangedCallback = function(NewKey) end,
})

KeyLeft:AddLabel("Interact Prompt"):AddKeyPicker("InteractPrompt", {
    Default        = "E",
    Mode           = "Press",
    Text           = "Interact Prompt",
    NoUI           = false,
    Callback       = function() end,
    ChangedCallback = function(NewKey) end,
})

KeyLeft:AddLabel("Rotate Unit"):AddKeyPicker("RotateUnit", {
    Default        = "R",
    Mode           = "Press",
    Text           = "Rotate Unit",
    NoUI           = false,
    Callback       = function() end,
    ChangedCallback = function(NewKey) end,
})

KeyLeft:AddLabel("Quick Placement"):AddKeyPicker("QuickPlacement", {
    Default        = "LeftShift",
    Mode           = "Hold",
    Text           = "Quick Placement",
    NoUI           = false,
    Callback       = function() end,
    ChangedCallback = function(NewKey) end,
})

KeyLeft:AddLabel("Auto Upgrade Unit"):AddKeyPicker("AutoUpgradeUnit", {
    Default        = "Unknown",
    Mode           = "Toggle",
    Text           = "Auto Upgrade Unit",
    NoUI           = false,
    Callback       = function() end,
    ChangedCallback = function(NewKey) end,
})

KeyLeft:AddLabel("Change Unit Targeting"):AddKeyPicker("ChangeUnitTargeting", {
    Default        = "X",
    Mode           = "Press",
    Text           = "Change Unit Targeting",
    NoUI           = false,
    Callback       = function() end,
    ChangedCallback = function(NewKey) end,
})

KeyLeft:AddLabel("Toggle Auto-Upgrade Placed Units"):AddKeyPicker("ToggleAutoUpgrade", {
    Default        = "Unknown",
    Mode           = "Toggle",
    Text           = "Toggle Auto-Upgrade Placed Units",
    NoUI           = false,
    Callback       = function() end,
    ChangedCallback = function(NewKey) end,
})

KeyLeft:AddLabel("Toggle Quests Menu"):AddKeyPicker("ToggleQuestsMenu", {
    Default        = "Unknown",
    Mode           = "Toggle",
    Text           = "Toggle Quests Menu",
    NoUI           = false,
    Callback       = function() end,
    ChangedCallback = function(NewKey) end,
})

-- ── Right keybinds ────────────────────────────────────────────────────────────

KeyRight:AddLabel("Sprint"):AddKeyPicker("Sprint", {
    Default        = "LeftShift",
    Mode           = "Hold",
    Text           = "Sprint",
    NoUI           = false,
    Callback       = function() end,
    ChangedCallback = function(NewKey) end,
})

KeyRight:AddLabel("Toggle Shift Lock"):AddKeyPicker("ToggleShiftLock", {
    Default        = "LeftControl",
    Mode           = "Toggle",
    Text           = "Toggle Shift Lock",
    NoUI           = false,
    Callback       = function() end,
    ChangedCallback = function(NewKey) end,
})

KeyRight:AddLabel("Cancel Unit Placement"):AddKeyPicker("CancelUnitPlacement", {
    Default        = "Z",
    Mode           = "Press",
    Text           = "Cancel Unit Placement",
    NoUI           = false,
    Callback       = function() end,
    ChangedCallback = function(NewKey) end,
})

KeyRight:AddLabel("Upgrade Unit"):AddKeyPicker("UpgradeUnit", {
    Default        = "X",
    Mode           = "Press",
    Text           = "Upgrade Unit",
    NoUI           = false,
    Callback       = function() end,
    ChangedCallback = function(NewKey) end,
})

KeyRight:AddLabel("Sell Unit"):AddKeyPicker("SellUnit", {
    Default        = "X",
    Mode           = "Press",
    Text           = "Sell Unit",
    NoUI           = false,
    Callback       = function() end,
    ChangedCallback = function(NewKey) end,
})

KeyRight:AddLabel("Toggle Auto Skip Waves"):AddKeyPicker("ToggleAutoSkipWaves", {
    Default        = "Unknown",
    Mode           = "Toggle",
    Text           = "Toggle Auto Skip Waves",
    NoUI           = false,
    Callback       = function() end,
    ChangedCallback = function(NewKey) end,
})

KeyRight:AddLabel("Toggle Play Menu"):AddKeyPicker("TogglePlayMenu", {
    Default        = "Unknown",
    Mode           = "Toggle",
    Text           = "Toggle Play Menu",
    NoUI           = false,
    Callback       = function() end,
    ChangedCallback = function(NewKey) end,
})

KeyRight:AddLabel("Toggle Areas Menu"):AddKeyPicker("ToggleAreasMenu", {
    Default        = "Unknown",
    Mode           = "Toggle",
    Text           = "Toggle Areas Menu",
    NoUI           = false,
    Callback       = function() end,
    ChangedCallback = function(NewKey) end,
})

-- ═══════════════════════════════════════════════════════════════════════════════
-- TESTING TAB
-- ═══════════════════════════════════════════════════════════════════════════════

local TestLeft  = Tabs.Testing:AddLeftGroupbox("Debug Tools")
local TestRight = Tabs.Testing:AddRightGroupbox("Logging")

TestLeft:AddToggle("DebugMode", {
    Text    = "Debug Mode",
    Tooltip = "Enable debug overlays and verbose logging",
    Default = false,
    Risky   = true,
    Callback = function(Value) end,
})

TestLeft:AddButton({
    Text   = "Print All Settings",
    Tooltip = "Dump all current setting values to the output",
    Func = function()
        for k, v in pairs(Toggles) do
            print(k, "=", v.Value)
        end
        for k, v in pairs(Options) do
            if v.Value ~= nil then
                print(k, "=", v.Value)
            end
        end
    end,
})

TestRight:AddToggle("VerboseLogging", {
    Text    = "Verbose Logging",
    Tooltip = "Log all events to the developer console",
    Default = false,
    Callback = function(Value) end,
})

-- ═══════════════════════════════════════════════════════════════════════════════
-- UI SETTINGS TAB  (theme + save/load config)
-- ═══════════════════════════════════════════════════════════════════════════════

local MenuGroup = Tabs.UISettings:AddLeftGroupbox("Menu", "wrench")

MenuGroup:AddToggle("KeybindMenuOpen", {
    Default  = Library.KeybindFrame.Visible,
    Text     = "Open Keybind Menu",
    Callback = function(Value)
        Library.KeybindFrame.Visible = Value
    end,
})

MenuGroup:AddToggle("ShowCustomCursor", {
    Text     = "Custom Cursor",
    Default  = Library.ShowCustomCursor,
    Callback = function(Value)
        Library.ShowCustomCursor = Value
    end,
})

MenuGroup:AddDropdown("NotificationSide", {
    Values   = { "Left", "Right" },
    Default  = "Right",
    Text     = "Notification Side",
    Callback = function(Value)
        Library:SetNotifySide(Value)
    end,
})

MenuGroup:AddSlider("UICornerSlider", {
    Text     = "Corner Radius",
    Default  = Library.CornerRadius,
    Min      = 0,
    Max      = 20,
    Rounding = 0,
    Callback = function(Value)
        Window:SetCornerRadius(Value)
    end,
})

MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu Keybind")
    :AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })

MenuGroup:AddButton("Unload", function()
    Library:Unload()
end)

Library.ToggleKeybind = Options.MenuKeybind

-- ─── Addons ───────────────────────────────────────────────────────────────────

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

ThemeManager:SetFolder("ObsidianSettings")
SaveManager:SetFolder("ObsidianSettings")

SaveManager:BuildConfigSection(Tabs.UISettings)
ThemeManager:ApplyToTab(Tabs.UISettings)

SaveManager:LoadAutoloadConfig()
