--[[
    Settings.lua — Custom Settings UI
    Repo: https://github.com/PXG4E/Expeditions

    Run in your executor:
        loadstring(game:HttpGet("https://raw.githubusercontent.com/PXG4E/Expeditions/main/Settings.lua"))()
--]]

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

-- destroy old instance if re-ran
pcall(function()
    local old = PlayerGui:FindFirstChild("SettingsGui")
    if old then old:Destroy() end
end)

-- ─── Colours ──────────────────────────────────────────────────────────────────
local C = {
    BG        = Color3.fromRGB(12,  15,  20),
    Sidebar   = Color3.fromRGB(18,  22,  30),
    Card      = Color3.fromRGB(22,  27,  35),
    CardBdr   = Color3.fromRGB(38,  46,  62),
    Cyan      = Color3.fromRGB(0,   210, 255),
    CyanDim   = Color3.fromRGB(0,   160, 200),
    Text      = Color3.fromRGB(220, 225, 235),
    Sub       = Color3.fromRGB(130, 135, 150),
    Green     = Color3.fromRGB(30,  175, 75),
    Red       = Color3.fromRGB(210, 40,  50),
    Search    = Color3.fromRGB(28,  33,  45),
    SliderBG  = Color3.fromRGB(38,  44,  58),
    SliderFG  = Color3.fromRGB(110, 115, 135),
    White     = Color3.new(1, 1, 1),
    Black     = Color3.new(0, 0, 0),
}

-- ─── Helpers ──────────────────────────────────────────────────────────────────
local function New(cls, props, parent)
    local o = Instance.new(cls)
    for k, v in pairs(props) do o[k] = v end
    if parent then o.Parent = parent end
    return o
end
local function Corner(r, p) New("UICorner", { CornerRadius = UDim.new(0, r) }, p) end
local function Stroke(col, thick, p)
    local s = New("UIStroke", { Color = col, Thickness = thick }, p)
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
end
local function ListLayout(p, pad)
    New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, pad or 0) }, p)
end
local function Pad(t, b, l, r, p)
    New("UIPadding", { PaddingTop = UDim.new(0,t), PaddingBottom = UDim.new(0,b), PaddingLeft = UDim.new(0,l), PaddingRight = UDim.new(0,r) }, p)
end

-- ─── Root ─────────────────────────────────────────────────────────────────────
local Gui = New("ScreenGui", { Name = "SettingsGui", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling }, PlayerGui)

-- dim backdrop
New("TextButton", { Size = UDim2.fromScale(1,1), BackgroundColor3 = Color3.new(0,0,0), BackgroundTransparency = 0.45, Text = "", ZIndex = 1 }, Gui)

-- ─── Window ───────────────────────────────────────────────────────────────────
local Win = New("Frame", {
    AnchorPoint      = Vector2.new(0.5, 0.5),
    Position         = UDim2.fromScale(0.5, 0.5),
    Size             = UDim2.fromOffset(980, 640),
    BackgroundColor3 = C.BG,
    ClipsDescendants = true,
    ZIndex           = 2,
}, Gui)
Corner(8, Win)
Stroke(C.Cyan, 2, Win)

-- drag
do
    local drag, dragStart, winStart = false, nil, nil
    Win.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true; dragStart = i.Position; winStart = Win.Position end
    end)
    Win.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - dragStart
            Win.Position = UDim2.new(winStart.X.Scale, winStart.X.Offset + d.X, winStart.Y.Scale, winStart.Y.Offset + d.Y)
        end
    end)
end

-- ─── Top Bar ──────────────────────────────────────────────────────────────────
local TopBar = New("Frame", { Size = UDim2.new(1,0,0,62), BackgroundColor3 = C.BG, ZIndex = 3 }, Win)

-- cyan badge
local Badge = New("Frame", { Size = UDim2.fromOffset(228, 62), BackgroundColor3 = C.Cyan, ZIndex = 3 }, TopBar)
New("TextLabel", {
    Size = UDim2.fromScale(1,1), BackgroundTransparency = 1,
    Text = "⚙  SETTINGS", TextColor3 = C.Black,
    Font = Enum.Font.GothamBold, TextSize = 20, ZIndex = 4,
}, Badge)
-- diagonal overhang
New("Frame", { Position = UDim2.fromOffset(212,-2), Size = UDim2.fromOffset(36, 66), BackgroundColor3 = C.Cyan, Rotation = -8, ZIndex = 3 }, TopBar)

