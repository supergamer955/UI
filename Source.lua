--[[ 
    GRZY HUB - PREMIUM LIBRARY
    Features: Auto-Cleanup, Smooth Dragging, Toggle System
]]

local GrzyLib = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- [ AUTO-CLEANUP ]
if CoreGui:FindFirstChild("GrzyHub_Premium") then
    CoreGui:FindFirstChild("GrzyHub_Premium"):Destroy()
end

local function MakeDraggable(Frame)
    local dragging, dragInput, dragStart, startPos
    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Frame.Position
        end
    end)
    Frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            TweenService:Create(Frame, TweenInfo.new(0.15, Enum.EasingStyle.Quart), {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }):Play()
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

function GrzyLib:CreateWindow(Config)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "GrzyHub_Premium"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 550, 0, 380)
    Main.Position = UDim2.new(0.5, -275, 0.5, -190)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui
    MakeDraggable(Main)

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = Color3.fromRGB(120, 0, 255)
    Stroke.Thickness = 1.8

    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 150, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    Sidebar.BackgroundTransparency = 0.5
    Sidebar.Parent = Main
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Size = UDim2.new(1, 0, 1, -60)
    TabContainer.Position = UDim2.new(0, 0, 0, 60)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    TabContainer.Parent = Sidebar
    Instance.new("UIListLayout", TabContainer).Padding = UDim.new(0, 5)

    local ContentHolder = Instance.new("Frame")
    ContentHolder.Size = UDim2.new(1, -165, 1, -20)
    ContentHolder.Position = UDim2.new(0, 160, 0, 10)
    ContentHolder.BackgroundTransparency = 1
    ContentHolder.Parent = Main

    local Title = Instance.new("TextLabel")
    Title.Text = Config.Name or "GRZY HUB"
    Title.Size = UDim2.new(1, 0, 0, 60)
    Title.TextColor3 = Color3.fromRGB(160, 100, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.BackgroundTransparency = 1
    Title.Parent = Sidebar

    local Tabs = {}

    function Tabs:CreateTab(Name)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, -10, 0, 35)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = Name
        TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.Parent = TabContainer
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.Visible = false
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 0
        Page.Parent = ContentHolder
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(ContentHolder:GetChildren()) do v.Visible = false end
            for _, v in pairs(TabContainer:GetChildren()) do 
                if v:IsA("TextButton") then v.BackgroundTransparency = 1 end
            end
            Page.Visible = true
            TabBtn.BackgroundTransparency = 0.8
            TabBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 255)
        end)

        local Elements = {}

        -- BUTTON ELEMENT
        function Elements:CreateButton(Text, Callback)
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, -10, 0, 40)
            Button.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            Button.Text = "  " .. Text
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextXAlignment = Enum.TextXAlignment.Left
            Button.Font = Enum.Font.Gotham
            Button.Parent = Page
            Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)

            Button.MouseButton1Click:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(120, 0, 255)}):Play()
                task.wait(0.1)
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 30)}):Play()
                Callback()
            end)
        end

        -- TOGGLE ELEMENT (Like Zap Hub)
        function Elements:CreateToggle(Text, Callback)
            local Toggled = false
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, -10, 0, 40)
            Button.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            Button.Text = "  " .. Text
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextXAlignment = Enum.TextXAlignment.Left
            Button.Font = Enum.Font.Gotham
            Button.Parent = Page
            Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)

            local Indicator = Instance.new("Frame")
            Indicator.Size = UDim2.new(0, 10, 0, 10)
            Indicator.Position = UDim2.new(1, -25, 0.5, -5)
            Indicator.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
            Indicator.Parent = Button
            Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)

            Button.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                local Color = Toggled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(200, 0, 0)
                TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = Color}):Play()
                Callback(Toggled)
            end)
        end

        return Elements
    end

    return Tabs
end

return GrzyLib
