-- V82: FIXED BUTTON LOGIC + CRASH PROOF PHYSICS
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local lp = game.Players.LocalPlayer
local tornadoActive, ringActive, shieldActive, floatActive = false, false, false, false
local platforms = {}
local shieldPart = nil

-- 1. KILL SWITCH
local function stopAll()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v.Anchored and not v:IsDescendantOf(lp.Character) then
            v.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            v.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end
    end
end

-- 2. UI ROOT
local sg = Instance.new("ScreenGui", CoreGui:FindFirstChild("RobloxGui") or CoreGui); sg.Name = "VortexV42"
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 280, 0, 520); main.Position = UDim2.new(0.5, -140, 0.2, 0)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 15); main.BorderSizePixel = 0
Instance.new("UICorner", main)

local head = Instance.new("Frame", main); head.Size = UDim2.new(1, 0, 0, 35); head.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Instance.new("UICorner", head)
local close = Instance.new("TextButton", head); close.Size = UDim2.new(0, 30, 0, 30); close.Position = UDim2.new(1, -32, 0, 2); close.Text = "×"; close.BackgroundColor3 = Color3.fromRGB(180, 0, 0); close.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", close)

-- Tabs
local tBar = Instance.new("Frame", main); tBar.Size = UDim2.new(1, 0, 0, 30); tBar.Position = UDim2.new(0,0,0,35); tBar.BackgroundColor3 = Color3.fromRGB(20,20,20)
local function mTab(nm, x, w)
    local b = Instance.new("TextButton", tBar); b.Size = UDim2.new(w, 0, 1, 0); b.Position = UDim2.new(x, 0, 0, 0)
    b.Text = nm; b.BackgroundColor3 = Color3.fromRGB(25,25,30); b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"; b.TextSize = 8; return b
end
local tS = mTab("STORM", 0, 0.25); local tR = mTab("RING", 0.25, 0.25); local tSh = mTab("SHIELD", 0.5, 0.25); local tO = mTab("OTHER", 0.75, 0.25)

local function mPage()
    local p = Instance.new("ScrollingFrame", main); p.Size = UDim2.new(1,-20,1,-75); p.Position = UDim2.new(0,10,0,70)
    p.BackgroundTransparency = 1; p.ScrollBarThickness = 2; p.AutomaticCanvasSize = "Y"; Instance.new("UIListLayout", p).Padding = UDim.new(0,5); return p
end
local pS, pR, pSh, pO = mPage(), mPage(), mPage(), mPage(); pR.Visible, pSh.Visible, pO.Visible = false, false, false

tS.MouseButton1Click:Connect(function() pS.Visible, pR.Visible, pSh.Visible, pO.Visible = true, false, false, false end)
tR.MouseButton1Click:Connect(function() pS.Visible, pR.Visible, pSh.Visible, pO.Visible = false, true, false, false end)
tSh.MouseButton1Click:Connect(function() pS.Visible, pR.Visible, pSh.Visible, pO.Visible = false, false, true, false end)
tO.MouseButton1Click:Connect(function() pS.Visible, pR.Visible, pSh.Visible, pO.Visible = false, false, false, true end)

-- Helpers
local function uBtn(txt, prnt, clr)
    local b = Instance.new("TextButton", prnt); b.Size = UDim2.new(1, 0, 0, 35); b.BackgroundColor3 = clr; b.Text = txt; b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"; Instance.new("UICorner", b); return b
end
local function uInp(txt, prnt, def)
    local f = Instance.new("Frame", prnt); f.Size = UDim2.new(1, 0, 0, 30); f.BackgroundTransparency = 1
    local l = Instance.new("TextLabel", f); l.Size = UDim2.new(0.6, 0, 1, 0); l.Text = txt; l.TextColor3 = Color3.new(0.7,0.7,0.7); l.BackgroundTransparency = 1; l.TextXAlignment = "Left"
    local b = Instance.new("TextBox", f); b.Size = UDim2.new(0.35, 0, 0.8, 0); b.Position = UDim2.new(0.65, 0, 0.1, 0); b.Text = tostring(def); b.BackgroundColor3 = Color3.fromRGB(30,30,30); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b); return b
end

-- Settings
local bS = uBtn("STORM: OFF", pS, Color3.fromRGB(80, 0, 180))
local sRange = uInp("Search Range", pS, 1000)
local sLays = uInp("Layer Count", pS, 5)
local sY = uInp("Starting Y", pS, 20)
local sVGap = uInp("Layer Height (Y)", pS, 15)
local sHGap = uInp("Layer Width (X)", pS, 10)
local sSafe = uInp("Safe Distance", pS, 35)
local sSpd = uInp("Spin Speed", pS, 180)

local bR = uBtn("SATURN: OFF", pR, Color3.fromRGB(0, 100, 200))
local rRange = uInp("Search Range", pR, 800)
local rCount = uInp("Ring Count", pR, 4)
local rSafe = uInp("Safe Distance", pR, 45)
local rGap = uInp("Ring Spacing", pR, 20)
local rShrink = uInp("Shrink Per Ring", pR, 5)
local rSpd = uInp("Orbit Speed", pR, 120)

