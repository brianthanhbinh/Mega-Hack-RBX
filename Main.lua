local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local LP = game.Players.LocalPlayer
local LT = game:GetService("Lighting")
local cam = workspace.CurrentCamera

local tornado, ring, shield, noclip, infJump, clickTp, glow, freecam, esp = false, false, false, false, false, false, false, false, false
local fcPart, origL = nil, {B = LT.Brightness, C = LT.ClockTime}

-- 1. UI CORE
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"):FindFirstChild("RobloxGui") or LP:WaitForChild("PlayerGui"))
sg.Name = "VortexV144"; sg.ResetOnSpawn = false

local togBtn = Instance.new("TextButton", sg); togBtn.Size = UDim2.new(0, 40, 0, 40); togBtn.Position = UDim2.new(0, 10, 0.5, -20); togBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30); togBtn.Text = "V"; togBtn.TextColor3 = Color3.fromRGB(0, 180, 255); togBtn.Font = "GothamBold"; Instance.new("UICorner", togBtn)

local main = Instance.new("Frame", sg); main.Size = UDim2.new(0, 580, 0, 480); main.Position = UDim2.new(0.5, -290, 0.25, 0); main.BackgroundColor3 = Color3.fromRGB(10, 10, 15); main.BackgroundTransparency = 0.1; Instance.new("UICorner", main)
togBtn.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)

local head = Instance.new("Frame", main); head.Size = UDim2.new(1, 0, 0, 40); head.BackgroundColor3 = Color3.fromRGB(25, 25, 35); Instance.new("UICorner", head)
local close = Instance.new("TextButton", head); close.Size = UDim2.new(0, 30, 0, 30); close.Position = UDim2.new(1, -35, 0, 5); close.Text = "×"; close.BackgroundColor3 = Color3.fromRGB(180, 40, 40); close.TextColor3 = Color3.new(1,1,1); close.MouseButton1Click:Connect(function() sg:Destroy() end); Instance.new("UICorner", close)
local mini = Instance.new("TextButton", head); mini.Size = UDim2.new(0, 30, 0, 30); mini.Position = UDim2.new(1, -70, 0, 5); mini.Text = "-"; mini.BackgroundColor3 = Color3.fromRGB(50, 50, 60); mini.TextColor3 = Color3.new(1,1,1); mini.MouseButton1Click:Connect(function() main.Visible = false end); Instance.new("UICorner", mini)

-- DRAG
local d, sP, dP; head.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true; sP = i.Position; dP = main.Position end end)
UIS.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement and d then local delta = i.Position - sP; main.Position = UDim2.new(dP.X.Scale, dP.X.Offset + delta.X, dP.Y.Scale, dP.Y.Offset + delta.Y) end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)

local container = Instance.new("Frame", main); container.Size = UDim2.new(1, -20, 1, -95); container.Position = UDim2.new(0, 10, 0, 85); container.BackgroundTransparency = 1
local function pge() 
    local p = Instance.new("ScrollingFrame", container); p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.Visible = false; p.ScrollBarThickness = 2; p.AutomaticCanvasSize = "Y"
    local l = Instance.new("UIGridLayout", p); l.CellSize = UDim2.new(0.5, -8, 0, 35); l.CellPadding = UDim2.new(0, 10, 0, 10); return p 
end
local pM, pS, pR, pSh, pT, pF = pge(), pge(), pge(), pge(), pge(), pge(); pM.Visible = true

local function tgl(t, p, f) 
    local act = false; local b = Instance.new("TextButton", p); b.BackgroundColor3 = Color3.fromRGB(40, 40, 50); b.Text = t; b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"; b.TextSize = 10; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() act = not act; b.BackgroundColor3 = act and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(40, 40, 50); f(act) end)
end
local function inp(t, p, d) 
    local f = Instance.new("Frame", p); f.BackgroundTransparency = 1; local l = Instance.new("TextLabel", f); l.Size = UDim2.new(0.4, 0, 1, 0); l.Text = t; l.TextColor3 = Color3.new(0.8,0.8,0.8); l.TextSize = 9;
    local i = Instance.new("TextBox", f); i.Size = UDim2.new(0.55, 0, 0.8, 0); i.Position = UDim2.new(0.45, 0, 0.1, 0); i.Text = d; i.BackgroundColor3 = Color3.fromRGB(30, 30, 45); i.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", i); return i 
end

-- POPULATE TABS
tgl("BOX ESP", pM, function(v) esp = v end)
tgl("FREECAM", pM, function(v) freecam = v end)
tgl("INF JUMP", pM, function(v) infJump = v end)
tgl("NOCLIP", pM, function(v) noclip = v end)
tgl("CLICK TP (CTRL)", pM, function(v) clickTp = v end)
local pN = inp("Player Name", pM, ""); tgl("TP TO PLAYER", pM, function() local t = game.Players:FindFirstChild(pN.Text); if t and t.Character then LP.Character:MoveTo(t.Character.HumanoidRootPart.Position) end end)
local WS, JP = inp("Speed", pM, "16"), inp("Jump", pM, "50")

