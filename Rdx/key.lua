--[[
    RDX HUB - v1.6.9
    Script Maker: RDX
    Script Developer: RDX
    Changelog v1.6.9:
      - +6 scripts novos na Infinity Lab (total: 14)
      - Theus Hub Bolha, Escolinha Hub, Tony Foden, 
        Atravessar Phantomball, Approximations, Galaxy
      - Script Key itzgoat
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

print("[RDX Hub] Iniciando v1.6.9...")

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
-- NOTIFICAÇÕES (COM FILA REAL)
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
    local title    = opts.Title    or "RDX Hub"
    local content  = opts.Content  or ""
    local icon     = opts.Icon     or "🔔"
    local duration = opts.Duration or 4
    local accent   = opts.Color    or Color3.fromHex("#30ff6a")

    local gui = Instance.new("ScreenGui")
    gui.Name = "RDXHub_Notify"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 9999
    gui.Parent = PlayerGui

    local card = Instance.new("TextButton")
    card.AutoButtonColor = false
    card.Text = ""
    card.Size = UDim2.fromOffset(300, NOTIF_HEIGHT)
    card.AnchorPoint = Vector2.new(0, 0)
    card.Position = UDim2.new(1, 0, 0, 20 + #activeNotifs * NOTIF_SPACING)
    card.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    card.BorderSizePixel = 0
    card.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = card

    local stroke = Instance.new("UIStroke")
    stroke.Color = accent
    stroke.Thickness = 1.2
    stroke.Transparency = 0.4
    stroke.Parent = card

    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 4, 1, -12)
    accentBar.Position = UDim2.fromOffset(6, 6)
    accentBar.BackgroundColor3 = accent
    accentBar.BorderSizePixel = 0
    accentBar.Parent = card
    Instance.new("UICorner", accentBar).CornerRadius = UDim.new(1, 0)

    local iconLabel = Instance.new("TextLabel")
    iconLabel.BackgroundTransparency = 1
    iconLabel.Size = UDim2.fromOffset(30, 30)
    iconLabel.Position = UDim2.fromOffset(18, 10)
    iconLabel.Text = icon
    iconLabel.TextSize = 20
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
    descLabel.Parent = card

    local timerBar = Instance.new("Frame")
    timerBar.Size = UDim2.new(1, -20, 0, 2)
    timerBar.Position = UDim2.new(0, 10, 1, -6)
    timerBar.BackgroundColor3 = accent
    timerBar.BorderSizePixel = 0
    timerBar.Parent = card
    Instance.new("UICorner", timerBar).CornerRadius = UDim.new(1, 0)

    local notifEntry = { card = card, gui = gui, closed = false }
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
        timerBar,
        TweenInfo.new(duration, Enum.EasingStyle.Linear),
        { Size = UDim2.new(0, 0, 0, 2) }
    ):Play()

    task.delay(duration, close)
end

------------------------------------------------------------
-- LOAD SCRIPT
------------------------------------------------------------

local function LoadScript(url)
    if type(url) ~= "string" or url == "" then
        CustomNotify({
            Title = "Erro",
            Content = "URL do script inválida.",
            Icon = "❌",
            Color = Color3.fromRGB(220, 60, 70),
            Duration = 4
        })
        return
    end

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
            CustomNotify({
                Title = "RDX Hub",
                Content = "Script carregado!",
                Icon = "✅",
                Duration = 3
            })
        else
            CustomNotify({
                Title = "Erro",
                Content = "Falha ao carregar.",
                Icon = "❌",
                Color = Color3.fromRGB(220, 60, 70),
                Duration = 4
            })
            warn("[RDX Hub] Erro LoadScript:", err)
        end
    end)
end

------------------------------------------------------------
-- WHITELIST
------------------------------------------------------------

