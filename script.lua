local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- State Variables
local menuOpen = true
local slidingOut = false
local slidingIn = false

-- Main GUI Container
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ManjiiOfficialUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui")

-- Overlay Watermark
local Overlay = Instance.new("TextLabel")
Overlay.Name = "Overlay"
Overlay.Size = UDim2.new(0, 150, 0, 30)
Overlay.Position = UDim2.new(0, 10, 0, 10)
Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Overlay.BackgroundTransparency = 0.5
Overlay.Text = "MANJII OFFICIAL"
Overlay.TextColor3 = Color3.fromRGB(0, 255, 255)
Overlay.TextSize = 12
Overlay.Font = Enum.Font.GothamBold
Overlay.TextStrokeTransparency = 0
Overlay.TextStrokeColor3 = Color3.fromRGB(0, 100, 255)
Overlay.BorderSizePixel = 0
local OverlayCorner = Instance.new("UICorner")
OverlayCorner.CornerRadius = UDim.new(0, 8)
OverlayCorner.Parent = Overlay
Overlay.Parent = ScreenGui

-- Main Menu Frame
local MenuFrame = Instance.new("Frame")
MenuFrame.Name = "MenuFrame"
MenuFrame.Size = UDim2.new(0, 400, 0, 500)
MenuFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
MenuFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MenuFrame.BackgroundTransparency = 0.15
MenuFrame.BorderSizePixel = 0
MenuFrame.Parent = ScreenGui

local MenuGradient = Instance.new("UIGradient")
MenuGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 40, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 20, 80))
}
MenuGradient.Parent = MenuFrame

local MenuCorner = Instance.new("UICorner")
MenuCorner.CornerRadius = UDim.new(0, 12)
MenuCorner.Parent = MenuFrame

local MenuStroke = Instance.new("UIStroke")
MenuStroke.Color = Color3.fromRGB(0, 200, 255)
MenuStroke.Thickness = 1
MenuStroke.Transparency = 0.5
MenuStroke.Parent = MenuFrame

-- Toggle Button
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 40, 0, 40)
ToggleBtn.Position = UDim2.new(0, 165, 0, 10)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleBtn.BackgroundTransparency = 0.6
ToggleBtn.Text = "«"
ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
ToggleBtn.TextSize = 18
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Parent = ScreenGui
local ToggleBtnCorner = Instance.new("UICorner")
ToggleBtnCorner.CornerRadius = UDim.new(1, 0)
ToggleBtnCorner.Parent = ToggleBtn

-- Scrolling Frame for Buttons
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -20, 1, -60)
ScrollFrame.Position = UDim2.new(0, 10, 0, 50)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 255)
ScrollFrame.BorderSizePixel = 0
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.Parent = MenuFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ScrollFrame

-- Button Creation Function
local featureCount = 0
local function createFeatureButton(text, callback)
    featureCount = featureCount + 1
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 35)
    Btn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
    Btn.BackgroundTransparency = 0.85
    Btn.Text = "   [OFF] " .. text
    Btn.TextColor3 = Color3.fromRGB(200, 255, 255)
    Btn.TextSize = 13
    Btn.Font = Enum.Font.Gotham
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.BorderSizePixel = 0
    Btn.LayoutOrder = featureCount
    Btn.Parent = ScrollFrame

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = Btn

    local BtnGradient = Instance.new("UIGradient")
    BtnGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 255))
    }
    BtnGradient.Parent = Btn

    local state = false
    Btn.MouseButton1Click:Connect(function()
        state = not state
        Btn.Text = "   " .. (state and "[ON] " or "[OFF] ") .. text
        Btn.BackgroundTransparency = state and 0.7 or 0.85
        callback(state)
    end)
    
    return Btn
end

-- Slide In/Out Logic
local function slideOut()
    if slidingOut or slidingIn then return end
    slidingOut = true
    local tween = TweenService:Create(MenuFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(1.5, 0, 0.5, -250)})
    tween:Play()
    tween.Completed:Connect(function()
        slidingOut = false
        menuOpen = false
        MenuFrame.Visible = false
    end)
end

local function slideIn()
    if slidingOut or slidingIn then return end
    MenuFrame.Visible = true
    menuOpen = true
    slidingIn = true
    MenuFrame.Position = UDim2.new(1.5, 0, 0.5, -250)
    local tween = TweenService:Create(MenuFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -200, 0.5, -250)})
    tween:Play()
    tween.Completed:Connect(function()
        slidingIn = false
    end)
end

ToggleBtn.MouseButton1Click:Connect(function()
    if menuOpen then
        slideOut()
        ToggleBtn.Text = "»"
    else
        slideIn()
        ToggleBtn.Text = "«"
    end
end)

-- Make Menu Draggable
local dragging, dragInput, dragStart, startPos

MenuFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MenuFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MenuFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MenuFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ESP Functionality
local espEnabled = false
local function toggleESP(state)
    espEnabled = state
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local highlight = player.Character:FindFirstChild("ManjiiESP")
            if state then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "ManjiiESP"
                    highlight.FillColor = Color3.fromRGB(0, 255, 255)
                    highlight.OutlineColor = Color3.fromRGB(0, 100, 255)
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                    highlight.Parent = player.Character
                end
            else
                if highlight then highlight:Destroy() end
            end
        end
    end
end

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(c)
        if espEnabled then
            task.wait(1)
            toggleESP(true)
        end
    end)
end)

-- Auto Sprint
local sprintConn
createFeatureButton("Sprint Boost", function(state)
    if state then
        sprintConn = RunService.RenderStepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = 25 end
            end
        end)
    else
        if sprintConn then sprintConn:Disconnect() end
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = 16 end
    end
end)

-- Infinite Jump
local jumpConn
createFeatureButton("Infinite Jump", function(state)
    if state then
        jumpConn = UserInputService.JumpRequest:Connect(function()
            if LocalPlayer.Character then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid").ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        if jumpConn then jumpConn:Disconnect() end
    end
end)

-- Full Invisible
createFeatureButton("Absolute Invisibility", function(state)
    local char = LocalPlayer.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = state and 1 or 0
                if part:FindFirstChildOfClass("Decal") then
                    part.Decal.Transparency = state and 1 or 0
                end
            end
        end
        local face = char:FindFirstChild("Head") and char.Head:FindFirstChildOfClass("Decal")
        if face then face.Transparency = state and 1 or 0 end
    end
end)

-- Killer Immunity (Godmode)
local immConn
createFeatureButton("Killer Immunity (Godmode)", function(state)
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            if state then
                immConn = hum.HealthChanged:Connect(function(newHealth)
                    if newHealth < hum.MaxHealth then
                        hum.Health = hum.MaxHealth
                    end
                end)
            else
                if immConn then immConn:Disconnect() end
            end
        end
    end
end)

-- Kill Aura / Auto Slash
local killAuraConn
createFeatureButton("Auto Slash (Kill Aura)", function(state)
    if state then
        killAuraConn = RunService.RenderStepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart")
                local tool = char:FindFirstChildOfClass("Tool")
                if root and tool then
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            local dist = (root.Position - p.Character.HumanoidRootPart.Position).Magnitude
                            if dist < 20 then
                                tool:Activate()
                                break
                            end
                        end
                    end
                end
            end
        end)
    else
        if killAuraConn then killAuraConn:Disconnect() end
    end
end)

-- Auto Killer (Teleport to nearest survivor and slash)
local autoKillerConn
createFeatureButton("Auto Killer (TP & Slash)", function(state)
    if state then
        autoKillerConn = RunService.RenderStepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart")
                local tool = char:FindFirstChildOfClass("Tool")
                if root and tool then
                    local nearest, minDist = nil, math.huge
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            local dist = (root.Position - p.Character.HumanoidRootPart.Position).Magnitude
                            if dist < minDist then
                                minDist = dist
                                nearest = p
                            end
                        end
                    end
                    if nearest and minDist > 5 then
                        root.CFrame = nearest.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                    elseif nearest and minDist <= 5 then
                        tool:Activate()
                    end
                end
            end
        end)
    else
        if autoKillerConn then autoKillerConn:Disconnect() end
    end
end)

-- Auto Complete Missions
createFeatureButton("Auto Complete Missions", function(state)
    if state then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") or (obj:IsA("ClickDetector")) then
                if obj:IsA("ProximityPrompt") then
                    fireproximityprompt(obj)
                end
            end
        end
    end
end)

-- Auto Palette (Interact with nearby interactive objects)
local palletConn
createFeatureButton("Auto Palette / Interact", function(state)
    if state then
        palletConn = RunService.RenderStepped:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local root = char.HumanoidRootPart
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") then
                        local part = obj.Parent
                        if part:IsA("BasePart") then
                            local dist = (root.Position - part.Position).Magnitude
                            if dist < 15 then
                                fireproximityprompt(obj)
                            end
                        end
                    end
                end
            end
        end)
    else
        if palletConn then palletConn:Disconnect() end
    end
end)

-- ESP Toggle
createFeatureButton("Kill Auto ESP", function(state)
    toggleESP(state)
end)

-- Low Gravity
createFeatureButton("Low Gravity", function(state)
    workspace.Gravity = state and 0.2 or 196.2
end)

-- No Clip
local noclipConn
createFeatureButton("No Clip", function(state)
    if state then
        noclipConn = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConn then noclipConn:Disconnect() end
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end)

-- Click Teleport
local clickTpEnabled = false
createFeatureButton("Click Teleport", function(state)
    clickTpEnabled = state
end)

UserInputService.InputBegan:Connect(function(input)
    if clickTpEnabled and input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mouse = LocalPlayer:GetMouse()
        if mouse.Hit then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = mouse.Hit + Vector3.new(0, 3, 0)
            end
        end
    end
end)

-- Resize Scrolling Frame Canvas
task.defer(function()
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
    end)
end)
