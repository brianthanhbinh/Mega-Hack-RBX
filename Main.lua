-- V64: ORBIT DISTANCE LOCK (PREVENTS FLING)
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local floatActive = false
local tornadoAll = false
local tornadoTouch = false
local platforms = {}

-- 1. UI SETUP
local parent = CoreGui:FindFirstChild("RobloxGui") or CoreGui
if parent:FindFirstChild("VortexSafe") then parent.VortexSafe:Destroy() end

local sg = Instance.new("ScreenGui", parent)
sg.Name = "VortexSafe"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 260, 0, 520)
main.Position = UDim2.new(0.8, -270, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.BorderSizePixel = 0
Instance.new("UICorner", main)

local header = Instance.new("Frame", main)
header.Size = UDim2.new(1, 0, 0, 35); header.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Instance.new("UICorner", header)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -40, 1, 0); title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "VORTEX V24: SAFE-ZONE"; title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1; title.Font = "GothamBold"; title.TextXAlignment = "Left"

local close = Instance.new("TextButton", header)
close.Size = UDim2.new(0, 30, 0, 30); close.Position = UDim2.new(1, -32, 0, 2)
close.Text = "×"; close.TextColor3 = Color3.new(1, 1, 1); close.BackgroundColor3 = Color3.fromRGB(200, 40, 40); Instance.new("UICorner", close)

-- Buttons
local function createBtn(text, pos, color)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0, 240, 0, 40); btn.Position = pos
    btn.Text = text; btn.BackgroundColor3 = color; btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = "GothamBold"; btn.TextSize = 11; Instance.new("UICorner", btn)
    return btn
end

local btnChaos = createBtn("MAP CHAOS (UNANCHOR)", UDim2.new(0, 10, 0, 45), Color3.fromRGB(120, 0, 0))
local btnTornadoAll = createBtn("TORNADO: ALL IN RANGE (OFF)", UDim2.new(0, 10, 0, 95), Color3.fromRGB(60, 0, 120))
local btnTornadoTouch = createBtn("TORNADO: ONLY TOUCHED (OFF)", UDim2.new(0, 10, 0, 145), Color3.fromRGB(45, 45, 45))
local btnFloat = createBtn("FLOAT PLATFORM: OFF [T]", UDim2.new(0, 10, 0, 195), Color3.fromRGB(30, 30, 30))

-- Inputs
local function createInput(name, pos, default)
    local lbl = Instance.new("TextLabel", main); lbl.Size = UDim2.new(0, 150, 0, 20); lbl.Position = pos
    lbl.Text = name; lbl.TextColor3 = Color3.new(0.8,0.8,0.8); lbl.BackgroundTransparency = 1; lbl.Font = "Gotham"
    local box = Instance.new("TextBox", main); box.Size = UDim2.new(0, 70, 0, 22); box.Position = pos + UDim2.new(0, 170, 0, 0)
    box.Text = tostring(default); box.BackgroundColor3 = Color3.fromRGB(30,30,30); box.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", box)
    return box
end

local inPullRange = createInput("Pull Range", UDim2.new(0, 10, 0, 250), 1000)
local inSpeed = createInput("Orbit Speed", UDim2.new(0, 10, 0, 285), 160)
local inOrbitDist = createInput("SAFE DISTANCE", UDim2.new(0, 10, 0, 320), 25) -- Keeps parts away
local inLift = createInput("Lift Force", UDim2.new(0, 10, 0, 355), 40)

-- 2. LOGIC
btnChaos.MouseButton1Click:Connect(function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v:IsDescendantOf(game.Players.LocalPlayer.Character) then
            v.Anchored = false; v.AssemblyLinearVelocity = Vector3.new(0, 10, 0)
        end
    end
end)

btnTornadoAll.MouseButton1Click:Connect(function()
    tornadoAll = not tornadoAll
    btnTornadoAll.Text = "TORNADO: ALL (" .. (tornadoAll and "ON" or "OFF") .. ")"
    btnTornadoAll.BackgroundColor3 = tornadoAll and Color3.fromRGB(150, 0, 255) or Color3.fromRGB(60, 0, 120)
end)

btnTornadoTouch.MouseButton1Click:Connect(function()
    tornadoTouch = not tornadoTouch
    btnTornadoTouch.Text = "TORNADO: TOUCH (" .. (tornadoTouch and "ON" or "OFF") .. ")"
    btnTornadoTouch.BackgroundColor3 = tornadoTouch and Color3.fromRGB(0, 100, 255) or Color3.fromRGB(45, 45, 45)
end)

btnFloat.MouseButton1Click:Connect(function()
    floatActive = not floatActive
    btnFloat.Text = "FLOAT PLATFORM: " .. (floatActive and "ON" or "OFF")
    btnFloat.BackgroundColor3 = floatActive and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(30, 30, 30)
    if not floatActive then for _,v in pairs(platforms) do v:Destroy() end platforms = {} end
end)

close.MouseButton1Click:Connect(function() 
    floatActive = false; tornadoAll = false; tornadoTouch = false
    for _,v in pairs(platforms) do v:Destroy() end sg:Destroy() 
end)

-- 3. PHYSICS LOOP
RunService.Heartbeat:Connect(function()
    local lp = game.Players.LocalPlayer
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = lp.Character.HumanoidRootPart
    local center = hrp.Position

    if floatActive then
        local pad = platforms["MyPad"]
        if not pad or not pad.Parent then
            pad = Instance.new("Part", workspace); pad.Size = Vector3.new(22, 1, 22); pad.Anchored = true
            pad.Transparency = 0.5; pad.Color = Color3.fromRGB(0, 255, 200); platforms["MyPad"] = pad
        end
        pad.CFrame = hrp.CFrame * CFrame.new(0, -3.5, 0)
    end

    if tornadoAll or tornadoTouch then
        local pRange = tonumber(inPullRange.Text) or 1000
        local speed = tonumber(inSpeed.Text) or 160
        local safeDist = tonumber(inOrbitDist.Text) or 25
        local lift = tonumber(inLift.Text) or 40

        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and not part.Anchored and not part:IsDescendantOf(lp.Character) then
                local offset = part.Position - center
                local dist = offset.Magnitude
                local doOrbit = false

                if tornadoTouch then
                    local touching = part:GetTouchingParts()
                    for _, t in pairs(touching) do
                        if (platforms["MyPad"] and t == platforms["MyPad"]) or t:IsDescendantOf(lp.Character) then
                            doOrbit = true; break
                        end
                    end
                elseif dist < pRange then
                    doOrbit = true
                end

                if doOrbit then
                    -- THE ANTI-FLING FIX
                    local radialForce = 0
                    if dist > safeDist + 5 then
                        radialForce = -50 -- Too far? Pull in.
                    elseif dist < safeDist - 5 then
                        radialForce = 80 -- Too close? Push away to avoid fling!
                    end

                    local orbitDir = Vector3.new(offset.Z, 0, -offset.X).Unit
                    part.AssemblyLinearVelocity = (orbitDir * speed) + (offset.Unit * radialForce) + Vector3.new(0, lift, 0)
                end
            end
        end
    end
end)

-- Draggable UI Logic
UIS.InputBegan:Connect(function(k, g) if not g and k.KeyCode == Enum.KeyCode.T then btnFloat.MouseButton1Click:Fire() end end)
local d, di, ds, sp
header.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true; ds = i.Position; sp = main.Position i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then d = false end end) end end)
header.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement then di = i end end)
RunService.RenderStepped:Connect(function() if d and di then local dl = di.Position - ds; main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + dl.X, sp.Y.Scale, sp.Y.Offset + dl.Y) end end)