local function ShowWhitelistPrompt(onAnswer)
    print("[RDX Hub] Mostrando whitelist...")

    local gui = Instance.new("ScreenGui")
    gui.Name = "RDXHub_Whitelist"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 99999
    gui.Parent = PlayerGui

    local blocker = Instance.new("TextButton")
    blocker.Size = UDim2.fromScale(1, 1)
    blocker.BackgroundColor3 = Color3.fromRGB(3, 5, 8)
    blocker.BackgroundTransparency = 0.15
    blocker.Text = ""
    blocker.AutoButtonColor = false
    blocker.Modal = true
    blocker.BorderSizePixel = 0
    blocker.Parent = gui

    local card = Instance.new("Frame")
    card.Size = UDim2.fromOffset(420, 230)
    card.Position = UDim2.fromScale(0.5, 0.5)
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.BackgroundColor3 = Color3.fromRGB(15, 18, 24)
    card.BorderSizePixel = 0
    card.Parent = gui

    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 14)

    local cardStroke = Instance.new("UIStroke")
    cardStroke.Color = Color3.fromHex("#30ff6a")
    cardStroke.Thickness = 1.5
    cardStroke.Transparency = 0.25
    cardStroke.Parent = card

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -40, 0, 34)
    title.Position = UDim2.fromOffset(20, 20)
    title.Text = "RDX HUB • WHITELIST"
    title.TextColor3 = Color3.fromHex("#30ff6a")
    title.TextSize = 22
    title.FontFace = OxaniumBold
    title.Parent = card

    local desc = Instance.new("TextLabel")
    desc.BackgroundTransparency = 1
    desc.Size = UDim2.new(1, -44, 0, 60)
    desc.Position = UDim2.fromOffset(22, 64)
    desc.Text = "Você quer entrar na whitelist do RDX Hub?\nEscolha Sim para carregar o script ou Não para sair."
    desc.TextColor3 = Color3.fromRGB(205, 210, 215)
    desc.TextSize = 14
    desc.TextWrapped = true
    desc.FontFace = OxaniumMedium
    desc.Parent = card

    local function makeButton(text, color, pos)
        local btn = Instance.new("TextButton")
        btn.AutoButtonColor = true
        btn.Size = UDim2.fromOffset(165, 44)
        btn.Position = pos
        btn.Text = text
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.TextSize = 16
        btn.FontFace = OxaniumBold
        btn.BackgroundColor3 = color
        btn.BorderSizePixel = 0
        btn.Parent = card
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 9)
        return btn
    end

    local yesBtn = makeButton("SIM, ENTRAR", Color3.fromHex("#20b957"), UDim2.fromOffset(35, 155))
    local noBtn  = makeButton("NÃO, SAIR",  Color3.fromRGB(125, 35, 48), UDim2.fromOffset(220, 155))

    local answered = false
    local function answer(val)
        if answered then return end
        answered = true
        if gui and gui.Parent then gui:Destroy() end
        if typeof(onAnswer) == "function" then
            task.spawn(function() pcall(onAnswer, val) end)
        end
    end

    yesBtn.MouseButton1Click:Connect(function() answer(true) end)
    noBtn.MouseButton1Click:Connect(function() answer(false) end)
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
}

local AtravessarScripts = {
    {"Atravessar Simples🔥", "https://pastebin.com/raw/D15v30nW"},
    {"Atravessar Theus 👻", "https://pastefy.app/7e1VxPgW/raw"},
    {"PJ Atravessa 🧧", "https://pastefy.app/CrhmqFtx/raw"},
    {"Atravessar V12🟣", "https://pastebin.com/raw/GZn1L0PM"},
    {"Oliver Atravessador 🗡", "https://rawscripts.net/raw/Universal-Script-Script-de-atravessar-56285"},
    {"Noclip Injusto + Reach 900 studs🔥", "https://pastebin.com/raw/hfrDcUm8"},
    {"Anti Ball Pedra + Atravessar⚽", "https://pastebin.com/raw/Z7eZDEj8"},
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
}

