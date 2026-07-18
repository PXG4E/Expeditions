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
    AutoShow = false,   -- keep Obsidian's own UI invisible
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
GameBox:AddToggle("AutoNext",              { Text = "Auto Next",                  Default = false })

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

-- Keybinds (KeyPickers handle input detection + save/load)
local KeyBox = Tabs.Config:AddLeftGroupbox("Keybinds")
local KEYBIND_DEFS = {
    { id = "KbDash",          label = "Dash",                           default = "Q",            mode = "Press"  },
    { id = "KbSprint",        label = "Sprint",                         default = "LeftShift",    mode = "Hold"   },
    { id = "KbInteract",      label = "Interact Prompt",                default = "E",            mode = "Press"  },
    { id = "KbShiftLock",     label = "Toggle Shift Lock",              default = "LeftControl",  mode = "Toggle" },
    { id = "KbRotate",        label = "Rotate Unit",                    default = "R",            mode = "Press"  },
    { id = "KbCancel",        label = "Cancel Unit Placement",          default = "Z",            mode = "Press"  },
    { id = "KbQuickPlace",    label = "Quick Placement",                default = "LeftShift",    mode = "Hold"   },
    { id = "KbUpgrade",       label = "Upgrade Unit",                   default = "X",            mode = "Press"  },
    { id = "KbAutoUpgrade",   label = "Auto Upgrade Unit",              default = "Unknown",      mode = "Toggle" },
    { id = "KbSell",          label = "Sell Unit",                      default = "X",            mode = "Press"  },
    { id = "KbTargeting",     label = "Change Unit Targeting",          default = "X",            mode = "Press"  },
    { id = "KbAutoSkip",      label = "Toggle Auto Skip Waves",         default = "Unknown",      mode = "Toggle" },
    { id = "KbAutoUpgradePlaced", label = "Toggle Auto-Upgrade Placed", default = "Unknown",      mode = "Toggle" },
    { id = "KbPlayMenu",      label = "Toggle Play Menu",               default = "Unknown",      mode = "Toggle" },
    { id = "KbQuestsMenu",    label = "Toggle Quests Menu",             default = "Unknown",      mode = "Toggle" },
    { id = "KbAreasMenu",     label = "Toggle Areas Menu",              default = "Unknown",      mode = "Toggle" },
}

-- fix mixed-syntax rows above (Lua workaround for the label field)

for _, kb in ipairs(KEYBIND_DEFS) do
    KeyBox:AddLabel(kb.label):AddKeyPicker(kb.id, {
        Default  = kb.default,
        Mode     = kb.mode,
        Text     = kb.label,
        NoUI     = false,
    })
end

-- Menu keybind + Save/Load
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
local UserInputService = game:GetService("UserInputService")
local LocalPlayer      = Players.LocalPlayer
local PlayerGui        = LocalPlayer:WaitForChild("PlayerGui")

pcall(function()
    local old = PlayerGui:FindFirstChild("SettingsGui")
    if old then old:Destroy() end
end)

local C = {
    BG       = Color3.fromRGB(12,  15,  20),
    Sidebar  = Color3.fromRGB(18,  22,  30),
    Card     = Color3.fromRGB(22,  27,  35),
    CardBdr  = Color3.fromRGB(38,  46,  62),
    Cyan     = Color3.fromRGB(0,   210, 255),
    CyanDim  = Color3.fromRGB(0,   155, 190),
    Text     = Color3.fromRGB(220, 225, 235),
    Sub      = Color3.fromRGB(130, 135, 150),
    Green    = Color3.fromRGB(30,  175, 75),
    Red      = Color3.fromRGB(210, 40,  50),
    SearchBG = Color3.fromRGB(28,  33,  45),
    SliderBG = Color3.fromRGB(38,  44,  58),
    SliderFG = Color3.fromRGB(110, 115, 135),
    White    = Color3.new(1,1,1),
    Black    = Color3.new(0,0,0),
}

local function New(cls, props, parent)
    local o = Instance.new(cls)
    for k,v in pairs(props) do o[k] = v end
    if parent then o.Parent = parent end
    return o
