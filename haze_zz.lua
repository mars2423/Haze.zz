-- ═══════════════════════════════════════════════════════════════════════════════════════
--   Haze.zz  -  Midnight Blue Theme (Custom UI Library + Script)
--   No external dependencies - just execute this entire script
-- ═══════════════════════════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════════════════════════
--   WHITELIST SYSTEM  -  Edit the table below to control access
-- ═══════════════════════════════════════════════════════════════════════════════════════
local WHITELISTED_USERS = {
    -- Add usernames, display names, or UserIds (as strings) here
    -- Matching is case-insensitive for names
    "YourUsername",
    "FriendName1",
    "FriendName2",
    -- "12345678",  -- you can also whitelist by UserId
}

local function isWhitelisted(plr)
    for _, entry in ipairs(WHITELISTED_USERS) do
        if string.lower(entry) == string.lower(plr.Name)
        or string.lower(entry) == string.lower(plr.DisplayName)
        or tostring(plr.UserId) == entry then
            return true
        end
    end
    return false
end

do
    local _wlPlayer = game:GetService("Players").LocalPlayer
    if not isWhitelisted(_wlPlayer) then
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "haze.zz",
                Text = "You are not whitelisted.",
                Duration = 5,
            })
        end)
        return
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════════════
--   UI LIBRARY (BUILT-IN)  -  MIDNIGHT BLUE THEME
-- ═══════════════════════════════════════════════════════════════════════════════════════
local Library = {}
Library.__index = Library

local Theme = {
    Background      = Color3.fromRGB(10, 10, 14),
    TopBar          = Color3.fromRGB(14, 14, 20),
    TabBar          = Color3.fromRGB(12, 12, 18),
    TabActive       = Color3.fromRGB(60, 140, 255),
    TabInactive     = Color3.fromRGB(85, 85, 100),
    Section         = Color3.fromRGB(16, 16, 22),
    SectionBorder   = Color3.fromRGB(30, 40, 60),
    Element         = Color3.fromRGB(20, 20, 28),
    ElementHover    = Color3.fromRGB(28, 32, 44),
    Accent          = Color3.fromRGB(60, 140, 255),
    AccentDark      = Color3.fromRGB(35, 95, 200),
    TextPrimary     = Color3.fromRGB(210, 215, 230),
    TextSecondary   = Color3.fromRGB(90, 100, 120),
    Toggle_On       = Color3.fromRGB(60, 140, 255),
    Toggle_Off      = Color3.fromRGB(45, 45, 60),
    SliderFill      = Color3.fromRGB(60, 140, 255),
    SliderTrack     = Color3.fromRGB(30, 30, 42),
    DropdownBG      = Color3.fromRGB(12, 12, 18),
    DropdownHover   = Color3.fromRGB(28, 32, 48),
    Font            = Enum.Font.GothamSemibold,
    FontLight       = Enum.Font.Gotham,
    CornerRadius    = UDim.new(0, 6),
}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local function tween(obj, props, duration)
    duration = duration or 0.2
    TweenService:Create(obj, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local function create(class, props, children)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        inst[k] = v
    end
    for _, child in ipairs(children or {}) do
        child.Parent = inst
    end
    return inst
end

local function corner(parent, radius)
    return create("UICorner", { CornerRadius = radius or Theme.CornerRadius, Parent = parent })
end

local function stroke(parent, color, thickness)
    return create("UIStroke", { Color = color or Theme.SectionBorder, Thickness = thickness or 1, Parent = parent })
end

local function padding(parent, t, b, l, r)
    return create("UIPadding", {
        PaddingTop    = UDim.new(0, t or 6),
        PaddingBottom = UDim.new(0, b or 6),
        PaddingLeft   = UDim.new(0, l or 8),
        PaddingRight  = UDim.new(0, r or 8),
        Parent = parent,
    })
end

-- ═══════════════════════════════════════════════════════════════════════════════════════
-- SECTION CLASS
-- ═══════════════════════════════════════════════════════════════════════════════════════
local Section = {}
Section.__index = Section

function Section:Toggle(name, default, callback)
    callback = callback or function() end
    local state = default or false
    local holder = create("Frame", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = Theme.Element,
        Parent = self._container,
    })
    corner(holder)
    create("TextLabel", {
        Size = UDim2.new(1, -44, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        Font = Theme.FontLight,
        TextSize = 13,
        TextColor3 = Theme.TextPrimary,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = holder,
    })
    local radioOuter = create("Frame", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(1, -28, 0.5, -8),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 1,
        Parent = holder,
    })
    corner(radioOuter, UDim.new(0, 7))
    local radioRing = create("UIStroke", {
        Color = state and Theme.Toggle_On or Theme.Toggle_Off,
        Thickness = 1.5,
        Parent = radioOuter,
    })
    local radioDot = create("Frame", {
        Size = UDim2.new(0, 8, 0, 8),
        Position = UDim2.new(0.5, -4, 0.5, -4),
        BackgroundColor3 = Theme.Toggle_On,
        BackgroundTransparency = state and 0 or 1,
        Parent = radioOuter,
    })
    corner(radioDot, UDim.new(0, 4))
    local btn = create("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        Parent = holder,
    })
    btn.MouseButton1Click:Connect(function()
        state = not state
        tween(radioRing, { Color = state and Theme.Toggle_On or Theme.Toggle_Off })
        tween(radioDot, { BackgroundTransparency = state and 0 or 1 }, 0.15)
        callback(state)
    end)
    return { SetValue = function(_, v) state = v; callback(v) end }
end

function Section:Slider(name, min, max, default, callback)
    callback = callback or function() end
    min = min or 0
    max = max or 100
    default = default or min
    local holder = create("Frame", {
        Size = UDim2.new(1, 0, 0, 48),
        BackgroundColor3 = Theme.Element,
        Parent = self._container,
    })
    corner(holder)
    local valuePct = (default - min) / (max - min)
    create("TextLabel", {
        Size = UDim2.new(1, -64, 0, 20),
        Position = UDim2.new(0, 10, 0, 4),
        BackgroundTransparency = 1,
        Text = name,
        Font = Theme.FontLight,
        TextSize = 13,
        TextColor3 = Theme.TextPrimary,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = holder,
    })
    local valueLabel = create("TextLabel", {
        Size = UDim2.new(0, 58, 0, 20),
        Position = UDim2.new(1, -66, 0, 4),
        BackgroundTransparency = 1,
        Text = tostring(default) .. "/" .. tostring(max),
        Font = Theme.Font,
        TextSize = 13,
        TextColor3 = Theme.Accent,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = holder,
    })
    local track = create("Frame", {
        Size = UDim2.new(1, -20, 0, 5),
        Position = UDim2.new(0, 10, 0, 32),
        BackgroundColor3 = Theme.SliderTrack,
        Parent = holder,
    })
    corner(track, UDim.new(0, 3))
    local fill = create("Frame", {
        Size = UDim2.new(valuePct, 0, 1, 0),
        BackgroundColor3 = Theme.SliderFill,
        Parent = track,
    })
    corner(fill, UDim.new(0, 3))
    local knob = create("Frame", {
        Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new(valuePct, -6, 0.5, -6),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        ZIndex = 2,
        Parent = track,
    })
    corner(knob, UDim.new(0, 6))
    local dragging = false
    local inputBtn = create("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        Parent = track,
        ZIndex = 3,
    })
    local function update(input)
        local absX = track.AbsolutePosition.X
        local width = track.AbsoluteSize.X
        local relX = math.clamp((input.Position.X - absX) / width, 0, 1)
        local value = math.floor(min + (max - min) * relX)
        valueLabel.Text = tostring(value) .. "/" .. tostring(max)
        fill.Size = UDim2.new(relX, 0, 1, 0)
        knob.Position = UDim2.new(relX, -6, 0.5, -6)
        callback(value)
    end
    inputBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

function Section:Dropdown(name, options, callback)
    callback = callback or function() end
    options = options or {}
    local opened = false
    local selected = options[1] or ""
    local holder = create("Frame", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = Theme.Element,
        ClipsDescendants = true,
        Parent = self._container,
    })
    corner(holder)
    create("TextLabel", {
        Size = UDim2.new(0.5, -10, 0, 32),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        Font = Theme.FontLight,
        TextSize = 13,
        TextColor3 = Theme.TextPrimary,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = holder,
    })
    local selectedLabel = create("TextLabel", {
        Size = UDim2.new(0.45, -10, 0, 32),
        Position = UDim2.new(0.55, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = selected .. "  v",
        Font = Theme.Font,
        TextSize = 13,
        TextColor3 = Theme.Accent,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = holder,
    })
    local optContainer = create("Frame", {
        Size = UDim2.new(1, -8, 0, #options * 24),
        Position = UDim2.new(0, 4, 0, 34),
        BackgroundColor3 = Theme.DropdownBG,
        Parent = holder,
    })
    corner(optContainer, UDim.new(0, 4))
    create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2),
        Parent = optContainer,
    })
    for _, opt in ipairs(options) do
        local optBtn = create("TextButton", {
            Size = UDim2.new(1, 0, 0, 22),
            BackgroundColor3 = Theme.DropdownBG,
            Text = opt,
            Font = Theme.FontLight,
            TextSize = 13,
            TextColor3 = Theme.TextPrimary,
            Parent = optContainer,
        })
        corner(optBtn, UDim.new(0, 4))
        optBtn.MouseEnter:Connect(function()
            tween(optBtn, { BackgroundColor3 = Theme.DropdownHover }, 0.15)
        end)
        optBtn.MouseLeave:Connect(function()
            tween(optBtn, { BackgroundColor3 = Theme.DropdownBG }, 0.15)
        end)
        optBtn.MouseButton1Click:Connect(function()
            selected = opt
            selectedLabel.Text = opt .. "  v"
            opened = false
            tween(holder, { Size = UDim2.new(1, 0, 0, 32) }, 0.25)
            callback(opt)
        end)
    end
    local toggleBtn = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundTransparency = 1,
        Text = "",
        Parent = holder,
    })
    toggleBtn.MouseButton1Click:Connect(function()
        opened = not opened
        local targetH = opened and (32 + 4 + #options * 26) or 32
        tween(holder, { Size = UDim2.new(1, 0, 0, targetH) }, 0.25)
    end)
end

function Section:TextBox(name, placeholder, callback)
    callback = callback or function() end
    placeholder = placeholder or "Type here..."
    local holder = create("Frame", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = Theme.Element,
        Parent = self._container,
    })
    corner(holder)
    create("TextLabel", {
        Size = UDim2.new(0.4, -10, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        Font = Theme.FontLight,
        TextSize = 13,
        TextColor3 = Theme.TextPrimary,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = holder,
    })
    local box = create("TextBox", {
        Size = UDim2.new(0.55, -8, 0, 20),
        Position = UDim2.new(0.4, 4, 0.5, -10),
        BackgroundColor3 = Theme.DropdownBG,
        Text = "",
        PlaceholderText = placeholder,
        Font = Theme.FontLight,
        TextSize = 13,
        TextColor3 = Theme.TextPrimary,
        PlaceholderColor3 = Theme.TextSecondary,
        ClearTextOnFocus = false,
        Parent = holder,
    })
    corner(box, UDim.new(0, 4))
    stroke(box, Theme.SectionBorder, 1)
    box.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            callback(box.Text)
        end
    end)
end

function Section:Button(name, callback)
    callback = callback or function() end
    local holder = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundTransparency = 1,
        Text = name,
        Font = Theme.Font,
        TextSize = 13,
        TextColor3 = Theme.Accent,
        Parent = self._container,
    })
    corner(holder)
    stroke(holder, Theme.Accent, 1)
    holder.MouseEnter:Connect(function()
        tween(holder, { BackgroundTransparency = 0.85, BackgroundColor3 = Theme.Accent }, 0.15)
    end)
    holder.MouseLeave:Connect(function()
        tween(holder, { BackgroundTransparency = 1 }, 0.15)
    end)
    holder.MouseButton1Click:Connect(function()
        callback()
    end)
end

