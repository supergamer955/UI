local GrzyLib = {}
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

function GrzyLib:CreateWindow(Config)
    local HubName = Config.Name or "Grzy Hub"
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "GrzyHub_UI"
    ScreenGui.Parent = CoreGui
    
    -- Main UI Frame
    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 500, 0, 350)
    Main.Position = UDim2.new(0.5, -250, 0.5, -175)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Main

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(120, 0, 255)
    Stroke.Thickness = 2
    Stroke.Parent = Main

    -- Container for elements
    local Container = Instance.new("ScrollingFrame")
    Container.Size = UDim2.new(1, -20, 1, -60)
    Container.Position = UDim2.new(0, 10, 0, 50)
    Container.BackgroundTransparency = 1
    Container.ScrollBarThickness = 2
    Container.Parent = Main
    
    local Layout = Instance.new("UIListLayout")
    Layout.Parent = Container
    Layout.Padding = UDim.new(0, 5)

    local Title = Instance.new("TextLabel")
    Title.Text = HubName
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.Parent = Main

    local Elements = {}

    function Elements:CreateButton(Name, Callback)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, -10, 0, 35)
        Button.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        Button.Text = Name
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.Font = Enum.Font.Gotham
        Button.Parent = Container
        
        Instance.new("UICorner").Parent = Button
        
        Button.MouseButton1Click:Connect(function()
            Callback()
        end)
    end

    return Elements
end

return GrzyLib