end
local function Corner(r, p)  New("UICorner", { CornerRadius = UDim.new(0,r) }, p) end
local function Stroke(c,t,p) local s = New("UIStroke",{ Color=c, Thickness=t },p); s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border end
local function ListLayout(p, gap) New("UIListLayout",{ SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0,gap or 0) }, p) end
local function Pad(t,b,l,r,p) New("UIPadding",{ PaddingTop=UDim.new(0,t), PaddingBottom=UDim.new(0,b), PaddingLeft=UDim.new(0,l), PaddingRight=UDim.new(0,r) }, p) end

-- Screen
local Gui = New("ScreenGui", { Name="SettingsGui", ResetOnSpawn=false, ZIndexBehavior=Enum.ZIndexBehavior.Sibling }, PlayerGui)
New("TextButton", { Size=UDim2.fromScale(1,1), BackgroundColor3=Color3.new(0,0,0), BackgroundTransparency=0.5, Text="", ZIndex=1 }, Gui)

-- Window
local Win2 = New("Frame", {
    AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.fromScale(0.5,0.5),
    Size=UDim2.fromOffset(980,640), BackgroundColor3=C.BG, ClipsDescendants=true, ZIndex=2,
}, Gui)
Corner(8, Win2); Stroke(C.Cyan, 2, Win2)

-- drag
do
    local drag, ds, ws = false, nil, nil
    Win2.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag=true; ds=i.Position; ws=Win2.Position end
    end)
    Win2.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag=false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - ds
            Win2.Position = UDim2.new(ws.X.Scale, ws.X.Offset+d.X, ws.Y.Scale, ws.Y.Offset+d.Y)
        end
    end)
end

-- Top bar
local TopBar = New("Frame", { Size=UDim2.new(1,0,0,62), BackgroundColor3=C.BG, ZIndex=3 }, Win2)
local Badge  = New("Frame", { Size=UDim2.fromOffset(228,62), BackgroundColor3=C.Cyan, ZIndex=3 }, TopBar)
New("TextLabel",{ Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="⚙  SETTINGS", TextColor3=C.Black, Font=Enum.Font.GothamBold, TextSize=20, ZIndex=4 }, Badge)
New("Frame",{ Position=UDim2.fromOffset(212,-2), Size=UDim2.fromOffset(36,66), BackgroundColor3=C.Cyan, Rotation=-8, ZIndex=2 }, TopBar)

local SrchF = New("Frame",{ AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.new(0.5,10,0.5,0), Size=UDim2.fromOffset(370,36), BackgroundColor3=C.SearchBG, ZIndex=4 }, TopBar)
Corner(6,SrchF); Stroke(C.CardBdr,1,SrchF)
New("TextLabel",{ Size=UDim2.fromOffset(28,36), BackgroundTransparency=1, Text="🔍", TextSize=14, TextColor3=C.Sub, ZIndex=5 }, SrchF)
local SearchBox = New("TextBox",{ Position=UDim2.fromOffset(28,0), Size=UDim2.new(1,-34,1,0), BackgroundTransparency=1, PlaceholderText="Search...", PlaceholderColor3=C.Sub, Text="", TextColor3=C.Text, Font=Enum.Font.Gotham, TextSize=14, TextXAlignment=Enum.TextXAlignment.Left, ClearTextOnFocus=false, ZIndex=5 }, SrchF)

local CloseBtn = New("TextButton",{ AnchorPoint=Vector2.new(1,0.5), Position=UDim2.new(1,-14,0.5,0), Size=UDim2.fromOffset(36,36), BackgroundColor3=C.Red, Text="✕", TextColor3=C.White, Font=Enum.Font.GothamBold, TextSize=16, ZIndex=4 }, TopBar)
Corner(6,CloseBtn)
CloseBtn.MouseButton1Click:Connect(function() Gui:Destroy() end)
New("Frame",{ Position=UDim2.fromOffset(0,62), Size=UDim2.new(1,0,0,1), BackgroundColor3=C.Cyan, BackgroundTransparency=0.6, ZIndex=3 }, Win2)

