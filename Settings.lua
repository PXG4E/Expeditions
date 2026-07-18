--[[
    Settings.lua — Custom Settings UI
    Repo: https://github.com/PXG4E/Expeditions

    Run in your executor:
        loadstring(game:HttpGet("https://raw.githubusercontent.com/PXG4E/Expeditions/main/Settings.lua"))()
--]]

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

-- ─── Destroy old instance ─────────────────────────────────────────────────────
local existing = PlayerGui:FindFirstChild("SettingsGui")
if existing then existing:Destroy() end

-- ─── Constants ────────────────────────────────────────────────────────────────
local C = {
    BG         = Color3.fromRGB(12,  15,  20),
    SidebarBG  = Color3.fromRGB(18,  22,  30),
    CardBG     = Color3.fromRGB(22,  27,  35),
    CardBorder = Color3.fromRGB(35,  42,  55),
    Cyan       = Color3.fromRGB(0,   210, 255),
    CyanDark   = Color3.fromRGB(0,   160, 200),
    Text       = Color3.fromRGB(220, 225, 235),
    SubText    = Color3.fromRGB(130, 135, 150),
    Green      = Color3.fromRGB(30,  180, 80),
    Red        = Color3.fromRGB(210, 40,  50),
    SearchBG   = Color3.fromRGB(28,  33,  45),
    SliderBG   = Color3.fromRGB(38,  44,  58),
    SliderFill = Color3.fromRGB(120, 125, 140),
    White      = Color3.new(1, 1, 1),
    Black      = Color3.new(0, 0, 0),
}

-- ─── Helper: new instance ─────────────────────────────────────────────────────
local function New(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        obj[k] = v
    end
    if parent then obj.Parent = parent end
    return obj
end

local function Corner(radius, parent)
    return New("UICorner", { CornerRadius = UDim.new(0, radius) }, parent)
end

local function Stroke(color, thickness, parent)
    local s = New("UIStroke", { Color = color, Thickness = thickness }, parent)
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return s
end

local function Padding(all, parent)
    return New("UIPadding", {
        PaddingTop    = UDim.new(0, all),
        PaddingBottom = UDim.new(0, all),
        PaddingLeft   = UDim.new(0, all),
        PaddingRight  = UDim.new(0, all),
    }, parent)
end

-- ─── Root ─────────────────────────────────────────────────────────────────────
local ScreenGui = New("ScreenGui", {
    Name            = "SettingsGui",
    ResetOnSpawn    = false,
    ZIndexBehavior  = Enum.ZIndexBehavior.Sibling,
}, PlayerGui)

-- ─── Backdrop ─────────────────────────────────────────────────────────────────
local Backdrop = New("Frame", {
    Size              = UDim2.fromScale(1, 1),
    BackgroundColor3  = Color3.new(0, 0, 0),
    BackgroundTransparency = 0.5,
}, ScreenGui)

-- ─── Main Window ──────────────────────────────────────────────────────────────
local Win = New("Frame", {
    AnchorPoint      = Vector2.new(0.5, 0.5),
    Position         = UDim2.fromScale(0.5, 0.5),
    Size             = UDim2.fromOffset(980, 660),
    BackgroundColor3 = C.BG,
    ClipsDescendants = true,
}, ScreenGui)
Corner(8, Win)
Stroke(C.Cyan, 2, Win)

-- Make window draggable
do
    local dragging, dragStart, startPos = false, nil, nil
    Win.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging  = true
            dragStart = input.Position
            startPos  = Win.Position
        end
    end)
    Win.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Win.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ─── Top Bar ──────────────────────────────────────────────────────────────────
local TopBar = New("Frame", {
    Size             = UDim2.new(1, 0, 0, 62),
    BackgroundColor3 = C.BG,
    ZIndex           = 2,
}, Win)

-- "SETTINGS" badge (cyan left panel)
local HeaderBadge = New("Frame", {
    Size             = UDim2.fromOffset(222, 62),
    BackgroundColor3 = C.Cyan,
    ZIndex           = 2,
}, TopBar)
New("UICorner", { CornerRadius = UDim.new(0, 0) }, HeaderBadge)