local BrookhavenScripts = {
    {"Brookhaven Ultimate🏡", "https://pastefy.app/Ul55j8hu/raw"},
    {"Brookhaven Painel V2🏠", "https://pastebin.com/raw/m70Y67h9"},
    {"Brookhaven Optimization🧩", "https://pastebin.com/raw/5DK3dz5Y"},
    {"Brookhaven Panel🏠", "https://pastefy.app/RGPRtmRg/raw"},
    {"Brazilian Panel🇧🇷", "https://pastebin.com/raw/x5XX9kiK"},
    {"Brazilian Panel V2 🇧🇷", "https://pastebin.com/raw/geau1Zy7"},
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
    {"Six Hub 6️⃣", "https://pastebin.com/raw/MDhqkib4"},
}

local OutrosScripts = {
    {"Script Da Debinha🥀", "https://pastefy.app/9k4tL5Q7/raw"},
    {"Hotdog V4 🌭", "https://pastefy.app/GzxmSIIn/raw"},
    {"Tira Analógico 🕹", "https://pastefy.app/AJhzcN5G/raw"},
    {"Tubaina Hub 🥶", "https://pastefy.app/xLM92mP5/raw"},
    {"Script do Kay V2🔥", "https://pastebin.com/raw/eXGuwWWE"},
    {"DD Osama V5 🇺🇸", "https://pastebin.com/raw/NxpP7iWb"},
    {"Fuzzy Bugs ♟️", "https://pastefy.app/rsiBF3CL/raw"},
    {"Anti Roubo Bola ⚽️\n🔑 Key: KWLS", "https://pastebin.com/raw/4GXQEjAs"},
    {"Sixxinho Hub 🔒\n🔑 Key: SWGK", "https://raw.githubusercontent.com/josegaviao888-alt/Six-Hub-Privdo/refs/heads/main/Six%20hUB"},
    {"X Hub ❌️", "https://pastefy.app/yXuzlTpQ/raw"},
    {"Caga Na Roupa Hub 💩", "https://pastefy.app/eKFExNPG/raw"},
    {"Anti Pulo Foldenxz 🚫", "https://pastebin.com/raw/d2T3QxGt"},
    {"Anti Pulo Elias 🚫", "https://pastebin.com/raw/mgzrnsbr"},
    {"Zyck Anti Pulo 🚫", "https://pastebin.com/raw/MCTcaHZq"},
}

