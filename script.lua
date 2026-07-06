local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- GUI Library Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MANJII_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui")

local Overlay = Instance.new("TextLabel")
Overlay.Name = "Watermark"
Overlay.Size = UDim2.new(0, 150, 0, 30)
Overlay.Position = UDim2.new(0, 10, 0, 10)
Overlay.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Overlay.BackgroundTransparency = 0.3
Overlay.TextColor3 = Color3.fromRGB(255, 255, 255)
Overlay.Text = "MANJII OFFICIAL"
Overlay.Font = Enum.Font.GothamBold
Overlay.TextSize = 12
Overlay.TextStrokeTransparency = 0
Overlay.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
Overlay.Parent = ScreenGui
Instance.new("UICorner", Overlay).CornerRadius = UDim.new(0, 4)

-- Draggable Watermark & Color Change
local dragging, dragInput, dragStart, startPos

Overlay.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Overlay.Position
        
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
        -- Right click to cycle text color
        local colors = {
            Color3.fromRGB(255, 0, 0),
            Color3.fromRGB(0, 255, 0),
            Color3.fromRGB(0, 120, 255),
            Color3.fromRGB(255, 255, 0),
            Color3.fromRGB(255, 0, 255),
            Color3.fromRGB(0, 255, 255),
            Color3.fromRGB(255, 255, 255)
        }
        local current = Overlay.TextColor3
        for i, c in ipairs(colors) do
            if c == current then
                Overlay.TextColor3 = colors[i + 1] or colors[1]
                break
            end
        end
    end
end)

Overlay.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        Overlay.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Core Variables
local EspEnabled = true
local SprintEnabled = true
local AutoMission = true
local AutoSlash = false
local AutoKiller = false
local AutoPalette = false

-- ESP Module
local function CreateESP(player)
    if player == LocalPlayer then return end
    local char = player.Character
    if not char then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "MANJII_ESP"
    highlight.FillTransparency = 0.8
    highlight.OutlineTransparency = 0
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.Parent = char
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "MANJII_BILLBOARD"
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = char:FindFirstChild("Head") or char
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0.5
    label.Text = player.Name
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.Parent = billboard
end

local function ClearESP(player)
    if player.Character then
        local h = player.Character:FindFirstChild("MANJII_ESP")
        if h then h:Destroy() end
        local head = player.Character:FindFirstChild("Head")
        if head then
            local bb = head:FindFirstChild("MANJII_BILLBOARD")
            if bb then bb:Destroy() end
        end
    end
end

-- Initialize ESP
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function()
            task.wait(1)
            if EspEnabled then CreateESP(player) end
        end)
        if player.Character then task.spawn(function() task.wait(0.5) if EspEnabled then CreateESP(player) end end) end
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(1)
        if EspEnabled then CreateESP(player) end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    ClearESP(player)
end)

-- Infinite Sprint
RunService:BindToRenderStep("MANJII_SPRINT", 1, function()
    if SprintEnabled and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = 25
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                hum.WalkSpeed = 50
            end
        end
    end
end)

-- Auto Mission / Auto Interact (Completes many missions by interacting with nearby map props/NPCs)
task.spawn(function()
    while task.wait(1) do
        if AutoMission and LocalPlayer.Character then
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if (obj:IsA("ProximityPrompt") or obj:IsA("ClickDetector")) and obj.Enabled then
                        local part = obj.Parent
                        if part:IsA("BasePart") then
                            local dist = (root.Position - part.Position).Magnitude
                            if dist <= 15 then
                                if obj:IsA("ProximityPrompt") then
                                    fireproximityprompt(obj)
                                elseif obj:IsA("ClickDetector") then
                                    fireclickdetector(obj)
                                end
                                task.wait(0.5)
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Auto Slash (Survivor)
task.spawn(function()
    while task.wait(0.1) do
        if AutoSlash and LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hum and root then
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                        local targetHum = player.Character:FindFirstChildOfClass("Humanoid")
                        if targetRoot and targetHum and targetHum.Health > 0 then
                            local dist = (root.Position - targetRoot.Position).Magnitude
                            if dist <= 8 then
                                -- Simulate melee slash via tool or raw network event if available
                                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                                if tool then
                                    local slashEvent = tool:FindFirstChild("RemoteEvent") or tool:FindFirstChild("SlashEvent")
                                    if slashEvent then
                                        slashEvent:FireServer(targetRoot.Position)
                                    else
                                        -- Fallback: Trigger tool activation
                                        tool:Activate()
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Auto Killer (Killer Role)
task.spawn(function()
    while task.wait(0.05) do
        if AutoKiller and LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hum and root then
                local closestPlayer, closestDist = nil, math.huge
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                        local targetHum = player.Character:FindFirstChildOfClass("Humanoid")
                        if targetRoot and targetHum and targetHum.Health > 0 then
                            local dist = (root.Position - targetRoot.Position).Magnitude
                            if dist < closestDist then
                                closestDist = dist
                                closestPlayer = {player = player, root = targetRoot}
                            end
                        end
                    end
                end
                
                if closestPlayer and closestDist <= 100 then
                    -- Teleport to target to guarantee hit
                    root.CFrame = closestPlayer.root.CFrame * CFrame.new(0, 0, 3)
                    
                    -- Attempt to fire killer attack events
                    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then
                        tool:Activate()
                        for _, rem in ipairs(tool:GetDescendants()) do
                            if rem:IsA("RemoteEvent") then
                                rem:FireServer(closestPlayer.root)
                            end
                        end
                    else
                        -- Fallback: Check character or backpack for attack remotes
                        for _, rem in ipairs(ReplicatedStorage:GetDescendants()) do
                            if rem:IsA("RemoteEvent") and (rem.Name:lower():find("attack") or rem.Name:lower():find("kill") or rem.Name:lower():find("slash")) then
                                rem:FireServer(closestPlayer.root)
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Auto Palette (Grabbing/Using palettes or items automatically)
task.spawn(function()
    while task.wait(1) do
        if AutoPalette and LocalPlayer.Character then
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") and obj.Enabled then
                        local part = obj.Parent
                        if part:IsA("BasePart") then
                            local promptText = obj.Text or ""
                            -- Generic trigger for palettes, boards, items, generators, etc.
                            if promptText:lower():find("palette") or promptText:lower():find("board") or promptText:lower():find("item") or promptText:lower():find("grab") or promptText:lower():find("use") then
                                local dist = (root.Position - part.Position).Magnitude
                                if dist <= 20 then
                                    fireproximityprompt(obj)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Keybind Handler
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.E then
        AutoSlash = not AutoSlash
    elseif input.KeyCode == Enum.KeyCode.K then
        AutoKiller = not AutoKiller
    elseif input.KeyCode == Enum.KeyCode.P then
        AutoPalette = not AutoPalette
    elseif input.KeyCode == Enum.KeyCode.M then
        AutoMission = not AutoMission
    elseif input.KeyCode == Enum.KeyCode.H then
        SprintEnabled = not SprintEnabled
    end
end)
