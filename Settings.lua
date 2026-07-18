--[[
    Settings.lua — Custom UI + Obsidian backend
    Repo: https://github.com/PXG4E/Expeditions

    Run:
        loadstring(game:HttpGet("https://raw.githubusercontent.com/PXG4E/Expeditions/main/Settings.lua"))()
--]]

-- ─── 1. Load Obsidian (backend only — window stays hidden) ───────────────────
local repo = "https://raw.githubusercontent.com/PXG4E/Expeditions/main/"

local function load(url)
    local ok, result = pcall(function() return loadstring(game:HttpGet(url))() end)
    if not ok then warn("[Settings] failed to load " .. url .. "\n" .. tostring(result)) end
    return ok and result or nil
end

local Library      = load(repo .. "Library.lua")
local SaveManager  = load(repo .. "addons/SaveManager.lua")
local ThemeManager = load(repo .. "addons/ThemeManager.lua")

if not Library then return end

local Toggles = Library.Toggles
local Options  = Library.Options

-- ─── 2. Hidden Obsidian window — registers all state, keybinds, save/load ────
local Win = Library:CreateWindow({
    Title    = "Settings",
    AutoShow = false,
    Center   = true,
})

local Tabs = {
    Audio    = Win:AddTab("Audio"),
    Gameplay = Win:AddTab("Gameplay"),
    Config   = Win:AddTab("Config"),
}

-- Audio sliders
local AudioBox = Tabs.Audio:AddLeftGroupbox("Audio")
AudioBox:AddSlider("MusicVolume",   { Text = "Music Volume",   Default = 1.2, Min = 0, Max = 2, Rounding = 1 })
AudioBox:AddSlider("SFXVolume",     { Text = "SFX Volume",     Default = 1.0, Min = 0, Max = 2, Rounding = 1 })
AudioBox:AddSlider("AmbientVolume", { Text = "Ambient Volume", Default = 1.2, Min = 0, Max = 2, Rounding = 1 })

-- Gameplay toggles
local GameBox = Tabs.Gameplay:AddLeftGroupbox("Gameplay")
GameBox:AddToggle("AutoSkipWaves",         { Text = "Auto Skip Waves",            Default = false })
GameBox:AddToggle("AutoVoteStart",         { Text = "Auto Vote Start",            Default = false })
GameBox:AddToggle("ShowMatchEndRewards",   { Text = "Show Match End Rewards",     Default = true  })
GameBox:AddToggle("DisplayPinnedQuests",   { Text = "Display Pinned Quests",      Default = true  })
GameBox:AddToggle("SelectUnitOnPlacement", { Text = "Select Unit on Placement",   Default = true  })
GameBox:AddToggle("ShowMaxRange",          { Text = "Show Max Range on Placement",Default = true  })
GameBox:AddToggle("DisplayPathVisualizers",{ Text = "Display Path Visualizers",   Default = true  })
GameBox:AddToggle("AutoRetry",             { Text = "Auto Retry",                 Default = false })
GameBox:AddToggle("AutoNext",             { Text = "Auto Next",                  Default = false })

-- Graphics
local GfxBox = Tabs.Gameplay:AddRightGroupbox("Graphics")
GfxBox:AddSlider("QualityLevel",    { Text = "Quality Level",   Default = 10,  Min = 1,  Max = 21, Rounding = 0 })
GfxBox:AddToggle("Shadows",         { Text = "Shadows",         Default = true  })
GfxBox:AddToggle("ShowFPS",         { Text = "Show FPS",        Default = false })
GfxBox:AddToggle("ReduceParticles", { Text = "Reduce Particles",Default = false })

-- Units
local UnitsBox = Tabs.Gameplay:AddLeftGroupbox("Units")
UnitsBox:AddToggle("UnitHealthBars", { Text = "Show Unit Health Bars",   Default = true  })
UnitsBox:AddToggle("UnitLevel",      { Text = "Show Unit Level",         Default = true  })
UnitsBox:AddToggle("AutoUpgrade",    { Text = "Auto Upgrade Units",      Default = false })
UnitsBox:AddToggle("ConfirmSell",    { Text = "Confirm Before Selling",  Default = true  })

-- Enemies
local EnemyBox = Tabs.Gameplay:AddRightGroupbox("Enemies")
EnemyBox:AddToggle("EnemyHealthBars",{ Text = "Show Enemy Health Bars",  Default = true  })
EnemyBox:AddToggle("EnemyNames",     { Text = "Show Enemy Names",        Default = false })
EnemyBox:AddToggle("BossWarning",    { Text = "Boss Warning",            Default = true  })
EnemyBox:AddToggle("PathPreview",    { Text = "Enemy Path Preview",      Default = false })

-- Misc
local MiscBox = Tabs.Gameplay:AddLeftGroupbox("Misc")
MiscBox:AddToggle("ShowPing",       { Text = "Show Ping",           Default = false })
MiscBox:AddToggle("AutoReady",      { Text = "Auto Ready",          Default = false })
MiscBox:AddToggle("WaveNotifs",     { Text = "Wave Notifications",  Default = true  })
MiscBox:AddToggle("ChatNotifs",     { Text = "Chat Notifications",  Default = true  })

