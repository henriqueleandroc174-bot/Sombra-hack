local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
Name = "Ney Hub V1",
LoadingTitle = "Carregando Ney Hub V1...",
LoadingSubtitle = "by Gemini",
ConfigurationSaving = {
Enabled = false
},
KeySystem = false
})

-- NOTIFICAÇÃO
Rayfield:Notify({
Title = "Executado com Sucesso",
Content = "Ney Hub V1 Ativado!",
Duration = 5,
Image = 4483362458,
Actions = {
Ignore = {
Name = "Fechar",
Callback = function() end
},
},
})

-- ============================================
-- VARIÁVEIS
-- ============================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local atravessar_players_ativado = false
local ant_pulo_ativado = false
local auto_desarme_ativado = false
local speed_ativado = false
local powershoot_ativado = false
local bola_chiclete_ativado = false
local gols = 0

-- CACHE
local Cache = {
Character = nil,
RootPart = nil,
Humanoid = nil,
Ball = nil
}

local function UpdateCharacterCache()
Cache.Character = LocalPlayer.Character
if Cache.Character then
Cache.RootPart = Cache.Character:FindFirstChild("HumanoidRootPart")
Cache.Humanoid = Cache.Character:FindFirstChildOfClass("Humanoid")
end
end

LocalPlayer.CharacterAdded:Connect(function()
task.wait(0.5)
UpdateCharacterCache()
end)

UpdateCharacterCache()

-- ============================================
-- FUNÇÃO GET BALL
-- ============================================
local function GetBall()
Cache.Ball = workspace:FindFirstChild("Ball") or workspace:FindFirstChild("Football") or workspace:FindFirstChild("Soccerball")
return Cache.Ball
end

-- ============================================
-- FUNÇÃO ATRAVESSAR
-- ============================================
local function AtravessarPlayers()
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LocalPlayer and plr.Character then
for _, part in ipairs(plr.Character:GetDescendants()) do
if part:IsA("BasePart") then
if atravessar_players_ativado then
part.CanCollide = false
else
part.CanCollide = true
end
end
end
end
end
end

-- ============================================
-- FUNÇÃO BOLA CHICLETE
-- ============================================
local function BolaBorracha()
if not bola_chiclete_ativado then return end
local ball = GetBall()
if not ball or not Cache.RootPart then return end
pcall(function()
ball.CanCollide = false
local dist = (ball.Position - Cache.RootPart.Position).Magnitude
if dist < 5 then
ball.CFrame = Cache.RootPart.CFrame * CFrame.new(0, 0, -3)
ball.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
end
end)
end

-- ============================================
-- FUNÇÃO AUTO DESARME
-- ============================================
local function SmartAutoTackle()
if not auto_desarme_ativado then return end
local ball = GetBall()
if not ball or not Cache.RootPart then return end

local closestDist = 12
local target = nil

for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LocalPlayer and plr.Character then
local root = plr.Character:FindFirstChild("HumanoidRootPart")
if root then
local dist = (root.Position - Cache.RootPart.Position).Magnitude
if dist < closestDist then
closestDist = dist
target = root
end
end
end
end

if target then
pcall(function()
ball.CFrame = Cache.RootPart.CFrame * CFrame.new(0, 2, -3)
ball.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
end)
end
end

-- ============================================
-- POWER SHOOT CAVAL
-- ============================================
local massParts = {}
local INTERNAL_LAYERS = 4
local BASE_SCALE = 0.85
local SCALE_STEP = 0.08
local DENSITY = 12.8
local ANTI_TRASPASO_MULT = 1.7

local function removeMasses()
for _, part in ipairs(massParts) do
if part and part.Parent then
part:Destroy()
end
end
massParts = {}
end

local function reinforceCharacter()
local char = LocalPlayer.Character
if not char then return end

removeMasses()

local parts = {}
for _, v in ipairs(char:GetChildren()) do
if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
table.insert(parts, v)
end
end
for _, part in ipairs(parts) do
for i = 1, INTERNAL_LAYERS do
local scale = BASE_SCALE - (i - 1) * SCALE_STEP
local mass = Instance.new("Part")
mass.Name = "InternalMass_" .. i
mass.Size = part.Size * scale
mass.CFrame = part.CFrame
mass.Transparency = 1
mass.CanCollide = false
mass.CanTouch = false
mass.CanQuery = false
mass.Massless = false
mass.CustomPhysicalProperties = PhysicalProperties.new(DENSITY * ANTI_TRASPASO_MULT, 0, 0, 0, 0)
local weld = Instance.new("WeldConstraint")
weld.Part0 = part
weld.Part1 = mass
weld.Parent = mass
mass.Parent = part
table.insert(massParts, mass)
end
end
end

-- ============================================
-- INTERFACE - ABAS
-- ============================================
local TabPrincipal = Window:CreateTab("Principal", 4483362458)
local TabOtimizacao = Window:CreateTab("Otimização", 4483362458)
local TabPlacar = Window:CreateTab("Placar", 4483362458)