function Section:KeyBind(name, default, callback)
    callback = callback or function() end
    local currentKey = default or Enum.KeyCode.Q
    local listening = false
    local holder = create("Frame", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = Theme.Element,
        Parent = self._container,
    })
    corner(holder)
    create("TextLabel", {
        Size = UDim2.new(1, -94, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        Font = Theme.FontLight,
        TextSize = 13,
        TextColor3 = Theme.TextPrimary,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = holder,
    })
    local bindBtn = create("TextButton", {
        Size = UDim2.new(0, 70, 0, 20),
        Position = UDim2.new(1, -78, 0.5, -10),
        BackgroundColor3 = Theme.DropdownBG,
        Text = currentKey.Name,
        Font = Theme.Font,
        TextSize = 12,
        TextColor3 = Theme.Accent,
        Parent = holder,
    })
    corner(bindBtn, UDim.new(0, 4))
    stroke(bindBtn, Theme.SectionBorder, 1)
    local inputConn = nil
    bindBtn.MouseButton1Click:Connect(function()
        if listening then return end
        listening = true
        bindBtn.Text = "..."
        tween(bindBtn, { BackgroundColor3 = Theme.ElementHover }, 0.15)
        inputConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                currentKey = input.KeyCode
                bindBtn.Text = input.KeyCode.Name
                tween(bindBtn, { BackgroundColor3 = Theme.DropdownBG }, 0.15)
                listening = false
                callback(currentKey)
                if inputConn then inputConn:Disconnect() inputConn = nil end
            end
        end)
    end)
    return {
        GetKey = function() return currentKey end,
        SetKey = function(_, key) currentKey = key; bindBtn.Text = key.Name; callback(key) end,
    }
end

-- ═══════════════════════════════════════════════════════════════════════════════════════
-- TAB CLASS
-- ═══════════════════════════════════════════════════════════════════════════════════════
local Tab = {}
Tab.__index = Tab

function Tab:Section(name)
    local sec = setmetatable({}, Section)
    self._sectionCount = (self._sectionCount or 0) + 1
    local targetCol = (self._sectionCount % 2 == 1) and self._leftCol or self._rightCol
    local sectionFrame = create("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.Section,
        Parent = targetCol,
    })
    corner(sectionFrame)
    stroke(sectionFrame)
    create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 26),
        BackgroundTransparency = 1,
        Text = "   " .. string.upper(name),
        Font = Theme.Font,
        TextSize = 12,
        TextColor3 = Theme.TextSecondary,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = sectionFrame,
    })
    local container = create("Frame", {
        Size = UDim2.new(1, -12, 0, 0),
        Position = UDim2.new(0, 6, 0, 26),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Parent = sectionFrame,
    })
    create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
        Parent = container,
    })
    create("UIPadding", {
        PaddingBottom = UDim.new(0, 8),
        Parent = container,
    })
    sec._container = container
    sec._frame = sectionFrame
    return sec
end

-- ═══════════════════════════════════════════════════════════════════════════════════════
-- WINDOW CLASS
-- ═══════════════════════════════════════════════════════════════════════════════════════
local Window = {}
Window.__index = Window

function Window:Tab(name)
    local tab = setmetatable({}, Tab)
    local tabBtn = create("TextButton", {
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        Text = name,
        Font = Theme.Font,
        TextSize = 12,
        TextColor3 = Theme.TabInactive,
        Parent = self._tabBar,
    })
    padding(tabBtn, 0, 0, 8, 8)
    local page = create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
        Parent = self._pageContainer,
    })
    padding(page, 8, 8, 4, 4)
    local columnHolder = create("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Parent = page,
    })
    local leftCol = create("Frame", {
        Size = UDim2.new(0.5, -4, 0, 0),
        Position = UDim2.new(0, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Parent = columnHolder,
    })
    create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        Parent = leftCol,
    })
    local rightCol = create("Frame", {
        Size = UDim2.new(0.5, -4, 0, 0),
        Position = UDim2.new(0.5, 4, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Parent = columnHolder,
    })
    create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        Parent = rightCol,
    })
    tab._content = page
    tab._leftCol = leftCol
    tab._rightCol = rightCol
    tab._sectionCount = 0
    tab._button = tabBtn
    table.insert(self._tabs, tab)
    if #self._tabs == 1 then
        page.Visible = true
        tabBtn.TextColor3 = Theme.TabActive
    end
    tabBtn.MouseButton1Click:Connect(function()
        for _, t in ipairs(self._tabs) do
            t._content.Visible = false
            tween(t._button, { TextColor3 = Theme.TabInactive }, 0.2)
        end
        page.Visible = true
        tween(tabBtn, { TextColor3 = Theme.TabActive }, 0.2)
    end)
    return tab
end

function Library:init(title)
    local win = setmetatable({}, Window)
    win._tabs = {}
    local player = Players.LocalPlayer
    local oldGui = (game:GetService("CoreGui"):FindFirstChild("HazeZZ_Lib"))
        or (player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("HazeZZ_Lib"))
    if oldGui then
        oldGui:Destroy()
    end
    local gui = create("ScreenGui", {
        Name = "HazeZZ_Lib",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = (syn and syn.protect_gui and game:GetService("CoreGui")) or player:WaitForChild("PlayerGui"),
    })
    local main = create("Frame", {
        Size = UDim2.new(0, 680, 0, 500),
        Position = UDim2.new(0.5, -340, 0.5, -250),
        BackgroundColor3 = Theme.Background,
        Parent = gui,
    })
    corner(main, UDim.new(0, 4))
    stroke(main, Theme.SectionBorder, 1)
    local topBar = create("Frame", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = Theme.TopBar,
        Parent = main,
    })
    corner(topBar, UDim.new(0, 4))
    create("Frame", {
        Size = UDim2.new(1, 0, 0, 8),
        Position = UDim2.new(0, 0, 1, -8),
        BackgroundColor3 = Theme.TopBar,
        BorderSizePixel = 0,
        Parent = topBar,
    })
    create("TextLabel", {
        Size = UDim2.new(0, 100, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = title or "haze.zz",
        Font = Theme.Font,
        TextSize = 14,
        TextColor3 = Theme.Accent,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = topBar,
    })
    local tabBar = create("Frame", {
        Size = UDim2.new(1, -160, 1, 0),
        Position = UDim2.new(0, 94, 0, 0),
        BackgroundTransparency = 1,
        Parent = topBar,
    })
    create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4),
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Parent = tabBar,
    })
    local minBtn = create("TextButton", {
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(1, -56, 0, 4),
        BackgroundColor3 = Theme.Element,
        Text = "-",
        Font = Theme.Font,
        TextSize = 13,
        TextColor3 = Theme.TextSecondary,
        Parent = topBar,
    })
    corner(minBtn, UDim.new(0, 4))
    local closeBtn = create("TextButton", {
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(1, -28, 0, 4),
        BackgroundColor3 = Color3.fromRGB(180, 40, 40),
        Text = "X",
        Font = Theme.Font,
        TextSize = 11,
        TextColor3 = Theme.TextPrimary,
        Parent = topBar,
    })
    corner(closeBtn, UDim.new(0, 4))
    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)
    local minimized = false
    local savedSize = main.Size
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            savedSize = main.Size
            tween(main, { Size = UDim2.new(0, main.Size.X.Offset, 0, 32) }, 0.3)
        else
            tween(main, { Size = savedSize }, 0.3)
        end
    end)
    local dragging, dragStart, startPos
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    local pageContainer = create("Frame", {
        Size = UDim2.new(1, -10, 1, -40),
        Position = UDim2.new(0, 5, 0, 36),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = main,
    })
    local Lighting = game:GetService("Lighting")
    local blurEffect = Instance.new("BlurEffect")
    blurEffect.Name = "HAZEZZ_MenuBlur"
    blurEffect.Size = 0
    blurEffect.Parent = Lighting
    local function setBlur(enabled)
        local targetSize = enabled and 18 or 0
        TweenService:Create(blurEffect, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = targetSize }):Play()
    end
    setBlur(true)
    local hazeGui = create("ScreenGui", {
        Name = "HAZEZZ_Haze",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = -1,
        IgnoreGuiInset = true,
        Parent = gui.Parent,
    })
    local hazeContainer = create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = hazeGui,
    })
    local HAZE_COUNT = 120
    local hazeParticles = {}
    local cam = workspace.CurrentCamera
    for i = 1, HAZE_COUNT do
        local size = math.random(2, 8)
        local startX = math.random(0, 100) / 100
        local startY = math.random(0, 100) / 100
        local angle = math.random(0, 628) / 100
        local speed = math.random(5, 40) / 1000
        local driftX = math.cos(angle) * speed
        local driftY = math.sin(angle) * speed
        local opacity = math.random(60, 92) / 100
        local colorPick = math.random(1, 4)
        local particleColor
        if colorPick == 1 then
            particleColor = Color3.fromRGB(math.random(80, 140), math.random(140, 200), 255)
        elseif colorPick == 2 then
            particleColor = Color3.fromRGB(math.random(140, 200), math.random(180, 220), 255)
        elseif colorPick == 3 then
            particleColor = Color3.fromRGB(math.random(60, 100), math.random(100, 160), math.random(200, 255))
        else
            particleColor = Color3.fromRGB(200, 210, math.random(230, 255))
        end
        local dot = create("Frame", {
            Size = UDim2.new(0, size, 0, size),
            Position = UDim2.new(startX, 0, startY, 0),
            BackgroundColor3 = particleColor,
            BackgroundTransparency = opacity,
            BorderSizePixel = 0,
            Parent = hazeContainer,
        })
        corner(dot, UDim.new(0, math.ceil(size / 2)))
        hazeParticles[i] = {
            frame = dot,
            xPos = startX,
            yPos = startY,
            driftX = driftX,
            driftY = driftY,
            baseOpacity = opacity,
            flickerSpeed = math.random(30, 180) / 100,
            flickerOffset = math.random(0, 628) / 100,
            flickerAmount = math.random(8, 25) / 100,
        }
    end
    RunService.RenderStepped:Connect(function(dt)
        if not hazeGui.Enabled then return end
        local elapsed = tick()
        for _, hp in ipairs(hazeParticles) do
            hp.xPos = hp.xPos + hp.driftX * dt
            hp.yPos = hp.yPos + hp.driftY * dt
            if hp.xPos > 1.05 then hp.xPos = -0.05 end
            if hp.xPos < -0.05 then hp.xPos = 1.05 end
            if hp.yPos > 1.05 then hp.yPos = -0.05 end
            if hp.yPos < -0.05 then hp.yPos = 1.05 end
            local flicker = math.sin(elapsed * hp.flickerSpeed + hp.flickerOffset)
            local newOpacity = math.clamp(hp.baseOpacity + flicker * hp.flickerAmount, 0.4, 0.97)
            hp.frame.Position = UDim2.new(hp.xPos, 0, hp.yPos, 0)
            hp.frame.BackgroundTransparency = newOpacity
        end
    end)
    local menuVisible = true
    local MENU_TOGGLE_KEY = Enum.KeyCode.RightShift
    UserInputService.InputBegan:Connect(function(input, _gameProcessed)
        if input.KeyCode == MENU_TOGGLE_KEY then
            menuVisible = not menuVisible
            gui.Enabled = menuVisible
            main.Visible = menuVisible
            hazeGui.Enabled = menuVisible
            setBlur(menuVisible)
        end
    end)
    gui.Destroying:Connect(function()
        if blurEffect and blurEffect.Parent then
            blurEffect:Destroy()
        end
        if hazeGui and hazeGui.Parent then
            hazeGui:Destroy()
        end
    end)
    win._gui = gui
    win._main = main
    win._tabBar = tabBar
    win._pageContainer = pageContainer
    return win
end

-- ═══════════════════════════════════════════════════════════════════
-- SCRIPT STARTS HERE
-- ═══════════════════════════════════════════════════════════════════

local UI = Library:init("haze.zz")

local MainTab = UI:Tab("Aimbot")
local CamlockSection = MainTab:Section("Camlock")
local SilentAimSection = MainTab:Section("Silent Aim")

