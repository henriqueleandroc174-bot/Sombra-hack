--[[
    SOUZA HUB - v1.2
    Script Maker: Souza
    Script Developer: Souza
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local SoundService = game:GetService("SoundService")
local MarketplaceService = game:GetService("MarketplaceService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local userName = LocalPlayer.Name
local displayName = LocalPlayer.DisplayName
local userId = LocalPlayer.UserId

print("[Souza Hub] Iniciando v1.2...")

------------------------------------------------------------
-- SONS
------------------------------------------------------------

local function PlaySound(id, volume)
    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://" .. tostring(id)
        sound.Volume = volume or 0.5
        sound.Parent = SoundService
        sound:Play()
        sound.Ended:Connect(function()
            sound:Destroy()
        end)
        task.delay(5, function()
            if sound and sound.Parent then sound:Destroy() end
        end)
    end)
end

local SOUNDS = {
    Click   = 6895079853,
    Open    = 9111674879,
    Success = 6026984224,
    Error   = 9114221340,
    Notify  = 4590662766,
}

------------------------------------------------------------
-- FONTE
------------------------------------------------------------

local function SafeFont(name, weight)
    local ok, result = pcall(function()
        return Font.fromName(name, weight)
    end)
    if ok and result then return result end
    return Font.fromEnum(Enum.Font.GothamBold)
end

local OxaniumBold   = SafeFont("Oxanium", Enum.FontWeight.Bold)
local OxaniumMedium = SafeFont("Oxanium", Enum.FontWeight.Medium)

------------------------------------------------------------
-- NOTIFICAÇÕES
------------------------------------------------------------

local activeNotifs = {}
local NOTIF_HEIGHT = 76
local NOTIF_SPACING = 86

local function RepositionNotifs()
    for i, notif in ipairs(activeNotifs) do
        if notif.card and notif.card.Parent then
            TweenService:Create(
                notif.card,
                TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                { Position = UDim2.new(1, -320, 0, 20 + (i - 1) * NOTIF_SPACING) }
            ):Play()
        end
    end
end

local function CustomNotify(opts)
    opts = opts or {}
    local title    = opts.Title    or "Souza Hub"
    local content  = opts.Content  or ""
    local icon     = opts.Icon     or "🔔"
    local duration = opts.Duration or 4
    local accent   = opts.Color    or Color3.fromHex("#00d4ff")

    PlaySound(SOUNDS.Notify, 0.35)

    local gui = Instance.new("ScreenGui")
    gui.Name = "SouzaHub_Notify"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 9999
    gui.Parent = PlayerGui

    local shadow = Instance.new("Frame")
    shadow.Size = UDim2.fromOffset(302, NOTIF_HEIGHT + 2)
    shadow.Position = UDim2.new(1, 0, 0, 20 + #activeNotifs * NOTIF_SPACING)
    shadow.AnchorPoint = Vector2.new(0, 0)
    shadow.BackgroundColor3 = accent
    shadow.BackgroundTransparency = 0.7
    shadow.BorderSizePixel = 0
    shadow.ZIndex = 1
    shadow.Parent = gui
    Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 14)

    local card = Instance.new("TextButton")
    card.AutoButtonColor = false
    card.Text = ""
    card.Size = UDim2.fromOffset(300, NOTIF_HEIGHT)
    card.AnchorPoint = Vector2.new(0, 0)
    card.Position = UDim2.new(1, 0, 0, 20 + #activeNotifs * NOTIF_SPACING)
    card.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
    card.BorderSizePixel = 0
    card.ZIndex = 2
    card.Parent = gui

    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(16, 20, 28)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 10, 14)),
    })
    gradient.Rotation = 45
    gradient.Parent = card

    local stroke = Instance.new("UIStroke")
    stroke.Color = accent
    stroke.Thickness = 1.5
    stroke.Transparency = 0.25
    stroke.Parent = card

    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 4, 1, -12)
    accentBar.Position = UDim2.fromOffset(6, 6)
    accentBar.BackgroundColor3 = accent
    accentBar.BorderSizePixel = 0
    accentBar.ZIndex = 3
    accentBar.Parent = card
    Instance.new("UICorner", accentBar).CornerRadius = UDim.new(1, 0)

    local accentGlow = Instance.new("Frame")
    accentGlow.Size = UDim2.new(0, 8, 1, -12)
    accentGlow.Position = UDim2.fromOffset(4, 6)
    accentGlow.BackgroundColor3 = accent
    accentGlow.BackgroundTransparency = 0.75
    accentGlow.BorderSizePixel = 0
    accentGlow.ZIndex = 2
    accentGlow.Parent = card
    Instance.new("UICorner", accentGlow).CornerRadius = UDim.new(1, 0)

    local iconLabel = Instance.new("TextLabel")
    iconLabel.BackgroundTransparency = 1
    iconLabel.Size = UDim2.fromOffset(30, 30)
    iconLabel.Position = UDim2.fromOffset(18, 10)
    iconLabel.Text = icon
    iconLabel.TextSize = 20
    iconLabel.ZIndex = 3
    iconLabel.Parent = card

    local titleLabel = Instance.new("TextLabel")
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, -64, 0, 20)
    titleLabel.Position = UDim2.fromOffset(56, 8)
    titleLabel.Text = title
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextColor3 = accent
    titleLabel.TextSize = 15
    titleLabel.FontFace = OxaniumBold
    titleLabel.ZIndex = 3
    titleLabel.Parent = card

    local descLabel = Instance.new("TextLabel")
    descLabel.BackgroundTransparency = 1
    descLabel.Size = UDim2.new(1, -64, 0, 40)
    descLabel.Position = UDim2.fromOffset(56, 28)
    descLabel.Text = content
    descLabel.TextWrapped = true
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextYAlignment = Enum.TextYAlignment.Top
    descLabel.TextColor3 = Color3.fromRGB(190, 190, 190)
    descLabel.TextSize = 12
    descLabel.FontFace = OxaniumMedium
    descLabel.ZIndex = 3
    descLabel.Parent = card

    local timerBar = Instance.new("Frame")
    timerBar.Size = UDim2.new(1, -20, 0, 2)
    timerBar.Position = UDim2.new(0, 10, 1, -6)
    timerBar.BackgroundColor3 = accent
    timerBar.BorderSizePixel = 0
    timerBar.ZIndex = 3
    timerBar.Parent = card
    Instance.new("UICorner", timerBar).CornerRadius = UDim.new(1, 0)

    local notifEntry = { card = card, gui = gui, shadow = shadow, closed = false }
    table.insert(activeNotifs, notifEntry)

    local function close()
        if notifEntry.closed then return end
        notifEntry.closed = true

        local outTween = TweenService:Create(
            card,
            TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
            { Position = UDim2.new(1, 20, 0, card.Position.Y.Offset) }
        )
        outTween:Play()
        TweenService:Create(
            shadow,
            TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
            { Position = UDim2.new(1, 20, 0, shadow.Position.Y.Offset) }
        ):Play()
        pcall(function() outTween.Completed:Wait() end)

        if gui and gui.Parent then gui:Destroy() end

        for i, n in ipairs(activeNotifs) do
            if n == notifEntry then
                table.remove(activeNotifs, i)
                break
            end
        end
        RepositionNotifs()
    end

    card.MouseButton1Click:Connect(close)

    TweenService:Create(
        card,
        TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Position = UDim2.new(1, -320, 0, card.Position.Y.Offset) }
    ):Play()
    TweenService:Create(
        shadow,
        TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Position = UDim2.new(1, -318, 0, shadow.Position.Y.Offset) }
    ):Play()

    TweenService:Create(
        timerBar,
        TweenInfo.new(duration, Enum.EasingStyle.Linear),
        { Size = UDim2.new(0, 0, 0, 2) }
    ):Play()

    task.delay(duration, close)
