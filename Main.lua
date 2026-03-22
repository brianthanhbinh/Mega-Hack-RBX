--[[
    MEGA HACK V145
    - ADD:Skybox thingy
    - FIXED: Skybox now uses DECAL ID and turns OFF correctly
    - FIXED: Shield Visualizer (SHOW RANGE) added to SHLD tab.
    - FIXED: All settings (Range, Speed, etc.) restored to all tabs.
    - MOBILE: Added Panic/Minimize "V" button for stealth.
]]

local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local LP = game.Players.LocalPlayer
local CG = game:GetService("CoreGui")
local LT = game:GetService("Lighting")
local cam = workspace.CurrentCamera

-- 1. UI CORE SETUP
local sg = Instance.new("ScreenGui", CG:FindFirstChild("RobloxGui") or LP:WaitForChild("PlayerGui"))
sg.Name = "VortexV145_Final"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 580, 0, 520)
main.Position = UDim2.new(0.5, -290, 0.2, 0)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
Instance.new("UICorner", main)

local head = Instance.new("Frame", main)
head.Size = UDim2.new(1, 0, 0, 40)
head.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
Instance.new("UICorner", head)

-- MOBILE MINIMIZE BUTTON (STEALTH "V")
local miniBtn = Instance.new("TextButton", sg)
miniBtn.Size = UDim2.new(0, 40, 0, 40)
miniBtn.Position = UDim2.new(0, 5, 0.5, 0)
miniBtn.Text = "V"
miniBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
miniBtn.TextColor3 = Color3.new(1,1,1)
miniBtn.Visible = false
Instance.new("UICorner", miniBtn)

local close = Instance.new("TextButton", head)
close.Size = UDim2.new(0, 35, 0, 35)
close.Position = UDim2.new(1, -40, 0, 2)
close.Text = "×"
close.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
close.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", close)

local mini = Instance.new("TextButton", head)
mini.Size = UDim2.new(0, 35, 0, 35)
mini.Position = UDim2.new(1, -80, 0, 2)
mini.Text = "-"
mini.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
mini.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", mini)

close.MouseButton1Click:Connect(function() sg:Destroy() end)
mini.MouseButton1Click:Connect(function() main.Visible = false; miniBtn.Visible = true end)
miniBtn.MouseButton1Click:Connect(function() main.Visible = true; miniBtn.Visible = false end)

-- 2. TAB UTILITIES
local container = Instance.new("Frame", main)
container.Size = UDim2.new(1, -20, 1, -120)
container.Position = UDim2.new(0, 10, 0, 110)
container.BackgroundTransparency = 1

local function createPage() 
    local p = Instance.new("ScrollingFrame", container)
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.ScrollBarThickness = 6
    p.AutomaticCanvasSize = "Y"
    local l = Instance.new("UIGridLayout", p)
    l.CellSize = UDim2.new(0.5, -10, 0, 45)
    l.CellPadding = UDim2.new(0, 10, 0, 10)
    return p 
end

local pM, pS, pR, pSh, pT, pF = createPage(), createPage(), createPage(), createPage(), createPage(), createPage()
pM.Visible = true

local function tgl(t, p, f) 
    local act = false
    local b = Instance.new("TextButton", p)
    b.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    b.Text = t; b.TextColor3 = Color3.new(1,1,1)
    b.Font = "GothamBold"; b.TextSize = 10
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() 
        act = not act
        b.BackgroundColor3 = act and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(35, 35, 40)
        f(act) 
    end)
end

local function inp(t, p, d) 
    local f = Instance.new("Frame", p); f.BackgroundTransparency = 1
    local l = Instance.new("TextLabel", f); l.Size = UDim2.new(0.4, 0, 1, 0); l.Text = t; l.TextColor3 = Color3.new(0.8,0.8,0.8); l.TextSize = 8;
    local i = Instance.new("TextBox", f); i.Size = UDim2.new(0.55, 0, 0.8, 0); i.Position = UDim2.new(0.45, 0, 0.1, 0); i.Text = d; i.BackgroundColor3 = Color3.fromRGB(20, 20, 25); i.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", i)
    return i 
end

local function btn(t, p, f) 
    local b = Instance.new("TextButton", p)
    b.Text = t; b.BackgroundColor3 = Color3.fromRGB(45, 45, 50); b.TextColor3 = Color3.new(1,1,1)
    b.Font = "GothamBold"; b.TextSize = 10; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(f)
end

-- 3. FEATURE ASSIGNMENT
-- [MAIN]
tgl("NOCLIP", pM, function(v) _G.noclip = v end)
tgl("INF JUMP", pM, function(v) _G.infjump = v end)
local WS = inp("SPEED", pM, "25")
local JP = inp("JUMP", pM, "50")
tgl("FREECAM", pM, function(v) 
    if v then _G.fpart = Instance.new("Part", workspace); _G.fpart.Anchored = true; _G.fpart.Transparency = 1; _G.fpart.CFrame = cam.CFrame; cam.CameraSubject = _G.fpart
    else cam.CameraSubject = LP.Character.Humanoid; if _G.fpart then _G.fpart:Destroy() end end
end)
btn("PANIC HIDE", pM, function() main.Visible = false; miniBtn.Visible = true end)

-- [STRM] (TORNADO)
tgl("ACTIVE", pS, function(v) _G.tornado = v end)
local sR = inp("RANGE", pS, "1200"); local sS = inp("SPEED", pS, "450")
local sY = inp("START Y", pS, "-15"); local sD = inp("Y GAP", pS, "15")