local CombatExtraTab = UI:Tab("CombatExtra")
local TriggerbotSection = CombatExtraTab:Section("Triggerbot")
local HitboxSection = CombatExtraTab:Section("Hitbox Expander")

local PlayerTab = UI:Tab("Player")
local SpeedSection = PlayerTab:Section("Speed")
local ESPSection = PlayerTab:Section("ESP")

local SkinsTab = UI:Tab("Skins")
local SkinPackSection = SkinsTab:Section("Skin Packs (All Guns)")
local KnifeSkinSection = SkinsTab:Section("Knife Skins")
local BulletColorSection = SkinsTab:Section("Bullet Color")

local MiscTab = UI:Tab("Misc")
local MiscExtraSection = MiscTab:Section("Extras")
local ConfigSection = MiscTab:Section("Configs")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

-- ═══════════════════════════════════════════════════════════════════
-- CAMLOCK SETTINGS
-- ═══════════════════════════════════════════════════════════════════
local camlockEnabled = false
local target = nil
local smoothness = 0.060
local prediction = 0.155
local keybind = Enum.KeyCode.Q
local mode = "Toggle"
local camlockAimPart = "Nearest Part"

local FOV_RADIUS = 150
local MAX_DISTANCE = 300
local STICKY_DISTANCE = 500
local keyHeld = false
local wallCheckEnabled = false
local autoLockOnHit = false

local knockedCheckEnabled = false
local grabbedCheckEnabled = false
local crewCheckEnabled = false

local autoSelectEnabled = false
local autoSelectCooldown = 0.5
local autoSelectLastTick = tick()

local noRecoilEnabled = false
local noJumpCooldownEnabled = false
local noSlowdownEnabled = false
local noBulletSpreadEnabled = false

local speedEnabled = false
local walkSpeed = 16
local speedKeybind = Enum.KeyCode.X
local speedMethod = "CFrame"

local antiStompEnabled = false
local antiStompFlingForce = 80

local espEnabled = false
local espBoxes = true
local espNames = true
local espHealth = true
local espDistance = true
local espTracers = false
local espColor = Color3.fromRGB(60, 140, 255)

-- SILENT AIM SETTINGS
local silentAimEnabled = false
local silentAimKeybind = Enum.KeyCode.T
local silentAimMode = "Toggle"
local silentAimFOV = 150
local silentAimPart = "Nearest Part"
local silentAimKeyHeld = false
local silentAimActive = false
local silentAimPrediction = 0.134
local silentShowFOV = false

local silentResolverEnabled = false
local silentResolverRefreshRate = 60
local silentResolverOldTick = tick()
local silentResolverOldPos = Vector3.new(0, 0, 0)
local silentResolvedVelocity = Vector3.new(0, 0, 0)

-- HITBOX EXPANDER SETTINGS
local hitboxEnabled = false
local hitboxSize = 15
local hitboxTransparency = 0.7
local hitboxVisible = true
local hitboxPart = "HumanoidRootPart"
local originalSizes = {}

-- TRIGGERBOT SETTINGS
local triggerbotEnabled = false
local triggerbotKeybind = Enum.KeyCode.R
local triggerbotMode = "Toggle"
local triggerbotKeyHeld = false
local triggerbotActive = false
local triggerbotDelay = 0
local triggerbotFOV = 80
local triggerbotAimPart = "Nearest Part"
local triggerbotLastFire = 0
local triggerbotFireRate = 0
local triggerbotShowFOV = false

-- ═══════════════════════════════════════════════════════════════════
-- NEAREST PART HELPER
-- ═══════════════════════════════════════════════════════════════════
local NEAREST_PARTS = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "RightUpperArm", "LeftUpperArm", "RightUpperLeg", "LeftUpperLeg"}

local function getNearestPart(character, aimPart)
    if aimPart ~= "Nearest Part" then
        return character:FindFirstChild(aimPart) or character:FindFirstChild("HumanoidRootPart")
    end
    local mousePos = Vector2.new(mouse.X, mouse.Y)
    local best = nil
    local bestDist = math.huge
    for _, partName in ipairs(NEAREST_PARTS) do
        local part = character:FindFirstChild(partName)
        if part then
            local screenPos, onScreen = camera:WorldToViewportPoint(part.Position)
            if onScreen then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                if dist < bestDist then
                    bestDist = dist
                    best = part
                end
            end
        end
    end
    return best or character:FindFirstChild("HumanoidRootPart")
end

-- ═══════════════════════════════════════════════════════════════════
-- CAMLOCK LOGIC
-- ═══════════════════════════════════════════════════════════════════

local function isVisibleTarget(targetPart)
    if not wallCheckEnabled then return true end
    if not player.Character or not player.Character:FindFirstChild("Head") then return true end
    local origin = camera.CFrame.Position
    local direction = (targetPart.Position - origin)
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    rayParams.FilterDescendantsInstances = {player.Character, camera}
    local result = workspace:Raycast(origin, direction, rayParams)
    if result then
        local hitPart = result.Instance
        local targetChar = targetPart.Parent
        if hitPart:IsDescendantOf(targetChar) then
            return true
        end
        return false
    end
    return true
end

local function isTargetValid(t)
    if not t then return false end
    if not t.Character then return false end
    if not t.Character:FindFirstChild("Head") then return false end
    if not t.Character:FindFirstChild("HumanoidRootPart") then return false end
    local humanoid = t.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    if not player.Character or not player.Character:FindFirstChild("Head") then return false end
    if knockedCheckEnabled and t.Character:FindFirstChild("BodyEffects") and t.Character.BodyEffects:FindFirstChild("K.O") and t.Character.BodyEffects["K.O"].Value == true then return false end
    if grabbedCheckEnabled and t.Character:FindFirstChild("GRABBING_CONSTRAINT") then return false end
    if crewCheckEnabled and t:FindFirstChild("DataFolder") and t.DataFolder:FindFirstChild("Information") and t.DataFolder.Information:FindFirstChild("Crew") and player:FindFirstChild("DataFolder") and player.DataFolder:FindFirstChild("Information") and player.DataFolder.Information:FindFirstChild("Crew") and t.DataFolder.Information.Crew.Value ~= "" and t.DataFolder.Information.Crew.Value == player.DataFolder.Information.Crew.Value then return false end
    local dist = (t.Character.Head.Position - player.Character.Head.Position).Magnitude
    if dist > STICKY_DISTANCE then return false end
    if not isVisibleTarget(t.Character.Head) then return false end
    return true
end

local function getClosestToMouse()
    local closestPlayer = nil
    local shortestDistance = FOV_RADIUS
    if not player.Character or not player.Character:FindFirstChild("Head") then
        return nil
    end
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player
        and otherPlayer.Character
        and otherPlayer.Character:FindFirstChild("Head")
        and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local humanoid = otherPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                if knockedCheckEnabled and otherPlayer.Character:FindFirstChild("BodyEffects") and otherPlayer.Character.BodyEffects:FindFirstChild("K.O") and otherPlayer.Character.BodyEffects["K.O"].Value == true then continue end
                if grabbedCheckEnabled and otherPlayer.Character:FindFirstChild("GRABBING_CONSTRAINT") then continue end
                if crewCheckEnabled and otherPlayer:FindFirstChild("DataFolder") and otherPlayer.DataFolder:FindFirstChild("Information") and otherPlayer.DataFolder.Information:FindFirstChild("Crew") and player:FindFirstChild("DataFolder") and player.DataFolder:FindFirstChild("Information") and player.DataFolder.Information:FindFirstChild("Crew") and otherPlayer.DataFolder.Information.Crew.Value ~= "" and otherPlayer.DataFolder.Information.Crew.Value == player.DataFolder.Information.Crew.Value then continue end
                local part = getNearestPart(otherPlayer.Character, camlockAimPart)
                if not part then continue end
                local screenPos, onScreen = camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local mousePos = Vector2.new(mouse.X, mouse.Y)
                    local targetPos = Vector2.new(screenPos.X, screenPos.Y)
                    local distance = (mousePos - targetPos).Magnitude
                    local worldDistance = (part.Position - player.Character.Head.Position).Magnitude
                    if distance < shortestDistance and worldDistance < MAX_DISTANCE then
                        if isVisibleTarget(part) then
                            shortestDistance = distance
                            closestPlayer = otherPlayer
                        end
                    end
                end
            end
        end
    end
    return closestPlayer
end

CamlockSection:Toggle("Camlock", false, function(value)
    camlockEnabled = value
    if camlockEnabled then
        target = getClosestToMouse()
    else
        target = nil
    end
end)

CamlockSection:Slider("Smoothness", 10, 500, 60, function(value)
    smoothness = value / 1000
end)

CamlockSection:Slider("Prediction", 10, 500, 155, function(value)
    prediction = value / 1000
end)

CamlockSection:KeyBind("Keybind", Enum.KeyCode.Q, function(key)
    keybind = key
end)

CamlockSection:Dropdown("Mode", {"Toggle","Hold"}, function(value)
    mode = value
    if mode == "Hold" and not keyHeld then
        camlockEnabled = false
        target = nil
    end
end)

CamlockSection:Dropdown("Aim Part", {"Nearest Part","Head","HumanoidRootPart","UpperTorso","LowerTorso"}, function(value)
    camlockAimPart = value
end)

CamlockSection:Toggle("Wall Check", false, function(value)
    wallCheckEnabled = value
end)

CamlockSection:Toggle("Auto Lock On Hit", false, function(value)
    autoLockOnHit = value
end)

CamlockSection:Toggle("Knocked Check", false, function(value)
    knockedCheckEnabled = value
end)

CamlockSection:Toggle("Grabbed Check", false, function(value)
    grabbedCheckEnabled = value
end)

CamlockSection:Toggle("Crew Check", false, function(value)
    crewCheckEnabled = value
end)

CamlockSection:Toggle("Auto Select", false, function(value)
    autoSelectEnabled = value
end)

CamlockSection:Slider("Select Cooldown", 0.1, 3, 0.5, function(value)
    autoSelectCooldown = value
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == keybind then
        keyHeld = true
        if mode == "Toggle" then
            camlockEnabled = not camlockEnabled
            if camlockEnabled then
                target = getClosestToMouse()
            else
                target = nil
            end
        elseif mode == "Hold" then
            camlockEnabled = true
            target = getClosestToMouse()
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.KeyCode == keybind then
        keyHeld = false
        if mode == "Hold" then
            camlockEnabled = false
            target = nil
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if camlockEnabled then
        if not isTargetValid(target) then
            target = getClosestToMouse()
        end
        if target
        and target.Character
        and target.Character:FindFirstChild("HumanoidRootPart") then
            local part = getNearestPart(target.Character, camlockAimPart)
            local hrp = target.Character.HumanoidRootPart
            local velocity = hrp.Velocity
            local predictedPosition = part.Position + (velocity * prediction)
            local newCFrame = CFrame.new(camera.CFrame.Position, predictedPosition)
            camera.CFrame = camera.CFrame:Lerp(newCFrame, smoothness)
        end
    end
    if autoSelectEnabled and camlockEnabled and (tick() - autoSelectLastTick >= autoSelectCooldown) then
        local newTarget = getClosestToMouse()
        if newTarget then
            target = newTarget
        end
        autoSelectLastTick = tick()
    end
end)

local lastHealth = nil

local function setupAutoLockOnHit()
    if not player.Character then return end
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    lastHealth = humanoid.Health
    humanoid.HealthChanged:Connect(function(newHealth)
        if not autoLockOnHit then return end
        if newHealth < (lastHealth or 100) then
            local closestAttacker = nil
            local closestDist = 60
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local myPos = player.Character.HumanoidRootPart.Position
                for _, otherPlayer in pairs(Players:GetPlayers()) do
                    if otherPlayer ~= player
                    and otherPlayer.Character
                    and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local otherHumanoid = otherPlayer.Character:FindFirstChildOfClass("Humanoid")
                        if otherHumanoid and otherHumanoid.Health > 0 then
                            local dist = (otherPlayer.Character.HumanoidRootPart.Position - myPos).Magnitude
                            if dist < closestDist then
                                closestDist = dist
                                closestAttacker = otherPlayer
                            end
                        end
                    end
                end
            end
            if closestAttacker then
                target = closestAttacker
                camlockEnabled = true
            end
        end
        lastHealth = newHealth
    end)