end

------------------------------------------------------------
-- LOAD SCRIPT
------------------------------------------------------------

local function LoadScript(url, scriptName)
    if type(url) ~= "string" or url == "" then
        PlaySound(SOUNDS.Error, 0.4)
        CustomNotify({
            Title = "Erro",
            Content = "URL do script inválida.",
            Icon = "❌",
            Color = Color3.fromRGB(220, 60, 70),
            Duration = 4
        })
        return
    end

    PlaySound(SOUNDS.Click, 0.3)
    CustomNotify({
        Title = "Carregando...",
        Content = scriptName or "Script",
        Icon = "⏳",
        Color = Color3.fromHex("#ffd700"),
        Duration = 2
    })

    task.spawn(function()
        local success, err = pcall(function()
            local source = game:HttpGet(url)
            if not source or source == "" then
                error("O conteúdo remoto está vazio.")
            end
            local execute = loadstring(source)
            if not execute then
                error("Não foi possível compilar o script.")
            end
            execute()
        end)

        if success then
            PlaySound(SOUNDS.Success, 0.4)
            CustomNotify({
                Title = "Souza Hub",
                Content = "Script carregado!",
                Icon = "✅",
                Duration = 3
            })
        else
            PlaySound(SOUNDS.Error, 0.4)
            CustomNotify({
                Title = "Erro",
                Content = "Falha ao carregar.",
                Icon = "❌",
                Color = Color3.fromRGB(220, 60, 70),
                Duration = 4
            })
            warn("[Souza Hub] Erro LoadScript:", err)
        end
    end)
end

------------------------------------------------------------
-- WHITELIST + WEBHOOK
------------------------------------------------------------

local request_func = http_request or request or (syn and syn.request)
local Webhook_URL = "https://discord.com/api/webhooks/1521158004186288209/a1uMv_SXlItQWtPftGEhgHnZdZ-JbfgplvTyMrEP2x_Kk26MlN4uqAnVIkJzbOWvNGyT"

local whitelistedUsers = {
    "arte_thetravessa",
    "matheosMK",
    "Dylanprooxddde",
    "rato244764",
    "chora_procaiojr",
    "Fposes1",
    "theusruff67",
    "slowbop01",
}

local function GetAccountAge()
    local ok, age = pcall(function()
        return LocalPlayer.AccountAge
    end)
    return ok and age or 0
end

local function EnviarAlertaInvasao()
    pcall(function()
        if not request_func then return end

        local gameName = "Desconhecido"
        pcall(function()
            gameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
        end)

        local embedInvasao = {
            embeds = {{
                title = "🚨 ALERTA - TENTATIVA DE ACESSO NEGADO",
                description = "**" .. displayName .. "** tentou executar o **Souza Hub** mas **NÃO está na whitelist**!",
                color = 0xFF4500,
                fields = {
                    { name = "👤 Usuário", value = "`" .. userName .. "`", inline = true },
                    { name = "📛 Display", value = "`" .. displayName .. "`", inline = true },
                    { name = "🆔 User ID", value = "`" .. tostring(userId) .. "`", inline = true },
                    { name = "📅 Idade da Conta", value = tostring(GetAccountAge()) .. " dias", inline = true },
                    { name = "🎮 Jogo", value = gameName, inline = false },
                    { name = "🌐 PlaceId", value = "`" .. tostring(game.PlaceId) .. "`", inline = true },
                    { name = "💻 JobId", value = "`" .. tostring(game.JobId):sub(1, 16) .. "...`", inline = true },
                    { name = "⏰ Horário", value = os.date("%d/%m/%Y %H:%M:%S"), inline = true },
                    { name = "🔗 Perfil", value = "[Abrir perfil](https://www.roblox.com/users/" .. userId .. "/profile)", inline = false },
                },
                footer = {
                    text = "Souza Hub Security System"
                },
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }}
        }

        request_func({
            Url = Webhook_URL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(embedInvasao)
        })
    end)
end