-- Keybinds
local KeyBox = Tabs.Config:AddLeftGroupbox("Keybinds")
local KEYBIND_DEFS = {
    { id = "KbDash",              label = "Dash",                           default = "Q",            mode = "Press"  },
    { id = "KbSprint",            label = "Sprint",                         default = "LeftShift",    mode = "Hold"   },
    { id = "KbInteract",          label = "Interact Prompt",                default = "E",            mode = "Press"  },
    { id = "KbShiftLock",         label = "Toggle Shift Lock",              default = "LeftControl",  mode = "Toggle" },
    { id = "KbRotate",            label = "Rotate Unit",                    default = "R",            mode = "Press"  },
    { id = "KbCancel",            label = "Cancel Unit Placement",          default = "Z",            mode = "Press"  },
    { id = "KbQuickPlace",        label = "Quick Placement",                default = "LeftShift",    mode = "Hold"   },
    { id = "KbUpgrade",           label = "Upgrade Unit",                   default = "X",            mode = "Press"  },
    { id = "KbAutoUpgrade",       label = "Auto Upgrade Unit",              default = "Unknown",      mode = "Toggle" },
    { id = "KbSell",              label = "Sell Unit",                      default = "X",            mode = "Press"  },
    { id = "KbTargeting",         label = "Change Unit Targeting",          default = "X",            mode = "Press"  },
    { id = "KbAutoSkip",          label = "Toggle Auto Skip Waves",         default = "Unknown",      mode = "Toggle" },
    { id = "KbAutoUpgradePlaced", label = "Toggle Auto-Upgrade Placed",     default = "Unknown",      mode = "Toggle" },
    { id = "KbPlayMenu",          label = "Toggle Play Menu",               default = "Unknown",      mode = "Toggle" },
    { id = "KbQuestsMenu",        label = "Toggle Quests Menu",             default = "Unknown",      mode = "Toggle" },
    { id = "KbAreasMenu",         label = "Toggle Areas Menu",              default = "Unknown",      mode = "Toggle" },
}

for _, kb in ipairs(KEYBIND_DEFS) do
    KeyBox:AddLabel(kb.label):AddKeyPicker(kb.id, {
        Default = kb.default,
        Mode    = kb.mode,
        Text    = kb.label,
        NoUI    = false,
    })
end

local CfgBox = Tabs.Config:AddRightGroupbox("Config")
CfgBox:AddLabel("Menu Keybind"):AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Toggle Menu" })
Library.ToggleKeybind = Options.MenuKeybind

if ThemeManager then ThemeManager:SetLibrary(Library); ThemeManager:SetFolder("Expeditions") end
if SaveManager  then
    SaveManager:SetLibrary(Library)
    SaveManager:IgnoreThemeSettings()
    SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
    SaveManager:SetFolder("Expeditions")
    if ThemeManager then SaveManager:BuildConfigSection(Tabs.Config) end
    SaveManager:LoadAutoloadConfig()
end

-- ─── 3. Custom UI ─────────────────────────────────────────────────────────────
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer      = Players.LocalPlayer
local PlayerGui        = LocalPlayer:WaitForChild("PlayerGui")

pcall(function()
    local old = PlayerGui:FindFirstChild("SettingsGui")
    if old then old:Destroy() end
end)

-- ─── Tween helpers ────────────────────────────────────────────────────────────
local TW_FAST   = TweenInfo.new(0.2,  Enum.EasingStyle.Quint,  Enum.EasingDirection.Out)
local TW_BOUNCE = TweenInfo.new(0.15, Enum.EasingStyle.Back,   Enum.EasingDirection.Out)
local TW_OPEN   = TweenInfo.new(0.35, Enum.EasingStyle.Back,   Enum.EasingDirection.Out)

local function Tween(obj, info, props)
    TweenService:Create(obj, info, props):Play()
end

-- ─── Lucide icon helper ───────────────────────────────────────────────────────
local iconCache = {}
local function getIcon(name)
    if name == nil then return nil end
    if iconCache[name] == nil then
        local ic = Library:GetCustomIcon(name)
        iconCache[name] = ic or false
    end
    return iconCache[name] or nil
end

-- ─── Color palette ────────────────────────────────────────────────────────────
local C = {
    BG       = Color3.fromRGB(10,  12,  16),
    Sidebar  = Color3.fromRGB(16,  19,  25),
    Card     = Color3.fromRGB(22,  26,  34),
    CardBdr  = Color3.fromRGB(38,  46,  62),
    Cyan     = Color3.fromRGB(0,   185, 210),
    CyanDim  = Color3.fromRGB(0,   140, 165),
    Text     = Color3.fromRGB(225, 230, 240),
    Sub      = Color3.fromRGB(120, 128, 145),
    Green    = Color3.fromRGB(34,  197, 94),
    Red      = Color3.fromRGB(220, 38,  50),
    SearchBG = Color3.fromRGB(26,  30,  40),
    SliderBG = Color3.fromRGB(32,  38,  50),
    SliderFG = Color3.fromRGB(0,   140, 165),
    White    = Color3.new(1,1,1),
    Black    = Color3.new(0,0,0),
}

-- ─── UI factories ─────────────────────────────────────────────────────────────
local function New(cls, props, parent)
    local o = Instance.new(cls)
    for k,v in pairs(props) do o[k] = v end
    if parent then o.Parent = parent end
    return o
end
local function Corner(r, p)  New("UICorner", { CornerRadius = UDim.new(0,r) }, p) end
local function Stroke(c,t,p)
    local s = New("UIStroke",{ Color=c, Thickness=t },p)
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return s
end
local function ListLayout(p, gap)
    New("UIListLayout",{ SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,gap or 0) }, p)
end
local function Pad(t,b,l,r,p)
    New("UIPadding",{ PaddingTop=UDim.new(0,t), PaddingBottom=UDim.new(0,b), PaddingLeft=UDim.new(0,l), PaddingRight=UDim.new(0,r) }, p)
end