-- Icon + title
New("TextLabel", {
    Size             = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Text             = "⚙  SETTINGS",
    TextColor3       = C.Black,
    Font             = Enum.Font.GothamBold,
    TextSize         = 20,
    ZIndex           = 3,
}, HeaderBadge)

-- Diagonal slash decoration on the right edge of the badge
local Slash = New("Frame", {
    AnchorPoint      = Vector2.new(0, 0),
    Position         = UDim2.fromOffset(210, 0),
    Size             = UDim2.fromOffset(40, 62),
    BackgroundColor3 = C.Cyan,
    Rotation         = -8,
    ZIndex           = 2,
}, TopBar)

-- Search bar
local SearchBar = New("Frame", {
    AnchorPoint      = Vector2.new(0.5, 0.5),
    Position         = UDim2.new(0.5, 10, 0.5, 0),
    Size             = UDim2.fromOffset(380, 36),
    BackgroundColor3 = C.SearchBG,
    ZIndex           = 2,
}, TopBar)
Corner(6, SearchBar)
Stroke(C.CardBorder, 1, SearchBar)

New("TextLabel", {
    Size             = UDim2.fromOffset(20, 20),
    Position         = UDim2.fromOffset(10, 8),
    BackgroundTransparency = 1,
    Text             = "🔍",
    TextSize         = 14,
    TextColor3       = C.SubText,
    ZIndex           = 3,
}, SearchBar)

local SearchBox = New("TextBox", {
    Size             = UDim2.new(1, -40, 1, 0),
    Position         = UDim2.fromOffset(34, 0),
    BackgroundTransparency = 1,
    PlaceholderText  = "Search...",
    PlaceholderColor3 = C.SubText,
    Text             = "",
    TextColor3       = C.Text,
    Font             = Enum.Font.Gotham,
    TextSize         = 14,
    TextXAlignment   = Enum.TextXAlignment.Left,
    ClearTextOnFocus = false,
    ZIndex           = 3,
}, SearchBar)

-- Close button
local CloseBtn = New("TextButton", {
    AnchorPoint      = Vector2.new(1, 0.5),
    Position         = UDim2.new(1, -14, 0.5, 0),
    Size             = UDim2.fromOffset(36, 36),
    BackgroundColor3 = C.Red,
    Text             = "✕",
    TextColor3       = C.White,
    Font             = Enum.Font.GothamBold,
    TextSize         = 16,
    ZIndex           = 3,
}, TopBar)
Corner(6, CloseBtn)
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Separator line under top bar
New("Frame", {
    Position         = UDim2.fromOffset(0, 62),
    Size             = UDim2.new(1, 0, 0, 1),
    BackgroundColor3 = C.Cyan,
    BackgroundTransparency = 0.7,
}, Win)

-- ─── Left Sidebar ─────────────────────────────────────────────────────────────
local Sidebar = New("Frame", {
    Position         = UDim2.fromOffset(0, 63),
    Size             = UDim2.new(0, 238, 1, -63),
    BackgroundColor3 = C.SidebarBG,
}, Win)

-- Sidebar right border
New("Frame", {
    AnchorPoint      = Vector2.new(1, 0),
    Position         = UDim2.fromScale(1, 0),
    Size             = UDim2.new(0, 1, 1, 0),
    BackgroundColor3 = C.Cyan,
    BackgroundTransparency = 0.6,
}, Sidebar)

local TabList = New("ScrollingFrame", {
    Size                    = UDim2.fromScale(1, 1),
    BackgroundTransparency  = 1,
    ScrollBarThickness      = 0,
    CanvasSize              = UDim2.fromScale(0, 0),
    AutomaticCanvasSize     = Enum.AutomaticSize.Y,
}, Sidebar)

New("UIListLayout", {
    SortOrder    = Enum.SortOrder.LayoutOrder,
    Padding      = UDim.new(0, 4),
    Parent       = TabList,
})
New("UIPadding", {
    PaddingTop   = UDim.new(0, 8),
    PaddingLeft  = UDim.new(0, 8),
    PaddingRight = UDim.new(0, 8),
    Parent       = TabList,
})

