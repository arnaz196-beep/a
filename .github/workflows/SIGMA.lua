local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Character
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

-- Teleport destination
local teleportCFrame = CFrame.new(
    11790.3154296875,
    17.419164657592773,
    -84.90773010253906
)

-- Auto-teleport control
local autoTeleporting = false

-- Create GUI
local gui = Instance.new("ScreenGui")
gui.Name = "TeleportGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Black frame (expanded for title)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 190) -- taller to fit title
frame.Position = UDim2.new(0.5, -125, 0.5, -95)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.1
frame.Parent = gui

-- Title text
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Arnazzz's scripts"
title.TextScaled = false
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Parent = frame

-- Make frame movable
local dragging = false
local dragInput, mousePos, framePos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        frame.Position = UDim2.new(
            framePos.X.Scale,
            framePos.X.Offset + delta.X,
            framePos.Y.Scale,
            framePos.Y.Offset + delta.Y
        )
    end
end)

-- Teleport button
local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(0.8, 0, 0.35, 0)
teleportButton.Position = UDim2.new(0.1, 0, 0.15, 0) -- shifted down to fit title
teleportButton.Text = "Teleport"
teleportButton.TextScaled = true
teleportButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.BorderSizePixel = 0
teleportButton.Parent = frame

teleportButton.MouseButton1Click:Connect(function()
    if hrp then
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.CFrame = teleportCFrame
    end
end)

-- Auto-teleport button
local autoButton = Instance.new("TextButton")
autoButton.Size = UDim2.new(0.8, 0, 0.35, 0)
autoButton.Position = UDim2.new(0.1, 0, 0.55, 0)
autoButton.Text = "Auto Teleport"
autoButton.TextScaled = true
autoButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
autoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
autoButton.BorderSizePixel = 0
autoButton.Parent = frame

autoButton.MouseButton1Click:Connect(function()
    autoTeleporting = not autoTeleporting
end)

-- Stop auto-teleport on pressing G
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.G then
        autoTeleporting = false
    end
end)

-- Auto-teleport loop
spawn(function()
    while true do
        if autoTeleporting and hrp then
            -- Teleport to destination
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.CFrame = teleportCFrame

            -- Move forward for 0.5 seconds
            local moveTime = 0.5
            local startTime = tick()
            while tick() - startTime < moveTime do
                -- Move forward each frame
                hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * 0.5
                wait(0.03)
                if not autoTeleporting then break end
            end

            -- Wait 0.25 seconds before next teleport
            local timer = 0
            while timer < 0.25 do
                wait(0.05)
                timer = timer + 0.05
                if not autoTeleporting then break end
            end
        else
            wait(0.1)
        end
    end
end)