local function EnviarAcessoConcedido()
    pcall(function()
        if not request_func then return end

        local gameName = "Desconhecido"
        pcall(function()
            gameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
        end)

        local embedSucesso = {
            embeds = {{
                title = "⚡ SOUZA HUB - ACESSO CONCEDIDO",
                description = "**" .. displayName .. "** entrou no **Souza Hub** com sucesso!",
                color = 0x00D4FF,
                fields = {
                    { name = "👤 Usuário", value = "`" .. userName .. "`", inline = true },
                    { name = "📛 Display", value = "`" .. displayName .. "`", inline = true },
                    { name = "🆔 User ID", value = "`" .. tostring(userId) .. "`", inline = true },
                    { name = "📅 Idade da Conta", value = tostring(GetAccountAge()) .. " dias", inline = true },
                    { name = "🎮 Jogo", value = gameName, inline = false },
                    { name = "🌐 PlaceId", value = "`" .. tostring(game.PlaceId) .. "`", inline = true },
                    { name = "💻 JobId", value = "`" .. tostring(game.JobId):sub(1, 16) .. "...`", inline = true },
                    { name = "⏰ Horário", value = os.date("%d/%m/%Y %H:%M:%S"), inline = true },
                    { name = "🔗 Perfil", value = "[Abrir perfil](https://www.roblox.com/users/" .. userId .. "/profile)", inline = false },
                },
                footer = {
                    text = "Souza Hub | Acesso Autorizado"
                },
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }}
        }
        request_func({
            Url = Webhook_URL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(embedSucesso)
        })
    end)
end

------------------------------------------------------------
-- TELA DE BOAS-VINDAS (WHITELIST BONITA)
------------------------------------------------------------

local function ShowWelcomeScreen(onContinue)
    local gui = Instance.new("ScreenGui")
    gui.Name = "SouzaHub_Welcome"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 99999
    gui.Parent = PlayerGui

    -- Fundo escuro
    local blocker = Instance.new("Frame")
    blocker.Size = UDim2.fromScale(1, 1)
    blocker.BackgroundColor3 = Color3.fromRGB(3, 5, 10)
    blocker.BackgroundTransparency = 0.25
    blocker.BorderSizePixel = 0
    blocker.Parent = gui

    -- Card principal
    local card = Instance.new("Frame")
    card.Size = UDim2.fromOffset(420, 280)
    card.Position = UDim2.fromScale(0.5, 0.5)
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.BackgroundColor3 = Color3.fromRGB(12, 16, 24)
    card.BorderSizePixel = 0
    card.Parent = gui
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 18)

    -- Gradiente do card
    local cardGrad = Instance.new("UIGradient")
    cardGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 24, 36)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 10, 16)),
    })
    cardGrad.Rotation = 135
    cardGrad.Parent = card

    -- Borda glow
    local cardStroke = Instance.new("UIStroke")
    cardStroke.Color = Color3.fromHex("#00d4ff")
    cardStroke.Thickness = 2
    cardStroke.Transparency = 0.2
    cardStroke.Parent = card

    -- Ícone topo
    local iconBg = Instance.new("Frame")
    iconBg.Size = UDim2.fromOffset(64, 64)
    iconBg.Position = UDim2.new(0.5, -32, 0, 22)
    iconBg.BackgroundColor3 = Color3.fromHex("#00d4ff")
    iconBg.BackgroundTransparency = 0.85
    iconBg.BorderSizePixel = 0
    iconBg.Parent = card
    Instance.new("UICorner", iconBg).CornerRadius = UDim.new(1, 0)

    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.fromScale(1, 1)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = "⚡"
    iconLabel.TextSize = 32
    iconLabel.Parent = iconBg

    -- Título grande
    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -40, 0, 36)
    title.Position = UDim2.fromOffset(20, 96)
    title.Text = "BEM-VINDO AO SOUZA HUB"
    title.TextColor3 = Color3.fromHex("#00d4ff")
    title.TextSize = 22
    title.FontFace = OxaniumBold
    title.Parent = card

    -- Subtítulo
    local subtitle = Instance.new("TextLabel")
    subtitle.BackgroundTransparency = 1
    subtitle.Size = UDim2.new(1, -40, 0, 24)
    subtitle.Position = UDim2.fromOffset(20, 132)
    subtitle.Text = "Acesso Concedido"
    subtitle.TextColor3 = Color3.fromHex("#22c55e")
    subtitle.TextSize = 16
    subtitle.FontFace = OxaniumBold
    subtitle.Parent = card

    -- Nome do player
    local playerLabel = Instance.new("TextLabel")
    playerLabel.BackgroundTransparency = 1
    playerLabel.Size = UDim2.new(1, -40, 0, 22)
    playerLabel.Position = UDim2.fromOffset(20, 162)
    playerLabel.Text = "Olá, " .. displayName .. " 👋"
    playerLabel.TextColor3 = Color3.fromRGB(200, 210, 220)
    playerLabel.TextSize = 14
    playerLabel.FontFace = OxaniumMedium
    playerLabel.Parent = card

    -- Botão continuar
    local continueBtn = Instance.new("TextButton")
    continueBtn.AutoButtonColor = true
    continueBtn.Size = UDim2.fromOffset(200, 44)
    continueBtn.Position = UDim2.new(0.5, -100, 1, -60)
    continueBtn.Text = "ENTRAR NO HUB"
    continueBtn.TextColor3 = Color3.new(1, 1, 1)
    continueBtn.TextSize = 16
    continueBtn.FontFace = OxaniumBold
    continueBtn.BackgroundColor3 = Color3.fromHex("#00a8cc")
    continueBtn.BorderSizePixel = 0
    continueBtn.Parent = card
    Instance.new("UICorner", continueBtn).CornerRadius = UDim.new(0, 10)

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromHex("#00d4ff")
    btnStroke.Thickness = 1.5
    btnStroke.Transparency = 0.4
    btnStroke.Parent = continueBtn

    -- Animação de entrada
    card.Size = UDim2.fromOffset(0, 0)
    card.BackgroundTransparency = 1
    TweenService:Create(card, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(420, 280),
        BackgroundTransparency = 0
    }):Play()

    PlaySound(SOUNDS.Success, 0.45)

    local clicked = false
    continueBtn.MouseButton1Click:Connect(function()
        if clicked then return end
        clicked = true
        PlaySound(SOUNDS.Click, 0.35)

        TweenService:Create(card, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Size = UDim2.fromOffset(0, 0),
            BackgroundTransparency = 1
        }):Play()
        TweenService:Create(blocker, TweenInfo.new(0.3), {
            BackgroundTransparency = 1
        }):Play()

        task.delay(0.35, function()
            if gui and gui.Parent then gui:Destroy() end
            if typeof(onContinue) == "function" then
                task.spawn(onContinue)
            end
        end)
    end)
end