-- ─── Right Content ────────────────────────────────────────────────────────────
local ContentArea = New("ScrollingFrame", {
    Position               = UDim2.fromOffset(239, 63),
    Size                   = UDim2.new(1, -239, 1, -63),
    BackgroundTransparency = 1,
    ScrollBarThickness     = 4,
    ScrollBarImageColor3   = C.Cyan,
    CanvasSize             = UDim2.fromScale(0, 0),
    AutomaticCanvasSize    = Enum.AutomaticSize.Y,
}, Win)

New("UIPadding", {
    PaddingTop   = UDim.new(0, 16),
    PaddingLeft  = UDim.new(0, 18),
    PaddingRight = UDim.new(0, 18),
    PaddingBottom = UDim.new(0, 16),
    Parent       = ContentArea,
})

local ContentLayout = New("UIListLayout", {
    SortOrder  = Enum.SortOrder.LayoutOrder,
    Padding    = UDim.new(0, 12),
    Parent     = ContentArea,
})

-- ─── UI Builder Helpers ───────────────────────────────────────────────────────

-- Section header (e.g. "♪ AUDIO")
local function SectionHeader(icon, title, order)
    local f = New("Frame", {
        Size             = UDim2.new(1, 0, 0, 32),
        BackgroundTransparency = 1,
        LayoutOrder      = order,
    }, ContentArea)
    New("TextLabel", {
        Size             = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text             = icon .. "  " .. title,
        TextColor3       = C.Cyan,
        Font             = Enum.Font.GothamBold,
        TextSize         = 15,
        TextXAlignment   = Enum.TextXAlignment.Left,
    }, f)
    return f
end

-- Two-column card grid container
local function CardGrid(order)
    local grid = New("Frame", {
        Size             = UDim2.new(1, 0, 0, 0),
        AutomaticSize    = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder      = order,
    }, ContentArea)
    local layout = New("UIGridLayout", {
        CellSize         = UDim2.new(0.5, -6, 0, 84),
        CellPaddingY     = UDim2.fromOffset(0, 8),
        CellPaddingX     = UDim2.fromOffset(12, 0),
        SortOrder        = Enum.SortOrder.LayoutOrder,
        Parent           = grid,
    })
    return grid
end