-- search
local SrchFrame = New("Frame", {
    AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.new(0.5,10,0.5,0),
    Size = UDim2.fromOffset(370,36), BackgroundColor3 = C.Search, ZIndex = 4,
}, TopBar)
Corner(6, SrchFrame); Stroke(C.CardBdr, 1, SrchFrame)
New("TextLabel", { Size = UDim2.fromOffset(28,36), BackgroundTransparency = 1, Text = "🔍", TextSize = 14, TextColor3 = C.Sub, ZIndex = 5 }, SrchFrame)
local SearchBox = New("TextBox", {
    Position = UDim2.fromOffset(28,0), Size = UDim2.new(1,-34,1,0),
    BackgroundTransparency = 1, PlaceholderText = "Search...", PlaceholderColor3 = C.Sub,
    Text = "", TextColor3 = C.Text, Font = Enum.Font.Gotham, TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false, ZIndex = 5,
}, SrchFrame)

-- close
local CloseBtn = New("TextButton", {
    AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,-14,0.5,0),
    Size = UDim2.fromOffset(36,36), BackgroundColor3 = C.Red,
    Text = "✕", TextColor3 = C.White, Font = Enum.Font.GothamBold, TextSize = 16, ZIndex = 4,
}, TopBar)
Corner(6, CloseBtn)
CloseBtn.MouseButton1Click:Connect(function() Gui:Destroy() end)

-- separator
New("Frame", { Position = UDim2.fromOffset(0,62), Size = UDim2.new(1,0,0,1), BackgroundColor3 = C.Cyan, BackgroundTransparency = 0.6, ZIndex = 3 }, Win)

-- ─── Sidebar ──────────────────────────────────────────────────────────────────
local Sidebar = New("Frame", { Position = UDim2.fromOffset(0,63), Size = UDim2.new(0,238,1,-63), BackgroundColor3 = C.Sidebar, ZIndex = 2 }, Win)
New("Frame", { AnchorPoint = Vector2.new(1,0), Position = UDim2.fromScale(1,0), Size = UDim2.new(0,1,1,0), BackgroundColor3 = C.Cyan, BackgroundTransparency = 0.55, ZIndex = 3 }, Sidebar)