local function ShowDeniedScreen()
    local gui = Instance.new("ScreenGui")
    gui.Name = "SouzaHub_Denied"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 99999
    gui.Parent = PlayerGui

    local blocker = Instance.new("Frame")
    blocker.Size = UDim2.fromScale(1, 1)
    blocker.BackgroundColor3 = Color3.fromRGB(8, 2, 2)
    blocker.BackgroundTransparency = 0.2
    blocker.BorderSizePixel = 0
    blocker.Parent = gui

    local card = Instance.new("Frame")
    card.Size = UDim2.fromOffset(400, 240)
    card.Position = UDim2.fromScale(0.5, 0.5)
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.BackgroundColor3 = Color3.fromRGB(20, 10, 12)
    card.BorderSizePixel = 0
    card.Parent = gui
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 16)

    local cardStroke = Instance.new("UIStroke")
    cardStroke.Color = Color3.fromRGB(220, 50, 60)
    cardStroke.Thickness = 2
    cardStroke.Parent = card

    local iconLabel = Instance.new("TextLabel")
    iconLabel.BackgroundTransparency = 1
    iconLabel.Size = UDim2.new(1, 0, 0, 50)
    iconLabel.Position = UDim2.fromOffset(0, 24)
    iconLabel.Text = "⛔"
    iconLabel.TextSize = 36
    iconLabel.Parent = card

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -40, 0, 30)
    title.Position = UDim2.fromOffset(20, 80)
    title.Text = "ACESSO NEGADO"
    title.TextColor3 = Color3.fromRGB(255, 80, 80)
    title.TextSize = 22
    title.FontFace = OxaniumBold
    title.Parent = card

    local desc = Instance.new("TextLabel")
    desc.BackgroundTransparency = 1
    desc.Size = UDim2.new(1, -40, 0, 50)
    desc.Position = UDim2.fromOffset(20, 120)
    desc.Text = "Você não está na whitelist.\nUsuário: " .. userName
    desc.TextColor3 = Color3.fromRGB(200, 180, 180)
    desc.TextSize = 14
    desc.TextWrapped = true
    desc.FontFace = OxaniumMedium
    desc.Parent = card

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.fromOffset(140, 40)
    closeBtn.Position = UDim2.new(0.5, -70, 1, -55)
    closeBtn.Text = "FECHAR"
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.TextSize = 14
    closeBtn.FontFace = OxaniumBold
    closeBtn.BackgroundColor3 = Color3.fromRGB(140, 30, 40)
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = card
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

    PlaySound(SOUNDS.Error, 0.5)

    closeBtn.MouseButton1Click:Connect(function()
        if gui and gui.Parent then gui:Destroy() end
    end)

    task.delay(10, function()
        if gui and gui.Parent then gui:Destroy() end
    end)
end

------------------------------------------------------------
-- LISTAS DE SCRIPTS
------------------------------------------------------------

local FutebolScripts = {
    {"Bola Chiclete⚽️", "https://pastefy.app/ZMHWh8kW/raw"},
    {"Anti Atravessar Soccer Tool⚽", "https://pastebin.com/raw/LYWJ6sfF"},
    {"Football Master V5 Pro⚽", "https://pastefy.app/77ScQkbz/raw"},
    {"Chute Bomba💣", "https://pastefy.app/HeRcZpTg/raw"},
    {"Soccer Dribble Hub ⚡️", "https://pastebin.com/raw/gwZKjbVM"},
    {"Passe Forte🦵", "https://pastebin.com/raw/2Yw8Bv85"},
    {"Condução Theus⚽", "https://pastefy.app/7FAwfRUX/raw"},
    {"Anti Ball Pedra⚽", "https://pastefy.app/59dDHHfr/raw"},
    {"Football Master V7⚽", "https://pastefy.app/I9nocuO2/raw"},
    {"Hub Da Leandrinha⚽️", "https://pastebin.com/raw/q5CxCNyi"},
    {"Zyck Blue Lock ⚽ (Spectar Bola)", "https://pastefy.app/6Zkp7ahC/raw"},
    {"Theus Hub Bolha ⚽", "https://pastefy.app/ZOy4xx6b/raw"},
    {"Desacelerar Bola 🐢", "https://luauforge-antiraw.netlify.app/raw/k6dgvUF9p81ntA4TTNPJcLU"},
}

local AtravessarScripts = {
    {"Atravessar Simples🔥", "https://pastebin.com/raw/D15v30nW"},
    {"Atravessar Theus 👻", "https://pastefy.app/7e1VxPgW/raw"},
    {"PJ Atravessa 🧧", "https://pastefy.app/CrhmqFtx/raw"},
    {"Atravessar V12🟣", "https://pastebin.com/raw/GZn1L0PM"},
    {"Oliver Atravessador 🗡", "https://rawscripts.net/raw/Universal-Script-Script-de-atravessar-56285"},
    {"Noclip Injusto + Reach 900 studs🔥", "https://pastebin.com/raw/hfrDcUm8"},
    {"Anti Ball Pedra + Atravessar⚽", "https://pastebin.com/raw/Z7eZDEj8"},
    {"Ktrom Hub — Atravessar + Reach 🎯", "https://pastefy.app/ruqQnDNd/raw"},
    {"Atravessa Epstein 👻", "https://pastefy.app/qgePJLeZ/raw"},
    {"Atravessar Tudo (Tecla 0) 🔓", "https://pastefy.app/cKpzcuHw/raw"},
    {"Atravessar Phantomball 👻", "https://pastefy.app/s5byaIDC/raw"},
    {"Atravessar Approximations 🌋", "https://pastefy.app/sffAxSCk/raw"},
    {"Atravessar Galaxy 🌌", "https://pastefy.app/F4GDQcAQ/raw"},
    {"Atravessar Pikolandia 💗", "https://pastefy.app/FMwl1GLk/raw"},
    {"Atravessar Lendário ✡️", "https://pastebin.com/raw/zh9P9AqV"},
    {"Atravessar 🟪", "https://pastefy.app/KdhVVlaC/raw"},
    {"Atravessar Seletivo (Mobile) ☁️", "https://pastefy.app/z7GBu0u9/raw"},
    {"Atravessar Seletivo (PC) ☁️", "https://pastefy.app/z7GBu0u9/raw"},
    {"Anti Pulo + Atravessar + Empurrar ⚽️", "https://pastefy.app/sIhEJFAz/raw"},
    {"Atravessar Surfista 🌊", "https://pastefy.app/PHJZmFMq/raw"},
    {"Atravessar Ultimate Hub", "https://pastefy.app/GtLarIM8/raw"},
    {"Atravessar Tontepstein Hub", "https://pastefy.app/QPcWTfqT/raw"},
}