-- Slider card
local sliderValues = {}
local function SliderCard(parent, id, label, desc, default, min, max, order, callback)
    local card = New("Frame", {
        BackgroundColor3 = C.CardBG,
        LayoutOrder      = order,
    }, parent)
    Corner(8, card)
    Stroke(C.CardBorder, 1, card)

    New("TextLabel", {
        Position         = UDim2.fromOffset(14, 12),
        Size             = UDim2.new(1, -80, 0, 18),
        BackgroundTransparency = 1,
        Text             = label,
        TextColor3       = C.Text,
        Font             = Enum.Font.GothamBold,
        TextSize         = 14,
        TextXAlignment   = Enum.TextXAlignment.Left,
    }, card)

    New("TextLabel", {
        Position         = UDim2.fromOffset(14, 30),
        Size             = UDim2.new(1, -80, 0, 14),
        BackgroundTransparency = 1,
        Text             = desc,
        TextColor3       = C.SubText,
        Font             = Enum.Font.Gotham,
        TextSize         = 11,
        TextXAlignment   = Enum.TextXAlignment.Left,
    }, card)

    -- Value box
    local valBox = New("Frame", {
        Position         = UDim2.fromOffset(14, 50),
        Size             = UDim2.fromOffset(42, 22),
        BackgroundColor3 = C.SliderBG,
    }, card)
    Corner(4, valBox)

    local valLabel = New("TextLabel", {
        Size             = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text             = tostring(default),
        TextColor3       = C.Text,
        Font             = Enum.Font.GothamBold,
        TextSize         = 12,
    }, valBox)

    -- Slider track
    local trackBG = New("Frame", {
        Position         = UDim2.fromOffset(62, 57),
        Size             = UDim2.new(1, -80, 0, 8),
        BackgroundColor3 = C.SliderBG,
    }, card)
    Corner(4, trackBG)

    local trackFill = New("Frame", {
        Size             = UDim2.new((default - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = C.SliderFill,
    }, trackBG)
    Corner(4, trackFill)

    -- Knob
    local knob = New("Frame", {
        AnchorPoint      = Vector2.new(0.5, 0.5),
        Position         = UDim2.new((default - min) / (max - min), 0, 0.5, 0),
        Size             = UDim2.fromOffset(14, 14),
        BackgroundColor3 = C.Text,
    }, trackBG)
    Corner(7, knob)
    Stroke(C.Cyan, 2, knob)

    -- Drag logic
    local currentVal = default
    sliderValues[id] = currentVal

    local function setVal(v)
        v = math.clamp(math.round(v * 10) / 10, min, max)
        currentVal = v
        sliderValues[id] = v
        local pct = (v - min) / (max - min)
        trackFill.Size = UDim2.new(pct, 0, 1, 0)
        knob.Position  = UDim2.new(pct, 0, 0.5, 0)
        valLabel.Text  = tostring(v)
        if callback then callback(v) end
    end

    local dragging = false
    knob.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    trackBG.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local rel = (inp.Position.X - trackBG.AbsolutePosition.X) / trackBG.AbsoluteSize.X
            setVal(min + rel * (max - min))
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
            local rel = (inp.Position.X - trackBG.AbsolutePosition.X) / trackBG.AbsoluteSize.X
            setVal(min + rel * (max - min))
        end
    end)

    return card
end

-- Toggle card
local toggleValues = {}
local function ToggleCard(parent, id, label, desc, default, order, callback)
    local card = New("Frame", {
        BackgroundColor3 = C.CardBG,
        LayoutOrder      = order,
    }, parent)
    Corner(8, card)
    Stroke(C.CardBorder, 1, card)

    New("TextLabel", {
        Position         = UDim2.fromOffset(14, 18),
        Size             = UDim2.new(1, -70, 0, 18),
        BackgroundTransparency = 1,
        Text             = label,
        TextColor3       = C.Text,
        Font             = Enum.Font.GothamBold,
        TextSize         = 14,
        TextXAlignment   = Enum.TextXAlignment.Left,
    }, card)

    New("TextLabel", {
        Position         = UDim2.fromOffset(14, 38),
        Size             = UDim2.new(1, -70, 0, 28),
        BackgroundTransparency = 1,
        Text             = desc,
        TextColor3       = C.SubText,
        Font             = Enum.Font.Gotham,
        TextSize         = 11,
        TextXAlignment   = Enum.TextXAlignment.Left,
        TextYAlignment   = Enum.TextYAlignment.Top,
        TextWrapped      = true,
    }, card)

    local val = default
    toggleValues[id] = val

    -- Toggle button
    local btn = New("TextButton", {
        AnchorPoint      = Vector2.new(1, 0.5),
        Position         = UDim2.new(1, -14, 0.5, 0),
        Size             = UDim2.fromOffset(40, 40),
        BackgroundColor3 = val and C.Green or C.Red,
        Text             = val and "✓" or "✕",
        TextColor3       = C.White,
        Font             = Enum.Font.GothamBold,
        TextSize         = 20,
    }, card)
    Corner(8, btn)

    btn.MouseButton1Click:Connect(function()
        val = not val
        toggleValues[id] = val
        btn.BackgroundColor3 = val and C.Green or C.Red
        btn.Text = val and "✓" or "✕"
        if callback then callback(val) end
    end)

    return card
end

-- Button card (action, no toggle)
local function ActionCard(parent, label, desc, icon, order, callback)
    local card = New("Frame", {
        BackgroundColor3 = C.CardBG,
        LayoutOrder      = order,
    }, parent)
    Corner(8, card)
    Stroke(C.CardBorder, 1, card)

    New("TextLabel", {
        Position         = UDim2.fromOffset(14, 18),
        Size             = UDim2.new(1, -70, 0, 18),
        BackgroundTransparency = 1,
        Text             = label,
        TextColor3       = C.Text,
        Font             = Enum.Font.GothamBold,
        TextSize         = 14,
        TextXAlignment   = Enum.TextXAlignment.Left,
    }, card)

    New("TextLabel", {
        Position         = UDim2.fromOffset(14, 38),
        Size             = UDim2.new(1, -70, 0, 28),
        BackgroundTransparency = 1,
        Text             = desc,
        TextColor3       = C.SubText,
        Font             = Enum.Font.Gotham,
        TextSize         = 11,
        TextXAlignment   = Enum.TextXAlignment.Left,
        TextYAlignment   = Enum.TextYAlignment.Top,
        TextWrapped      = true,
    }, card)

    local btn = New("TextButton", {
        AnchorPoint      = Vector2.new(1, 0.5),
        Position         = UDim2.new(1, -14, 0.5, 0),
        Size             = UDim2.fromOffset(40, 40),
        BackgroundColor3 = C.SliderBG,
        Text             = icon or "▶",
        TextColor3       = C.Text,
        Font             = Enum.Font.GothamBold,
        TextSize         = 18,
    }, card)
    Corner(8, btn)
    Stroke(C.CardBorder, 1, btn)

    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)

    -- Hover
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = C.CyanDark
        btn.TextColor3 = C.White
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = C.SliderBG
        btn.TextColor3 = C.Text
    end)

    return card