-- Creates an ImageLabel for a Lucide icon; returns the label (or nil if icon unavailable)
local function IconImg(parent, iconName, color, pos, size)
    local ic = getIcon(iconName)
    if not ic then return nil end
    return New("ImageLabel", {
        AnchorPoint         = Vector2.new(0, 0.5),
        Position            = pos or UDim2.new(0, 10, 0.5, 0),
        Size                = size or UDim2.fromOffset(18, 18),
        BackgroundTransparency = 1,
        Image               = ic.Url,
        ImageColor3         = color or C.Cyan,
        ImageRectOffset     = ic.ImageRectOffset or Vector2.zero,
        ImageRectSize       = ic.ImageRectSize   or Vector2.zero,
        ScaleType           = Enum.ScaleType.Fit,
    }, parent)
end

-- ─── Screen / Window ──────────────────────────────────────────────────────────
local Gui = New("ScreenGui", {
    Name = "SettingsGui",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, PlayerGui)

-- Dim backdrop
local Backdrop = New("TextButton", {
    Size = UDim2.fromScale(1,1),
    BackgroundColor3 = Color3.new(0,0,0),
    BackgroundTransparency = 0.55,
    Text = "",
    ZIndex = 1,
}, Gui)
Backdrop.MouseButton1Click:Connect(function() end) -- capture clicks

-- Main window
local Win2 = New("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position    = UDim2.fromScale(0.5, 0.5),
    Size        = UDim2.fromOffset(980, 640),
    BackgroundColor3 = C.BG,
    ClipsDescendants = true,
    ZIndex = 2,
}, Gui)
Corner(10, Win2)
Stroke(C.Cyan, 2, Win2)

-- Pop-in animation on open
local WinScale = New("UIScale", { Scale = 0.92 }, Win2)
Tween(WinScale, TW_OPEN, { Scale = 1.0 })

-- ─── Top bar (drag handle) ────────────────────────────────────────────────────
local TopBar = New("Frame", {
    Size = UDim2.new(1, 0, 0, 62),
    BackgroundColor3 = C.BG,
    ZIndex = 3,
}, Win2)

-- Drag — TOP BAR ONLY
do
    local drag, ds, ws = false, nil, nil
    TopBar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true; ds = i.Position; ws = Win2.Position
        end
    end)
    TopBar.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - ds
            Win2.Position = UDim2.new(ws.X.Scale, ws.X.Offset + d.X, ws.Y.Scale, ws.Y.Offset + d.Y)
        end
    end)
end

-- Settings badge (left of top bar)
local Badge = New("Frame", {
    Size = UDim2.fromOffset(228, 62),
    BackgroundColor3 = C.Cyan,
    ZIndex = 3,
}, TopBar)
-- Angled right edge
New("Frame", {
    Position = UDim2.fromOffset(212, -2),
    Size     = UDim2.fromOffset(36, 66),
    BackgroundColor3 = C.Cyan,
    Rotation = -8,
    ZIndex = 2,
}, TopBar)
-- Settings icon + label
do
    local settingsIcon = IconImg(Badge, "settings", C.Black, UDim2.new(0, 12, 0.5, 0), UDim2.fromOffset(20, 20))
    local textOffset = settingsIcon and 38 or 14
    New("TextLabel", {
        Position  = UDim2.fromOffset(textOffset, 0),
        Size      = UDim2.new(1, -textOffset-4, 1, 0),
        BackgroundTransparency = 1,
        Text      = "SETTINGS",
        TextColor3 = C.Black,
        Font      = Enum.Font.GothamBold,
        TextSize  = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex    = 4,
    }, Badge)
end

-- Search bar
local SrchF = New("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position    = UDim2.new(0.5, 10, 0.5, 0),
    Size        = UDim2.fromOffset(390, 36),
    BackgroundColor3 = C.SearchBG,
    ZIndex = 4,
}, TopBar)
Corner(6, SrchF); Stroke(C.CardBdr, 1, SrchF)

-- Search icon
local srchIconF = New("Frame", {
    Size = UDim2.fromOffset(32, 36),
    BackgroundTransparency = 1,
    ZIndex = 5,
}, SrchF)
local srchIc = IconImg(srchIconF, "search", C.Sub, UDim2.new(0, 7, 0.5, 0), UDim2.fromOffset(16, 16))
if not srchIc then
    New("TextLabel", { Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="⌕", TextColor3=C.Sub, TextSize=16, ZIndex=5 }, srchIconF)
end

local SearchBox = New("TextBox", {
    Position           = UDim2.fromOffset(32, 0),
    Size               = UDim2.new(1, -38, 1, 0),
    BackgroundTransparency = 1,
    PlaceholderText    = "Search...",
    PlaceholderColor3  = C.Sub,
    Text               = "",
    TextColor3         = C.Text,
    Font               = Enum.Font.Gotham,
    TextSize           = 14,
    TextXAlignment     = Enum.TextXAlignment.Left,
    ClearTextOnFocus   = false,
    ZIndex = 5,
}, SrchF)

-- Close button
local CloseBtn = New("TextButton", {
    AnchorPoint = Vector2.new(1, 0.5),
    Position    = UDim2.new(1, -14, 0.5, 0),
    Size        = UDim2.fromOffset(36, 36),
    BackgroundColor3 = C.Red,
    Text = "",
    ZIndex = 4,
}, TopBar)
Corner(6, CloseBtn)
do
    local closeIc = IconImg(CloseBtn, "x", C.White, UDim2.new(0.5, -9, 0.5, -9), UDim2.fromOffset(18, 18))
    if not closeIc then
        New("TextLabel", { Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="✕", TextColor3=C.White, Font=Enum.Font.GothamBold, TextSize=16, ZIndex=5 }, CloseBtn)
    end