local GoleiroScripts = {
    {"Muralha Hub🧱", "https://pastebin.com/raw/UxtmMHm1"},
    {"Goleiro Hub (Rayfield)🧤", "https://pastefy.app/cogJvYif/raw"},
    {"Legendary Defender ⚔️", "https://pastebin.com/raw/s91y0AFs"},
    {"GK Hub (Goleiro Deitado)🧤", "https://pastebin.com/raw/FaBkfBHr"},
    {"Yashin Ultra🧤", "https://pastebin.com/raw/KmNHLYsb"},
    {"Puyol V3 ⚡️", "https://pastebin.com/raw/bMLRRKwG"},
}

local MovimentoScripts = {
    {"Reach The Void🌑", "https://pastebin.com/raw/HyAUVhnP"},
    {"Ghost + Reach👻", "https://pastebin.com/raw/1if0pn7x"},
    {"Henrique Drible⚡", "https://pastebin.com/raw/wJKBdV8A"},
    {"Jvz Bug🥷", "https://pastefy.app/hYyBJna/raw"},
    {"Bug Do reidorm👑", "https://pastebin.com/raw/qtsDZHGu"},
    {"Pedrizz Bug⚡️", "https://pastebin.com/raw/28LDYic2"},
    {"Mtzin Pro Max⚡", "https://pastebin.com/raw/kCKEhh99"},
    {"Lag Switch👣", "https://pastefy.app/zZo7yoUB/raw"},
    {"Glitch Infinity♾️", "https://pastebin.com/raw/FpPh3UhN"},
    {"Theus Reach V2 🦿", "https://pastebin.com/raw/pm4pyxm4"},
    {"Reach Do Theus🦿", "https://pastefy.app/tSYVNcwc/raw"},
    {"Reach Forte Do Morales🤣", "https://pastefy.app/ckJb1cXM/raw"},
    {"Anti Pulo Luke Jr 🔆", "https://pastefy.app/d0yvvV78/raw"},
    {"Anti Pulo D Deus 👑", "https://pastefy.app/YwPd6C6B/raw"},
}

local BrookhavenScripts = {
    {"Brookhaven Ultimate🏡", "https://pastefy.app/Ul55j8hu/raw"},
    {"Brookhaven Painel V2🏠", "https://pastebin.com/raw/m70Y67h9"},
    {"Brookhaven Optimization🧩", "https://pastebin.com/raw/5DK3dz5Y"},
    {"Brookhaven Panel🏠", "https://pastefy.app/RGPRtmRg/raw"},
    {"Brazilian Panel🇧🇷", "https://pastebin.com/raw/x5XX9kiK"},
    {"Brazilian Panel V2 🇧🇷", "https://pastebin.com/raw/geau1Zy7"},
    {"Brookhaven Panel Completo 🏦", "https://pastefy.app/CWjWZ3ZJ/raw"},
    {"Cantona Hub 🏡", "https://pastefy.app/Ul55j8hu/raw"},
}

local OtimizacaoScripts = {
    {"Otimização🚀", "https://raw.githubusercontent.com/Davzxxfixroblox/DavzxHubFixLag/refs/heads/main/FixLagHub"},
    {"Ping Optimizer🧟‍♂️", "https://pastebin.com/raw/kbHL8MZ5"},
    {"Esticar Tela 🖥", "https://pastefy.app/4Sa0uIve/raw"},
    {"Limpar Tela 💻", "https://pastefy.app/FwY4L6qM/raw"},
    {"Mega Otimização Brookhaven 🏠", "https://pastebin.com/raw/GzrqQWkx"},
    {"Otimização Linha Transparente 🔗", "https://pastebin.com/raw/RbC506TY"},
}