end

-- ─── Tab Navigation ───────────────────────────────────────────────────────────

-- Each tab has: { name, icon, sections = { ... } }
-- We store per-tab content frames and manage visibility

local tabFrames   = {}
local tabButtons  = {}
local activeTab   = nil

local function makeTabButton(name, icon, order)
    local btn = New("TextButton", {
        Size             = UDim2.new(1, 0, 0, 46),
        BackgroundColor3 = C.SidebarBG,
        Text             = "",
        LayoutOrder      = order,
        AutoButtonColor  = false,
    }, TabList)
    Corner(8, btn)

    New("TextLabel", {
        Position         = UDim2.fromOffset(14, 0),
        Size             = UDim2.new(1, -14, 1, 0),
        BackgroundTransparency = 1,
        Text             = icon .. "   " .. name,
        TextColor3       = C.SubText,
        Font             = Enum.Font.Gotham,
        TextSize         = 14,
        TextXAlignment   = Enum.TextXAlignment.Left,
    }, btn)

    return btn
end

local function setActiveTab(name)
    if activeTab == name then return end
    activeTab = name

    -- Update buttons
    for n, b in pairs(tabButtons) do
        local label = b:FindFirstChildWhichIsA("TextLabel")
        if n == name then
            b.BackgroundColor3 = C.Cyan
            if label then
                label.TextColor3 = C.Black
                label.Font = Enum.Font.GothamBold
            end
        else
            b.BackgroundColor3 = C.SidebarBG
            if label then
                label.TextColor3 = C.SubText
                label.Font = Enum.Font.Gotham
            end
        end
    end

    -- Show/hide content sections
    for n, frames in pairs(tabFrames) do
        local visible = (n == name or name == "All")
        for _, f in ipairs(frames) do
            f.Visible = visible
        end
    end
end

-- ─── Content Sections ─────────────────────────────────────────────────────────

-- We collect each section's header + grid for tab filtering
local function registerSection(name, header, grid)
    if not tabFrames[name] then tabFrames[name] = {} end
    table.insert(tabFrames[name], header)
    table.insert(tabFrames[name], grid)
end

-- ── AUDIO ─────────────────────────────────────────────────────────────────────
local audioHeader = SectionHeader("♪", "AUDIO", 10)
local audioGrid   = CardGrid(11)

SliderCard(audioGrid, "MusicVolume",   "Music Volume",   "Adjusts all game mu...", 1.2, 0, 2, 1, function(v)
    -- game:GetService("SoundService"):SetVolumeByName("Music", v)
end)
SliderCard(audioGrid, "SFXVolume",     "SFX Volume",     "Adjusts all game so...", 1.0, 0, 2, 2, function(v)
    -- game:GetService("SoundService"):SetVolumeByName("SFX", v)
end)
SliderCard(audioGrid, "AmbientVolume", "Ambient Volume", "Adjusts all ambient ...", 1.2, 0, 2, 3, function(v)
    -- game:GetService("SoundService"):SetVolumeByName("Ambient", v)
end)

registerSection("Audio", audioHeader, audioGrid)