end
CloseBtn.MouseEnter:Connect(function() Tween(CloseBtn, TW_FAST, { BackgroundColor3=Color3.fromRGB(180,20,30) }) end)
CloseBtn.MouseLeave:Connect(function() Tween(CloseBtn, TW_FAST, { BackgroundColor3=C.Red }) end)
CloseBtn.MouseButton1Click:Connect(function()
    Tween(WinScale, TW_FAST, { Scale = 0.9 })
    task.delay(0.2, function() Gui:Destroy() end)
end)

-- Top bar bottom border
New("Frame", {
    Position = UDim2.fromOffset(0, 62),
    Size     = UDim2.new(1, 0, 0, 1),
    BackgroundColor3 = C.Cyan,
    BackgroundTransparency = 0.5,
    ZIndex = 3,
}, Win2)

-- ─── Sidebar ─────────────────────────────────────────────────────────────────
local SideFrame = New("Frame", {
    Position = UDim2.fromOffset(0, 63),
    Size     = UDim2.new(0, 238, 1, -63),
    BackgroundColor3 = C.Sidebar,
    ZIndex = 2,
}, Win2)
-- Right divider
New("Frame", {
    AnchorPoint = Vector2.new(1, 0),
    Position    = UDim2.fromScale(1, 0),
    Size        = UDim2.new(0, 1, 1, 0),
    BackgroundColor3 = C.Cyan,
    BackgroundTransparency = 0.5,
    ZIndex = 3,
}, SideFrame)

local TabScroll = New("ScrollingFrame", {
    Size                = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    ScrollBarThickness  = 0,
    CanvasSize          = UDim2.fromScale(0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ZIndex = 3,
}, SideFrame)
ListLayout(TabScroll, 4); Pad(8, 8, 8, 8, TabScroll)

-- ─── Content area ─────────────────────────────────────────────────────────────
local Content = New("ScrollingFrame", {
    Position            = UDim2.fromOffset(239, 63),
    Size                = UDim2.new(1, -239, 1, -63),
    BackgroundTransparency = 1,
    ScrollBarThickness  = 4,
    ScrollBarImageColor3 = C.Cyan,
    CanvasSize          = UDim2.fromScale(0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ZIndex = 2,
}, Win2)
ListLayout(Content, 10); Pad(14, 18, 18, 18, Content)

-- ─── Section header builder ───────────────────────────────────────────────────
local function SectionHeader(iconName, title, order)
    local f = New("Frame", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundTransparency = 1,
        LayoutOrder = order,
    }, Content)

    local ic = IconImg(f, iconName, C.Cyan, UDim2.new(0, 0, 0.5, -9), UDim2.fromOffset(18, 18))
    local txtX = ic and 24 or 0
    New("TextLabel", {
        Position  = UDim2.fromOffset(txtX, 0),
        Size      = UDim2.new(1, -txtX, 1, -4),
        BackgroundTransparency = 1,
        Text      = title,
        TextColor3 = C.Cyan,
        Font      = Enum.Font.GothamBold,
        TextSize  = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, f)

    -- Accent wave line below title
    New("Frame", {
        AnchorPoint = Vector2.new(0, 1),
        Position    = UDim2.fromScale(0, 1),
        Size        = UDim2.new(1, 0, 0, 2),
        BackgroundColor3 = C.Cyan,
        BackgroundTransparency = 0.65,
    }, f)

    return f
end

-- ─── Card grid ────────────────────────────────────────────────────────────────
local function CardGrid(order)
    local g = New("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = order,
    }, Content)
    New("UIGridLayout", {
        CellSize    = UDim2.new(0.5, -7, 0, 82),
        CellPadding = UDim2.new(0, 14, 0, 10),
        SortOrder   = Enum.SortOrder.LayoutOrder,
        Parent = g,
    })
    return g
end

-- ─── Slider card ──────────────────────────────────────────────────────────────
local function SliderCard(parent, id, label, desc, order)
    local opt  = Options[id]
    local card = New("Frame", { BackgroundColor3=C.Card, LayoutOrder=order }, parent)
    Corner(8, card); Stroke(C.CardBdr, 1, card)

    New("TextLabel", { Position=UDim2.fromOffset(13,9),  Size=UDim2.new(1,-14,0,17), BackgroundTransparency=1, Text=label, TextColor3=C.Text, Font=Enum.Font.GothamBold, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left }, card)
    New("TextLabel", { Position=UDim2.fromOffset(13,26), Size=UDim2.new(1,-14,0,15), BackgroundTransparency=1, Text=desc,  TextColor3=C.Sub,  Font=Enum.Font.Gotham,      TextSize=11, TextXAlignment=Enum.TextXAlignment.Left }, card)

    local valBG  = New("Frame",   { Position=UDim2.fromOffset(13,50), Size=UDim2.fromOffset(44,20), BackgroundColor3=C.SliderBG }, card); Corner(4, valBG)
    local valLbl = New("TextLabel",{ Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="0", TextColor3=C.Text, Font=Enum.Font.GothamBold, TextSize=11 }, valBG)

    local track = New("Frame",  { Position=UDim2.fromOffset(63,54), Size=UDim2.new(1,-78,0,8), BackgroundColor3=C.SliderBG }, card); Corner(4, track)
    local mn, mx = opt.Min, opt.Max
    local fill  = New("Frame",  { Size=UDim2.new((opt.Value-mn)/(mx-mn),0,1,0), BackgroundColor3=C.Cyan }, track); Corner(4, fill)
    local knob  = New("Frame",  { AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.new((opt.Value-mn)/(mx-mn),0,0.5,0), Size=UDim2.fromOffset(14,14), BackgroundColor3=C.Text }, track); Corner(7, knob)
    Stroke(C.Cyan, 2, knob)

    local function setUI(v)
        local pct = math.clamp((v-mn)/(mx-mn), 0, 1)
        local fmtV = string.format("%.1f", v)
        valLbl.Text = fmtV
        Tween(fill, TW_FAST, { Size = UDim2.new(pct, 0, 1, 0) })
        Tween(knob, TW_FAST, { Position = UDim2.new(pct, 0, 0.5, 0) })
    end
    setUI(opt.Value)
    opt:OnChanged(function() setUI(opt.Value) end)

    local down = false
    local function drag(x)
        local pct = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local newVal = math.floor((mn + pct*(mx-mn)) * 10 + 0.5) / 10
        opt:SetValue(newVal)
    end
    track.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then down=true; drag(i.Position.X) end end)
    knob.InputBegan:Connect(function(i)  if i.UserInputType==Enum.UserInputType.MouseButton1 then down=true end end)
    UserInputService.InputEnded:Connect(function(i)   if i.UserInputType==Enum.UserInputType.MouseButton1 then down=false end end)
    UserInputService.InputChanged:Connect(function(i) if down and i.UserInputType==Enum.UserInputType.MouseMovement then drag(i.Position.X) end end)