local TabScroll = New("ScrollingFrame", {
    Size = UDim2.fromScale(1,1), BackgroundTransparency = 1, ScrollBarThickness = 0,
    CanvasSize = UDim2.fromScale(0,0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 3,
}, Sidebar)
ListLayout(TabScroll, 4)
Pad(8, 8, 8, 8, TabScroll)

-- ─── Content Area ─────────────────────────────────────────────────────────────
local Content = New("ScrollingFrame", {
    Position = UDim2.fromOffset(239, 63), Size = UDim2.new(1,-239,1,-63),
    BackgroundTransparency = 1, ScrollBarThickness = 4,
    ScrollBarImageColor3 = C.Cyan, CanvasSize = UDim2.fromScale(0,0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 2,
}, Win)
ListLayout(Content, 10)
Pad(14, 18, 18, 18, Content)

-- ─── Section header ───────────────────────────────────────────────────────────
local function Header(icon, title, order)
    local f = New("Frame", { Size = UDim2.new(1,0,0,28), BackgroundTransparency = 1, LayoutOrder = order }, Content)
    New("TextLabel", {
        Size = UDim2.fromScale(1,1), BackgroundTransparency = 1,
        Text = icon .. "  " .. title, TextColor3 = C.Cyan,
        Font = Enum.Font.GothamBold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left,
    }, f)
    return f
end

-- ─── Two-column grid ──────────────────────────────────────────────────────────
local function Grid(order)
    local g = New("Frame", {
        Size = UDim2.new(1,0,0,0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1, LayoutOrder = order,
    }, Content)
    New("UIGridLayout", {
        CellSize    = UDim2.new(0.5, -7, 0, 82),
        CellPadding = UDim2.new(0, 14, 0, 10),
        SortOrder   = Enum.SortOrder.LayoutOrder,
        Parent      = g,
    })
    return g
end

-- ─── Slider card ──────────────────────────────────────────────────────────────
local sliderVals = {}
local function Slider(parent, id, label, desc, default, mn, mx, order, cb)
    local card = New("Frame", { BackgroundColor3 = C.Card, LayoutOrder = order }, parent)
    Corner(8, card); Stroke(C.CardBdr, 1, card)

    New("TextLabel", { Position = UDim2.fromOffset(13,10), Size = UDim2.new(1,-60,0,17),
        BackgroundTransparency = 1, Text = label, TextColor3 = C.Text,
        Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left }, card)
    New("TextLabel", { Position = UDim2.fromOffset(13,27), Size = UDim2.new(1,-60,0,16),
        BackgroundTransparency = 1, Text = desc, TextColor3 = C.Sub,
        Font = Enum.Font.Gotham, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left }, card)

    local valBG = New("Frame", { Position = UDim2.fromOffset(13,50), Size = UDim2.fromOffset(44,22), BackgroundColor3 = C.SliderBG }, card)
    Corner(4, valBG)
    local valLbl = New("TextLabel", { Size = UDim2.fromScale(1,1), BackgroundTransparency = 1, Text = tostring(default), TextColor3 = C.Text, Font = Enum.Font.GothamBold, TextSize = 12 }, valBG)

    local track = New("Frame", { Position = UDim2.fromOffset(63,55), Size = UDim2.new(1,-78,0,10), BackgroundColor3 = C.SliderBG }, card)
    Corner(5, track)
    local fill = New("Frame", { Size = UDim2.new((default-mn)/(mx-mn),0,1,0), BackgroundColor3 = C.SliderFG }, track)
    Corner(5, fill)
    local knob = New("Frame", {
        AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.new((default-mn)/(mx-mn),0,0.5,0),
        Size = UDim2.fromOffset(14,14), BackgroundColor3 = C.Text
    }, track)
    Corner(7, knob); Stroke(C.Cyan, 2, knob)

    sliderVals[id] = default
    local function set(v)
        v = math.clamp(math.round(v * 10) / 10, mn, mx)
        sliderVals[id] = v
        local pct = (v - mn) / (mx - mn)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        knob.Position = UDim2.new(pct, 0, 0.5, 0)
        valLbl.Text = tostring(v)
        if cb then pcall(cb, v) end
    end

    local down = false
    local function drag(x) set(mn + math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1) * (mx - mn)) end
    track.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then down = true; drag(i.Position.X) end end)
    knob.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then down = true end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then down = false end end)
    UserInputService.InputChanged:Connect(function(i) if down and i.UserInputType == Enum.UserInputType.MouseMovement then drag(i.Position.X) end end)
end

-- ─── Toggle card ──────────────────────────────────────────────────────────────
local toggleVals = {}
local function Toggle(parent, id, label, desc, default, order, cb)
    local card = New("Frame", { BackgroundColor3 = C.Card, LayoutOrder = order }, parent)
    Corner(8, card); Stroke(C.CardBdr, 1, card)

    New("TextLabel", { Position = UDim2.fromOffset(13,14), Size = UDim2.new(1,-64,0,17),
        BackgroundTransparency = 1, Text = label, TextColor3 = C.Text,
        Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left }, card)
    New("TextLabel", { Position = UDim2.fromOffset(13,31), Size = UDim2.new(1,-64,0,32),
        BackgroundTransparency = 1, Text = desc, TextColor3 = C.Sub,
        Font = Enum.Font.Gotham, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top }, card)

    toggleVals[id] = default
    local btn = New("TextButton", {
        AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,-12,0.5,0),
        Size = UDim2.fromOffset(38,38), BackgroundColor3 = default and C.Green or C.Red,
        Text = default and "✓" or "✕", TextColor3 = C.White, Font = Enum.Font.GothamBold, TextSize = 20,
    }, card)
    Corner(7, btn)
    btn.MouseButton1Click:Connect(function()
        toggleVals[id] = not toggleVals[id]
        btn.BackgroundColor3 = toggleVals[id] and C.Green or C.Red
        btn.Text = toggleVals[id] and "✓" or "✕"
        if cb then pcall(cb, toggleVals[id]) end
    end)
end