-- ── GAMEPLAY ──────────────────────────────────────────────────────────────────
local gameplayHeader = SectionHeader("⚙", "GAMEPLAY", 20)
local gameplayGrid   = CardGrid(21)

ActionCard(gameplayGrid, "Teleport To Spawn",        "Go to your current map's spawn point",         "⬇",  1, function()
    local lp = Players.LocalPlayer
    local sp = workspace:FindFirstChildOfClass("SpawnLocation")
    if sp and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        lp.Character.HumanoidRootPart.CFrame = sp.CFrame + Vector3.new(0, 3, 0)
    end
end)
ToggleCard(gameplayGrid, "AutoSkipWaves",        "Auto Skip Waves",          "Automatically vote to skip waves",        false,  2)
ToggleCard(gameplayGrid, "AutoVoteStart",        "Auto Vote Start",          "Automatically vote to start games",       false,  3)
ToggleCard(gameplayGrid, "ShowMatchEndRewards",  "Show Match End Rewards",   "Show reward pop-ups after matches",       true,   4)
ToggleCard(gameplayGrid, "DisplayPinnedQuests",  "Display Pinned Quests",    "Display all pinned quest quests in-game", true,   5)
ToggleCard(gameplayGrid, "SelectUnitOnPlacement","Select Unit on Placement", "Automatically select placed units",       true,   6)
ToggleCard(gameplayGrid, "ShowMaxRange",         "Show Max Range on Placement", "Show units' max range when placing",   true,   7)
ToggleCard(gameplayGrid, "DisplayPathVisualizers","Display Path Visualizers","Display path visualizers in-game",        true,   8)
ToggleCard(gameplayGrid, "AutoRetry",            "Auto Retry",               "Automatically retry when a match ends",   false,  9)
ToggleCard(gameplayGrid, "AutoNext",             "Auto Next",                "Automatically proceed to the next match", false, 10)

registerSection("Gameplay", gameplayHeader, gameplayGrid)

-- ── GRAPHICS ──────────────────────────────────────────────────────────────────
local graphicsHeader = SectionHeader("🖥", "GRAPHICS", 30)
local graphicsGrid   = CardGrid(31)

SliderCard(graphicsGrid, "QualityLevel", "Quality Level", "Overall rendering quality", 10, 1, 21, 1, function(v)
    settings().Rendering.QualityLevel = Enum.QualityLevel["Level" .. tostring(math.floor(v))]
end)
ToggleCard(graphicsGrid, "Shadows",         "Shadows",           "Toggle in-game shadows",                   true,  2, function(v)
    game:GetService("Lighting").GlobalShadows = v
end)
ToggleCard(graphicsGrid, "ShowFPS",         "Show FPS Counter",  "Display an in-game FPS counter",           false, 3)
ToggleCard(graphicsGrid, "ReduceParticles", "Reduce Particles",  "Reduce particle effects for performance",  false, 4)

registerSection("Graphics", graphicsHeader, graphicsGrid)

-- ── UNITS ─────────────────────────────────────────────────────────────────────
local unitsHeader = SectionHeader("🛡", "UNITS", 40)
local unitsGrid   = CardGrid(41)

ToggleCard(unitsGrid, "ShowUnitHealthBars", "Show Unit Health Bars", "Display health bars above friendly units",  true,  1)
ToggleCard(unitsGrid, "ShowUnitLevel",      "Show Unit Level",       "Display level indicators above units",      true,  2)
ToggleCard(unitsGrid, "AutoUpgradeUnits",   "Auto Upgrade Units",    "Automatically upgrade units when affordable", false, 3)
ToggleCard(unitsGrid, "ConfirmSell",        "Confirm Before Selling","Show confirmation before selling a unit",   true,  4)

registerSection("Units", unitsHeader, unitsGrid)

-- ── ENEMIES ───────────────────────────────────────────────────────────────────
local enemiesHeader = SectionHeader("💀", "ENEMIES", 50)
local enemiesGrid   = CardGrid(51)