end

-- ─── Toggle card ──────────────────────────────────────────────────────────────
local checkIcon = getIcon("check")
local xIcon     = getIcon("x")

local function ToggleCard(parent, id, label, desc, order)
    local tog  = Toggles[id]
    local card = New("Frame", { BackgroundColor3=C.Card, LayoutOrder=order }, parent)
    Corner(8, card); Stroke(C.CardBdr, 1, card)

    New("TextLabel", { Position=UDim2.fromOffset(13,13), Size=UDim2.new(1,-62,0,17), BackgroundTransparency=1, Text=label, TextColor3=C.Text, Font=Enum.Font.GothamBold, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left }, card)
    New("TextLabel", { Position=UDim2.fromOffset(13,30), Size=UDim2.new(1,-62,0,34), BackgroundTransparency=1, Text=desc,  TextColor3=C.Sub,  Font=Enum.Font.Gotham,      TextSize=11, TextXAlignment=Enum.TextXAlignment.Left, TextWrapped=true, TextYAlignment=Enum.TextYAlignment.Top }, card)

    local btn = New("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position    = UDim2.new(1, -12, 0.5, 0),
        Size        = UDim2.fromOffset(38, 38),
        BackgroundColor3 = tog.Value and C.Green or C.Red,
    }, card)
    Corner(7, btn)

    -- Icon image inside button (check or x)
    local iconImg = nil
    do
        local ic = tog.Value and checkIcon or xIcon
        if ic then
            iconImg = New("ImageLabel", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position    = UDim2.fromScale(0.5, 0.5),
                Size        = UDim2.fromOffset(20, 20),
                BackgroundTransparency = 1,
                Image       = ic.Url,
                ImageColor3 = C.White,
                ImageRectOffset = ic.ImageRectOffset or Vector2.zero,
                ImageRectSize   = ic.ImageRectSize   or Vector2.zero,
                ScaleType   = Enum.ScaleType.Fit,
            }, btn)
        else
            -- Fallback text
            New("TextLabel", { Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text=tog.Value and "✓" or "✕", TextColor3=C.White, Font=Enum.Font.GothamBold, TextSize=20 }, btn)
        end
    end

    local function updateBtn(animated)
        local newBg   = tog.Value and C.Green or C.Red
        local newIcon = tog.Value and checkIcon or xIcon
        if animated then
            Tween(btn, TW_FAST, { BackgroundColor3 = newBg })
        else
            btn.BackgroundColor3 = newBg
        end
        if iconImg and newIcon then
            iconImg.Image           = newIcon.Url
            iconImg.ImageRectOffset = newIcon.ImageRectOffset or Vector2.zero
            iconImg.ImageRectSize   = newIcon.ImageRectSize   or Vector2.zero
        end
    end
    tog:OnChanged(function() updateBtn(true) end)

    -- Clickable overlay for the whole button frame
    local clickBtn = New("TextButton", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = "",
    }, btn)

    clickBtn.MouseButton1Click:Connect(function()
        tog:SetValue(not tog.Value)
        -- Bounce animation: grow then shrink back
        Tween(btn, TW_BOUNCE, { Size = UDim2.fromOffset(43, 43) })
        task.delay(0.15, function()
            Tween(btn, TW_FAST, { Size = UDim2.fromOffset(38, 38) })
        end)
    end)

    -- Hover effect
    clickBtn.MouseEnter:Connect(function() Tween(btn, TW_FAST, { Size = UDim2.fromOffset(40, 40) }) end)
    clickBtn.MouseLeave:Connect(function() Tween(btn, TW_FAST, { Size = UDim2.fromOffset(38, 38) }) end)
end