local bSh = uBtn("PUSH SHIELD: OFF", pSh, Color3.fromRGB(180, 80, 0))
local shRange = uInp("Shield Range", pSh, 50)
local shForce = uInp("Push Force", pSh, 300)
local bVis = uBtn("VISIBILITY: OFF", pSh, Color3.fromRGB(50, 50, 50))

local bFloat = uBtn("FLOAT PAD: OFF", pO, Color3.fromRGB(40, 40, 40))
local bUnanchor = uBtn("UNANCHOR MAP", pO, Color3.fromRGB(120, 0, 0))

-- 3. TOGGLE REPAIR (FIXED CLICK LOGIC)
local function updateButtons()
    bS.Text = "STORM: "..(tornadoActive and "ON" or "OFF")
    bR.Text = "SATURN: "..(ringActive and "ON" or "OFF")
    bSh.Text = "PUSH SHIELD: "..(shieldActive and "ON" or "OFF")
    bFloat.Text = "FLOAT PAD: "..(floatActive and "ON" or "OFF")
end

bS.MouseButton1Click:Connect(function() 
    tornadoActive = not tornadoActive
    if tornadoActive then ringActive = false; shieldActive = false end
    stopAll(); updateButtons()
end)

bR.MouseButton1Click:Connect(function() 
    ringActive = not ringActive
    if ringActive then tornadoActive = false; shieldActive = false end
    stopAll(); updateButtons()
end)

bSh.MouseButton1Click:Connect(function() 
    shieldActive = not shieldActive
    if shieldActive then tornadoActive = false; ringActive = false end
    stopAll(); updateButtons()
end)

bVis.MouseButton1Click:Connect(function() 
    if shieldPart then shieldPart:Destroy(); shieldPart = nil; bVis.Text = "VISIBILITY: OFF" 
    else shieldPart = Instance.new("Part", workspace); shieldPart.Shape = "Ball"; shieldPart.Anchored = true; shieldPart.CanCollide = false; shieldPart.Material = "ForceField"; shieldPart.Transparency = 0.5; bVis.Text = "VISIBILITY: ON" end 
end)

bFloat.MouseButton1Click:Connect(function() floatActive = not floatActive; updateButtons() end)
bUnanchor.MouseButton1Click:Connect(function() for _,v in pairs(workspace:GetDescendants()) do if v:IsA("BasePart") and not v:IsDescendantOf(lp.Character) then v.Anchored = false end end end)
close.MouseButton1Click:Connect(function() stopAll(); if shieldPart then shieldPart:Destroy() end if platforms["Pad"] then platforms["Pad"]:Destroy() end sg:Destroy() end)

-- 4. PHYSICS ENGINE
RunService.Heartbeat:Connect(function()
    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if shieldPart then shieldPart.Position = hrp.Position; shieldPart.Size = Vector3.new(1,1,1) * (tonumber(shRange.Text) or 50) * 2 end
    if floatActive then local p = platforms["Pad"] or Instance.new("Part", workspace); p.Size = Vector3.new(25, 1, 25); p.Anchored = true; p.Transparency = 0.5; p.CFrame = hrp.CFrame * CFrame.new(0,-3.55,0); platforms["Pad"] = p else if platforms["Pad"] then platforms["Pad"]:Destroy(); platforms["Pad"] = nil end end

    if tornadoActive or ringActive or shieldActive then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v.Anchored and not v:IsDescendantOf(lp.Character) then
                local off = v.Position - hrp.Position; local dist = off.Magnitude
                
                if shieldActive and dist < (tonumber(shRange.Text) or 50) then
                    v.AssemblyLinearVelocity = off.Unit * (tonumber(shForce.Text) or 300)
                elseif tornadoActive and dist < (tonumber(sRange.Text) or 1000) then
                    local lIdx = (v.Name:len() % (tonumber(sLays.Text) or 5)) -- Stable indexing
                    local tH = hrp.Position.Y + (tonumber(sY.Text) or 20) + (lIdx * (tonumber(sVGap.Text) or 15))
                    local tD = (tonumber(sSafe.Text) or 35) + (lIdx * (tonumber(sHGap.Text) or 10))
                    local rad = (dist > tD + 2) and -70 or (dist < tD - 2) and 90 or 0
                    v.AssemblyLinearVelocity = (Vector3.new(off.Z, 0, -off.X).Unit * (tonumber(sSpd.Text) or 180)) + (off.Unit * rad) + Vector3.new(0, (tH - v.Position.Y) * 15, 0)
                elseif ringActive and dist < (tonumber(rRange.Text) or 800) then
                    local rIdx = (v.Name:len() % (tonumber(rCount.Text) or 4))
                    local tD = (tonumber(rSafe.Text) or 45) + (rIdx * (tonumber(rGap.Text) or 20)) - (rIdx * (tonumber(rShrink.Text) or 5))
                    local rad = (dist > tD + 2) and -70 or (dist < tD - 2) and 90 or 0
                    v.AssemblyLinearVelocity = (Vector3.new(off.Z, 0, -off.X).Unit * (tonumber(rSpd.Text) or 120)) + (off.Unit * rad) + Vector3.new(0, (hrp.Position.Y - v.Position.Y) * 15, 0)
                end
            end
        end
    end
end)

-- Dragging
local drag, dPoint, startPos
head.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true; dPoint = i.Position; startPos = main.Position end end)
UIS.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement and drag then local delta = i.Position - dPoint; main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