ToggleCard(enemiesGrid, "ShowEnemyHealthBars", "Show Enemy Health Bars", "Display health bars above enemies",      true,  1)
ToggleCard(enemiesGrid, "ShowEnemyNames",      "Show Enemy Names",       "Display enemy type labels in-game",      false, 2)
ToggleCard(enemiesGrid, "BossWarning",         "Boss Warning",           "Show a notification when a boss spawns", true,  3)
ToggleCard(enemiesGrid, "EnemyPathPreview",    "Enemy Path Preview",     "Highlight the path enemies will follow", false, 4)

registerSection("Enemies", enemiesHeader, enemiesGrid)

-- ── MISCELLANEOUS ─────────────────────────────────────────────────────────────
local miscHeader = SectionHeader("…", "MISCELLANEOUS", 60)
local miscGrid   = CardGrid(61)

ToggleCard(miscGrid, "ShowPing",           "Show Ping",           "Display your current ping in-game",       false, 1)
ToggleCard(miscGrid, "AutoReady",          "Auto Ready",          "Automatically mark yourself as ready",    false, 2)
ToggleCard(miscGrid, "WaveNotifications",  "Wave Notifications",  "Show notification at start of each wave", true,  3)
ToggleCard(miscGrid, "ChatNotifications",  "Chat Notifications",  "Show in-chat event messages",             true,  4)

registerSection("Miscellaneous", miscHeader, miscGrid)

-- ── KEYBINDS ──────────────────────────────────────────────────────────────────
local keybindsHeader = SectionHeader("⌨", "KEYBINDS", 70)
local keybindsFrame  = New("Frame", {
    Size             = UDim2.new(1, 0, 0, 0),
    AutomaticSize    = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1,
    LayoutOrder      = 71,
}, ContentArea)

New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6), Parent = keybindsFrame })

local KEYBINDS = {
    { id = "Dash",               label = "Dash",                         default = "Q"          },
    { id = "Sprint",             label = "Sprint",                       default = "L Shift"    },
    { id = "InteractPrompt",     label = "Interact Prompt",              default = "E"          },
    { id = "ToggleShiftLock",    label = "Toggle Shift Lock",            default = "L Control"  },
    { id = "RotateUnit",         label = "Rotate Unit",                  default = "R"          },
    { id = "CancelUnitPlacement", label = "Cancel Unit Placement",      default = "Z"          },
    { id = "QuickPlacement",     label = "Quick Placement",              default = "L Shift"    },
    { id = "UpgradeUnit",        label = "Upgrade Unit",                 default = "X, T"       },
    { id = "AutoUpgradeUnit",    label = "Auto Upgrade Unit",            default = ""           },
    { id = "SellUnit",           label = "Sell Unit",                    default = "X, X"       },
    { id = "ChangeUnitTargeting", label = "Change Unit Targeting",      default = "X, R"       },
    { id = "ToggleAutoSkip",     label = "Toggle Auto Skip Waves",       default = ""           },
    { id = "ToggleAutoUpgrade",  label = "Toggle Auto-Upgrade Placed Units", default = ""      },
    { id = "TogglePlayMenu",     label = "Toggle Play Menu",             default = ""           },
    { id = "ToggleQuestsMenu",   label = "Toggle Quests Menu",           default = ""           },
    { id = "ToggleAreasMenu",    label = "Toggle Areas Menu",            default = ""           },
}

-- Reset button
local resetRow = New("Frame", {
    Size             = UDim2.new(1, 0, 0, 36),
    BackgroundColor3 = C.CardBG,
    LayoutOrder      = 0,
}, keybindsFrame)
Corner(8, resetRow)
Stroke(C.CardBorder, 1, resetRow)

local resetBtn = New("TextButton", {
    Size             = UDim2.new(1, -20, 0, 28),
    Position         = UDim2.fromOffset(10, 4),
    BackgroundColor3 = C.SliderBG,
    Text             = "↺  Reset Keybinds",
    TextColor3       = C.Text,
    Font             = Enum.Font.GothamBold,
    TextSize         = 13,
}, resetRow)
Corner(6, resetBtn)

local keybindCurrentValues = {}

resetBtn.MouseButton1Click:Connect(function()
    for _, kb in ipairs(KEYBINDS) do
        keybindCurrentValues[kb.id] = kb.default
        -- update labels (handled below via a reference table)
    end
end)