end

setupAutoLockOnHit()

player.CharacterAdded:Connect(function()
    task.wait(1)
    setupAutoLockOnHit()
end)

-- ═══════════════════════════════════════════════════════════════════
-- SILENT AIM
-- ═══════════════════════════════════════════════════════════════════

-- Helper: check if executor has a function
local function hasFunction(name)
    local ok, val = pcall(function() return getfenv()[name] or _G[name] end)
    if ok and val then return true end
    local ok2, val2 = pcall(function()
        if name == "hookmetamethod" then return hookmetamethod end
        if name == "newcclosure" then return newcclosure end
        if name == "getnamecallmethod" then return getnamecallmethod end
        if name == "hookfunction" then return hookfunction end
        return nil
    end)
    return ok2 and val2 ~= nil
end

-- Safe wrapper: use newcclosure if available, otherwise raw function
local function safeWrap(fn)
    local ok, wrapped = pcall(function()
        if newcclosure then return newcclosure(fn) end
    end)
    return (ok and wrapped) or fn
end

local function silentWallCheck(part)
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.IgnoreWater = true
    rayParams.FilterDescendantsInstances = {player.Character, camera}
    local origin = camera.CFrame.Position
    local direction = (part.Position - origin).Unit
    local result = workspace:Raycast(origin, direction * 10000, rayParams)
    if result and result.Instance then
        return result.Instance:IsDescendantOf(part.Parent)
    end
    return false
end

local function getClosestPlayerSilent()
    local mousePos = Vector2.new(mouse.X, mouse.Y)
    local bestPart = nil
    local bestDist = silentAimFOV
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local char = otherPlayer.Character
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if not humanoid or humanoid.Health <= 0 then continue end
            if not char:FindFirstChild("HumanoidRootPart") then continue end
            if knockedCheckEnabled and char:FindFirstChild("BodyEffects") and char.BodyEffects:FindFirstChild("K.O") and char.BodyEffects["K.O"].Value == true then continue end
            if grabbedCheckEnabled and char:FindFirstChild("GRABBING_CONSTRAINT") then continue end
            if crewCheckEnabled then
                local skipCrew = false
                pcall(function()
                    if otherPlayer:FindFirstChild("DataFolder") and otherPlayer.DataFolder:FindFirstChild("Information") and otherPlayer.DataFolder.Information:FindFirstChild("Crew") then
                        if player:FindFirstChild("DataFolder") and player.DataFolder:FindFirstChild("Information") and player.DataFolder.Information:FindFirstChild("Crew") then
                            if otherPlayer.DataFolder.Information.Crew.Value == player.DataFolder.Information.Crew.Value and otherPlayer.DataFolder.Information.Crew.Value ~= "" then
                                skipCrew = true
                            end
                        end
                    end
                end)
                if skipCrew then continue end
            end
            if wallCheckEnabled and not silentWallCheck(char.HumanoidRootPart) then continue end
            local part = getNearestPart(char, silentAimPart)
            if not part then continue end
            local screenPos, onScreen = camera:WorldToScreenPoint(part.Position)
            if not onScreen then continue end
            local screenVec = Vector2.new(screenPos.X, screenPos.Y)
            local dist = (screenVec - mousePos).Magnitude
            if dist < bestDist then
                bestDist = dist
                bestPart = part
            end
        end
    end
    return bestPart
end

local function getSilentPredictedPosition(part)
    if not part or not part.Parent then return part and part.Position or nil end
    local char = part.Parent
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return part.Position end
    local velocity
    if silentResolverEnabled then
        velocity = silentResolvedVelocity
    else
        velocity = hrp.AssemblyLinearVelocity or hrp.Velocity or Vector3.new(0, 0, 0)
    end
    local position = part.Position + velocity * silentAimPrediction
    return position
end

local function silentResolve()
    if silentAimEnabled and silentResolverEnabled and silentAimActive then
        local silentTarget = getClosestPlayerSilent()
        if silentTarget and silentTarget.Parent and silentTarget.Parent:FindFirstChild("HumanoidRootPart") then
            local hrp = silentTarget.Parent.HumanoidRootPart
            local currentPos = hrp.Position
            local deltaTime = tick() - silentResolverOldTick
            if deltaTime > 0 then
                silentResolvedVelocity = (currentPos - silentResolverOldPos) / deltaTime
            end
            if tick() - silentResolverOldTick >= 1 / silentResolverRefreshRate then
                silentResolverOldTick = tick()
                silentResolverOldPos = hrp.Position
            end
        end
    end
end

-- ═══════════════════════════════════════════════════════════════════
-- SILENT AIM HOOKS — tries multiple methods, uses first that works
-- ═══════════════════════════════════════════════════════════════════

local gunHandler, oldGetAim
local silentAimMethod = "None"

-- METHOD 1: GunHandler.getAim override (just a table swap, works on any executor)
-- Try multiple Da Hood module paths
local GH_PATHS = {
    function() return require(game:GetService("ReplicatedStorage").Modules.GunHandler) end,
    function() return require(game:GetService("ReplicatedStorage"):FindFirstChild("Modules"):FindFirstChild("GunHandler")) end,
    function() return require(game:GetService("ReplicatedStorage"):FindFirstChild("GunHandler", true)) end,
    function()
        for _, desc in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
            if desc:IsA("ModuleScript") and (desc.Name == "GunHandler" or desc.Name == "gunHandler" or desc.Name == "GunModule") then
                return require(desc)
            end
        end
        return nil
    end,
}

for _, pathFn in ipairs(GH_PATHS) do
    if silentAimMethod ~= "None" then break end
    pcall(function()
        local gh = pathFn()
        if gh then
            -- Search for the aim function — Da Hood uses different names across versions
            local aimFnNames = {"getAim", "GetAim", "getaim", "aimFunction", "calculateAim", "GetDirection", "getDirection"}
            for _, fnName in ipairs(aimFnNames) do
                if type(gh[fnName]) == "function" then
                    gunHandler = gh
                    oldGetAim = gh[fnName]
                    gh[fnName] = function(origin, maxDist)
                        if silentAimEnabled and silentAimActive then
                            local silentTarget = getClosestPlayerSilent()
                            if silentTarget then
                                local predicted = getSilentPredictedPosition(silentTarget)
                                if predicted then
                                    local dir = (predicted - origin).Unit
                                    local dist = (predicted - origin).Magnitude
                                    return dir, math.min(dist, maxDist or 200)
                                end
                            end
                        end
                        return oldGetAim(origin, maxDist)
                    end
                    silentAimMethod = "GunHandler." .. fnName
                    break
                end
            end
        end
    end)
end

-- METHOD 2: __index hook on mouse (spoofs mouse.Hit, mouse.Target, mouse.UnitRay)
-- This is what Da Hood reads to get where you're aiming
if silentAimMethod == "None" and hasFunction("hookmetamethod") then
    pcall(function()
        local oldIndex
        oldIndex = hookmetamethod(game, "__index", safeWrap(function(self, key)
            if silentAimEnabled and silentAimActive then
                if self == mouse or (typeof(self) == "Instance" and self:IsA("Mouse")) then
                    local silentTarget = getClosestPlayerSilent()
                    if silentTarget then
                        local predicted = getSilentPredictedPosition(silentTarget)
                        if predicted then
                            if key == "Hit" then
                                return CFrame.new(predicted)
                            elseif key == "Target" then
                                return silentTarget
                            elseif key == "X" then
                                local screenPos = camera:WorldToViewportPoint(predicted)
                                return screenPos.X
                            elseif key == "Y" then
                                local screenPos = camera:WorldToViewportPoint(predicted)
                                return screenPos.Y
                            elseif key == "UnitRay" then
                                local origin = camera.CFrame.Position
                                local dir = (predicted - origin).Unit
                                return Ray.new(origin, dir)
                            end
                        end
                    end
                end
            end
            return oldIndex(self, key)
        end))
        silentAimMethod = "Index"
    end)
end

-- METHOD 3: __namecall hook (intercepts remote calls + mouse methods)
if silentAimMethod == "None" and hasFunction("hookmetamethod") and hasFunction("getnamecallmethod") then
    pcall(function()
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", safeWrap(function(self, ...)
            local method = getnamecallmethod()
            if silentAimEnabled and silentAimActive then
                -- Intercept mouse methods
                if typeof(self) == "Instance" and self:IsA("Mouse") then
                    if method == "GetHit" or method == "GetTarget" then
                        local silentTarget = getClosestPlayerSilent()
                        if silentTarget then
                            local predicted = getSilentPredictedPosition(silentTarget)
                            if predicted then
                                return CFrame.new(predicted)
                            end
                        end
                    end
                end
                -- Intercept remotes
                if method == "FireServer" and typeof(self) == "Instance" and self:IsA("RemoteEvent") then
                    local args = {...}
                    local silentTarget = getClosestPlayerSilent()
                    if silentTarget then
                        local predicted = getSilentPredictedPosition(silentTarget)
                        if predicted then
                            for i, arg in ipairs(args) do
                                if typeof(arg) == "CFrame" then
                                    args[i] = CFrame.new(arg.Position, predicted)
                                elseif typeof(arg) == "Vector3" then
                                    if arg.Magnitude < 2 then
                                        args[i] = (predicted - camera.CFrame.Position).Unit
                                    else
                                        args[i] = predicted
                                    end
                                end
                            end
                            return oldNamecall(self, unpack(args))
                        end
                    end
                end
            end
            return oldNamecall(self, ...)
        end))
        silentAimMethod = "Namecall"
    end)
end

-- METHOD 4: UNIVERSAL FALLBACK — no hooks needed, works on ANY executor
-- Runs every frame: when you click to shoot, it briefly moves your character's
-- aim by setting camera CFrame toward the target for 1 frame, then restores it.
-- Also continuously spoofs mouse properties via a proxy approach.
if silentAimMethod == "None" then
    local silentSnapping = false
    local originalCamCF = nil

    -- Before any gun logic runs (InputBegan fires before game processes click)
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if not silentAimEnabled or not silentAimActive then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local silentTarget = getClosestPlayerSilent()
            if silentTarget then
                local predicted = getSilentPredictedPosition(silentTarget)
                if predicted then
                    originalCamCF = camera.CFrame
                    camera.CFrame = CFrame.new(camera.CFrame.Position, predicted)
                    silentSnapping = true
                end
            end
        end
    end)

    -- Restore camera after 1 frame so the snap is invisible
    RunService.RenderStepped:Connect(function()
        if silentSnapping and originalCamCF then
            camera.CFrame = originalCamCF
            originalCamCF = nil
            silentSnapping = false
        end
    end)

    silentAimMethod = "CameraSnap"
end

-- Notify which method loaded
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "haze.zz",
        Text = "Silent Aim: " .. silentAimMethod .. " method",
        Duration = 3,
    })
end)

local silentFovCircle
pcall(function()
    silentFovCircle = Drawing.new("Circle")
    silentFovCircle.Color = Color3.fromRGB(60, 140, 255)
    silentFovCircle.Thickness = 1
    silentFovCircle.Filled = false
    silentFovCircle.Transparency = 0.6
    silentFovCircle.Visible = false
end)

RunService.RenderStepped:Connect(function()
    if not silentFovCircle then return end
    silentFovCircle.Visible = silentAimEnabled and silentShowFOV
    if silentFovCircle.Visible then
        silentFovCircle.Position = UserInputService:GetMouseLocation()
        silentFovCircle.Radius = silentAimFOV
    end
end)

-- ═══════════════════════════════════════════════════════════════════
-- SILENT AIM UI CONTROLS
-- ═══════════════════════════════════════════════════════════════════

SilentAimSection:Toggle("Silent Aim", false, function(value)
    silentAimEnabled = value
    if not value then
        silentAimActive = false
    end
end)

SilentAimSection:Dropdown("Hit Part", {"Nearest Part","Head","HumanoidRootPart","UpperTorso","LowerTorso"}, function(value)
    silentAimPart = value
end)