-- Sidebar
local SideFrame = New("Frame",{ Position=UDim2.fromOffset(0,63), Size=UDim2.new(0,238,1,-63), BackgroundColor3=C.Sidebar, ZIndex=2 }, Win2)
New("Frame",{ AnchorPoint=Vector2.new(1,0), Position=UDim2.fromScale(1,0), Size=UDim2.new(0,1,1,0), BackgroundColor3=C.Cyan, BackgroundTransparency=0.55, ZIndex=3 }, SideFrame)
local TabScroll = New("ScrollingFrame",{ Size=UDim2.fromScale(1,1), BackgroundTransparency=1, ScrollBarThickness=0, CanvasSize=UDim2.fromScale(0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y, ZIndex=3 }, SideFrame)
ListLayout(TabScroll, 4); Pad(8,8,8,8,TabScroll)

-- Content
local Content = New("ScrollingFrame",{ Position=UDim2.fromOffset(239,63), Size=UDim2.new(1,-239,1,-63), BackgroundTransparency=1, ScrollBarThickness=4, ScrollBarImageColor3=C.Cyan, CanvasSize=UDim2.fromScale(0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y, ZIndex=2 }, Win2)
ListLayout(Content, 10); Pad(14,18,18,18,Content)

-- ─── UI component builders ────────────────────────────────────────────────────

local function SectionHeader(icon, title, order)
    local f = New("Frame",{ Size=UDim2.new(1,0,0,28), BackgroundTransparency=1, LayoutOrder=order }, Content)
    New("TextLabel",{ Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text=icon.."  "..title, TextColor3=C.Cyan, Font=Enum.Font.GothamBold, TextSize=14, TextXAlignment=Enum.TextXAlignment.Left }, f)
    return f
end

local function CardGrid(order)
    local g = New("Frame",{ Size=UDim2.new(1,0,0,0), AutomaticSize=Enum.AutomaticSize.Y, BackgroundTransparency=1, LayoutOrder=order }, Content)
    New("UIGridLayout",{ CellSize=UDim2.new(0.5,-7,0,82), CellPadding=UDim2.new(0,14,0,10), SortOrder=Enum.SortOrder.LayoutOrder, Parent=g })
    return g
end

-- Slider card — reads/writes Library.Options[id]
local function SliderCard(parent, id, label, desc, order)
    local opt = Options[id]
    local card = New("Frame",{ BackgroundColor3=C.Card, LayoutOrder=order }, parent)
    Corner(8,card); Stroke(C.CardBdr,1,card)

    New("TextLabel",{ Position=UDim2.fromOffset(13,9),  Size=UDim2.new(1,-14,0,17), BackgroundTransparency=1, Text=label, TextColor3=C.Text, Font=Enum.Font.GothamBold, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left }, card)
    New("TextLabel",{ Position=UDim2.fromOffset(13,26), Size=UDim2.new(1,-14,0,15), BackgroundTransparency=1, Text=desc,  TextColor3=C.Sub,  Font=Enum.Font.Gotham,      TextSize=11, TextXAlignment=Enum.TextXAlignment.Left }, card)

    local valBG  = New("Frame",{ Position=UDim2.fromOffset(13,48), Size=UDim2.fromOffset(44,22), BackgroundColor3=C.SliderBG }, card); Corner(4,valBG)
    local valLbl = New("TextLabel",{ Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text=tostring(opt.Value), TextColor3=C.Text, Font=Enum.Font.GothamBold, TextSize=12 }, valBG)

    local track = New("Frame",{ Position=UDim2.fromOffset(63,52), Size=UDim2.new(1,-78,0,10), BackgroundColor3=C.SliderBG }, card); Corner(5,track)
    local mn, mx = opt.Min, opt.Max
    local fill   = New("Frame",{ Size=UDim2.new((opt.Value-mn)/(mx-mn),0,1,0), BackgroundColor3=C.SliderFG }, track); Corner(5,fill)
    local knob   = New("Frame",{ AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.new((opt.Value-mn)/(mx-mn),0,0.5,0), Size=UDim2.fromOffset(14,14), BackgroundColor3=C.Text }, track); Corner(7,knob); Stroke(C.Cyan,2,knob)

    -- sync UI → Obsidian
    local function setUI(v)
        local pct = math.clamp((v-mn)/(mx-mn), 0, 1)
        fill.Size     = UDim2.new(pct,0,1,0)
        knob.Position = UDim2.new(pct,0,0.5,0)
        valLbl.Text   = tostring(v)
    end
    -- sync Obsidian → UI (e.g. on save load)
    opt:OnChanged(function() setUI(opt.Value) end)

    local down = false
    local function drag(x)
        local pct = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        opt:SetValue(mn + pct*(mx-mn))
    end
    track.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then down=true; drag(i.Position.X) end end)
    knob.InputBegan:Connect(function(i)  if i.UserInputType==Enum.UserInputType.MouseButton1 then down=true end end)
    UserInputService.InputEnded:Connect(function(i)   if i.UserInputType==Enum.UserInputType.MouseButton1 then down=false end end)
    UserInputService.InputChanged:Connect(function(i) if down and i.UserInputType==Enum.UserInputType.MouseMovement then drag(i.Position.X) end end)
end

-- Toggle card — reads/writes Library.Toggles[id]
local function ToggleCard(parent, id, label, desc, order)
    local tog = Toggles[id]
    local card = New("Frame",{ BackgroundColor3=C.Card, LayoutOrder=order }, parent)
    Corner(8,card); Stroke(C.CardBdr,1,card)

    New("TextLabel",{ Position=UDim2.fromOffset(13,13), Size=UDim2.new(1,-62,0,17), BackgroundTransparency=1, Text=label, TextColor3=C.Text, Font=Enum.Font.GothamBold, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left }, card)
    New("TextLabel",{ Position=UDim2.fromOffset(13,30), Size=UDim2.new(1,-62,0,34), BackgroundTransparency=1, Text=desc,  TextColor3=C.Sub,  Font=Enum.Font.Gotham,      TextSize=11, TextXAlignment=Enum.TextXAlignment.Left, TextWrapped=true, TextYAlignment=Enum.TextYAlignment.Top }, card)

    local btn = New("TextButton",{ AnchorPoint=Vector2.new(1,0.5), Position=UDim2.new(1,-12,0.5,0), Size=UDim2.fromOffset(38,38), BackgroundColor3=tog.Value and C.Green or C.Red, Text=tog.Value and "✓" or "✕", TextColor3=C.White, Font=Enum.Font.GothamBold, TextSize=20 }, card)
    Corner(7,btn)

    -- sync Obsidian → UI
    local function updateBtn()
        btn.BackgroundColor3 = tog.Value and C.Green or C.Red
        btn.Text = tog.Value and "✓" or "✕"
    end
    tog:OnChanged(updateBtn)

    -- sync UI → Obsidian
    btn.MouseButton1Click:Connect(function()
        tog:SetValue(not tog.Value)
    end)
end

-- Action card (no Obsidian state needed)
local function ActionCard(parent, label, desc, order, cb)
    local card = New("Frame",{ BackgroundColor3=C.Card, LayoutOrder=order }, parent)
    Corner(8,card); Stroke(C.CardBdr,1,card)
    New("TextLabel",{ Position=UDim2.fromOffset(13,13), Size=UDim2.new(1,-62,0,17), BackgroundTransparency=1, Text=label, TextColor3=C.Text, Font=Enum.Font.GothamBold, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left }, card)
    New("TextLabel",{ Position=UDim2.fromOffset(13,30), Size=UDim2.new(1,-62,0,34), BackgroundTransparency=1, Text=desc,  TextColor3=C.Sub,  Font=Enum.Font.Gotham,      TextSize=11, TextXAlignment=Enum.TextXAlignment.Left, TextWrapped=true, TextYAlignment=Enum.TextYAlignment.Top }, card)
    local btn = New("TextButton",{ AnchorPoint=Vector2.new(1,0.5), Position=UDim2.new(1,-12,0.5,0), Size=UDim2.fromOffset(38,38), BackgroundColor3=C.SliderBG, Text="⬇", TextColor3=C.Text, Font=Enum.Font.GothamBold, TextSize=18 }, card)
    Corner(7,btn); Stroke(C.CardBdr,1,btn)
    btn.MouseEnter:Connect(function() btn.BackgroundColor3=C.CyanDim; btn.TextColor3=C.White end)
    btn.MouseLeave:Connect(function() btn.BackgroundColor3=C.SliderBG; btn.TextColor3=C.Text end)
    btn.MouseButton1Click:Connect(function() if cb then pcall(cb) end end)
end

-- ─── 4. Build sections ────────────────────────────────────────────────────────
local tabSections = {}  -- ["SectionName"] = { hdr, body, ... }
local function reg(name, ...)
    tabSections[name] = tabSections[name] or {}
    for _, f in ipairs({...}) do table.insert(tabSections[name], f) end
end

-- AUDIO
local aHdr  = SectionHeader("♪","AUDIO",10)
local aGrid = CardGrid(11)
SliderCard(aGrid,"MusicVolume",  "Music Volume",   "Adjusts all game music volume",  1)
SliderCard(aGrid,"SFXVolume",    "SFX Volume",     "Adjusts all game sound effects", 2)
SliderCard(aGrid,"AmbientVolume","Ambient Volume", "Adjusts all ambient volume",     3)
reg("Audio", aHdr, aGrid)

-- GAMEPLAY
local gHdr  = SectionHeader("⚙","GAMEPLAY",20)
local gGrid = CardGrid(21)
ActionCard(gGrid,"Teleport To Spawn","Go to your current map's spawn point",1,function()
    local lp=Players.LocalPlayer; local sp=workspace:FindFirstChildOfClass("SpawnLocation")
    if sp and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        lp.Character.HumanoidRootPart.CFrame = sp.CFrame + Vector3.new(0,3,0)
    end
end)
ToggleCard(gGrid,"AutoSkipWaves",         "Auto Skip Waves",           "Automatically vote to skip waves",            2)
ToggleCard(gGrid,"AutoVoteStart",         "Auto Vote Start",           "Automatically vote to start games",           3)
ToggleCard(gGrid,"ShowMatchEndRewards",   "Show Match End Rewards",    "Show reward pop-ups after matches",           4)
ToggleCard(gGrid,"DisplayPinnedQuests",   "Display Pinned Quests",     "Display all pinned quests in-game",           5)
ToggleCard(gGrid,"SelectUnitOnPlacement", "Select Unit on Placement",  "Automatically select placed units",           6)
ToggleCard(gGrid,"ShowMaxRange",          "Show Max Range on Placement","Show units' max range when placing",         7)
ToggleCard(gGrid,"DisplayPathVisualizers","Display Path Visualizers",  "Display path visualizers in-game",           8)
ToggleCard(gGrid,"AutoRetry",             "Auto Retry",                "Automatically retry when a match ends",       9)
ToggleCard(gGrid,"AutoNext",              "Auto Next",                 "Automatically proceed to the next match",    10)
reg("Gameplay", gHdr, gGrid)

-- GRAPHICS
local grHdr  = SectionHeader("🖥","GRAPHICS",30)
local grGrid = CardGrid(31)
SliderCard(grGrid,"QualityLevel","Quality Level","Rendering quality (1 = low, 21 = max)",1)
ToggleCard(grGrid,"Shadows",         "Shadows",            "Toggle in-game shadows",                  2)
ToggleCard(grGrid,"ShowFPS",         "Show FPS Counter",   "Display an in-game FPS counter",          3)
ToggleCard(grGrid,"ReduceParticles", "Reduce Particles",   "Reduce particles for better performance", 4)
reg("Graphics", grHdr, grGrid)

-- UNITS
local uHdr  = SectionHeader("🛡","UNITS",40)
local uGrid = CardGrid(41)
ToggleCard(uGrid,"UnitHealthBars","Show Unit Health Bars",  "Display health bars above friendly units",    1)
ToggleCard(uGrid,"UnitLevel",     "Show Unit Level",        "Display level indicators above units",        2)
ToggleCard(uGrid,"AutoUpgrade",   "Auto Upgrade Units",     "Automatically upgrade units when affordable", 3)
ToggleCard(uGrid,"ConfirmSell",   "Confirm Before Selling", "Show confirmation before selling a unit",     4)
reg("Units", uHdr, uGrid)

-- ENEMIES
local eHdr  = SectionHeader("💀","ENEMIES",50)
local eGrid = CardGrid(51)
ToggleCard(eGrid,"EnemyHealthBars","Show Enemy Health Bars","Display health bars above enemies",           1)
ToggleCard(eGrid,"EnemyNames",     "Show Enemy Names",      "Display enemy type labels in-game",          2)
ToggleCard(eGrid,"BossWarning",    "Boss Warning",          "Show notification when a boss spawns",       3)
ToggleCard(eGrid,"PathPreview",    "Enemy Path Preview",    "Highlight the path enemies will follow",     4)
reg("Enemies", eHdr, eGrid)

-- MISCELLANEOUS
local mHdr  = SectionHeader("…","MISCELLANEOUS",60)
local mGrid = CardGrid(61)
ToggleCard(mGrid,"ShowPing",    "Show Ping",            "Display your current ping in-game",            1)
ToggleCard(mGrid,"AutoReady",   "Auto Ready",           "Automatically mark yourself as ready",         2)
ToggleCard(mGrid,"WaveNotifs",  "Wave Notifications",   "Show notification at start of each wave",      3)
ToggleCard(mGrid,"ChatNotifs",  "Chat Notifications",   "Show in-chat event messages",                  4)
reg("Miscellaneous", mHdr, mGrid)

-- KEYBINDS
local kHdr   = SectionHeader("⌨","KEYBINDS",70)
local kFrame = New("Frame",{ Size=UDim2.new(1,0,0,0), AutomaticSize=Enum.AutomaticSize.Y, BackgroundTransparency=1, LayoutOrder=71 }, Content)
ListLayout(kFrame, 6)

-- reset row
do
    local row = New("Frame",{ Size=UDim2.new(1,0,0,36), BackgroundColor3=C.Card, LayoutOrder=0 }, kFrame)
    Corner(8,row); Stroke(C.CardBdr,1,row)
    local rb = New("TextButton",{ Position=UDim2.fromOffset(10,4), Size=UDim2.new(1,-20,0,28), BackgroundColor3=C.SliderBG, Text="↺  Reset Keybinds", TextColor3=C.Text, Font=Enum.Font.GothamBold, TextSize=13 }, row)
    Corner(6,rb)
    rb.MouseEnter:Connect(function() rb.BackgroundColor3=C.CyanDim; rb.TextColor3=C.White end)
    rb.MouseLeave:Connect(function() rb.BackgroundColor3=C.SliderBG; rb.TextColor3=C.Text end)
    rb.MouseButton1Click:Connect(function()
        for _, kb in ipairs(KEYBIND_DEFS) do
            if Options[kb.id] then Options[kb.id]:SetValue({ kb.default, kb.mode }) end
        end
    end)
end

-- rebind overlay
local RebindOverlay = New("Frame",{ Size=UDim2.fromScale(1,1), BackgroundColor3=Color3.new(0,0,0), BackgroundTransparency=0.3, ZIndex=10, Visible=false }, Win2)
local RebindLabel   = New("TextLabel",{ AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.fromScale(0.5,0.5), Size=UDim2.fromOffset(340,80), BackgroundColor3=C.Card, Text="Press any key to bind...\n(Escape to cancel)", TextColor3=C.Cyan, Font=Enum.Font.GothamBold, TextSize=16, ZIndex=11 }, RebindOverlay)
Corner(10, RebindLabel); Stroke(C.Cyan,2,RebindLabel)

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

-- keybind rows
for i, kb in ipairs(KEYBIND_DEFS) do
    local opt = Options[kb.id]
    local row = New("Frame",{ Size=UDim2.new(1,0,0,36), BackgroundColor3=C.Card, LayoutOrder=i }, kFrame)
    Corner(8,row); Stroke(C.CardBdr,1,row)

    New("TextLabel",{ Position=UDim2.fromOffset(13,0), Size=UDim2.new(0.55,-13,1,0), BackgroundTransparency=1, Text=kb.label, TextColor3=C.Text, Font=Enum.Font.Gotham, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left }, row)

    -- badge showing current key
    local badgeBG = New("Frame",{ AnchorPoint=Vector2.new(1,0.5), Position=UDim2.new(1,-12,0.5,0), Size=UDim2.fromOffset(86,24), BackgroundColor3=C.SliderBG }, row)
    Corner(5,badgeBG); Stroke(C.CardBdr,1,badgeBG)
    local keyVal = opt and opt.Value or kb.default
    local badgeLbl = New("TextLabel",{ Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text=keyVal, TextColor3=C.Text, Font=Enum.Font.GothamBold, TextSize=11 }, badgeBG)

    -- sync Obsidian → badge (e.g. on config load)
    if opt then
        opt:OnChanged(function() badgeLbl.Text = opt.Value end)
    end

    -- click badge to rebind
    local rebindBtn = New("TextButton",{ Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="" }, badgeBG)
    local id = kb.id
    rebindBtn.MouseButton1Click:Connect(function() startRebind(id, badgeLbl) end)
    rebindBtn.MouseEnter:Connect(function() badgeBG.BackgroundColor3=C.CyanDim end)
    rebindBtn.MouseLeave:Connect(function() badgeBG.BackgroundColor3=C.SliderBG end)
end

reg("Keybinds", kHdr, kFrame)

-- TESTING
local tHdr  = SectionHeader("🧪","TESTING",80)
local tGrid = CardGrid(81)
ActionCard(tGrid,"Print All Settings","Dump all values to the output console",1,function()
    for k,v in pairs(Toggles) do print("[Toggle]",k,"=",v.Value) end
    for k,v in pairs(Options)  do if v.Value~=nil then print("[Option]",k,"=",v.Value) end end
end)
reg("Testing", tHdr, tGrid)

-- ─── 5. Sidebar tabs ──────────────────────────────────────────────────────────
local tabBtns  = {}
local activeTab = nil

local TAB_DEFS = {
    { name="All",           icon="⇌" },
    { name="Audio",         icon="♪" },
    { name="Gameplay",      icon="⚙" },
    { name="Graphics",      icon="🖥" },
    { name="Units",         icon="🛡" },
    { name="Enemies",       icon="💀" },
    { name="Miscellaneous", icon="…" },
    { name="Keybinds",      icon="⌨" },
    { name="Testing",       icon="🧪" },
}

local function switchTab(name)
    activeTab = name
    for n, btn in pairs(tabBtns) do
        local lbl = btn:FindFirstChildWhichIsA("TextLabel")
        if n == name then
            btn.BackgroundColor3 = C.Cyan
            if lbl then lbl.TextColor3=C.Black; lbl.Font=Enum.Font.GothamBold end
        else
            btn.BackgroundColor3 = C.Sidebar
            if lbl then lbl.TextColor3=C.Sub;   lbl.Font=Enum.Font.Gotham end
        end
    end
    for secName, frames in pairs(tabSections) do
        local show = (name=="All") or (name==secName)
        for _, f in ipairs(frames) do f.Visible = show end
    end
end

for i, td in ipairs(TAB_DEFS) do
    local btn = New("TextButton",{ Size=UDim2.new(1,0,0,44), BackgroundColor3=C.Sidebar, Text="", LayoutOrder=i, AutoButtonColor=false }, TabScroll)
    Corner(8,btn)
    New("TextLabel",{ Position=UDim2.fromOffset(14,0), Size=UDim2.new(1,-14,1,0), BackgroundTransparency=1, Text=td.icon.."   "..td.name, TextColor3=C.Sub, Font=Enum.Font.Gotham, TextSize=14, TextXAlignment=Enum.TextXAlignment.Left }, btn)
    tabBtns[td.name] = btn
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
print("[Settings] Loaded. Custom UI active, Obsidian backend running.")