-- ─── Action card ──────────────────────────────────────────────────────────────
local function ActionCard(parent, label, desc, order, iconName, cb)
    local card = New("Frame", { BackgroundColor3=C.Card, LayoutOrder=order }, parent)
    Corner(8, card); Stroke(C.CardBdr, 1, card)
    New("TextLabel", { Position=UDim2.fromOffset(13,13), Size=UDim2.new(1,-62,0,17), BackgroundTransparency=1, Text=label, TextColor3=C.Text, Font=Enum.Font.GothamBold, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left }, card)
    New("TextLabel", { Position=UDim2.fromOffset(13,30), Size=UDim2.new(1,-62,0,34), BackgroundTransparency=1, Text=desc,  TextColor3=C.Sub,  Font=Enum.Font.Gotham,      TextSize=11, TextXAlignment=Enum.TextXAlignment.Left, TextWrapped=true, TextYAlignment=Enum.TextYAlignment.Top }, card)

    local btn = New("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position    = UDim2.new(1, -12, 0.5, 0),
        Size        = UDim2.fromOffset(38, 38),
        BackgroundColor3 = C.SliderBG,
        Text = "",
    }, card)
    Corner(7, btn); Stroke(C.CardBdr, 1, btn)

    -- Lucide icon inside the action button
    local ic = getIcon(iconName or "arrow-down")
    if ic then
        New("ImageLabel", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position    = UDim2.fromScale(0.5, 0.5),
            Size        = UDim2.fromOffset(18, 18),
            BackgroundTransparency = 1,
            Image       = ic.Url,
            ImageColor3 = C.Text,
            ImageRectOffset = ic.ImageRectOffset or Vector2.zero,
            ImageRectSize   = ic.ImageRectSize   or Vector2.zero,
            ScaleType   = Enum.ScaleType.Fit,
        }, btn)
    else
        New("TextLabel", { Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="→", TextColor3=C.Text, Font=Enum.Font.GothamBold, TextSize=18 }, btn)
    end

    btn.MouseEnter:Connect(function() Tween(btn, TW_FAST, { BackgroundColor3=C.CyanDim }) end)
    btn.MouseLeave:Connect(function() Tween(btn, TW_FAST, { BackgroundColor3=C.SliderBG }) end)
    btn.MouseButton1Click:Connect(function()
        if cb then pcall(cb) end
        Tween(btn, TW_BOUNCE, { Size=UDim2.fromOffset(42,42) })
        task.delay(0.15, function() Tween(btn, TW_FAST, { Size=UDim2.fromOffset(38,38) }) end)
    end)
end

-- ─── 4. Build sections ────────────────────────────────────────────────────────
local tabSections = {}
local function reg(name, ...)
    tabSections[name] = tabSections[name] or {}
    for _, f in ipairs({...}) do table.insert(tabSections[name], f) end
end

-- AUDIO
local aHdr  = SectionHeader("volume-2",   "AUDIO",    10)
local aGrid = CardGrid(11)
SliderCard(aGrid,"MusicVolume",  "Music Volume",   "Adjusts all game music volume",       1)
SliderCard(aGrid,"SFXVolume",    "SFX Volume",     "Adjusts all game sound effects",      2)
SliderCard(aGrid,"AmbientVolume","Ambient Volume", "Adjusts all ambient volume",          3)
reg("Audio", aHdr, aGrid)

-- GAMEPLAY
local gHdr  = SectionHeader("gamepad-2",  "GAMEPLAY",  20)
local gGrid = CardGrid(21)
ActionCard(gGrid,"Teleport To Spawn","Go to your current map's spawn point",1,"map-pin",function()
    local lp=Players.LocalPlayer; local sp=workspace:FindFirstChildOfClass("SpawnLocation")
    if sp and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        lp.Character.HumanoidRootPart.CFrame = sp.CFrame + Vector3.new(0,3,0)
    end
end)
ToggleCard(gGrid,"AutoSkipWaves",         "Auto Skip Waves",            "Automatically vote to skip waves",           2)
ToggleCard(gGrid,"AutoVoteStart",         "Auto Vote Start",            "Automatically vote to start games",          3)
ToggleCard(gGrid,"ShowMatchEndRewards",   "Show Match End Rewards",     "Show reward pop-ups after matches",          4)
ToggleCard(gGrid,"DisplayPinnedQuests",   "Display Pinned Quests",      "Display all pinned quests in-game",          5)
ToggleCard(gGrid,"SelectUnitOnPlacement", "Select Unit on Placement",   "Automatically select placed units",          6)
ToggleCard(gGrid,"ShowMaxRange",          "Show Max Range on Placement","Show units' max range when placing",         7)
ToggleCard(gGrid,"DisplayPathVisualizers","Display Path Visualizers",   "Display path visualizers in-game",           8)
ToggleCard(gGrid,"AutoRetry",             "Auto Retry",                 "Automatically retry when a match ends",      9)
ToggleCard(gGrid,"AutoNext",              "Auto Next",                  "Automatically proceed to the next match",   10)
reg("Gameplay", gHdr, gGrid)

-- GRAPHICS
local grHdr  = SectionHeader("monitor",   "GRAPHICS",  30)
local grGrid = CardGrid(31)
SliderCard(grGrid,"QualityLevel","Quality Level","Rendering quality (1 = low, 21 = max)",1)
ToggleCard(grGrid,"Shadows",         "Shadows",            "Toggle in-game shadows",                   2)
ToggleCard(grGrid,"ShowFPS",         "Show FPS Counter",   "Display an in-game FPS counter",           3)
ToggleCard(grGrid,"ReduceParticles", "Reduce Particles",   "Reduce particles for better performance",  4)
reg("Graphics", grHdr, grGrid)

-- UNITS
local uHdr  = SectionHeader("shield",    "UNITS",     40)
local uGrid = CardGrid(41)
ToggleCard(uGrid,"UnitHealthBars","Show Unit Health Bars",  "Display health bars above friendly units",    1)
ToggleCard(uGrid,"UnitLevel",     "Show Unit Level",        "Display level indicators above units",        2)
ToggleCard(uGrid,"AutoUpgrade",   "Auto Upgrade Units",     "Automatically upgrade units when affordable", 3)
ToggleCard(uGrid,"ConfirmSell",   "Confirm Before Selling", "Show confirmation before selling a unit",     4)
reg("Units", uHdr, uGrid)