-- Key badge helper
local function Badge(text, parent, xOffset)
    if not text or text == "" then return xOffset end
    local parts = text:split(", ")
    local x = xOffset
    for _, part in ipairs(parts) do
        local bg = New("Frame", {
            Position         = UDim2.fromOffset(x, 8),
            Size             = UDim2.fromOffset(math.max(26, #part * 8 + 14), 22),
            BackgroundColor3 = C.SliderBG,
        }, parent)
        Corner(5, bg)
        Stroke(C.CardBorder, 1, bg)
        New("TextLabel", {
            Size             = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Text             = part,
            TextColor3       = C.Text,
            Font             = Enum.Font.GothamBold,
            TextSize         = 11,
        }, bg)
        x = x + bg.Size.X.Offset + 6
    end
    return x
end

local keybindLabels = {}

for i, kb in ipairs(KEYBINDS) do
    keybindCurrentValues[kb.id] = kb.default

    local row = New("Frame", {
        Size             = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = C.CardBG,
        LayoutOrder      = i,
    }, keybindsFrame)
    Corner(8, row)
    Stroke(C.CardBorder, 1, row)

    New("TextLabel", {
        Position         = UDim2.fromOffset(14, 0),
        Size             = UDim2.new(0.5, -14, 1, 0),
        BackgroundTransparency = 1,
        Text             = kb.label,
        TextColor3       = C.Text,
        Font             = Enum.Font.Gotham,
        TextSize         = 13,
        TextXAlignment   = Enum.TextXAlignment.Left,
    }, row)

    -- Badge area
    local badgeArea = New("Frame", {
        Position         = UDim2.fromScale(0.5, 0),
        Size             = UDim2.new(0.5, -14, 1, 0),
        BackgroundTransparency = 1,
    }, row)
    Badge(kb.default, badgeArea, 0)

    keybindLabels[kb.id] = badgeArea
end

registerSection("Keybinds", keybindsHeader, keybindsFrame)

-- ── TESTING ───────────────────────────────────────────────────────────────────
local testingHeader = SectionHeader("🧪", "TESTING", 80)
local testingGrid   = CardGrid(81)

ToggleCard(testingGrid, "DebugMode",     "Debug Mode",       "Enable debug overlays",                 false, 1)
ToggleCard(testingGrid, "VerboseLog",    "Verbose Logging",  "Log all events to developer console",   false, 2)
ActionCard(testingGrid, "Print Settings", "Dump all current values to output", "▶", 3, function()
    for k, v in pairs(toggleValues) do print("[Toggle]", k, "=", v) end
    for k, v in pairs(sliderValues) do print("[Slider]", k, "=", v) end
end)

registerSection("Testing", testingHeader, testingGrid)

-- ─── Build Sidebar Tabs ────────────────────────────────────────────────────────

local tabDefs = {
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

for i, td in ipairs(tabDefs) do
    local btn = makeTabButton(td.name, td.icon, i)
    tabButtons[td.name] = btn
    btn.MouseButton1Click:Connect(function()
        setActiveTab(td.name)
    end)
end

-- ─── Search filtering ─────────────────────────────────────────────────────────

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local query = SearchBox.Text:lower()
    if query == "" then
        -- Restore current tab visibility
        setActiveTab(activeTab)
        return
    end
    -- Show all sections and filter cards
    for _, frames in pairs(tabFrames) do
        for _, f in ipairs(frames) do
            f.Visible = true
        end
    end
    -- Hide cards that don't match
    for _, section in pairs({ audioGrid, gameplayGrid, graphicsGrid, unitsGrid, enemiesGrid, miscGrid, testingGrid }) do
        for _, card in ipairs(section:GetChildren()) do
            if card:IsA("Frame") then
                local lbl = card:FindFirstChildWhichIsA("TextLabel")
                if lbl then
                    card.Visible = lbl.Text:lower():find(query) ~= nil
                end
            end
        end
    end
end)

-- ─── Initial state ────────────────────────────────────────────────────────────
setActiveTab("All")

print("[Settings] UI loaded. Press the ✕ button to close.")