-- [RING]
tgl("ACTIVE", pR, function(v) _G.ring = v end)
local rR = inp("RANGE", pR, "800"); local rS = inp("SPEED", pR, "300")
local rY = inp("START Y", pR, "0"); local rD = inp("Y GAP", pR, "10")

-- [SHLD] (SHIELD)
tgl("ACTIVE", pSh, function(v) _G.shield = v end)
tgl("SHOW RANGE", pSh, function(v) _G.showshield = v end)
local shDist = inp("DIST", pSh, "50"); local shForce = inp("FORCE", pSh, "1000")

-- [TOOL]
btn("DEX", pT, function() loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))() end)
btn("IY ADMIN", pT, function() loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() end)
local pmID = inp("PM ID", pT, "102555550"); btn("PM SPAWN", pT, function() pcall(function() local m = game:GetObjects("rbxassetid://"..pmID.Text)[1]; m.Parent = workspace; m:MoveTo(LP.Character.HumanoidRootPart.Position) end) end)

-- [FUN]
tgl("UNANCHOR", pF, function(v) _G.unanchor = v end)
local imgID = inp("DECAL ID", pF, "13426164417") 
tgl("SKY SWITCH", pF, function(v) _G.skybox = v end)
tgl("SKY SPIN", pF, function(v) _G.skyspin = v end)
tgl("DECAL SWITCH", pF, function(v) _G.decalspam = v end)

-- 4. THE MAIN LOOP (STARTS HERE)
RS.Stepped:Connect(function()
    local c = LP.Character; if not c or not c:FindFirstChild("HumanoidRootPart") then return end
    local h = c.HumanoidRootPart
    
    -- WalkSpeed/JumpPower Fix
    c.Humanoid.WalkSpeed = tonumber(WS.Text) or 25
    c.Humanoid.JumpPower = tonumber(JP.Text) or 50

    -- SKY ENGINE (TOMATO SKY)
    if _G.skybox then
        local s = LT:FindFirstChild("VortexSky") or Instance.new("Sky", LT)
        s.Name = "VortexSky"
        local id = "rbxassetid://" .. imgID.Text
        s.SkyboxBk = id; s.SkyboxDn = id; s.SkyboxFt = id; s.SkyboxLf = id; s.SkyboxRt = id; s.SkyboxUp = id
        if _G.skyspin then LT.ClockTime = (LT.ClockTime + 0.01) % 24 end
    else
        if LT:FindFirstChild("VortexSky") then LT.VortexSky:Destroy() end
    end

    -- SHIELD VISUALIZER (RED SPHERE)
    if _G.showshield then
        local v = workspace:FindFirstChild("VortexShieldVis") or Instance.new("Part", workspace)
        v.Name = "VortexShieldVis"; v.Shape = "Ball"; v.Material = "ForceField"; v.Color = Color3.new(1,0,0); v.Transparency = 0.7; v.Anchored = true; v.CanCollide = false
        local d = tonumber(shDist.Text) or 50
        v.Size = Vector3.new(d*2, d*2, d*2); v.CFrame = h.CFrame
    else
        if workspace:FindFirstChild("VortexShieldVis") then workspace.VortexShieldVis:Destroy() end
    end

    -- GLOBAL OBJECT MANIPULATION (DECALS + PHYSICS)
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v.Anchored and not v:IsDescendantOf(c) then
            local dist = (v.Position - h.Position).Magnitude
            
            -- Tomato Decals
            if _G.decalspam and not v:FindFirstChild("TomatoDecal") then
                for _,face in pairs(Enum.NormalId:GetEnumItems()) do
                    local d = Instance.new("Decal", v); d.Name = "TomatoDecal"; d.Texture = "rbxassetid://"..imgID.Text; d.Face = face
                end
            end

            -- Physics (Shield/Tornado/Ring)
            if _G.shield and dist < (tonumber(shDist.Text) or 50) then
                v.AssemblyLinearVelocity = (v.Position - h.Position).Unit * (tonumber(shForce.Text) or 1000)
            elseif _G.tornado and dist < (tonumber(sR.Text) or 1200) then
                local idx = (math.floor(v.Position.Y / (tonumber(sD.Text) or 15)) % 12)
                local tY = h.Position.Y + (tonumber(sY.Text) or -15) + (idx * (tonumber(sD.Text) or 15))
                v.AssemblyLinearVelocity = Vector3.new((v.Position-h.Position).Z, 0, -(v.Position-h.Position).X).Unit * (tonumber(sS.Text) or 450) + Vector3.new(0, (tY - v.Position.Y) * 40, 0)
            end
        end
    end
end)

-- 5. NAVIGATION & DRAG
local function mt(n, x, pg) 
    local b = Instance.new("TextButton", main); b.Size = UDim2.new(1/6, -4, 0, 40); b.Position = UDim2.new(x, 2, 0, 45); b.Text = n; b.BackgroundColor3 = Color3.fromRGB(30, 30, 35); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() 
        pM.Visible, pS.Visible, pR.Visible, pSh.Visible, pT.Visible, pF.Visible = false, false, false, false, false, false
        pg.Visible = true 
    end)
end
mt("MAIN", 0, pM); mt("STRM", 1/6, pS); mt("RING", 2/6, pR); mt("SHLD", 3/6, pSh); mt("TOOL", 4/6, pT); mt("FUN", 5/6, pF)

-- TOUCH DRAG SYSTEM
local d, sP, dP
head.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = true; sP = i.Position; dP = main.Position end end)
UIS.InputChanged:Connect(function(i) if (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) and d then local delta = i.Position - sP; main.Position = UDim2.new(dP.X.Scale, dP.X.Offset + delta.X, dP.Y.Scale, dP.Y.Offset + delta.Y) end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = false end end)