-- ENEMIES
local eHdr  = SectionHeader("skull",     "ENEMIES",   50)
local eGrid = CardGrid(51)
ToggleCard(eGrid,"EnemyHealthBars","Show Enemy Health Bars","Display health bars above enemies",            1)
ToggleCard(eGrid,"EnemyNames",     "Show Enemy Names",      "Display enemy type labels in-game",           2)
ToggleCard(eGrid,"BossWarning",    "Boss Warning",          "Show notification when a boss spawns",        3)
ToggleCard(eGrid,"PathPreview",    "Enemy Path Preview",    "Highlight the path enemies will follow",      4)
reg("Enemies", eHdr, eGrid)

-- MISCELLANEOUS
local mHdr  = SectionHeader("ellipsis",  "MISCELLANEOUS", 60)
local mGrid = CardGrid(61)
ToggleCard(mGrid,"ShowPing",    "Show Ping",          "Display your current ping in-game",              1)
ToggleCard(mGrid,"AutoReady",   "Auto Ready",         "Automatically mark yourself as ready",           2)
ToggleCard(mGrid,"WaveNotifs",  "Wave Notifications", "Show notification at start of each wave",        3)
ToggleCard(mGrid,"ChatNotifs",  "Chat Notifications", "Show in-chat event messages",                    4)
reg("Miscellaneous", mHdr, mGrid)

-- KEYBINDS
local kHdr   = SectionHeader("keyboard",  "KEYBINDS",  70)
local kFrame = New("Frame",{ Size=UDim2.new(1,0,0,0), AutomaticSize=Enum.AutomaticSize.Y, BackgroundTransparency=1, LayoutOrder=71 }, Content)
ListLayout(kFrame, 6)

do
    local row = New("Frame",{ Size=UDim2.new(1,0,0,36), BackgroundColor3=C.Card, LayoutOrder=0 }, kFrame)
    Corner(8,row); Stroke(C.CardBdr,1,row)
    local rb = New("TextButton",{ Position=UDim2.fromOffset(10,4), Size=UDim2.new(1,-20,0,28), BackgroundColor3=C.SliderBG, Text="", Font=Enum.Font.GothamBold, TextSize=13 }, row)
    Corner(6,rb)
    do
        local ic = getIcon("rotate-ccw")
        if ic then
            New("ImageLabel",{ AnchorPoint=Vector2.new(0,0.5), Position=UDim2.fromOffset(10,0), Size=UDim2.fromOffset(14,14), BackgroundTransparency=1, Image=ic.Url, ImageColor3=C.Text, ImageRectOffset=ic.ImageRectOffset or Vector2.zero, ImageRectSize=ic.ImageRectSize or Vector2.zero, ScaleType=Enum.ScaleType.Fit }, rb)
        end
        New("TextLabel",{ Position=UDim2.fromOffset(30,0), Size=UDim2.new(1,-36,1,0), BackgroundTransparency=1, Text="Reset Keybinds", TextColor3=C.Text, Font=Enum.Font.GothamBold, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left }, rb)
    end
    rb.MouseEnter:Connect(function() Tween(rb, TW_FAST, {BackgroundColor3=C.CyanDim}) end)
    rb.MouseLeave:Connect(function() Tween(rb, TW_FAST, {BackgroundColor3=C.SliderBG}) end)
    rb.MouseButton1Click:Connect(function()
        for _, kb in ipairs(KEYBIND_DEFS) do
            if Options[kb.id] then Options[kb.id]:SetValue({ kb.default, kb.mode }) end
        end
    end)
end

local RebindOverlay = New("Frame",{ Size=UDim2.fromScale(1,1), BackgroundColor3=Color3.new(0,0,0), BackgroundTransparency=0.3, ZIndex=10, Visible=false }, Win2)
local RebindLabel   = New("TextLabel",{ AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.fromScale(0.5,0.5), Size=UDim2.fromOffset(340,80), BackgroundColor3=C.Card, Text="Press any key to bind...\n(Escape to cancel)", TextColor3=C.Cyan, Font=Enum.Font.GothamBold, TextSize=16, ZIndex=11 }, RebindOverlay)
Corner(10, RebindLabel); Stroke(C.Cyan, 2, RebindLabel)

local rebindTarget = nil
local function startRebind(id, badgeLbl)
    rebindTarget = id
    RebindOverlay.Visible = true
    local conn; conn = UserInputService.InputBegan:Connect(function(inp, gp)
        if gp then return end
        if inp.UserInputType ~= Enum.UserInputType.Keyboard then return end
        conn:Disconnect()
        RebindOverlay.Visible = false
        if inp.KeyCode ~= Enum.KeyCode.Escape then
            local keyName = inp.KeyCode.Name
            if Options[id] then Options[id]:SetValue({ keyName, Options[id].Mode or "Press" }) end
            if badgeLbl then badgeLbl.Text = keyName end
        end
        rebindTarget = nil
    end)
end

