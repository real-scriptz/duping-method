-- ✅ FIXED TINIEST Draggable "DUPING METHOD" Button (100% Mobile Touch Fixed)
-- Smallest possible UI: 50x50 round button
-- Drag code now attached DIRECTLY to the button (this fixes why it wasn't dragging before)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Persistent ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DUPING_METHOD_GUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- SMALLEST main frame (50x50)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "DUPING_METHOD_FRAME"
mainFrame.Size = UDim2.new(0, 50, 0, 50)
mainFrame.Position = UDim2.new(0.5, -25, 0, 30)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 110, 255)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

-- Perfect circle
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = mainFrame

-- Button with EXACT name "DUPING METHOD"
local dupingButton = Instance.new("TextButton")
dupingButton.Name = "DUPING_METHOD_BUTTON"
dupingButton.Size = UDim2.new(1, 0, 1, 0)
dupingButton.BackgroundTransparency = 1
dupingButton.Text = "DUPING METHOD"
dupingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
dupingButton.TextScaled = true
dupingButton.Font = Enum.Font.GothamBold
dupingButton.Parent = mainFrame

-- === CUSTOM DRAG (now connected to the button itself - this is the fix) ===
local dragging = false
local dragStart = nil
local startPos = nil

local function updateDrag(input)
    if not dragging then return end
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

-- DRAG START + MOVEMENT now on the button (fixes the issue)
dupingButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

dupingButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        updateDrag(input)
    end
end)

-- Global fallback for smooth drag even if finger leaves the tiny button
UserInputService.InputChanged:Connect(function(input)
    if dragging then
        updateDrag(input)
    end
end)

-- Click = instant reset (duping method)
dupingButton.MouseButton1Click:Connect(function()
    local character = player.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.Health = 0
        task.delay(0.1, function()
            if player.Character then
                player:LoadCharacter()
            end
        end)
    end
end)

print("✅ TINIEST DUPING METHOD button loaded + FIXED!")
print("Drag the tiny blue circle anywhere - mobile touch should now work perfectly")