local HubsScripts = {
    {"Nova Era Hub💎", "https://pastefy.app/zrszTIQx/raw"},
    {"Zyck 4.5 🇺🇸", "https://pastefy.app/P2eNOBe2/raw"},
    {"Gui Prime Pro⚽️", "https://pastebin.com/raw/xgkQc7Q9"},
    {"K4y The Promission☠️", "https://pastefy.app/Of3pO501/raw"},
    {"LP Scripts✔️", "https://gist.githubusercontent.com/yesn20456-crypto/af368f3184c1d34a8f4a9e33d4325d0d/raw/60e8309b99f9e002a55005b2d7905a82b90b70f1/gistfile1.txt"},
    {"Armando Jr Hub🔥", "https://raw.githubusercontent.com/carlosedut11/ArmadinhoJrPorCantonaJr/refs/heads/main/ArmadinhoJrPorCantonaJr.lua"},
    {"Lucas Hub😈", "https://pastebin.com/raw/xmbL5T3i"},
    {"Painel do Kayne🔥", "https://pastebin.com/raw/Frxjj6my"},
    {"Kayne Supremo🔥", "https://pastebin.com/raw/xyS7KQdY"},
    {"Theus Hub🍎", "https://pastefy.app/bib1MRS8/raw"},
    {"Matteo Hub ❄️", "https://pastefy.app/Pvf3lqmJ/raw"},
    {"Gotto Hub⚽", "https://pastefy.app/EOizRmIz/raw"},
    {"Loved Hub🍷", "https://pastefy.app/AccDN8CV/raw"},
    {"Painel Spider V2🕷", "https://pastefy.app/LvYw31OO/raw"},
    {"Angel Hub😇", "https://pastefy.app/679CyrEi/raw"},
    {"Samuzx Hub🥶", "https://pastefy.app/yOVyrBNy/raw"},
    {"Script do Spider V1🕷", "https://pastefy.app/hutJntDN/raw"},
    {"Script do Freezer🧊", "https://pastefy.app/bWS31I8q/raw"},
    {"Papai Cris Menu❤️", "https://pastefy.app/jI58Il0a/raw"},
    {"Hunk Hub🫂", "https://pastefy.app/ZGDUJNWr/raw"},
    {"Slow Hub 🐌", "https://pastefy.app/tSoOifGr/raw"},
    {"Drinho Hub 🎯", "https://pastefy.app/KEfkfhsr/raw"},
    {"Lukinhas Hub 💙", "https://pastebin.com/raw/dhxQnF4b"},
    {"Pirulito Hub 🍭", "https://pastebin.com/raw/A0xCHTGM"},
    {"Toni Kroos 🍀", "https://pastebin.com/raw/bCL22UZw"},
    {"X10 Premium Hub 💎", "https://pastebin.com/raw/MW2Zyv6z"},
    {"Fire Hub🔥", "https://pastebin.com/raw/iVp2tnCR"},
    {"Sforza Hub🔧", "https://pastebin.com/raw/pdyfSjzK"},
    {"Zyck ☠️", "https://pastebin.com/raw/WYeG9ypc"},
    {"Abençoado 777 👼", "https://raw.githubusercontent.com/admpietrovinicius-debug/Aben-oado-777/refs/heads/main/Aben%C3%A7oado777.lua"},
    {"Water Hub🌊", "https://pastefy.app/iQzbaBGE/raw"},
    {"Painel Foldenxzz Jr 🧪", "https://pastefy.app/HDWLEnnU/raw"},
    {"Escolinha Hub 📚", "https://gist.githubusercontent.com/zzckyz-wq/48e7df7b3c0a12b17bab930a766895b7/raw/62669d8a0a58bc5c95be6a2431a5a9c64cdd08d2/Escolinha%2520hub"},
    {"Tony Foden Hub ⚓", "https://pastefy.app/TE3UvyPK/raw"},
    {"Cbb Hub 🎨 (Rayfield)", "https://pastefy.app/Lu3gg6Jy/raw"},
    {"Brito Hub ⚡️", "https://pastebin.com/raw/e8i6ytza"},
    {"Piu V5 ㊗️", "https://pastefy.app/ZTjSqELh/raw"},
    {"Royal Shadow ☂️", "https://pastefy.app/Y6yKS7DD/raw"},
    {"Armando Shop 👑", "https://pastebin.com/raw/9uJjEgB1"},
    {"Mega Tardelli 🌩", "https://pastefy.app/9K9ornyQ/raw"},
    {"Painel Angolano 🇦🇴", "https://pastefy.app/pXmmHUly/raw"},
    {"Painel Jacaré 🐊", "https://luauforge-antiraw.netlify.app/raw/DAm5hJT1tuhKTdPaGnnFFy0"},
    {"Painel do Foldenxzz 📱", "https://pastefy.app/GXpWOskW/raw"},
    {"Surfista Hub 🌊", "https://pastefy.app/7Lvt5Tiw/raw"},
    {"Painel Xitado V1.3 📱", "https://luauforge-antiraw.netlify.app/raw/pYOJlRUKB8JvzYRuB33MSei"},
    {"Biscoito Hub 🍪", "https://pastebin.com/raw/Ba0sq6Ry"},
    {"Acre Jr Hub 🔑 Key: quemnaoxitanaobrilha", "https://pastefy.app/FIiw8Xy4/raw"},
}

local OutrosScripts = {
    {"Script Da Debinha🥀", "https://pastefy.app/9k4tL5Q7/raw"},
    {"Hotdog V4 🌭", "https://pastefy.app/GzxmSIIn/raw"},
    {"Tira Analógico 🕹", "https://pastefy.app/AJhzcN5G/raw"},
    {"Tubaina Hub 🥶", "https://pastefy.app/xLM92mP5/raw"},
    {"Script do Kay V2🔥", "https://pastebin.com/raw/eXGuwWWE"},
    {"DD Osama V5 🇺🇸", "https://pastebin.com/raw/NxpP7iWb"},
    {"Fuzzy Bugs ♟️", "https://pastefy.app/rsiBF3CL/raw"},
    {"Anti Roubo Bola ⚽️", "https://pastebin.com/raw/4GXQEjAs"},
    {"Sixxinho Hub 🔒", "https://raw.githubusercontent.com/josegaviao888-alt/Six-Hub-Privdo/refs/heads/main/Six%20hUB"},
    {"X Hub ❌️", "https://pastefy.app/yXuzlTpQ/raw"},
    {"Caga Na Roupa Hub 💩", "https://pastefy.app/eKFExNPG/raw"},
    {"Anti Pulo Foldenxz 🚫", "https://pastebin.com/raw/d2T3QxGt"},
    {"Anti Pulo Elias 🚫", "https://pastebin.com/raw/mgzrnsbr"},
    {"Zyck Anti Pulo 🚫", "https://pastebin.com/raw/MCTcaHZq"},
    {"Jonh Surfista 🌊", "https://pastefy.app/wx7Icj6J/raw"},
    {"itzgoat Hub 🔑", "https://pastebin.com/raw/SFAFzLKW"},
    {"Painel Xitado 📱", "https://pastefy.app/rncdQyLw/raw"},
    {"Slow Hub 🐢", "https://pastefy.app/2ADw9VBQ/raw"},
    {"Shadow Panel 🌑", "https://pastefy.app/1eBuzcuh/raw"},
    {"Ball Chiclete ⚽️", "https://pastefy.app/AzBz08Dq/raw"},
    {"Bola Roxa 🟣", "https://pastefy.app/lGbsdxob/raw"},
    {"Bugador Otimizado 🔥", "https://pastebin.com/raw/rUqNTHNa"},
    {"Script Diaz ⚖️", "https://pastefy.app/KvAq9KB1/raw"},
}

local MexeNaTelaScripts = {
    {"Teste De Campo 🏑", "https://pastefy.app/dNWJ5ot7/raw"},
    {"Script De Magnetismo 🧲", "https://pastefy.app/SNttOINq/raw"},
}

local UtilitariosScripts = {
    {"Fly🍃", "https://pastefy.app/IHIgGN9b/raw"},
    {"Coquette Hub🎀", "https://rawscripts.net/raw/Brookhaven-RP-Coquette-Hub-41921"},
    {"Hexagon Client🔘", "https://raw.githubusercontent.com/nxvap/hexagon/refs/heads/main/brookhaven"},
    {"Script De Emotes🕺", "https://pastefy.app/lAdApmz4/raw"},
    {"Crosshair 🎯", "https://rawscripts.net/raw/Universal-Script-Custom-Crosshair-Gui-237611"},
}