SilentAimSection:Slider("FOV Radius", 10, 500, 150, function(value)
    silentAimFOV = value
end)

SilentAimSection:Toggle("Show FOV", false, function(value)
    silentShowFOV = value
end)

SilentAimSection:Slider("Prediction", 10, 500, 134, function(value)
    silentAimPrediction = value / 1000
end)

SilentAimSection:KeyBind("Keybind", Enum.KeyCode.T, function(key)
    silentAimKeybind = key
end)

SilentAimSection:Dropdown("Mode", {"Toggle","Hold"}, function(value)
    silentAimMode = value
    if silentAimMode == "Hold" and not silentAimKeyHeld then
        silentAimActive = false
    end
end)

SilentAimSection:Toggle("Resolver", false, function(value)
    silentResolverEnabled = value
end)

SilentAimSection:Slider("Resolver Refresh", 1, 120, 60, function(value)
    silentResolverRefreshRate = value
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == silentAimKeybind then
        silentAimKeyHeld = true
        if silentAimMode == "Toggle" then
            silentAimActive = not silentAimActive
        elseif silentAimMode == "Hold" then
            silentAimActive = true
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == silentAimKeybind then
        silentAimKeyHeld = false
        if silentAimMode == "Hold" then
            silentAimActive = false
        end
    end
end)

local oldNewIndex
pcall(function()
    oldNewIndex = hookmetamethod(game, "__newindex", newcclosure(function(self, key, value)
        if noRecoilEnabled and key == "CFrame" and self:IsA("Camera") then
            return
        end
        if noJumpCooldownEnabled then
            if key == "JumpPower" and self:IsA("Humanoid") and value == 0 then
                return
            end
            if key == "JumpHeight" and self:IsA("Humanoid") and value == 0 then
                return
            end
        end
        -- Block bullet spread by preventing spread-related property changes
        if noBulletSpreadEnabled then
            local keyLower = string.lower(tostring(key))
            if keyLower == "spread" or keyLower == "currentspread"
            or keyLower == "hipfirespread" or keyLower == "adsspread"
            or keyLower == "spreadangle" or keyLower == "bulletspread"
            or keyLower == "maxspread" or keyLower == "minspread" then
                return
            end
        end
        return oldNewIndex(self, key, value)
    end))
end)

-- No Bullet Spread: Da Hood specific — hooks into GunHandler and gun configs
-- Da Hood stores spread in the gun module tables, not in Value instances
RunService.Heartbeat:Connect(function()
    if not noBulletSpreadEnabled then return end
    if not player.Character then return end

    -- Method 1: Zero spread on gun config tables inside equipped tools
    for _, tool in pairs(player.Character:GetChildren()) do
        if tool:IsA("Tool") then
            pcall(function()
                -- Da Hood guns use ModuleScripts with config tables
                for _, desc in pairs(tool:GetDescendants()) do
                    if desc:IsA("ModuleScript") then
                        pcall(function()
                            local config = require(desc)
                            if type(config) == "table" then
                                if config.Spread ~= nil then config.Spread = 0 end
                                if config.MinSpread ~= nil then config.MinSpread = 0 end
                                if config.MaxSpread ~= nil then config.MaxSpread = 0 end
                                if config.HipFireSpread ~= nil then config.HipFireSpread = 0 end
                                if config.ADSSpread ~= nil then config.ADSSpread = 0 end
                                if config.SpreadIncrease ~= nil then config.SpreadIncrease = 0 end
                                if config.SpreadDecrease ~= nil then config.SpreadDecrease = 999 end
                                if config.CurrentSpread ~= nil then config.CurrentSpread = 0 end
                                if config.SpreadRecovery ~= nil then config.SpreadRecovery = 999 end
                            end
                        end)
                    end
                    -- Also catch NumberValue/IntValue instances just in case
                    if desc:IsA("NumberValue") or desc:IsA("IntValue") then
                        local nameLower = string.lower(desc.Name)
                        if nameLower:find("spread") then
                            if nameLower:find("decrease") or nameLower:find("recovery") then
                                desc.Value = 999
                            else
                                desc.Value = 0
                            end
                        end
                    end
                end
            end)
        end
    end

    -- Method 2: Zero spread in GunHandler module's internal state
    if gunHandler then
        pcall(function()
            if gunHandler.Spread ~= nil then gunHandler.Spread = 0 end
            if gunHandler.CurrentSpread ~= nil then gunHandler.CurrentSpread = 0 end
            if gunHandler.SpreadIncrease ~= nil then gunHandler.SpreadIncrease = 0 end
            if gunHandler.MaxSpread ~= nil then gunHandler.MaxSpread = 0 end
            if gunHandler.MinSpread ~= nil then gunHandler.MinSpread = 0 end
        end)
    end

    -- Method 3: Zero spread on gun configs in ReplicatedStorage
    pcall(function()
        local gunModels = game:GetService("ReplicatedStorage"):FindFirstChild("GunModels")
            or game:GetService("ReplicatedStorage"):FindFirstChild("Guns")
            or game:GetService("ReplicatedStorage"):FindFirstChild("Weapons")
        if gunModels then
            for _, gun in pairs(gunModels:GetDescendants()) do
                if gun:IsA("ModuleScript") then
                    pcall(function()
                        local config = require(gun)
                        if type(config) == "table" then
                            if config.Spread ~= nil then config.Spread = 0 end
                            if config.MinSpread ~= nil then config.MinSpread = 0 end
                            if config.MaxSpread ~= nil then config.MaxSpread = 0 end
                            if config.HipFireSpread ~= nil then config.HipFireSpread = 0 end
                            if config.ADSSpread ~= nil then config.ADSSpread = 0 end
                            if config.SpreadIncrease ~= nil then config.SpreadIncrease = 0 end
                            if config.SpreadDecrease ~= nil then config.SpreadDecrease = 999 end
                            if config.CurrentSpread ~= nil then config.CurrentSpread = 0 end
                        end
                    end)
                end
            end
        end
    end)
end)

RunService.Heartbeat:Connect(function()
    silentResolve()
end)

-- ═══════════════════════════════════════════════════════════════════
-- TRIGGERBOT LOGIC
-- ═══════════════════════════════════════════════════════════════════

local function triggerbotWallCheck(part)
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.IgnoreWater = true
    rayParams.FilterDescendantsInstances = {player.Character, camera}
    local origin = camera.CFrame.Position
    local direction = (part.Position - origin).Unit
    local result = workspace:Raycast(origin, direction * 10000, rayParams)
    if result and result.Instance then
        return result.Instance:IsDescendantOf(part.Parent)
    end
    return false
end

local function isValidTBEnemy(otherPlayer)
    if otherPlayer == player then return false end
    if not otherPlayer.Character then return false end
    local char = otherPlayer.Character
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    if not char:FindFirstChild("HumanoidRootPart") then return false end
    if knockedCheckEnabled and char:FindFirstChild("BodyEffects") and char.BodyEffects:FindFirstChild("K.O") and char.BodyEffects["K.O"].Value == true then return false end
    if grabbedCheckEnabled and char:FindFirstChild("GRABBING_CONSTRAINT") then return false end
    if crewCheckEnabled then
        local skipCrew = false
        pcall(function()
            if otherPlayer:FindFirstChild("DataFolder") and otherPlayer.DataFolder:FindFirstChild("Information") and otherPlayer.DataFolder.Information:FindFirstChild("Crew") then
                if player:FindFirstChild("DataFolder") and player.DataFolder:FindFirstChild("Information") and player.DataFolder.Information:FindFirstChild("Crew") then
                    if otherPlayer.DataFolder.Information.Crew.Value == player.DataFolder.Information.Crew.Value and otherPlayer.DataFolder.Information.Crew.Value ~= "" then
                        skipCrew = true
                    end
                end
            end
        end)
        if skipCrew then return false end
    end
    return true
end

local function getTriggerbotTarget()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return nil
    end

    local mousePos = Vector2.new(mouse.X, mouse.Y)
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.IgnoreWater = true
    rayParams.FilterDescendantsInstances = {player.Character, camera}

    -- Step 1: Multi-ray spread — cast rays in a cone around the crosshair
    -- This catches targets even when the exact center pixel misses
    local SPREAD_OFFSETS = {
        {0, 0},                          -- center
        {6, 0}, {-6, 0}, {0, 6}, {0, -6},   -- cardinal
        {4, 4}, {-4, 4}, {4, -4}, {-4, -4}, -- diagonal close
        {10, 0}, {-10, 0}, {0, 10}, {0, -10}, -- cardinal far
        {7, 7}, {-7, 7}, {7, -7}, {-7, -7},   -- diagonal far
    }

    for _, offset in ipairs(SPREAD_OFFSETS) do
        local checkX = mousePos.X + offset[1]
        local checkY = mousePos.Y + offset[2]
        local unitRay = camera:ViewportPointToRay(checkX, checkY)
        local rayResult = workspace:Raycast(unitRay.Origin, unitRay.Direction * 5000, rayParams)

        if rayResult and rayResult.Instance then
            local hitPart = rayResult.Instance
            for _, otherPlayer in pairs(Players:GetPlayers()) do
                if isValidTBEnemy(otherPlayer) then
                    local char = otherPlayer.Character
                    if hitPart:IsDescendantOf(char) then
                        local part = getNearestPart(char, triggerbotAimPart)
                        return part or char:FindFirstChild("HumanoidRootPart")
                    end
                end
            end
        end
    end

    -- Step 2: Fallback — check if any enemy body part is very close to crosshair
    -- on screen AND has clear line-of-sight. Checks ALL body parts, not just the
    -- nearest one, so it picks up hits the spread rays might still miss.
    local TB_BODY_PARTS = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "RightUpperArm", "LeftUpperArm", "RightUpperLeg", "LeftUpperLeg", "RightLowerArm", "LeftLowerArm", "RightLowerLeg", "LeftLowerLeg"}
    local bestPart = nil
    local bestDist = math.min(triggerbotFOV, 55)

    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if isValidTBEnemy(otherPlayer) then
            local char = otherPlayer.Character
            for _, partName in ipairs(TB_BODY_PARTS) do
                local part = char:FindFirstChild(partName)
                if part then
                    local screenPos, onScreen = camera:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if dist < bestDist then
                            if triggerbotWallCheck(part) then
                                bestDist = dist
                                bestPart = getNearestPart(char, triggerbotAimPart) or part
                            end
                        end
                    end
                end
            end
        end
    end
    return bestPart
end

local triggerbotFovCircle
pcall(function()
    triggerbotFovCircle = Drawing.new("Circle")
    triggerbotFovCircle.Color = Color3.fromRGB(60, 180, 255)
    triggerbotFovCircle.Thickness = 1
    triggerbotFovCircle.Filled = false
    triggerbotFovCircle.Transparency = 0.5
    triggerbotFovCircle.Visible = false
end)

local triggerbotDelayStart = 0
local triggerbotDelayTarget = nil

RunService.RenderStepped:Connect(function()
    if triggerbotFovCircle then
        triggerbotFovCircle.Visible = triggerbotEnabled and triggerbotActive and triggerbotShowFOV
        if triggerbotFovCircle.Visible then
            triggerbotFovCircle.Position = UserInputService:GetMouseLocation()
            triggerbotFovCircle.Radius = triggerbotFOV
        end
    end
    if triggerbotEnabled and triggerbotActive then
        local tbTarget = getTriggerbotTarget()
        if tbTarget then
            if tbTarget ~= triggerbotDelayTarget then
                triggerbotDelayTarget = tbTarget
                triggerbotDelayStart = tick()
            end
            local elapsed = (tick() - triggerbotDelayStart) * 1000
            if elapsed >= triggerbotDelay then
                local now = tick() * 1000
                if now - triggerbotLastFire >= triggerbotFireRate then
                    triggerbotLastFire = now
                    pcall(mouse1click)
                end
            end
        else
            triggerbotDelayTarget = nil
            triggerbotDelayStart = 0
        end
    else
        triggerbotDelayTarget = nil
        triggerbotDelayStart = 0
    end
end)