-- ─── Action card ──────────────────────────────────────────────────────────────
local function Action(parent, label, desc, order, cb)
    local card = New("Frame", { BackgroundColor3 = C.Card, LayoutOrder = order }, parent)
    Corner(8, card); Stroke(C.CardBdr, 1, card)

    New("TextLabel", { Position = UDim2.fromOffset(13,14), Size = UDim2.new(1,-64,0,17),
        BackgroundTransparency = 1, Text = label, TextColor3 = C.Text,
        Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left }, card)
    New("TextLabel", { Position = UDim2.fromOffset(13,31), Size = UDim2.new(1,-64,0,32),
        BackgroundTransparency = 1, Text = desc, TextColor3 = C.Sub,
        Font = Enum.Font.Gotham, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top }, card)

    local btn = New("TextButton", {
        AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,-12,0.5,0),
        Size = UDim2.fromOffset(38,38), BackgroundColor3 = C.SliderBG,
        Text = "⬇", TextColor3 = C.Text, Font = Enum.Font.GothamBold, TextSize = 18,
    }, card)
    Corner(7, btn); Stroke(C.CardBdr, 1, btn)
    btn.MouseEnter:Connect(function() btn.BackgroundColor3 = C.CyanDim; btn.TextColor3 = C.White end)
    btn.MouseLeave:Connect(function() btn.BackgroundColor3 = C.SliderBG; btn.TextColor3 = C.Text end)
    btn.MouseButton1Click:Connect(function() if cb then pcall(cb) end end)
end

-- ─── Sections ─────────────────────────────────────────────────────────────────
-- tabSections["TabName"] = { header, gridOrFrame }
local tabSections = {}
local function reg(name, hdr, body)
    tabSections[name] = tabSections[name] or {}
    table.insert(tabSections[name], hdr)
    table.insert(tabSections[name], body)
end

-- AUDIO
local aHdr = Header("♪", "AUDIO", 10)
local aGrid = Grid(11)
Slider(aGrid, "MusicVol",   "Music Volume",   "Adjusts all game music volume",   1.2, 0, 2, 1)
Slider(aGrid, "SFXVol",     "SFX Volume",     "Adjusts all game sound effects",  1.0, 0, 2, 2)
Slider(aGrid, "AmbientVol", "Ambient Volume", "Adjusts all ambient volume",      1.2, 0, 2, 3)
reg("Audio", aHdr, aGrid)

-- GAMEPLAY
local gHdr = Header("⚙", "GAMEPLAY", 20)
local gGrid = Grid(21)
Action(gGrid,  "Teleport To Spawn",         "Go to your current map's spawn point",   1, function()
    local lp = Players.LocalPlayer
    local sp = workspace:FindFirstChildOfClass("SpawnLocation")
    if sp and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        lp.Character.HumanoidRootPart.CFrame = sp.CFrame + Vector3.new(0,3,0)
    end
end)
Toggle(gGrid, "AutoSkipWaves",        "Auto Skip Waves",           "Automatically vote to skip waves",          false, 2)
Toggle(gGrid, "AutoVoteStart",        "Auto Vote Start",           "Automatically vote to start games",         false, 3)
Toggle(gGrid, "ShowMatchEndRewards",  "Show Match End Rewards",    "Show reward pop-ups after matches",         true,  4)
Toggle(gGrid, "DisplayPinnedQuests",  "Display Pinned Quests",     "Display all pinned quests in-game",         true,  5)
Toggle(gGrid, "SelectUnitOnPlacement","Select Unit on Placement",  "Automatically select placed units",         true,  6)
Toggle(gGrid, "ShowMaxRange",         "Show Max Range on Placement","Show units' max range when placing",       true,  7)
Toggle(gGrid, "DisplayPathVisualizers","Display Path Visualizers", "Display path visualizers in-game",          true,  8)
Toggle(gGrid, "AutoRetry",            "Auto Retry",                "Automatically retry when a match ends",     false, 9)
Toggle(gGrid, "AutoNext",             "Auto Next",                 "Automatically proceed to the next match",   false, 10)
reg("Gameplay", gHdr, gGrid)

-- GRAPHICS
local grHdr = Header("🖥", "GRAPHICS", 30)
local grGrid = Grid(31)
Slider(grGrid, "QualityLevel", "Quality Level", "Rendering quality (1 = low, 21 = high)", 10, 1, 21, 1, function(v)
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel["Level"..tostring(math.floor(v))] end)
end)
Toggle(grGrid, "Shadows",         "Shadows",            "Toggle in-game shadows",                   true,  2, function(v) game:GetService("Lighting").GlobalShadows = v end)
Toggle(grGrid, "ShowFPS",         "Show FPS Counter",   "Display an in-game FPS counter",           false, 3)
Toggle(grGrid, "ReduceParticles", "Reduce Particles",   "Reduce particle effects for performance",  false, 4)
reg("Graphics", grHdr, grGrid)