local ALL_LISTS = {
    FutebolScripts, AtravessarScripts, GoleiroScripts,
    MovimentoScripts, BrookhavenScripts, OtimizacaoScripts,
    HubsScripts, OutrosScripts, MexeNaTelaScripts, UtilitariosScripts,
}

local function GetTotalScripts()
    local total = 0
    for _, list in ipairs(ALL_LISTS) do
        total += #list
    end
    return total
end

------------------------------------------------------------
-- CONFIG PERSISTENTE
------------------------------------------------------------

local CurrentConfig = {
    FOV = 70,
    Speed = 16,
    Jump = 50,
}

local function ApplyConfigToCharacter(char)
    local hum = char:WaitForChild("Humanoid", 5)
    if not hum then return end
    hum.WalkSpeed = CurrentConfig.Speed
    hum.JumpPower = CurrentConfig.Jump
end

LocalPlayer.CharacterAdded:Connect(ApplyConfigToCharacter)

if LocalPlayer.Character then
    task.spawn(ApplyConfigToCharacter, LocalPlayer.Character)
end

------------------------------------------------------------
-- BUILD HUB
------------------------------------------------------------

local Window

local function BuildHub()
    print("[Souza Hub] Carregando WindUI...")

    local WindUI
    local success, err = pcall(function()
        WindUI = loadstring(
            game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua")
        )()
    end)

    if not success or not WindUI then
        success, err = pcall(function()
            WindUI = loadstring(
                game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua")
            )()
        end)
    end

    if not success or not WindUI then
        success, err = pcall(function()
            WindUI = loadstring(
                game:HttpGet("https://github.com/Footagesus/WindUI/releases/download/1.6.66/main.lua")
            )()
        end)
    end

    if not success or not WindUI then
        warn("[Souza Hub] ERRO: Não foi possível carregar o WindUI!")
        CustomNotify({
            Title = "Erro Crítico",
            Content = "Falha ao carregar WindUI.",
            Icon = "❌",
            Color = Color3.fromRGB(220, 60, 70),
            Duration = 8
        })
        return
    end

    print("[Souza Hub] WindUI carregado!")

    pcall(function()
        WindUI:AddTheme({
            Name = "Souza",
            Accent = Color3.fromHex("#00d4ff"),
            Background = Color3.fromHex("#080a10"),
            Outline = Color3.fromHex("#1a2a3a"),
            Text = Color3.fromHex("#ffffff"),
            Placeholder = Color3.fromHex("#6b8a9e"),
            Button = Color3.fromHex("#10141c"),
            Icon = Color3.fromHex("#00d4ff"),
        })
    end)

    local windowSuccess, windowError = pcall(function()
        Window = WindUI:CreateWindow({
            Title = "Souza Hub",
            Icon = "zap",
            Author = "Souza",
            Folder = "SouzaHub",
            Size = UDim2.fromOffset(620, 500),
            Transparent = true,
            Theme = "Souza",
            Resizable = true,
            SideBarWidth = 200,
            BackgroundImageTransparency = 0.38,
            HideSearchBar = false,
            ScrollBarEnabled = true,
            User = {
                Enabled = true,
                Anonymous = false,
                Callback = function()
                    PlaySound(SOUNDS.Click, 0.3)
                end,
            },
        })
    end)

    if not windowSuccess or not Window then
        warn("[Souza Hub] Erro ao criar Window:", windowError)
        CustomNotify({
            Title = "Erro Crítico",
            Content = "Não foi possível criar a interface.",
            Icon = "❌",
            Color = Color3.fromRGB(220, 60, 70),
            Duration = 8
        })
        return
    end

    -- Botão de abrir bem mais bonito
    pcall(function()
        Window:EditOpenButton({
            Title = "⚡ Souza Hub",
            Icon = "zap",
            CornerRadius = UDim.new(0, 12),
            StrokeThickness = 2.5,
            Color = ColorSequence.new(
                Color3.fromHex("#00d4ff"),
                Color3.fromHex("#0077b6"),
                Color3.fromHex("#00d4ff")
            ),
            OnlyMobile = false,
            Enabled = true,
            Draggable = true,
        })
    end)

    pcall(function()
        Window:Tag({ Title = "v1.2", Icon = "star", Color = Color3.fromHex("#00d4ff") })
        Window:Tag({ Title = "Souza", Icon = "user", Color = Color3.fromHex("#ff6b35") })
        Window:Tag({ Title = "SECURE", Icon = "shield", Color = Color3.fromHex("#22c55e") })
    end)

    local MainTab     = Window:Tab({ Title = "Início",        Icon = "home" })
    local ApeloesTab  = Window:Tab({ Title = "Scripts",       Icon = "code" })
    local DiversosTab = Window:Tab({ Title = "Diversos",      Icon = "layers" })
    local ConfigTab   = Window:Tab({ Title = "Config",        Icon = "settings" })
    local CreditsTab  = Window:Tab({ Title = "Créditos",      Icon = "heart" })

    ------------------------------------------------------------
    -- INÍCIO
    ------------------------------------------------------------
    MainTab:Paragraph({
        Title = "⚡ Souza Hub v1.2",
        Desc = "Hub premium carregado. Use as abas laterais para navegar pelos scripts.",
    })

    MainTab:Section({ Title = "📊 Estatísticas", Icon = "bar-chart-2" })

    MainTab:Button({
        Title = "Ver quantos Scripts tem",
        Callback = function()
            PlaySound(SOUNDS.Click, 0.3)
            local total = GetTotalScripts()
            CustomNotify({
                Title = "Souza Hub",
                Content = "Existem " .. total .. " scripts disponíveis!",
                Icon = "📜",
                Duration = 5,
            })
        end,
    })

    MainTab:Section({ Title = "⚙ Configurações Rápidas", Icon = "sliders" })

    MainTab:Toggle({
        Title = "Ativar efeitos visuais",
        Desc = "Liga/desliga efeitos visuais do Hub",
        Default = true,
        Callback = function(state)
            PlaySound(SOUNDS.Click, 0.3)
            CustomNotify({
                Title = "Souza Hub",
                Content = state and "Efeitos visuais ativados" or "Efeitos visuais desativados",
                Icon = state and "✨" or "🚫",
                Duration = 3,
            })
        end,
    })

    ------------------------------------------------------------
    -- SCRIPTS
    ------------------------------------------------------------
    local function AddButtonSection(tab, title, icon, list)
        tab:Section({ Title = title, Icon = icon })
        for _, data in ipairs(list) do
            tab:Button({
                Title = data[1],
                Callback = function()
                    PlaySound(SOUNDS.Click, 0.25)
                    LoadScript(data[2], data[1])
                end
            })
        end
    end

    AddButtonSection(ApeloesTab, "⚽ Futebol / Bola",       "circle",           FutebolScripts)
    AddButtonSection(ApeloesTab, "👻 Atravessar / Noclip",  "ghost",            AtravessarScripts)
    AddButtonSection(ApeloesTab, "🧤 Goleiro / Defesa",     "shield",           GoleiroScripts)
    AddButtonSection(ApeloesTab, "🏃 Movimento / Reach",    "zap",              MovimentoScripts)
    AddButtonSection(ApeloesTab, "🏡 Brookhaven",           "home",             BrookhavenScripts)
    AddButtonSection(ApeloesTab, "🚀 Otimização",           "rocket",           OtimizacaoScripts)
    AddButtonSection(ApeloesTab, "🎨 Hubs / Painéis",       "layout-dashboard", HubsScripts)
    AddButtonSection(ApeloesTab, "🧩 Outros",               "box",              OutrosScripts)

    ------------------------------------------------------------
    -- DIVERSOS
    ------------------------------------------------------------
    DiversosTab:Section({ Title = "🎬 Mexe na tela", Icon = "film" })
    for _, data in ipairs(MexeNaTelaScripts) do
        DiversosTab:Button({
            Title = data[1],
            Callback = function()
                PlaySound(SOUNDS.Click, 0.25)
                LoadScript(data[2], data[1])
            end
        })
    end

    DiversosTab:Section({ Title = "🛠 Utilitários", Icon = "wrench" })
    for _, data in ipairs(UtilitariosScripts) do
        DiversosTab:Button({
            Title = data[1],
            Callback = function()
                PlaySound(SOUNDS.Click, 0.25)
                LoadScript(data[2], data[1])
            end
        })
    end

    ------------------------------------------------------------
    -- CONFIG
    ------------------------------------------------------------
    ConfigTab:Section({ Title = "📷 Câmera", Icon = "camera" })

    ConfigTab:Slider({
        Title = "FOV (Campo de Visão)",
        Step = 1,
        Value = { Min = 20, Max = 120, Default = 70 },
        Callback = function(value)
            CurrentConfig.FOV = value
            pcall(function()
                local camera = workspace.CurrentCamera
                if camera then camera.FieldOfView = value end
            end)
        end,
    })

    ConfigTab:Section({ Title = "🏃 Movimento", Icon = "zap" })

    ConfigTab:Slider({
        Title = "Velocidade (Speed)",
        Step = 1,
        Value = { Min = 16, Max = 200, Default = 16 },
        Callback = function(value)
            CurrentConfig.Speed = value
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then hum.WalkSpeed = value end
                end
            end)
        end,
    })

    ConfigTab:Slider({
        Title = "Força de Pulo (Jump)",
        Step = 1,
        Value = { Min = 50, Max = 300, Default = 50 },
        Callback = function(value)
            CurrentConfig.Jump = value
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then hum.JumpPower = value end
                end
            end)
        end,
    })

    ConfigTab:Section({ Title = "⚠ Zona de Perigo", Icon = "alert-triangle" })

    ConfigTab:Button({
        Title = "Destruir Interface 🔨",
        Callback = function()
            PlaySound(SOUNDS.Error, 0.4)
            pcall(function()
                if Window then
                    Window:Destroy()
                    Window = nil
                end
            end)
            CustomNotify({
                Title = "Souza Hub",
                Content = "Interface destruída.",
                Icon = "🔨",
                Duration = 3
            })
        end,
    })

    ------------------------------------------------------------
    -- CRÉDITOS
    ------------------------------------------------------------
    CreditsTab:Section({ Title = "👑 Equipe", Icon = "crown" })

    CreditsTab:Paragraph({
        Title = "Script Maker",
        Desc = "Souza 🖥️ — cria novas funções e recursos.",
    })

    CreditsTab:Paragraph({
        Title = "Script Developer",
        Desc = "Souza ⚒️ — atualiza e corrige bugs.",
    })

    CreditsTab:Section({ Title = "📌 Informações", Icon = "info" })

    CreditsTab:Paragraph({
        Title = "Versão",
        Desc = "v1.2 — Welcome screen + visual melhorado + scripts organizados.",
    })

    CreditsTab:Paragraph({
        Title = "Agradecimento",
        Desc = "Obrigado por usar o Souza Hub! Aproveite ao máximo. 💙",
    })

    print("[Souza Hub] Hub criado com sucesso!")
    PlaySound(SOUNDS.Open, 0.45)

    CustomNotify({
        Title = "Souza Hub v1.2",
        Content = "Script carregado com sucesso!",
        Icon = "⚡",
        Color = Color3.fromHex("#00d4ff"),
        Duration = 5,
    })
end

------------------------------------------------------------
-- EXECUÇÃO PRINCIPAL
------------------------------------------------------------

task.spawn(function()
    local isWhitelisted = false
    for _, whitelisted in ipairs(whitelistedUsers) do
        if string.lower(userName) == string.lower(whitelisted) then
            isWhitelisted = true
            break
        end
    end

    if isWhitelisted then
        print("✅ " .. userName .. " - AUTORIZADO!")
        EnviarAcessoConcedido()

        -- Tela bonita de boas-vindas
        ShowWelcomeScreen(function()
            local success, err = pcall(BuildHub)
            if not success then
                warn("[Souza Hub] Erro ao iniciar o Hub:", err)
                CustomNotify({
                    Title = "Erro Crítico",
                    Content = "O Souza Hub encontrou um erro ao iniciar.",
                    Icon = "❌",
                    Color = Color3.fromRGB(220, 60, 70),
                    Duration = 7
                })
            end
        end)
    else
        EnviarAlertaInvasao()
        ShowDeniedScreen()
        warn("🚫 Usuário não autorizado: " .. userName)
        return
    end
end)