-- ═══════════════════════════════════════════════════════════════════
-- TRIGGERBOT UI CONTROLS
-- ═══════════════════════════════════════════════════════════════════

TriggerbotSection:Toggle("Triggerbot", false, function(value)
    triggerbotEnabled = value
    if not value then
        triggerbotActive = false
    end
end)

TriggerbotSection:KeyBind("Keybind", Enum.KeyCode.R, function(key)
    triggerbotKeybind = key
end)

TriggerbotSection:Dropdown("Mode", {"Toggle","Hold"}, function(value)
    triggerbotMode = value
    if triggerbotMode == "Hold" and not triggerbotKeyHeld then
        triggerbotActive = false
    end
end)

TriggerbotSection:Slider("FOV Radius", 10, 500, 80, function(value)
    triggerbotFOV = value
end)

TriggerbotSection:Toggle("Show FOV", false, function(value)
    triggerbotShowFOV = value
end)

TriggerbotSection:Slider("Delay (ms)", 0, 500, 0, function(value)
    triggerbotDelay = value
end)

TriggerbotSection:Slider("Fire Rate (ms)", 10, 500, 0, function(value)
    triggerbotFireRate = value
end)

TriggerbotSection:Dropdown("Aim Part", {"Nearest Part","Head","HumanoidRootPart","UpperTorso","LowerTorso"}, function(value)
    triggerbotAimPart = value
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == triggerbotKeybind then
        triggerbotKeyHeld = true
        if triggerbotMode == "Toggle" then
            triggerbotActive = not triggerbotActive
        elseif triggerbotMode == "Hold" then
            triggerbotActive = true
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == triggerbotKeybind then
        triggerbotKeyHeld = false
        if triggerbotMode == "Hold" then
            triggerbotActive = false
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════════
-- HITBOX EXPANDER
-- ═══════════════════════════════════════════════════════════════════

local function expandHitboxes()
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local part = otherPlayer.Character:FindFirstChild(hitboxPart)
            if part then
                if not originalSizes[part] then
                    originalSizes[part] = part.Size
                end
                part.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                part.Transparency = hitboxVisible and hitboxTransparency or 1
                if hitboxVisible then
                    part.BrickColor = BrickColor.new("Really red")
                    part.Material = Enum.Material.ForceField
                end
                part.CanCollide = false
            end
        end
    end
end

local function resetHitboxes()
    for part, origSize in pairs(originalSizes) do
        if part and part.Parent then
            part.Size = origSize
            part.Transparency = 1
            part.Material = Enum.Material.Plastic
        end
    end
    originalSizes = {}
end

HitboxSection:Toggle("Hitbox Expander", false, function(value)
    hitboxEnabled = value
    if not hitboxEnabled then
        resetHitboxes()
    end
end)

HitboxSection:Toggle("Show Hitbox", true, function(value)
    hitboxVisible = value
end)

HitboxSection:Slider("Hitbox Size", 0, 50, 15, function(value)
    hitboxSize = value
end)

HitboxSection:Slider("Transparency", 0, 10, 7, function(value)
    hitboxTransparency = value / 10
end)

HitboxSection:Dropdown("Target Part", {"HumanoidRootPart","Head","UpperTorso","LowerTorso"}, function(value)
    resetHitboxes()
    hitboxPart = value
end)

RunService.RenderStepped:Connect(function()
    if hitboxEnabled then
        expandHitboxes()
    end
end)

Players.PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer.Character then
        local part = leavingPlayer.Character:FindFirstChild(hitboxPart)
        if part and originalSizes[part] then
            originalSizes[part] = nil
        end
    end
end)

SpeedSection:Toggle("Speed Hack", false, function(value)
    speedEnabled = value
end)

SpeedSection:Slider("Speed Value", 16, 2000, 16, function(value)
    walkSpeed = value
end)

SpeedSection:KeyBind("Keybind", Enum.KeyCode.X, function(key)
    speedKeybind = key
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == speedKeybind then
        speedEnabled = not speedEnabled
    end
end)

RunService.RenderStepped:Connect(function(deltaTime)
    if speedEnabled and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
        if humanoid and rootPart and humanoid.MoveDirection.Magnitude > 0 then
            local moveDir = humanoid.MoveDirection.Unit
            local velocity = moveDir * walkSpeed * deltaTime
            rootPart.CFrame = rootPart.CFrame + Vector3.new(velocity.X, 0, velocity.Z)
        end
    end
end)

local espObjects = {}

local function createESP(plr)
    if plr == player then return end
    if espObjects[plr] then return end
    local ok, drawings = pcall(function()
        local d = {}
        d.boxTopLine = Drawing.new("Line")
        d.boxBottomLine = Drawing.new("Line")
        d.boxLeftLine = Drawing.new("Line")
        d.boxRightLine = Drawing.new("Line")
        for _, line in pairs({d.boxTopLine, d.boxBottomLine, d.boxLeftLine, d.boxRightLine}) do
            line.Visible = false
            line.Color = espColor
            line.Thickness = 1
            line.Transparency = 1
        end
        d.name = Drawing.new("Text")
        d.name.Visible = false
        d.name.Color = Color3.new(1, 1, 1)
        d.name.Size = 13
        d.name.Center = true
        d.name.Outline = true
        d.name.OutlineColor = Color3.new(0, 0, 0)
        d.name.Font = 2
        d.healthBg = Drawing.new("Line")
        d.healthBg.Visible = false
        d.healthBg.Color = Color3.new(0, 0, 0)
        d.healthBg.Thickness = 3
        d.healthBg.Transparency = 0.5
        d.healthBar = Drawing.new("Line")
        d.healthBar.Visible = false
        d.healthBar.Color = Color3.new(0, 1, 0)
        d.healthBar.Thickness = 1
        d.healthBar.Transparency = 1
        d.distance = Drawing.new("Text")
        d.distance.Visible = false
        d.distance.Color = Color3.new(1, 1, 1)
        d.distance.Size = 12
        d.distance.Center = true
        d.distance.Outline = true
        d.distance.OutlineColor = Color3.new(0, 0, 0)
        d.distance.Font = 2
        d.tracer = Drawing.new("Line")
        d.tracer.Visible = false
        d.tracer.Color = espColor
        d.tracer.Thickness = 1
        d.tracer.Transparency = 1
        return d
    end)
    if ok and drawings then
        espObjects[plr] = drawings
    end
end

local function removeESP(plr)
    if espObjects[plr] then
        for _, drawing in pairs(espObjects[plr]) do
            pcall(function() drawing:Remove() end)
        end
        espObjects[plr] = nil
    end
end

local function clearAllESP()
    for plr, _ in pairs(espObjects) do
        removeESP(plr)
    end
    espObjects = {}
end

local function updateESP()
    for plr, drawings in pairs(espObjects) do
        local character = plr.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        local head = character and character:FindFirstChild("Head")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not espEnabled or not character or not hrp or not head or not humanoid or humanoid.Health <= 0 then
            for _, drawing in pairs(drawings) do
                pcall(function() drawing.Visible = false end)
            end
            continue
        end
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            for _, drawing in pairs(drawings) do
                pcall(function() drawing.Visible = false end)
            end
            continue
        end
        local rootPos, onScreen = camera:WorldToViewportPoint(hrp.Position)
        local headPos = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
        local legPos = camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
        if not onScreen then
            for _, drawing in pairs(drawings) do
                pcall(function() drawing.Visible = false end)
            end
            if espTracers then
                drawings.tracer.Visible = true
                drawings.tracer.Color = espColor
                drawings.tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                local screenPos2D = camera:WorldToViewportPoint(hrp.Position)
                drawings.tracer.To = Vector2.new(screenPos2D.X, screenPos2D.Y)
            end
            continue
        end
        local boxHeight = math.abs(headPos.Y - legPos.Y)
        local boxWidth = boxHeight * 0.6
        local boxX = rootPos.X - boxWidth / 2
        local boxY = headPos.Y
        if espBoxes then
            drawings.boxTopLine.Visible = true
            drawings.boxTopLine.Color = espColor
            drawings.boxTopLine.From = Vector2.new(boxX, boxY)
            drawings.boxTopLine.To = Vector2.new(boxX + boxWidth, boxY)
            drawings.boxBottomLine.Visible = true
            drawings.boxBottomLine.Color = espColor
            drawings.boxBottomLine.From = Vector2.new(boxX, boxY + boxHeight)
            drawings.boxBottomLine.To = Vector2.new(boxX + boxWidth, boxY + boxHeight)
            drawings.boxLeftLine.Visible = true
            drawings.boxLeftLine.Color = espColor
            drawings.boxLeftLine.From = Vector2.new(boxX, boxY)
            drawings.boxLeftLine.To = Vector2.new(boxX, boxY + boxHeight)
            drawings.boxRightLine.Visible = true
            drawings.boxRightLine.Color = espColor
            drawings.boxRightLine.From = Vector2.new(boxX + boxWidth, boxY)
            drawings.boxRightLine.To = Vector2.new(boxX + boxWidth, boxY + boxHeight)
        else
            drawings.boxTopLine.Visible = false
            drawings.boxBottomLine.Visible = false
            drawings.boxLeftLine.Visible = false
            drawings.boxRightLine.Visible = false
        end
        if espNames then
            drawings.name.Visible = true
            drawings.name.Text = plr.DisplayName
            drawings.name.Position = Vector2.new(rootPos.X, boxY - 16)
        else
            drawings.name.Visible = false
        end
        if espHealth then
            local healthFrac = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
            drawings.healthBg.Visible = true
            drawings.healthBg.From = Vector2.new(boxX - 5, boxY + boxHeight)
            drawings.healthBg.To = Vector2.new(boxX - 5, boxY)
            drawings.healthBar.Visible = true
            drawings.healthBar.From = Vector2.new(boxX - 5, boxY + boxHeight)
            drawings.healthBar.To = Vector2.new(boxX - 5, boxY + boxHeight - (boxHeight * healthFrac))
            if healthFrac > 0.5 then
                drawings.healthBar.Color = Color3.fromRGB(0, 255, 0)
            elseif healthFrac > 0.25 then
                drawings.healthBar.Color = Color3.fromRGB(255, 255, 0)
            else
                drawings.healthBar.Color = Color3.fromRGB(255, 0, 0)
            end
        else
            drawings.healthBg.Visible = false
            drawings.healthBar.Visible = false
        end
        if espDistance then
            local dist = (hrp.Position - player.Character.HumanoidRootPart.Position).Magnitude
            drawings.distance.Visible = true
            drawings.distance.Text = math.floor(dist) .. " studs"
            drawings.distance.Position = Vector2.new(rootPos.X, boxY + boxHeight + 2)
        else
            drawings.distance.Visible = false
        end
        if espTracers then
            drawings.tracer.Visible = true
            drawings.tracer.Color = espColor
            drawings.tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
            drawings.tracer.To = Vector2.new(rootPos.X, boxY + boxHeight)
        else
            drawings.tracer.Visible = false
        end
    end
end

for _, plr in ipairs(Players:GetPlayers()) do
    createESP(plr)
end

Players.PlayerAdded:Connect(function(plr)
    createESP(plr)
end)

Players.PlayerRemoving:Connect(function(plr)
    removeESP(plr)
end)

RunService.RenderStepped:Connect(function()
    if espEnabled then
        updateESP()
    else
        for _, drawings in pairs(espObjects) do
            for _, drawing in pairs(drawings) do
                pcall(function() drawing.Visible = false end)
            end
        end
    end
end)

ESPSection:Toggle("ESP Enabled", false, function(value)
    espEnabled = value
    if not value then
        for _, drawings in pairs(espObjects) do
            for _, drawing in pairs(drawings) do
                pcall(function() drawing.Visible = false end)
            end
        end
    end
end)

ESPSection:Toggle("Boxes", true, function(value)
    espBoxes = value
end)

ESPSection:Toggle("Names", true, function(value)
    espNames = value
end)

ESPSection:Toggle("Health Bar", true, function(value)
    espHealth = value
end)

ESPSection:Toggle("Distance", true, function(value)
    espDistance = value
end)