tgl("IY ADMIN", pT, function() loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() end)
tgl("F3X BUILDER", pT, function() loadstring(game:HttpGet("https://raw.githubusercontent.com/FrenzySploit/FrenzySploit/main/F3X.lua"))() end)
tgl("DEX", pT, function() loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))() end)
tgl("BTOOLS (LITE)", pT, function() for i,v in pairs(Enum.BinType:GetEnumItems()) do Instance.new("HopperBin", LP.Backpack).BinType = v end end)

tgl("SHIELD ACTIVE", pSh, function(v) shield = v end); local shR, shF = inp("Range", pSh, "60"), inp("Force", pSh, "400")
tgl("STORM ACTIVE", pS, function(v) tornado = v end); local sR, sL, sS = inp("Range", pS, "1000"), inp("Layers", pS, "5"), inp("Speed", pS, "180")

local skI = inp("Sky ID", pF, "6073715111"); tgl("APPLY SKY", pF, function() local s = LT:FindFirstChildOfClass("Sky") or Instance.new("Sky", LT); local t = "rbxassetid://"..skI.Text; s.SkyboxBk, s.SkyboxDn, s.SkyboxFt, s.SkyboxLf, s.SkyboxRt, s.SkyboxUp = t, t, t, t, t, t end)
tgl("FULLBRIGHT", pF, function(v) glow = v end)

-- ESP & ENGINE
local function makeEsp(p) if p == LP then return end local b = Instance.new("BoxHandleAdornment", sg); b.AlwaysOnTop = true; b.ZIndex = 10; b.Transparency = 0.5; b.Color3 = Color3.new(0, 1, 1); RS.RenderStepped:Connect(function() if esp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then b.Adornee = p.Character.HumanoidRootPart; b.Size = p.Character.HumanoidRootPart.Size * 1.5; b.Visible = true else b.Visible = false end end) end
for _, p in pairs(game.Players:GetPlayers()) do makeEsp(p) end; game.Players.PlayerAdded:Connect(makeEsp)

RS.Stepped:Connect(function()
    local c = LP.Character or LP.CharacterAdded:Wait(); local h = c:FindFirstChild("HumanoidRootPart") if not h then return end
    c.Humanoid.WalkSpeed, c.Humanoid.JumpPower = tonumber(WS.Text) or 16, tonumber(JP.Text) or 50
    if noclip then for _,v in pairs(c:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    if glow then LT.Brightness = 2 else LT.Brightness = origL.B end
    if freecam then
        if not fcPart then fcPart = Instance.new("Part", workspace); fcPart.Anchored, fcPart.CanCollide, fcPart.Transparency = true, false, 1; fcPart.Position = cam.CFrame.p; h.Anchored = true end
        cam.CameraSubject = fcPart; local m = Vector3.new(0,0,0); if UIS:IsKeyDown("W") then m = m + cam.CFrame.LookVector end if UIS:IsKeyDown("S") then m = m - cam.CFrame.LookVector end if UIS:IsKeyDown("A") then m = m - cam.CFrame.RightVector end if UIS:IsKeyDown("D") then m = m + cam.CFrame.RightVector end fcPart.Position = fcPart.Position + (m * 2.5)
    else cam.CameraSubject = c.Humanoid; if fcPart then fcPart:Destroy(); fcPart = nil; h.Anchored = false end end
    if shield or tornado then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v.Anchored and not v:IsDescendantOf(c) then
                local d = (v.Position - h.Position).Magnitude
                if shield and d < (tonumber(shR.Text) or 60) then v.AssemblyLinearVelocity = (v.Position-h.Position).Unit * (tonumber(shF.Text) or 400)
                elseif tornado and d < (tonumber(sR.Text) or 1000) then v.AssemblyLinearVelocity = Vector3.new((v.Position-h.Position).Z, 0, -(v.Position-h.Position).X).Unit * (tonumber(sS.Text) or 180) + Vector3.new(0, (h.Position.Y+30-v.Position.Y)*25, 0) end
            end
        end
    end
end)

local function mt(n, x, pg) local b = Instance.new("TextButton", main); b.Size = UDim2.new(1/6, -4, 0, 35); b.Position = UDim2.new(x, 2, 0, 45); b.Text = n; b.BackgroundColor3 = Color3.fromRGB(30, 30, 45); b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"; b.MouseButton1Click:Connect(function() pM.Visible, pS.Visible, pR.Visible, pSh.Visible, pT.Visible, pF.Visible = false, false, false, false, false, false; pg.Visible = true end); Instance.new("UICorner", b) end
mt("MAIN", 0, pM); mt("STRM", 1/6, pS); mt("RING", 2/6, pR); mt("SHLD", 3/6, pSh); mt("TOOL", 4/6, pT); mt("FUN", 5/6, pF)
UIS.InputBegan:Connect(function(i, g) if not g and clickTp and i.UserInputType == Enum.UserInputType.MouseButton1 and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then LP.Character:MoveTo(LP:GetMouse().Hit.p) end end)
UIS.JumpRequest:Connect(function() if infJump then LP.Character.Humanoid:ChangeState(3) end end)