-- UNITS
local uHdr = Header("🛡", "UNITS", 40)
local uGrid = Grid(41)
Toggle(uGrid, "UnitHealthBars", "Show Unit Health Bars",    "Display health bars above friendly units",      true,  1)
Toggle(uGrid, "UnitLevel",      "Show Unit Level",          "Display level indicators above units",          true,  2)
Toggle(uGrid, "AutoUpgrade",    "Auto Upgrade Units",       "Automatically upgrade units when affordable",   false, 3)
Toggle(uGrid, "ConfirmSell",    "Confirm Before Selling",   "Show confirmation before selling a unit",       true,  4)
reg("Units", uHdr, uGrid)

-- ENEMIES
local eHdr = Header("💀", "ENEMIES", 50)
local eGrid = Grid(51)
Toggle(eGrid, "EnemyHealthBars", "Show Enemy Health Bars",  "Display health bars above enemies",              true,  1)
Toggle(eGrid, "EnemyNames",      "Show Enemy Names",        "Display enemy type labels in-game",              false, 2)
Toggle(eGrid, "BossWarning",     "Boss Warning",            "Show notification when a boss spawns",           true,  3)
Toggle(eGrid, "PathPreview",     "Enemy Path Preview",      "Highlight the path enemies will follow",         false, 4)
reg("Enemies", eHdr, eGrid)

-- MISCELLANEOUS
local mHdr = Header("…", "MISCELLANEOUS", 60)
local mGrid = Grid(61)
Toggle(mGrid, "ShowPing",          "Show Ping",             "Display your current ping in-game",              false, 1)
Toggle(mGrid, "AutoReady",         "Auto Ready",            "Automatically mark yourself as ready",           false, 2)
Toggle(mGrid, "WaveNotifs",        "Wave Notifications",    "Show notification at start of each wave",        true,  3)
Toggle(mGrid, "ChatNotifs",        "Chat Notifications",    "Show in-chat event messages",                    true,  4)
reg("Miscellaneous", mHdr, mGrid)

-- KEYBINDS
local kHdr = Header("⌨", "KEYBINDS", 70)
local kFrame = New("Frame", {
    Size = UDim2.new(1,0,0,0), AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1, LayoutOrder = 71,
}, Content)
ListLayout(kFrame, 6)

-- reset button
do
    local row = New("Frame", { Size = UDim2.new(1,0,0,36), BackgroundColor3 = C.Card, LayoutOrder = 0 }, kFrame)
    Corner(8, row); Stroke(C.CardBdr, 1, row)
    local rb = New("TextButton", {
        Position = UDim2.fromOffset(10,4), Size = UDim2.new(1,-20,0,28),
        BackgroundColor3 = C.SliderBG, Text = "↺  Reset Keybinds",
        TextColor3 = C.Text, Font = Enum.Font.GothamBold, TextSize = 13,
    }, row)
    Corner(6, rb)
    rb.MouseEnter:Connect(function() rb.BackgroundColor3 = C.CyanDim; rb.TextColor3 = C.White end)
    rb.MouseLeave:Connect(function() rb.BackgroundColor3 = C.SliderBG; rb.TextColor3 = C.Text end)
    rb.MouseButton1Click:Connect(function()
        -- reset handled below by keybind default table
    end)
end

local KEYBINDS = {
    { label = "Dash",                           key = "Q"         },
    { label = "Sprint",                         key = "L Shift"   },
    { label = "Interact Prompt",                key = "E"         },
    { label = "Toggle Shift Lock",              key = "L Control" },
    { label = "Rotate Unit",                    key = "R"         },
    { label = "Cancel Unit Placement",          key = "Z"         },
    { label = "Quick Placement",                key = "L Shift"   },
    { label = "Upgrade Unit",                   key = "X  T"      },
    { label = "Auto Upgrade Unit",              key = ""          },
    { label = "Sell Unit",                      key = "X  X"      },
    { label = "Change Unit Targeting",          key = "X  R"      },
    { label = "Toggle Auto Skip Waves",         key = ""          },
    { label = "Toggle Auto-Upgrade Placed Units", key = ""        },
    { label = "Toggle Play Menu",               key = ""          },
    { label = "Toggle Quests Menu",             key = ""          },
    { label = "Toggle Areas Menu",              key = ""          },
}