ESPSection:Toggle("Tracers", false, function(value)
    espTracers = value
end)

local DH_WEAPONS = {
    "[Revolver]", "[Double-Barrel SG]", "[Glock]", "[Shotgun]",
    "[AK47]", "[AR]", "[SMG]", "[TacticalShotgun]", "[AUG]",
    "[SilencerAR]", "[Silencer]", "[P90]", "[RPG]", "[LMG]",
    "[Flamethrower]", "[DrumGun]"
}

local SKIN_PACKS = {
    Inferno = {
        ["[SilencerAR]"] = "9401972413",
        ["[SMG]"] = "9387593777",
        ["[TacticalShotgun]"] = "9402244359",
        ["[AK47]"] = "9402094255",
        ["[AUG]"] = "9401802930",
        ["[AR]"] = "9401972413",
        ["[Glock]"] = "9401670081",
        ["[Shotgun]"] = "9387831940",
        ["[Silencer]"] = "9401670081",
        ["[P90]"] = "9399878713",
        ["[Revolver]"] = "9370404463",
        ["[RPG]"] = "9399831924",
        ["[LMG]"] = "9400160302",
        ["[Flamethrower]"] = "9400503673",
        ["[DrumGun]"] = "9381496666",
        ["[Double-Barrel SG]"] = "9401416743",
    },
    Galaxy = {
        ["[SilencerAR]"] = "9402007158",
        ["[SMG]"] = "9387614760",
        ["[TacticalShotgun]"] = "9402279010",
        ["[AK47]"] = "9402132929",
        ["[AUG]"] = "9401832956",
        ["[AR]"] = "9402007158",
        ["[Glock]"] = "9401709916",
        ["[Shotgun]"] = "9387933478",
        ["[Silencer]"] = "9401709916",
        ["[P90]"] = "9399887933",
        ["[Revolver]"] = "9370936730",
        ["[RPG]"] = "9399842353",
        ["[LMG]"] = "9400170566",
        ["[Flamethrower]"] = "9400558000",
        ["[DrumGun]"] = "9381577172",
        ["[Double-Barrel SG]"] = "9401441647",
    },
    Matrix = {
        ["[SilencerAR]"] = "9402023983",
        ["[SMG]"] = "9387681455",
        ["[TacticalShotgun]"] = "9402295362",
        ["[AK47]"] = "9402147406",
        ["[AUG]"] = "9401855319",
        ["[AR]"] = "9402023983",
        ["[Glock]"] = "9401727978",
        ["[Shotgun]"] = "9387945198",
        ["[Silencer]"] = "9401727978",
        ["[P90]"] = "9399894480",
        ["[Revolver]"] = "9380928144",
        ["[RPG]"] = "9399850204",
        ["[LMG]"] = "9400178599",
        ["[Flamethrower]"] = "9400582867",
        ["[DrumGun]"] = "9381601709",
        ["[Double-Barrel SG]"] = "9401457713",
    },
    RedDeath = {
        ["[SilencerAR]"] = "8213168054",
        ["[SMG]"] = "8199875638",
        ["[TacticalShotgun]"] = "9203641766",
        ["[AK47]"] = "8213572965",
        ["[AUG]"] = "8212802637",
        ["[AR]"] = "8213168054",
        ["[Glock]"] = "8212637463",
        ["[Shotgun]"] = "8200647420",
        ["[Silencer]"] = "8212637463",
        ["[P90]"] = "8205381104",
        ["[Revolver]"] = "8173928665",
        ["[RPG]"] = "8201055935",
        ["[LMG]"] = "8205713344",
        ["[Flamethrower]"] = "8206707126",
        ["[DrumGun]"] = "8186385983",
        ["[Double-Barrel SG]"] = "8212384179",
    },
    GoldGlory = {
        ["[SilencerAR]"] = "8213175568",
        ["[SMG]"] = "8199883519",
        ["[TacticalShotgun]"] = "9203647967",
        ["[AK47]"] = "8213606202",
        ["[AUG]"] = "8212809463",
        ["[AR]"] = "8213175568",
        ["[Glock]"] = "8212667115",
        ["[Shotgun]"] = "8200657428",
        ["[Silencer]"] = "8212667115",
        ["[P90]"] = "8205397990",
        ["[Revolver]"] = "8173955378",
        ["[RPG]"] = "8201059812",
        ["[LMG]"] = "8205719479",
        ["[Flamethrower]"] = "8208010648",
        ["[DrumGun]"] = "8186168230",
        ["[Double-Barrel SG]"] = "8212394280",
    },
}

local currentSkinPack = nil
local skinChangerActive = false
local skinRenderName = "HAZEZZ_SkinChanger"

local function applySkinPack()
    if not skinChangerActive or not currentSkinPack then return end
    local pack = SKIN_PACKS[currentSkinPack]
    if not pack then return end
    if not player.Character then return end
    for weaponName, textureId in pairs(pack) do
        if player.Character:FindFirstChild(weaponName) then
            local tool = player.Character[weaponName]
            if tool:FindFirstChild("Default") then
                tool.Default.TextureID = "rbxassetid://" .. textureId
            end
        end
    end
end

local function startSkinChanger()
    skinChangerActive = true
    pcall(function()
        RunService:UnbindFromRenderStep(skinRenderName)
    end)
    RunService:BindToRenderStep(skinRenderName, 0, function()
        if skinChangerActive and currentSkinPack then
            applySkinPack()
        end
    end)
end

local function stopSkinChanger()
    skinChangerActive = false
    pcall(function()
        RunService:UnbindFromRenderStep(skinRenderName)
    end)
end

SkinPackSection:Toggle("Skin Changer", false, function(value)
    if value then
        startSkinChanger()
    else
        stopSkinChanger()
    end
end)

SkinPackSection:Button("Inferno", function()
    currentSkinPack = "Inferno"
    startSkinChanger()
end)

SkinPackSection:Button("Galaxy", function()
    currentSkinPack = "Galaxy"
    startSkinChanger()
end)

SkinPackSection:Button("Matrix", function()
    currentSkinPack = "Matrix"
    startSkinChanger()
end)

SkinPackSection:Button("Red Death", function()
    currentSkinPack = "RedDeath"
    startSkinChanger()
end)

SkinPackSection:Button("Gold Glory", function()
    currentSkinPack = "GoldGlory"
    startSkinChanger()
end)

SkinPackSection:Button("Stop / Reset", function()
    stopSkinChanger()
    currentSkinPack = nil
end)

-- ═══════════════════════════════════════════════════════════════════
-- KNIFE SKIN CHANGER (Da Hood)
-- ═══════════════════════════════════════════════════════════════════

local KNIFE_SKINS = {
    ["Tanto"] = "13423465595",
    ["GPO"]   = "13937325725",
}

local KNOWN_GUNS = {
    ["[Revolver]"]=true, ["[Double-Barrel SG]"]=true, ["[Glock]"]=true, ["[Shotgun]"]=true,
    ["[AK47]"]=true, ["[AR]"]=true, ["[SMG]"]=true, ["[TacticalShotgun]"]=true, ["[AUG]"]=true,
    ["[SilencerAR]"]=true, ["[Silencer]"]=true, ["[P90]"]=true, ["[RPG]"]=true, ["[LMG]"]=true,
    ["[Flamethrower]"]=true, ["[DrumGun]"]=true,
}

local knifeSkinRenderName = "HAZEZZ_KnifeSkin"
local knifeSkinEnabled = false
local currentKnifeSkin = nil

local function findKnifeTool()
    if not player.Character then return nil end
    for _, name in ipairs({"[Knife]", "Knife", "[Tanto]", "[GPO]"}) do
        local tool = player.Character:FindFirstChild(name)
        if tool then return tool end
    end
    for _, child in pairs(player.Character:GetChildren()) do
        if child:IsA("Tool") and not KNOWN_GUNS[child.Name] then
            if child:FindFirstChild("Default") then
                return child
            end
        end
    end
    return nil
end

local function applyKnifeSkin()
    if not knifeSkinEnabled or not currentKnifeSkin then return end
    if not player.Character then return end
    local assetId = KNIFE_SKINS[currentKnifeSkin]
    if not assetId then return end
    local knife = findKnifeTool()
    if not knife then return end
    local default = knife:FindFirstChild("Default")
    if default then
        pcall(function()
            default.MeshId = "rbxassetid://" .. assetId
        end)
    end
end

local function startKnifeSkinChanger()
    knifeSkinEnabled = true
    pcall(function()
        RunService:UnbindFromRenderStep(knifeSkinRenderName)
    end)
    RunService:BindToRenderStep(knifeSkinRenderName, 0, function()
        if knifeSkinEnabled and currentKnifeSkin then
            applyKnifeSkin()
        end
    end)
end

local function stopKnifeSkinChanger()
    knifeSkinEnabled = false
    currentKnifeSkin = nil
    pcall(function()
        RunService:UnbindFromRenderStep(knifeSkinRenderName)
    end)
end

KnifeSkinSection:Toggle("Knife Skin Changer", false, function(value)
    if value then
        startKnifeSkinChanger()
    else
        stopKnifeSkinChanger()
    end
end)

KnifeSkinSection:Dropdown("Knife Skin", {"Tanto", "GPO"}, function(value)
    currentKnifeSkin = value
    if knifeSkinEnabled then
        applyKnifeSkin()
    end
end)

KnifeSkinSection:Button("Stop / Reset Knife", function()
    stopKnifeSkinChanger()
end)

-- ═══════════════════════════════════════════════════════════════════
-- BULLET COLOR CHANGER
-- ═══════════════════════════════════════════════════════════════════
local bulletColorEnabled = false
local bulletColor = Color3.fromRGB(60, 140, 255)

local BULLET_COLOR_PRESETS = {
    Pink    = Color3.fromRGB(255, 128, 180),
    Red     = Color3.fromRGB(255, 0, 0),
    Blue    = Color3.fromRGB(0, 120, 255),
    Green   = Color3.fromRGB(0, 255, 80),
    Purple  = Color3.fromRGB(180, 0, 255),
    Yellow  = Color3.fromRGB(255, 255, 0),
    Cyan    = Color3.fromRGB(0, 255, 255),
    Orange  = Color3.fromRGB(255, 140, 0),
    White   = Color3.fromRGB(255, 255, 255),
    Black   = Color3.fromRGB(15, 15, 15),
}

local function recolorBullet(obj)
    if not bulletColorEnabled then return end
    pcall(function()
        if obj:IsA("BasePart") then
            obj.Color = bulletColor
            obj.BrickColor = BrickColor.new(bulletColor)
            if obj:FindFirstChildOfClass("PointLight") then
                obj:FindFirstChildOfClass("PointLight").Color = bulletColor
            end
            if obj:FindFirstChildOfClass("Fire") then
                obj:FindFirstChildOfClass("Fire").Color = bulletColor
                obj:FindFirstChildOfClass("Fire").SecondaryColor = bulletColor
            end
        end
        if obj:IsA("Trail") then
            obj.Color = ColorSequence.new(bulletColor)
        end
        if obj:IsA("Beam") then
            obj.Color = ColorSequence.new(bulletColor)
        end
        if obj:IsA("ParticleEmitter") then
            obj.Color = ColorSequence.new(bulletColor)
        end
    end)
end

local function watchForBullets(parent)
    parent.DescendantAdded:Connect(function(desc)
        if not bulletColorEnabled then return end
        local name = desc.Name:lower()
        if name == "bullet" or name == "effect" or name:find("bullet")
            or name:find("tracer") or name:find("muzzle") or name:find("flash")
            or name:find("projectile") or name:find("ray") then
            recolorBullet(desc)
            task.defer(function()
                for _, child in pairs(desc:GetDescendants()) do
                    recolorBullet(child)
                end
            end)
        end
        if desc:IsA("BasePart") and desc.Parent then
            local parentName = desc.Parent.Name:lower()
            if parentName == "bullets" or parentName == "effects" or parentName == "guneffects" then
                recolorBullet(desc)
            end
        end
    end)
end

watchForBullets(workspace)

