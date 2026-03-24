local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 220, 0, 420) -- Made taller for the extra box
Main.Position = UDim2.new(0.5, -110, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 2
Main.BorderColor3 = Color3.fromRGB(0, 255, 150)
Main.Active = true
Main.Draggable = true

local function createInput(placeholder, pos)
    local i = Instance.new("TextBox", Main)
    i.Size = UDim2.new(0.9, 0, 0, 35)
    i.Position = UDim2.new(0.05, 0, 0, pos)
    i.PlaceholderText = placeholder
    i.Text = ""
    i.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    i.TextColor3 = Color3.new(1, 1, 1)
    i.ClearTextOnFocus = false
    return i
end

-- TWO SEPARATE BOXES
local NameInput = createInput("Type Player NAME Here", 40)
local IDInput   = createInput("Type Asset/User ID Here", 80)

local function createBtn(text, pos, color)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(0.9, 0, 0, 35)
    b.Position = UDim2.new(0.05, 0, 0, pos)
    b.Text = text
    b.BackgroundColor3 = color or Color3.fromRGB(60, 60, 60)
    b.TextColor3 = Color3.new(1,1,1)
    return b
end

local SpawnBtn    = createBtn("Spawn by Name", 125, Color3.fromRGB(0, 100, 200))
local SkyBtn      = createBtn("Set Skybox (Use ID Box)", 170)
local DecalBtn    = createBtn("Spam Decals (Use ID Box)", 210)
local UnanchorBtn = createBtn("Unanchor Map", 250)
local LoadBtn     = createBtn("Open Loadstring", 295)
local CloseBtn    = createBtn("CLOSE & RESET", 360, Color3.fromRGB(150, 0, 0))

--- LOGIC ---

SpawnBtn.MouseButton1Click:Connect(function()
    local name = NameInput.Text
    local id
    
    -- Try to get ID from Name
    local success, result = pcall(function()
        return game:GetService("Players"):GetUserIdFromNameAsync(name)
    end)
    
    if success then
        id = result
        local s, model = pcall(function()
            return game:GetService("Players"):CreateHumanoidModelFromUserId(id)
        end)
        
        if s and model then
            model.Parent = workspace
            model:MoveTo(game.Players.LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(5, 0, 0))
            print("Successfully spawned " .. name)
        end
    else
        warn("User not found: " .. name)
    end
end)

SkyBtn.MouseButton1Click:Connect(function()
    local id = "rbxassetid://" .. (IDInput.Text:match("%d+") or "")
    local sky = game:GetService("Lighting"):FindFirstChildOfClass("Sky") or Instance.new("Sky", game:GetService("Lighting"))
    sky.SkyboxBk = id sky.SkyboxDn = id sky.SkyboxFt = id sky.SkyboxLf = id sky.SkyboxRt = id sky.SkyboxUp = id
end)

DecalBtn.MouseButton1Click:Connect(function()
    local id = "rbxassetid://" .. (IDInput.Text:match("%d+") or "")
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            local d = Instance.new("Decal", v)
            d.Texture = id
        end
    end
end)

UnanchorBtn.MouseButton1Click:Connect(function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then v.Anchored = false end
    end
end)

LoadBtn.MouseButton1Click:Connect(function()
    local url = "https://raw.githubusercontent.com/brianthanhbinh/Mega-Hack-RBX/main/Main.lua" 
    loadstring(game:HttpGet(url))()
end)

CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)