local InfinityExtraScripts = {
    {"Atravessar Pikolandia 💗", "https://pastefy.app/FMwl1GLk/raw"},
    {"Atravessar Lendário ✡️", "https://pastebin.com/raw/zh9P9AqV"},
    {"Atravessar 🟪", "https://pastefy.app/KdhVVlaC/raw"},
    {"Atravessar Seletivo (Mobile) ☁️", "https://pastefy.app/z7GBu0u9/raw"},
    {"Atravessar Seletivo (PC) ☁️", "https://pastefy.app/z7GBu0u9/raw"},
    {"Anti Pulo + Atravessar + Empurrar ⚽️", "https://pastefy.app/sIhEJFAz/raw"},
    {"Anti Pulo Luke Jr 🔆", "https://pastefy.app/d0yvvV78/raw"},
    {"Anti Pulo D Deus 👑", "https://pastefy.app/YwPd6C6B/raw"},
    {"Reach Forte Do Morales🤣", "https://pastefy.app/ckJb1cXM/raw"},
    {"Reach The Void (Novo)🌑", "https://pastefy.app/1fVPQXXM/raw"},
    {"Ball Chiclete ⚽️", "https://pastefy.app/AzBz08Dq/raw"},
    {"Bola Roxa 🟣", "https://pastefy.app/lGbsdxob/raw"},
    {"Brito Hub ⚡️", "https://pastebin.com/raw/e8i6ytza"},
    {"Cantona Hub 🏡", "https://pastefy.app/Ul55j8hu/raw"},
    {"Piu V5 ㊗️", "https://pastefy.app/ZTjSqELh/raw"},
    {"Royal Shadow ☂️", "https://pastefy.app/Y6yKS7DD/raw"},
    {"Armando Shop 👑", "https://pastebin.com/raw/9uJjEgB1"},
    {"Mega Tardelli 🌩", "https://pastefy.app/9K9ornyQ/raw"},
    {"Bugador Otimizado 🔥", "https://pastebin.com/raw/rUqNTHNa"},
    {"Painel Angolano 🇦🇴", "https://pastefy.app/pXmmHUly/raw"},
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

-- ✨ INFINITY LAB (14 SCRIPTS)
local InfinityLabScripts = {
    {"Zyck Blue Lock ⚽ (Spectar Bola)", "https://pastefy.app/6Zkp7ahC/raw"},
    {"Ktrom Hub — Atravessar + Reach 🎯", "https://pastefy.app/ruqQnDNd/raw"},
    {"Painel Foldenxzz Jr 🧪", "https://pastefy.app/HDWLEnnU/raw"},
    {"Atravessa Epstein 👻", "https://pastefy.app/qgePJLeZ/raw"},
    {"Atravessar Tudo (Tecla 0) 🔓", "https://pastefy.app/cKpzcuHw/raw"},
    {"Brookhaven Panel Completo 🏦", "https://pastefy.app/CWjWZ3ZJ/raw"},
    {"Jonh Surfista 🌊", "https://pastefy.app/wx7Icj6J/raw"},
    {"Script Key itzgoat 🔑", "https://pastebin.com/raw/SFAFzLKW"},
    -- NOVOS v1.6.9
    {"Theus Hub Bolha ⚽", "https://pastefy.app/ZOy4xx6b/raw"},
    {"Escolinha Hub 📚\n🔑 Key: JackEpsteinbonitao", "https://gist.githubusercontent.com/zzckyz-wq/48e7df7b3c0a12b17bab930a766895b7/raw/62669d8a0a58bc5c95be6a2431a5a9c64cdd08d2/Escolinha%2520hub"},
    {"Tony Foden Hub ⚓", "https://pastefy.app/TE3UvyPK/raw"},
    {"Atravessar Phantomball 👻", "https://pastefy.app/s5byaIDC/raw"},
    {"Atravessar Approximations 🌋", "https://pastefy.app/sffAxSCk/raw"},
    {"Atravessar Galaxy 🌌 (by RDX)", "https://pastefy.app/F4GDQcAQ/raw"},
}

local ALL_LISTS = {
    FutebolScripts, AtravessarScripts, GoleiroScripts,
    MovimentoScripts, BrookhavenScripts, OtimizacaoScripts,
    HubsScripts, OutrosScripts, InfinityExtraScripts,
    MexeNaTelaScripts, UtilitariosScripts, InfinityLabScripts,
}

local function GetTotalScripts()
    local total = 0
    for _, list in ipairs(ALL_LISTS) do
        total += #list
    end
    return total
end

------------------------------------------------------------
-- CONFIG PERSISTENTE EM RESPAWN
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
    print("[RDX Hub] Carregando WindUI...")

    local WindUI
    local success, err = pcall(function()
        WindUI = loadstring(
            game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua")
        )()
    end)

    if not success or not WindUI then
        warn("[RDX Hub] Método 1 falhou, tentando método 2...")
        success, err = pcall(function()
            WindUI = loadstring(
                game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua")
            )()
        end)
    end

    if not success or not WindUI then
        warn("[RDX Hub] Método 2 falhou, tentando método 3...")
        success, err = pcall(function()
            WindUI = loadstring(
                game:HttpGet("https://github.com/Footagesus/WindUI/releases/download/1.6.66/main.lua")
            )()
        end)
    end

    if not success or not WindUI then
        warn("[RDX Hub] ERRO: Não foi possível carregar o WindUI!")
        warn(err)
        CustomNotify({
            Title = "Erro Crítico",
            Content = "Falha ao carregar WindUI. Veja o console.",
            Icon = "❌",
            Color = Color3.fromRGB(220, 60, 70),
            Duration = 8
        })
        return
    end

    print("[RDX Hub] WindUI carregado com sucesso!")

    local windowSuccess, windowError = pcall(function()
        Window = WindUI:CreateWindow({
            Title = "RDX Hub",
            Icon = "infinity",
            Author = "RDX",
            Folder = "RDXHub",
            Size = UDim2.fromOffset(580, 440),
            Transparent = true,
            Theme = "Dark",
            Resizable = true,
            SideBarWidth = 180,
        })
    end)

    if not windowSuccess or not Window then
        warn("[RDX Hub] Erro ao criar Window:", windowError)
        CustomNotify({
            Title = "Erro Crítico",
            Content = "Não foi possível criar a interface.",
            Icon = "❌",
            Color = Color3.fromRGB(220, 60, 70),
            Duration = 8
        })
        return
    end

    pcall(function()
        Window:EditOpenButton({
            Title = "RDX Hub",
            Icon = "monitor",
            CornerRadius = UDim.new(0, 0),
            StrokeThickness = 2,
            Color = ColorSequence.new(Color3.fromRGB(0, 0, 0), Color3.fromRGB(0, 0, 0)),
            OnlyMobile = false,
            Enabled = true,
            Draggable = true,
        })
    end)

    pcall(function()
        Window:Tag({ Title = "v1.6.9", Icon = "biohazard", Color = Color3.fromHex("#30ff6a") })
        Window:Tag({ Title = "RDX", Icon = "crown",     Color = Color3.fromHex("#ffd700") })
        Window:Tag({ Title = "INFINITO",Icon = "infinity",  Color = Color3.fromHex("#8d5cff") })
    end)

    local MainTab     = Window:Tab({ Title = "Início",         Icon = "home" })
    local ApeloesTab  = Window:Tab({ Title = "Apeloes",        Icon = "script" })
    local LabTab      = Window:Tab({ Title = "Infinity Lab",   Icon = "flask-conical" })
    local DiversosTab = Window:Tab({ Title = "Diversos",       Icon = "layers" })
    local ConfigTab   = Window:Tab({ Title = "Configurações",  Icon = "cog" })
    local CreditsTab  = Window:Tab({ Title = "Créditos",       Icon = "sparkles" })

    ------------------------------------------------------------
    -- INÍCIO
    ------------------------------------------------------------
    MainTab:Paragraph({
        Title = "RDX Hub v1.6.9",
        Desc = "Hub carregado com sucesso. Use as abas do menu lateral para navegar.",
    })

    MainTab:Paragraph({
        Title = "Contador de Scripts",
        Desc = "Aperte o botão abaixo para ver quantos Scripts tem no Hub.",
    })

    MainTab:Button({
        Title = "Ver quantos Scripts tem",
        Callback = function()
            local total = GetTotalScripts()
            CustomNotify({
                Title = "RDX Hub",
                Content = "Existem " .. total .. " scripts disponíveis!",
                Icon = "📜",
                Duration = 5,
            })
        end,
    })

    MainTab:Toggle({
        Title = "Ativar efeitos visuais",
        Desc = "Liga/desliga efeitos visuais do Hub",
        Default = true,
        Callback = function(state)
            CustomNotify({
                Title = "RDX Hub",
                Content = state and "Efeitos visuais ativados" or "Efeitos visuais desativados",
                Icon = state and "✨" or "🚫",
                Duration = 3,
            })
        end,
    })

    ------------------------------------------------------------
    -- APELOES
    ------------------------------------------------------------
    local function AddButtonSection(tab, title, icon, list)
        tab:Section({ Title = title, Icon = icon })
        for _, data in ipairs(list) do
            tab:Button({
                Title = data[1],
                Callback = function() LoadScript(data[2]) end
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

    ApeloesTab:Paragraph({
        Title = "Scripts do RDX Hub",
        Desc = "Novos scripts exclusivos e atualizados.",
    })
    for _, data in ipairs(InfinityExtraScripts) do
        ApeloesTab:Button({
            Title = data[1],
            Callback = function() LoadScript(data[2]) end
        })
    end

    ------------------------------------------------------------
    -- INFINITY LAB
    ------------------------------------------------------------
    LabTab:Paragraph({
        Title = "🧪 Infinity Lab",
        Desc = "Scripts novos, exclusivos e experimentais do hub.",
    })
    for _, data in ipairs(InfinityLabScripts) do
        LabTab:Button({
            Title = data[1],
            Callback = function() LoadScript(data[2]) end
        })
    end

    ------------------------------------------------------------
    -- DIVERSOS
    ------------------------------------------------------------
    DiversosTab:Paragraph({
        Title = "Mexe na tela e alguns script",
        Desc = "Scripts para mexer na tela e testes.",
    })
    for _, data in ipairs(MexeNaTelaScripts) do
        DiversosTab:Button({
            Title = data[1],
            Callback = function() LoadScript(data[2]) end
        })
    end

    DiversosTab:Paragraph({
        Title = "Scripts utilitários",
        Desc = "Fly, emotes, crosshair e outros.",
    })
    for _, data in ipairs(UtilitariosScripts) do
        DiversosTab:Button({
            Title = data[1],
            Callback = function() LoadScript(data[2]) end
        })
    end

    ------------------------------------------------------------
    -- CONFIGURAÇÕES
    ------------------------------------------------------------
    ConfigTab:Slider({
        Title = "FOV",
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

    ConfigTab:Button({
        Title = "Destruir Interface 🔨",
        Callback = function()
            pcall(function()
                if Window then
                    Window:Destroy()
                    Window = nil
                end
            end)
            CustomNotify({
                Title = "RDX Hub",
                Content = "Interface destruída.",
                Icon = "🔨",
                Duration = 3
            })
        end,
    })

    ------------------------------------------------------------
    -- CRÉDITOS
    ------------------------------------------------------------
    CreditsTab:Paragraph({ Title = "Script Maker",     Desc = "RDX 🖥️ — cria novas funções e recursos." })
    CreditsTab:Paragraph({ Title = "Script Developer", Desc = "RDX ⚒️ — atualiza e corrige bugs." })
    CreditsTab:Paragraph({ Title = "Versão",           Desc = "v1.6.9 — Infinity Lab com 14 scripts." })

    print("[RDX Hub] Hub criado com sucesso!")

    CustomNotify({
        Title = "RDX Hub",
        Content = "Script carregado com sucesso! Versão v1.6.9",
        Icon = "✅",
        Duration = 5,
    })
end

------------------------------------------------------------
-- EXECUÇÃO PRINCIPAL
------------------------------------------------------------

task.spawn(function()
    local started = false

    local function StartHub(accepted)
        if started then return end
        started = true

        if accepted then
            task.wait(0.15)
            local success, err = pcall(BuildHub)
            if not success then
                warn("[RDX Hub] Erro ao iniciar o Hub:", err)
                CustomNotify({
                    Title = "Erro Crítico",
                    Content = "O RDX Hub encontrou um erro ao iniciar.",
                    Icon = "❌",
                    Color = Color3.fromRGB(220, 60, 70),
                    Duration = 7
                })
            end
        else
            CustomNotify({
                Title = "RDX Hub",
                Content = "Você saiu da whitelist.",
                Icon = "🚫",
                Color = Color3.fromRGB(220, 60, 70),
                Duration = 4
            })
        end
    end

    local success, err = pcall(function()
        ShowWhitelistPrompt(StartHub)
    end)

    if not success then
        warn("[RDX Hub] Erro na whitelist:", err)
        CustomNotify({
            Title = "Erro Crítico",
            Content = "Não foi possível abrir a whitelist.",
            Icon = "❌",
            Color = Color3.fromRGB(220, 60, 70),
            Duration = 7
        })
    end
end)