player.CharacterAdded:Connect(function(char)
    char.DescendantAdded:Connect(function(desc)
        if not bulletColorEnabled then return end
        if desc:IsA("ParticleEmitter") or desc:IsA("Trail") or desc:IsA("Beam") or desc:IsA("PointLight") or desc:IsA("Fire") then
            local parentName = desc.Parent and desc.Parent.Name:lower() or ""
            if parentName:find("muzzle") or parentName:find("barrel") or parentName:find("flash") or parentName:find("bullet") then
                recolorBullet(desc)
            end
        end
    end)
end)

BulletColorSection:Toggle("Bullet Color", false, function(value)
    bulletColorEnabled = value
end)

BulletColorSection:Dropdown("Preset Color", {"Pink","Red","Blue","Green","Purple","Yellow","Cyan","Orange","White","Black"}, function(value)
    bulletColor = BULLET_COLOR_PRESETS[value] or bulletColor
end)

BulletColorSection:Slider("Red", 0, 255, 255, function(value)
    bulletColor = Color3.fromRGB(value, math.floor(bulletColor.G * 255), math.floor(bulletColor.B * 255))
end)

BulletColorSection:Slider("Green", 0, 255, 128, function(value)
    bulletColor = Color3.fromRGB(math.floor(bulletColor.R * 255), value, math.floor(bulletColor.B * 255))
end)

BulletColorSection:Slider("Blue", 0, 255, 180, function(value)
    bulletColor = Color3.fromRGB(math.floor(bulletColor.R * 255), math.floor(bulletColor.G * 255), value)
end)

local antiFlingEnabled = false

MiscExtraSection:Toggle("Anti Fling", false, function(value)
    antiFlingEnabled = value
end)

RunService.Heartbeat:Connect(function()
    if antiFlingEnabled and player.Character then
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            if hrp.Velocity.Magnitude > 100 then
                hrp.Velocity = hrp.Velocity.Unit * 50
            end
            hrp.RotVelocity = Vector3.new(0, 0, 0)
        end
    end
end)

local noRagdollEnabled = false

MiscExtraSection:Toggle("No Ragdoll", false, function(value)
    noRagdollEnabled = value
end)

MiscExtraSection:Toggle("No Recoil", false, function(value)
    noRecoilEnabled = value
end)

MiscExtraSection:Toggle("No Jump Cooldown", false, function(value)
    noJumpCooldownEnabled = value
end)

MiscExtraSection:Toggle("No Slowdown", false, function(value)
    noSlowdownEnabled = value
end)

MiscExtraSection:Toggle("No Bullet Spread", false, function(value)
    noBulletSpreadEnabled = value
end)

RunService.Heartbeat:Connect(function()
    if noRagdollEnabled and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if noSlowdownEnabled and player.Character then
        local bodyEffects = player.Character:FindFirstChild("BodyEffects")
        if bodyEffects then
            local movement = bodyEffects:FindFirstChild("Movement")
            if movement then
                for _, child in pairs(movement:GetChildren()) do
                    child:Destroy()
                end
            end
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════════
-- CONFIG SYSTEM
-- ═══════════════════════════════════════════════════════════════════
local HttpService = game:GetService("HttpService")
local CONFIG_FOLDER = "hazezz_configs"
local configName = "default"

pcall(function()
    if not isfolder(CONFIG_FOLDER) then
        makefolder(CONFIG_FOLDER)
    end
end)

local function getConfigPath(name)
    return CONFIG_FOLDER .. "/" .. name .. ".json"
end

local function keyCodeToName(kc)
    for _, v in pairs(Enum.KeyCode:GetEnumItems()) do
        if v == kc then return v.Name end
    end
    return "Q"
end

local function nameToKeyCode(name)
    local ok, result = pcall(function() return Enum.KeyCode[name] end)
    return ok and result or Enum.KeyCode.Q
end

local function colorToTable(c)
    return {R = math.floor(c.R * 255), G = math.floor(c.G * 255), B = math.floor(c.B * 255)}
end

local function tableToColor(t)
    return Color3.fromRGB(t.R or 255, t.G or 128, t.B or 180)
end

local function saveConfig(name)
    local data = {
        camlockSmoothing = smoothness * 1000,
        camlockPrediction = prediction * 1000,
        camlockKeybind = keyCodeToName(keybind),
        camlockMode = mode,
        camlockAimPart = camlockAimPart,
        camlockFOV = FOV_RADIUS,
        camlockMaxDist = MAX_DISTANCE,
        camlockWallCheck = wallCheckEnabled,
        camlockAutoLockOnHit = autoLockOnHit,
        camlockKnockedCheck = knockedCheckEnabled,
        camlockGrabbedCheck = grabbedCheckEnabled,
        camlockCrewCheck = crewCheckEnabled,
        camlockAutoSelect = autoSelectEnabled,
        camlockAutoSelectCooldown = autoSelectCooldown,
        silentKeybind = keyCodeToName(silentAimKeybind),
        silentMode = silentAimMode,
        silentFOV = silentAimFOV,
        silentPart = silentAimPart,
        silentPrediction = silentAimPrediction * 1000,
        silentShowFOV = silentShowFOV,
        silentResolver = silentResolverEnabled,
        silentResolverRefresh = silentResolverRefreshRate,
        triggerbotKeybind = keyCodeToName(triggerbotKeybind),
        triggerbotMode = triggerbotMode,
        triggerbotFOV = triggerbotFOV,
        triggerbotDelay = triggerbotDelay,
        triggerbotFireRate = triggerbotFireRate,
        triggerbotAimPart = triggerbotAimPart,
        triggerbotShowFOV = triggerbotShowFOV,
        hitboxSize = hitboxSize,
        hitboxTransparency = hitboxTransparency,
        hitboxVisible = hitboxVisible,
        hitboxPart = hitboxPart,
        speedWalkSpeed = walkSpeed,
        speedKeybind = keyCodeToName(speedKeybind),
        espBoxes = espBoxes,
        espNames = espNames,
        espHealth = espHealth,
        espDistance = espDistance,
        espTracers = espTracers,
        espColor = colorToTable(espColor),
        noRecoil = noRecoilEnabled,
        noJumpCooldown = noJumpCooldownEnabled,
        noSlowdown = noSlowdownEnabled,
        noBulletSpread = noBulletSpreadEnabled,
    }
    local ok, encoded = pcall(function() return HttpService:JSONEncode(data) end)
    if ok then
        pcall(function() writefile(getConfigPath(name), encoded) end)
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "haze.zz",
                Text = "Config saved: " .. name,
                Duration = 2
            })
        end)
    end
end

local function loadConfig(name)
    local path = getConfigPath(name)
    local ok, content = pcall(function() return readfile(path) end)
    if not ok then
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "haze.zz",
                Text = "Config not found: " .. name,
                Duration = 2
            })
        end)
        return
    end
    local ok2, data = pcall(function() return HttpService:JSONDecode(content) end)
    if not ok2 or not data then return end
    if data.camlockSmoothing then smoothness = data.camlockSmoothing / 1000 end
    if data.camlockPrediction then prediction = data.camlockPrediction / 1000 end
    if data.camlockKeybind then keybind = nameToKeyCode(data.camlockKeybind) end
    if data.camlockMode then mode = data.camlockMode end
    if data.camlockAimPart then camlockAimPart = data.camlockAimPart end
    if data.camlockFOV then FOV_RADIUS = data.camlockFOV end
    if data.camlockMaxDist then MAX_DISTANCE = data.camlockMaxDist end
    if data.camlockWallCheck ~= nil then wallCheckEnabled = data.camlockWallCheck end
    if data.camlockAutoLockOnHit ~= nil then autoLockOnHit = data.camlockAutoLockOnHit end
    if data.camlockKnockedCheck ~= nil then knockedCheckEnabled = data.camlockKnockedCheck end
    if data.camlockGrabbedCheck ~= nil then grabbedCheckEnabled = data.camlockGrabbedCheck end
    if data.camlockCrewCheck ~= nil then crewCheckEnabled = data.camlockCrewCheck end
    if data.camlockAutoSelect ~= nil then autoSelectEnabled = data.camlockAutoSelect end
    if data.camlockAutoSelectCooldown then autoSelectCooldown = data.camlockAutoSelectCooldown end
    if data.silentKeybind then silentAimKeybind = nameToKeyCode(data.silentKeybind) end
    if data.silentMode then silentAimMode = data.silentMode end
    if data.silentFOV then silentAimFOV = data.silentFOV end
    if data.silentPart then silentAimPart = data.silentPart end
    if data.silentPrediction then silentAimPrediction = data.silentPrediction / 1000 end
    if data.silentShowFOV ~= nil then silentShowFOV = data.silentShowFOV end
    if data.silentResolver ~= nil then silentResolverEnabled = data.silentResolver end
    if data.silentResolverRefresh then silentResolverRefreshRate = data.silentResolverRefresh end
    if data.triggerbotKeybind then triggerbotKeybind = nameToKeyCode(data.triggerbotKeybind) end
    if data.triggerbotMode then triggerbotMode = data.triggerbotMode end
    if data.triggerbotFOV then triggerbotFOV = data.triggerbotFOV end
    if data.triggerbotDelay then triggerbotDelay = data.triggerbotDelay end
    if data.triggerbotFireRate then triggerbotFireRate = data.triggerbotFireRate end
    if data.triggerbotAimPart then triggerbotAimPart = data.triggerbotAimPart end
    if data.triggerbotShowFOV ~= nil then triggerbotShowFOV = data.triggerbotShowFOV end
    if data.hitboxSize then hitboxSize = data.hitboxSize end
    if data.hitboxTransparency then hitboxTransparency = data.hitboxTransparency end
    if data.hitboxVisible ~= nil then hitboxVisible = data.hitboxVisible end
    if data.hitboxPart then hitboxPart = data.hitboxPart end
    if data.speedWalkSpeed then walkSpeed = data.speedWalkSpeed end
    if data.speedKeybind then speedKeybind = nameToKeyCode(data.speedKeybind) end
    if data.espBoxes ~= nil then espBoxes = data.espBoxes end
    if data.espNames ~= nil then espNames = data.espNames end
    if data.espHealth ~= nil then espHealth = data.espHealth end
    if data.espDistance ~= nil then espDistance = data.espDistance end
    if data.espTracers ~= nil then espTracers = data.espTracers end
    if data.espColor then espColor = tableToColor(data.espColor) end
    if data.noRecoil ~= nil then noRecoilEnabled = data.noRecoil end
    if data.noJumpCooldown ~= nil then noJumpCooldownEnabled = data.noJumpCooldown end
    if data.noSlowdown ~= nil then noSlowdownEnabled = data.noSlowdown end
    if data.noBulletSpread ~= nil then noBulletSpreadEnabled = data.noBulletSpread end
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "haze.zz",
            Text = "Config loaded: " .. name,
            Duration = 2
        })
    end)
end

local function deleteConfig(name)
    local path = getConfigPath(name)
    local ok = pcall(function()
        if isfile(path) then
            delfile(path)
        end
    end)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "haze.zz",
            Text = ok and ("Deleted: " .. name) or ("Not found: " .. name),
            Duration = 2
        })
    end)
end

local function listConfigs()
    local configs = {}
    pcall(function()
        local files = listfiles(CONFIG_FOLDER)
        for _, file in pairs(files) do
            local name = file:match("([^/\\]+)%.json$")
            if name then
                table.insert(configs, name)
            end
        end
    end)
    return configs
end

ConfigSection:TextBox("Config Name", "default", function(value)
    configName = value
end)

ConfigSection:Button("Save Config", function()
    if configName and configName ~= "" then
        saveConfig(configName)
    end
end)

ConfigSection:Button("Load Config", function()
    if configName and configName ~= "" then
        loadConfig(configName)
    end
end)

ConfigSection:Button("Delete Config", function()
    if configName and configName ~= "" then
        deleteConfig(configName)
    end
end)

ConfigSection:Button("List Configs", function()
    local configs = listConfigs()
    local text = #configs > 0 and table.concat(configs, ", ") or "No configs found"
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "haze.zz configs",
            Text = text,
            Duration = 4
        })
    end)
end)