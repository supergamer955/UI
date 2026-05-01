--[[
    GRZY HUB - ADVANCED EDITION
    Aesthetics: Tactical, Glassmorphic, Purple
    Features: Draggable UI, Smooth Tweens, Tab System
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local GrzyHub = {
    Tabs = {},
    Elements = {},
    CurrentTab = nil
}

-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GrzyHub_Premium"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame (The Glass)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 550, 0, 350)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Rounded Corners & Purple Stroke
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(120, 0, 255)
UIStroke.Thickness = 1.5
UIStroke.Transparency = 0.5
UIStroke.Parent = MainFrame

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 150, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
Sidebar.BackgroundTransparency = 0.5
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 10)
SidebarCorner.Parent = Sidebar

local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Size = UDim2.new(1, 0, 1, -50)
TabContainer.Position = UDim2.new(0, 0, 0, 50)
TabContainer.BackgroundTransparency = 1
TabContainer.BorderSizePixel = 0
TabContainer.ScrollBarThickness = 0
TabContainer.Parent = Sidebar

local Layout = Instance.new("UIListLayout")
Layout.Parent = TabContainer
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Padding = UDim.new(0, 5)

-- Content Area
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -160, 1, -10)
Content.Position = UDim2.new(0, 155, 0, 5)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- [[ DRAGGING SYSTEM ]]
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then update(input) end
end)

-- [[ API FUNCTIONS ]]

function GrzyHub:CreateTab(name)
    local TabButton = Instance.new("TextButton")
    local TabPage = Instance.new("ScrollingFrame")
    
    -- Tab Button Visuals
    TabButton.Size = UDim2.new(1, -10, 0, 35)
    TabButton.BackgroundColor3 = Color3.fromRGB(120, 0, 255)
    TabButton.BackgroundTransparency = 1
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.Font = Enum.Font.GothamBold
    TabButton.TextSize = 14
    TabButton.Parent = TabContainer
    
    local TBCorner = Instance.new("UICorner")
    TBCorner.CornerRadius = UDim.new(0, 6)
    TBCorner.Parent = TabButton

    -- Page Setup
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.BackgroundTransparency = 1
    TabPage.Visible = false
    TabPage.ScrollBarThickness = 2
    TabPage.Parent = Content
    
    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Parent = TabPage
    PageLayout.Padding = UDim.new(0, 8)

    TabButton.MouseButton1Click:Connect(function()
        for _, page in pairs(Content:GetChildren()) do
            if page:IsA("ScrollingFrame") then page.Visible = false end
        end
        for _, btn in pairs(TabContainer:GetChildren()) do
            if btn:IsA("TextButton") then
                TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            end
        end
        TabPage.Visible = true
        TweenService:Create(TabButton, TweenInfo.new(0.3), {BackgroundTransparency = 0.7}):Play()
    end)

    local function CreateButton(text, callback)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, -10, 0, 40)
        Button.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        Button.Text = "  " .. text
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.Font = Enum.Font.Gotham
        Button.TextSize = 14
        Button.TextXAlignment = Enum.TextXAlignment.Left
        Button.Parent = TabPage
        
        local BCorner = Instance.new("UICorner")
        BCorner.CornerRadius = UDim.new(0, 6)
        BCorner.Parent = Button
        
        Button.MouseButton1Click:Connect(function()
            -- Button Click Effect
            local originalColor = Button.BackgroundColor3
            Button.BackgroundColor3 = Color3.fromRGB(120, 0, 255)
            wait(0.1)
            Button.BackgroundColor3 = originalColor
            pcall(callback)
        end)
    end

    return {CreateButton = CreateButton}
end

-- [[ EXECUTION EXAMPLE ]]

local MainTab = GrzyHub:CreateTab("Main")
local VisualsTab = GrzyHub:CreateTab("Visuals")

MainTab.CreateButton("Auto Farm (Toggle)", function()
    print("Auto farm started...")
    -- Add your Pet Sim logic here
end)

VisualsTab.CreateButton("Show Hitboxes", function()
    print("Hitboxes enabled")
end)

print("Grzy Hub Loaded Successfully!")