for i, kb in ipairs(KEYBIND_DEFS) do
    local opt = Options[kb.id]
    local row = New("Frame",{ Size=UDim2.new(1,0,0,36), BackgroundColor3=C.Card, LayoutOrder=i }, kFrame)
    Corner(8,row); Stroke(C.CardBdr,1,row)
    New("TextLabel",{ Position=UDim2.fromOffset(13,0), Size=UDim2.new(0.55,-13,1,0), BackgroundTransparency=1, Text=kb.label, TextColor3=C.Text, Font=Enum.Font.Gotham, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left }, row)

    local badgeBG = New("Frame",{ AnchorPoint=Vector2.new(1,0.5), Position=UDim2.new(1,-12,0.5,0), Size=UDim2.fromOffset(86,24), BackgroundColor3=C.SliderBG }, row)
    Corner(5,badgeBG); Stroke(C.CardBdr,1,badgeBG)
    local keyVal = opt and opt.Value or kb.default
    local badgeLbl = New("TextLabel",{ Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text=keyVal, TextColor3=C.Text, Font=Enum.Font.GothamBold, TextSize=11 }, badgeBG)
    if opt then opt:OnChanged(function() badgeLbl.Text = opt.Value end) end

    local rebindBtn = New("TextButton",{ Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="" }, badgeBG)
    local id = kb.id
    rebindBtn.MouseButton1Click:Connect(function() startRebind(id, badgeLbl) end)
    rebindBtn.MouseEnter:Connect(function() Tween(badgeBG, TW_FAST, {BackgroundColor3=C.CyanDim}) end)
    rebindBtn.MouseLeave:Connect(function() Tween(badgeBG, TW_FAST, {BackgroundColor3=C.SliderBG}) end)
end

reg("Keybinds", kHdr, kFrame)

-- TESTING
local tHdr  = SectionHeader("flask-conical","TESTING",  80)
local tGrid = CardGrid(81)
ActionCard(tGrid,"Print All Settings","Dump all toggle and option values to console",1,"terminal",function()
    for k,v in pairs(Toggles) do print("[Toggle]",k,"=",v.Value) end
    for k,v in pairs(Options)  do if v.Value~=nil then print("[Option]",k,"=",v.Value) end end
end)
reg("Testing", tHdr, tGrid)

-- ─── 5. Sidebar tabs with Lucide icons ────────────────────────────────────────
local tabBtns  = {}
local activeTab = nil

local TAB_DEFS = {
    { name="All",           icon="layout-grid"   },
    { name="Audio",         icon="volume-2"       },
    { name="Gameplay",      icon="gamepad-2"      },
    { name="Graphics",      icon="monitor"        },
    { name="Units",         icon="shield"         },
    { name="Enemies",       icon="skull"          },
    { name="Miscellaneous", icon="ellipsis"       },
    { name="Keybinds",      icon="keyboard"       },
    { name="Testing",       icon="flask-conical"  },
}

local function switchTab(name)
    activeTab = name
    for n, data in pairs(tabBtns) do
        local isActive = (n == name)
        Tween(data.btn, TW_FAST, {
            BackgroundColor3 = isActive and C.Cyan or C.Sidebar,
        })
        if data.lbl then
            Tween(data.lbl, TW_FAST, {
                TextColor3 = isActive and C.Black or C.Sub,
            })
            data.lbl.Font = isActive and Enum.Font.GothamBold or Enum.Font.Gotham
        end
        if data.icImg then
            Tween(data.icImg, TW_FAST, {
                ImageColor3 = isActive and C.Black or C.Sub,
            })
        end
    end
    for secName, frames in pairs(tabSections) do
        local show = (name=="All") or (name==secName)
        for _, f in ipairs(frames) do f.Visible = show end
    end
end

for i, td in ipairs(TAB_DEFS) do
    local btn = New("TextButton", {
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = C.Sidebar,
        Text = "",
        LayoutOrder = i,
        AutoButtonColor = false,
    }, TabScroll)
    Corner(8, btn)

    local icImg = IconImg(btn, td.icon, C.Sub, UDim2.new(0, 12, 0.5, -9), UDim2.fromOffset(18, 18))
    local textX = icImg and 36 or 14
    local lbl = New("TextLabel", {
        Position  = UDim2.fromOffset(textX, 0),
        Size      = UDim2.new(1, -(textX + 8), 1, 0),
        BackgroundTransparency = 1,
        Text      = td.name,
        TextColor3 = C.Sub,
        Font      = Enum.Font.Gotham,
        TextSize  = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, btn)

    tabBtns[td.name] = { btn=btn, lbl=lbl, icImg=icImg }

    btn.MouseEnter:Connect(function()
        if activeTab ~= td.name then
            Tween(btn, TW_FAST, { BackgroundColor3 = Color3.fromRGB(28, 34, 46) })
        end
    end)
    btn.MouseLeave:Connect(function()
        if activeTab ~= td.name then
            Tween(btn, TW_FAST, { BackgroundColor3 = C.Sidebar })
        end
    end)

    local name = td.name
    btn.MouseButton1Click:Connect(function() switchTab(name) end)
end

-- ─── 6. Search ────────────────────────────────────────────────────────────────
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local q = SearchBox.Text:lower():match("^%s*(.-)%s*$")
    if q == "" then switchTab(activeTab or "All"); return end
    for _, frames in pairs(tabSections) do
        for _, f in ipairs(frames) do f.Visible = true end
    end
    for _, grid in ipairs({ aGrid, gGrid, grGrid, uGrid, eGrid, mGrid, tGrid }) do
        for _, child in ipairs(grid:GetChildren()) do
            if child:IsA("Frame") then
                local lbl = child:FindFirstChildWhichIsA("TextLabel")
                child.Visible = lbl and lbl.Text:lower():find(q, 1, true) ~= nil
            end
        end
    end
end)

-- ─── Done ─────────────────────────────────────────────────────────────────────
switchTab("All")
print("[Settings] Loaded. Custom UI active with Lucide icons + smooth animations.")