-- ============================================
-- ABA PRINCIPAL
-- ============================================
TabPrincipal:CreateSection("Movimentação e Trapaças")

TabPrincipal:CreateToggle({
Name = "Atravessar Players/Bola (Ghost Mode)",
CurrentValue = false,
Callback = function(Value)
atravessar_players_ativado = Value
AtravessarPlayers()
end,
})

TabPrincipal:CreateToggle({
Name = "Speed 27 (Disfarçada)",
CurrentValue = false,
Callback = function(Value)
speed_ativado = Value
local char = LocalPlayer.Character
if char and char:FindFirstChild("Humanoid") then
if Value then
char.Humanoid.WalkSpeed = 27
else
char.Humanoid.WalkSpeed = 16
end
end
end,
})

TabPrincipal:CreateToggle({
Name = "Anti Pulo",
CurrentValue = false,
Callback = function(Value)
ant_pulo_ativado = Value
local char = LocalPlayer.Character
if char and char:FindFirstChild("Humanoid") then
if Value then
char.Humanoid.JumpPower = 0
else
char.Humanoid.JumpPower = 50
end
end
end,
})

TabPrincipal:CreateSection("Controle de Bola")

TabPrincipal:CreateToggle({
Name = "Auto Desarme (Pega do Oponente)",
CurrentValue = false,
Callback = function(Value)
auto_desarme_ativado = Value
end,
})

TabPrincipal:CreateToggle({
Name = "Super Chute (PowerShoot Caval)",
CurrentValue = false,
Callback = function(Value)
powershoot_ativado = Value
if Value then
reinforceCharacter()
Rayfield:Notify({Title = "PowerShoot", Content = "Corpo Reforçado e Chute Ativado!", Duration = 2})
else
removeMasses()
end
end,
})

TabPrincipal:CreateToggle({
Name = "Bola Chiclete (Grudada)",
CurrentValue = false,
Callback = function(Value)
bola_chiclete_ativado = Value
end,
})

-- ============================================
-- ABA OTIMIZAÇÃO
-- ============================================
TabOtimizacao:CreateSection("Visual & Performance")

TabOtimizacao:CreateButton({
Name = "Remover Lag (Gráficos Low)",
Callback = function()
for _, v in pairs(game:GetDescendants()) do
if v:IsA("Pants") or v:IsA("Shirt") or v:IsA("Decal") or v:IsA("Texture") then
pcall(function() v:Destroy() end)
elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
pcall(function() v.Enabled = false end)
end
end
settings().Rendering.QualityLevel = 1
end,
})

-- ============================================
-- PLACAR
-- ============================================
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Frame = Instance.new("Frame", ScreenGui)
local TextLabel = Instance.new("TextLabel", Frame)

Frame.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
Frame.Position = UDim2.new(0.02, 0, 0.4, 0)
Frame.Size = UDim2.new(0, 100, 0, 50)
Frame.Active = true
Frame.Draggable = true
Frame.Visible = true

TextLabel.Size = UDim2.new(1, 0, 1, 0)
TextLabel.Text = "Gols: 0"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1
TextLabel.TextScaled = true

TabPlacar:CreateButton({
Name = "Gol +1",
Callback = function()
gols = gols + 1
TextLabel.Text = "Gols: " .. gols
end,
})

TabPlacar:CreateToggle({
Name = "Ver Contador",
CurrentValue = true,
Callback = function(Value)
Frame.Visible = Value
end,
})

-- ============================================
-- LOOP PRINCIPAL
-- ============================================
RunService.Heartbeat:Connect(function()
AtravessarPlayers()

if bola_chiclete_ativado then
BolaBorracha()
end

if auto_desarme_ativado then
SmartAutoTackle()
end

if powershoot_ativado then
local ball = GetBall()
local char = LocalPlayer.Character
if ball and char and char:FindFirstChild("HumanoidRootPart") then
local dist = (char.HumanoidRootPart.Position - ball.Position).Magnitude
if dist < 5 then
ball.Velocity = char.HumanoidRootPart.CFrame.LookVector * 220
end
end
end
end)

-- ============================================
-- RECARREGAR CACHE AO MORRER
-- ============================================
LocalPlayer.CharacterAdded:Connect(function()
task.wait(0.5)
UpdateCharacterCache()
if powershoot_ativado then
reinforceCharacter()
end
if speed_ativado then
local char = LocalPlayer.Character
if char and char:FindFirstChild("Humanoid") then
char.Humanoid.WalkSpeed = 27
end
end
if ant_pulo_ativado then
local char = LocalPlayer.Character
if char and char:FindFirstChild("Humanoid") then
char.Humanoid.JumpPower = 0
end
end
end)

print("✅ NEY HUB V1 CARREGADO!")
print("📌 Todas as funções ativadas!")