for i, kb in ipairs(KEYBINDS) do
    local row = New("Frame", { Size = UDim2.new(1,0,0,36), BackgroundColor3 = C.Card, LayoutOrder = i }, kFrame)
    Corner(8, row); Stroke(C.CardBdr, 1, row)

    New("TextLabel", {
        Position = UDim2.fromOffset(13,0), Size = UDim2.new(0.55,-13,1,0),
        BackgroundTransparency = 1, Text = kb.label, TextColor3 = C.Text,
        Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
    }, row)

    -- key badges
    if kb.key ~= "" then
        local parts = kb.key:split("  ")
        local xOff = 0
        local badgeArea = New("Frame", { Position = UDim2.fromScale(0.55,0), Size = UDim2.new(0.45,-13,1,0), BackgroundTransparency = 1 }, row)
        for _, part in ipairs(parts) do
            local bg = New("Frame", {
                Position = UDim2.fromOffset(xOff, 7), Size = UDim2.fromOffset(math.max(26, #part * 9 + 12), 22),
                BackgroundColor3 = C.SliderBG,
            }, badgeArea)
            Corner(5, bg); Stroke(C.CardBdr, 1, bg)
            New("TextLabel", { Size = UDim2.fromScale(1,1), BackgroundTransparency = 1, Text = part, TextColor3 = C.Text, Font = Enum.Font.GothamBold, TextSize = 11 }, bg)
            xOff = xOff + bg.Size.X.Offset + 6
        end
    end
end
reg("Keybinds", kHdr, kFrame)

-- TESTING
local tHdr = Header("🧪", "TESTING", 80)
local tGrid = Grid(81)
Toggle(tGrid, "DebugMode",  "Debug Mode",      "Enable debug overlays",                false, 1)
Toggle(tGrid, "VerboseLog", "Verbose Logging", "Log all events to developer console",  false, 2)
Action(tGrid, "Print Settings", "Dump all current values to output", 3, function()
    for k,v in pairs(toggleVals) do print("[Toggle]", k, "=", v) end
    for k,v in pairs(sliderVals) do print("[Slider]", k, "=", v) end
end)
reg("Testing", tHdr, tGrid)

-- ─── Sidebar tabs ─────────────────────────────────────────────────────────────
local tabBtns = {}
local activeTab = nil

local TAB_DEFS = {
    { name = "All",           icon = "⇌" },
    { name = "Audio",         icon = "♪" },
    { name = "Gameplay",      icon = "⚙" },
    { name = "Graphics",      icon = "🖥" },
    { name = "Units",         icon = "🛡" },
    { name = "Enemies",       icon = "💀" },
    { name = "Miscellaneous", icon = "…" },
    { name = "Keybinds",      icon = "⌨" },
    { name = "Testing",       icon = "🧪" },
}

local function switchTab(name)
    activeTab = name
    -- update button styles
    for n, btn in pairs(tabBtns) do
        local lbl = btn:FindFirstChildWhichIsA("TextLabel")
        if n == name then
            btn.BackgroundColor3 = C.Cyan
            if lbl then lbl.TextColor3 = C.Black; lbl.Font = Enum.Font.GothamBold end
        else
            btn.BackgroundColor3 = C.Sidebar
            if lbl then lbl.TextColor3 = C.Sub; lbl.Font = Enum.Font.Gotham end
        end
    end
    -- show / hide sections
    for secName, frames in pairs(tabSections) do
        local show = (name == "All") or (name == secName)
        for _, f in ipairs(frames) do
            f.Visible = show
        end
    end
end

for i, td in ipairs(TAB_DEFS) do
    local btn = New("TextButton", {
        Size = UDim2.new(1,0,0,44), BackgroundColor3 = C.Sidebar,
        Text = "", LayoutOrder = i, AutoButtonColor = false,
    }, TabScroll)
    Corner(8, btn)

    New("TextLabel", {
        Position = UDim2.fromOffset(14,0), Size = UDim2.new(1,-14,1,0),
        BackgroundTransparency = 1, Text = td.icon .. "   " .. td.name,
        TextColor3 = C.Sub, Font = Enum.Font.Gotham, TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, btn)

    tabBtns[td.name] = btn
    local name = td.name
    btn.MouseButton1Click:Connect(function() switchTab(name) end)
end

-- ─── Search ───────────────────────────────────────────────────────────────────
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local q = SearchBox.Text:lower():gsub("^%s+",""):gsub("%s+$","")
    if q == "" then
        switchTab(activeTab or "All")
        return
    end
    -- reveal all sections, filter cards
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

-- ─── Start ────────────────────────────────────────────────────────────────────
switchTab("All")
print("[Settings] Loaded. Click ✕ or destroy SettingsGui to close.")
