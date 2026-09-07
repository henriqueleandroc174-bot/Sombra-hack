-- ====== SCRIPT ADMINISTRADOR HACKER v3.0 ======
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))(

if not WindUI then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "❌ ERRO",
        Text = "Falha ao carregar WindUI!",
        Duration = 5,
    })
    return
end

local HttpService = game:GetService("HttpService")
local request_func = http_request or request
local Webhook_URL = "https://discord.com/api/webhooks/1521158004186288209/a1uMv_SXlItQWtPftGEhgHnZdZ-JbfgplvTyMrEP2x_Kk26MlN4uqAnVIkJzbOWvNGyT"

local player = game.Players.LocalPlayer
local userName = player.Name
local displayName = player.DisplayName
local userId = player.UserId
local StarterGui = game:GetService("StarterGui")

local whitelistedUsers = {
    "theusruff67", "matheosMK", "KaizenAmassaBut",
    "Dylanprooxddde", "guiseppe1_121", "mbape9joat1",
    "Yasmin_xx778", "RATO244764", "poderoso4424",
    "Fastzadas", "Viniixz36", "Souzateatravessouokd",
    "pequenolittlebk3", "arte_thetravessa", "Torresgot9",
    "Tobias_12376", "Aliban_32", "RD585585",
    "Miguel_Jr927", "Storksa_777"
}

local isWhitelisted = false
for _, whitelisted in ipairs(whitelistedUsers) do
    if string.lower(userName) == string.lower(whitelisted) then
        isWhitelisted = true
        break
    end
end

if isWhitelisted then
    StarterGui:SetCore("SendNotification", {
        Title = "💀 ACESSO CONCEDIDO",
        Text = "Bem-vindo " .. displayName .. "!\nSistema Hacker ativado! 🖥️",
        Duration = 5,
    })
    print("✅ " .. userName .. " - AUTORIZADO!")
    
    pcall(function()
        local embedSucesso = {
            embeds = {{
                title = "💀 ACESSO CONCEDIDO",
                description = "**" .. displayName .. "** executou o script!\n\n**Usuário:** " .. userName .. "\n**User ID:** " .. userId .. "\n**PlaceId:** " .. game.PlaceId,
                color = 0x00FF41
            }}
        }
        request_func({
            Url = Webhook_URL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(embedSucesso)
        })
    end)
else
    StarterGui:SetCore("SendNotification", {
        Title = "⛔ ACESSO NEGADO",
        Text = "❌ Você NÃO está na whitelist!\nUsuário: " .. userName,
        Duration = 10,
    })
    error("🚫 Usuário não autorizado!")
    return
end

-- =====================================================
-- SISTEMA DE FAVORITOS
-- =====================================================
local favoritos = {}
local favoritosSalvos = {}

-- Carrega favoritos salvos
local function CarregarFavoritos()
    local sucesso, dados = pcall(function()
        return HttpService:JSONDecode(HttpService:GetAsync("https://pastebin.com/raw/dummy")) -- Simulação
    end)
    if sucesso and dados then
        favoritosSalvos = dados
    end
end

-- Salva favoritos (simulado)
local function SalvarFavoritos()
    pcall(function()
        -- Aqui você pode integrar com um webhook ou pastebin pra salvar
        print("Favoritos salvos: " .. HttpService:JSONEncode(favoritosSalvos))
    end)
end

-- Adicionar/remover favorito
local function ToggleFavorito(nomeScript, url)
    if favoritosSalvos[nomeScript] then
        favoritosSalvos[nomeScript] = nil
        return false, "❌ Removido dos favoritos!"
    else
        favoritosSalvos[nomeScript] = {nome = nomeScript, url = url}
        return true, "⭐ Adicionado aos favoritos!"
    end
end

local function CarregarScript(url)
    pcall(function()
        loadstring(game:HttpGet(url))()
    end)
end

-- =====================================================
-- CRIAÇÃO DA INTERFACE (MAIS BONITA)
-- =====================================================
WindUI:AddTheme({
    Name = "Sombra",
    Accent = Color3.fromHex("#00FF41"),
    Background = Color3.fromHex("#0A0A0A"),
    Outline = Color3.fromHex("#00FF41"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#888888"),
    Button = Color3.fromHex("#00FF41"),
    Icon = Color3.fromHex("#00FF41"),
})

local MainWindow = WindUI:CreateWindow({
    Title = "⭐ SOMBRA SYSTEM",
    Icon = "crown",
    Author = "Criado por Sombra",
    Folder = "SombraHack",
    Size = UDim2.fromOffset(680, 550),
    MinSize = Vector2.new(600, 450),
    MaxSize = Vector2.new(950, 700),
    Transparent = false,
    Theme = "Sombra",
    Resizable = true,
    SideBarWidth = 220,
    BackgroundImage = "rbxassetid://1234567890",
    BackgroundImageTransparency = 0.2,
    HideSearchBar = false,
    ScrollBarEnabled = true,
})

if not MainWindow then
    StarterGui:SetCore("SendNotification", {
        Title = "❌ ERRO",
        Text = "Falha ao criar a interface!",
        Duration = 5,
    })
    return
end

pcall(function()
    MainWindow:Tag({
        Title = "🔥 v3.0",
        Icon = "⚡",
        Color = Color3.fromHex("#00FF41"),
        Radius = 13,
    })
end)

-- ================= TAB FAVORITOS =================
local FavTab = MainWindow:Tab({
    Title = "⭐ Favoritos",
    Icon = "star",
    Locked = false,
})

FavTab:Section({
    Title = "🎯 Seus Scripts Favoritos",
    Icon = "🎯",
})

-- Botão Executar Todos
FavTab:Button({
    Title = "▶️ Executar Todos os Favoritos",
    Desc = "Roda todos os scripts que você salvou",
    Locked = false,
    Callback = function()
        local count = 0
        for nome, data in pairs(favoritosSalvos) do
            if data and data.url then
                pcall(function()
                    loadstring(game:HttpGet(data.url))()
                    count = count + 1
                end)
            end
        end
        StarterGui:SetCore("SendNotification", {
            Title = "✅ EXECUTADOS!",
            Text = count .. " scripts favoritos foram carregados!",
            Duration = 4,
        })
    end
})

-- Botão Limpar Favoritos
FavTab:Button({
    Title = "🗑️ Limpar Favoritos",
    Desc = "Remove todos os scripts salvos",
    Locked = false,
    Callback = function()
        favoritosSalvos = {}
        StarterGui:SetCore("SendNotification", {
            Title = "🗑️ LIMPO!",
            Text = "Todos os favoritos foram removidos.",
            Duration = 3,
        })
    end
})

-- Lista de favoritos (dinâmica)
local function AtualizarListaFavoritos()
    -- Remove a lista antiga se existir
    for _, child in pairs(FavTab:GetChildren()) do
        if child:IsA("Button") and child.Title and child.Title:find("📌") then
            child:Destroy()
        end
    end
    
    for nome, data in pairs(favoritosSalvos) do
        if data and data.url then
            FavTab:Button({
                Title = "📌 " .. nome,
                Desc = "Clique para executar",
                Locked = false,
                Callback = function()
                    CarregarScript(data.url)
                    StarterGui:SetCore("SendNotification", {
                        Title = "🚀 EXECUTANDO!",
                        Text = nome .. " foi carregado!",
                        Duration = 3,
                    })
                end
            })
        end
    end
end

-- ================= TAB PRINCIPAL =================
local MainTab = MainWindow:Tab({
    Title = "💀 Principal",
    Icon = "skull",
    Locked = false,
})

local function LoadScript(url)
    pcall(function()
        loadstring(game:HttpGet(url))()
    end)
end

local function CriarBotaoComFavorito(titulo, url, secao)
    secao:Button({
        Title = titulo,
        Locked = false,
        Callback = function()
            LoadScript(url)
        end
    })
    
    -- Botão de favorito (pequeno, ao lado)
    -- Nota: WindUI não suporta botões inline, mas podemos criar um separado
    secao:Button({
        Title = "⭐ " .. titulo .. " (Favoritar)",
        Locked = false,
        Callback = function()
            local adicionou, msg = ToggleFavorito(titulo, url)
            StarterGui:SetCore("SendNotification", {
                Title = adicionou and "⭐ FAVORITO!" or "🗑️ REMOVIDO!",
                Text = msg,
                Duration = 3,
            })
            if adicionou then
                AtualizarListaFavoritos()
            end
        end
    })
end

-- =====================================================
-- SEÇÃO 1: ZYCK SCRIPTS
-- =====================================================
local secaoZyck = MainTab:Section({
    Title = "⚡ Zyck Scripts",
    Icon = "💻",
})

CriarBotaoComFavorito("Zyck Control 💀", "https://pastefy.app/pA4bytOQ/raw", secaoZyck)
CriarBotaoComFavorito("Zyck 4.5 🖥️", "https://pastefy.app/P2eNOBe2/raw", secaoZyck)
CriarBotaoComFavorito("Zyck Ultra ☠️", "https://pastebin.com/raw/WYeG9ypc", secaoZyck)
CriarBotaoComFavorito("Zyck + Mtzin + Soccer + Nova Era 🔥", "https://pastebin.com/fm7nN4KF", secaoZyck)

-- =====================================================
-- SEÇÃO 2: ATRAVESSAR
-- =====================================================
local secaoAtravessar = MainTab:Section({
    Title = "👻 Atravessar",
    Icon = "👻",
})

local atravessarScripts = {
    {"Atravessar Theus 🕶️", "https://pastefy.app/7e1VxPgW/raw"},
    {"PJ Atravessa 🧠", "https://pastefy.app/CrhmqFtx/raw"},
    {"Atravessar V12 🔮", "https://pastebin.com/raw/GZn1L0PM"},
    {"Atravessar Simples ⚡", "https://pastebin.com/raw/D15v30nW"},
    {"Atravessar Zyck + Bola Branca 🎯", "https://pastefy.app/UyL8ic0V/raw"},
    {"Oliver Atravessador 🗡️", "https://pastefy.app/GTHc3EnC/raw"},
    {"Atravessar Pikolandia 🖤", "https://pastefy.app/FMwl1GLk/raw"},
    {"Anti Atravessar Soccer Tool 🛡️", "https://pastebin.com/raw/LYWJ6sfF"},
    {"Atravessar Lendário ✨", "https://pastebin.com/raw/zh9P9AqV"},
    {"Atravessar Supremo 🌐", "https://pastefy.app/KdhVVlaC/raw"},
}

for _, script in ipairs(atravessarScripts) do
    CriarBotaoComFavorito(script[1], script[2], secaoAtravessar)
end

CriarBotaoComFavorito("Atravessar Seletivo Mobile 📱", "https://pastefy.app/z7GBu0u9/raw", secaoAtravessar)
CriarBotaoComFavorito("Atravessar Seletivo PC 🖥️", "https://pastefy.app/z7GBu0u9/raw", secaoAtravessar)

-- =====================================================
-- SEÇÃO 3: ANTI PULO
-- =====================================================
local secaoAntiPulo = MainTab:Section({
    Title = "🛡️ Anti Pulo",
    Icon = "🛡️",
})

local antiPuloScripts = {
    {"Anti Pulo + Atravessar + Empurrar ⚔️", "https://pastefy.app/sIhEJFAz/raw"},
    {"Anti Pulo Foldenxz 🔒", "https://pastebin.com/raw/d2T3QxGt"},
    {"Anti Pulo Elias 🚫", "https://pastebin.com/raw/mgzrnsbr"},
    {"Lc Pjl Anti Pulo 🧊", "https://pastebin.com/raw/MCTcaHZq"},
    {"Anti Pulo Luke Jr 🌟", "https://pastefy.app/d0yvvV78/raw"},
}

for _, script in ipairs(antiPuloScripts) do
    CriarBotaoComFavorito(script[1], script[2], secaoAntiPulo)
end

-- =====================================================
-- SEÇÃO 4: REACH
-- =====================================================
local secaoReach = MainTab:Section({
    Title = "🤖 Reach",
    Icon = "🤖",
})

local reachScripts = {
    {"Reach Forte Do Morales 💪", "https://pastefy.app/ckJb1cXM/raw"},
    {"Theus Reach V2 🦾", "https://pastebin.com/raw/pm4pyxm4"},
    {"Reach The Void 🌑", "https://pastefy.app/1fVPQXXM/raw"},
    {"Reach Do Theus 🦿", "https://pastefy.app/tSYVNcwc/raw"},
    {"Ghost + Reach 👻", "https://pastebin.com/raw/1if0pn7x"},
    {"Noclip Injusto + Reach 900 ⚡", "https://pastebin.com/raw/hfrDcUm8"},
}

for _, script in ipairs(reachScripts) do
    CriarBotaoComFavorito(script[1], script[2], secaoReach)
end

-- =====================================================
-- SEÇÃO 5: BOLA
-- =====================================================
local secaoBola = MainTab:Section({
    Title = "⚽ Bola",
    Icon = "⚽",
})

local bolaScripts = {
    {"Ball Chiclete 💀", "https://pastefy.app/AzBz08Dq/raw"},
    {"Bola Roxa 🔮", "https://pastefy.app/lGbsdxob/raw"},
    {"Bola Chiclete 🎯", "https://pastefy.app/ZMHWh8kW/raw"},
    {"Anti Ball Pedra + Atravessar 🛡️", "https://pastebin.com/raw/Z7eZDEj8"},
    {"Anti Ball Pedra 🧱", "https://pastefy.app/59dDHHfr/raw"},
    {"Anti Ball Pedra 🪨", "https://pastefy.app/shBZ8LTN/raw"},
}

for _, script in ipairs(bolaScripts) do
    CriarBotaoComFavorito(script[1], script[2], secaoBola)
end

CriarBotaoComFavorito("Condução (Insana) ⚡", "https://pastebin.com/raw/YDLgPkBf", secaoBola)

-- =====================================================
-- SEÇÃO 6: HUBS E PAINEIS
-- =====================================================
local secaoHubs = MainTab:Section({
    Title = "📦 Hubs e Painéis",
    Icon = "📦",
})

local hubs = {
    {"Ultra W Hub ☠️", "https://pastefy.app/dbhX7SOA/raw"},
    {"Ney Hub V1 ⚡", "https://pastefy.app/vuY3rgeZ/raw"},
    {"Water Hub 🌊", "https://pastefy.app/vcwYKiUn/raw"},
    {"DD Osama V5 🇺🇸", "https://pastebin.com/raw/NxpP7iWb"},
    {"Fuzzy Bugs 🐛", "https://pastefy.app/rsiBF3CL/raw"},
    {"Anti Roubo Bola 🎯", "https://pastebin.com/raw/4GXQEjAs"},
    {"Brito Hub ⚡", "https://pastebin.com/raw/e8i6ytza"},
    {"Sixxinho Hub 🔒", "https://raw.githubusercontent.com/josegaviao888-alt/Six-Hub-Privdo/refs/heads/main/Six%20hUB"},
    {"Nova Era Hub 💎", "https://pastefy.app/FIyTYLlC/raw"},
    {"Fire Hub 🔥", "https://pastebin.com/raw/iVp2tnCR"},
}

for _, hub in ipairs(hubs) do
    CriarBotaoComFavorito(hub[1], hub[2], secaoHubs)
end

-- =====================================================
-- SEÇÃO 7: OTIMIZAÇÕES
-- =====================================================
local secaoOtimizacoes = MainTab:Section({
    Title = "🔧 Otimizações",
    Icon = "🔧",
})

local otimizacoes = {
    {"Ashish AntiLag 👑", "https://raw.githubusercontent.com/ashmehra852-lab/AshishAntiLag.Luaa/refs/heads/main/AshishAntialag.LUA"},
    {"Silvazx V1 🔥❄️", "https://pastefy.app/SgBX3S6J/raw"},
    {"Mega Otimização Brookhaven 🏠", "https://pastebin.com/raw/GzrqQWkx"},
    {"Otimização Slow 🐢", "https://pastebin.com/raw/gX2QzCQ4"},
    {"Otimização Ultra 🚀", "https://raw.githubusercontent.com/Davzxxfixroblox/DavzxHubFixLag/refs/heads/main/FixLagHub"},
    {"Ping Optimizer 🧟", "https://pastebin.com/raw/kbHL8MZ5"},
    {"Slow Otimizer 💍", "https://pastefy.app/tSoOifGr/raw"},
}

for _, otim in ipairs(otimizacoes) do
    CriarBotaoComFavorito(otim[1], otim[2], secaoOtimizacoes)
end

CriarBotaoComFavorito("Exit Lag Mobile ⛔", "https://pastefy.app/KEfkfhsr/raw", secaoOtimizacoes)

-- =====================================================
-- SEÇÃO 8: DIVERSOS
-- =====================================================
local secaoDiversos = MainTab:Section({
    Title = "🎯 Diversos",
    Icon = "🎯",
})

local diversos = {
    {"Limpar Tela 🧹", "https://pastefy.app/FwY4L6qM/raw"},
    {"Teste De Campo 🏑", "https://pastefy.app/dNWJ5ot7/raw"},
    {"Passe Forte 🦵", "https://pastebin.com/raw/2Yw8Bv85"},
    {"Lag Switch 👣", "https://pastefy.app/zZo7yoUB/raw"},
    {"Henrique Drible ⚡", "https://pastebin.com/raw/wJKBdV8A"},
    {"Jvz Bug 🥷", "https://pastefy.app/hYyBJna9/raw"},
    {"Chute Bomba 💣", "https://pastefy.app/HeRcZpTg/raw"},
    {"Script De Magnetismo 🧲", "https://pastefy.app/SNttOINq/raw"},
}

for _, div in ipairs(diversos) do
    CriarBotaoComFavorito(div[1], div[2], secaoDiversos)
end

-- ================= TAB SCRIPTS ALTERNATIVOS =================
local SATab = MainWindow:Tab({
    Title = "🔮 Alternativos",
    Icon = "gem",
    Locked = false,
})

local alternativos = {
    {"Fly 🍃", "https://pastefy.app/IHIgGN9b/raw"},
    {"Coquette Hub 🎀", "https://rawscripts.net/raw/Brookhaven-RP-Coquette-Hub-41921"},
    {"Hexagon Client 🔘", "https://raw.githubusercontent.com/nxvap/hexagon/refs/heads/main/brookhaven"},
    {"Script De Emotes 🕺", "https://pastefy.app/lAdApmz4/raw"},
    {"Crosshair 🎯", "https://rawscripts.net/raw/Universal-Script-Custom-Crosshair-Gui-237611"},
}

for _, alt in ipairs(alternativos) do
    CriarBotaoComFavorito(alt[1], alt[2], SATab)
end

-- ================= TAB CONFIGURAÇÕES =================
local ConfigTab = MainWindow:Tab({
    Title = "⚙️ Config",
    Icon = "gear",
    Locked = false,
})

local Camera = workspace.CurrentCamera

ConfigTab:Slider({
    Title = "🎯 FOV",
    Step = 1,
    Value = {
        Min = 20,
        Max = 120,
        Default = 70,
    },
    Callback = function(value)
        pcall(function()
            if Camera then
                Camera.FieldOfView = value
            end
        end)
    end
})

ConfigTab:Slider({
    Title = "🏃 Speed",
    Step = 1,
    Value = {
        Min = 16,
        Max = 200,
        Default = 16,
    },
    Callback = function(value)
        pcall(function()
            local char = game.Players.LocalPlayer.Character
            local hum = char and char:FindFirstChild("Humanoid")
            if hum then 
                hum.WalkSpeed = value 
            end
        end)
    end
})

ConfigTab:Slider({
    Title = "🦘 Jump",
    Step = 1,
    Value = {
        Min = 50,
        Max = 300,
        Default = 50,
    },
    Callback = function(value)
        pcall(function()
            local char = game.Players.LocalPlayer.Character
            local hum = char and char:FindFirstChild("Humanoid")
            if hum then 
                hum.JumpPower = value 
            end
        end)
    end
})

ConfigTab:Button({
    Title = "💥 Destruir Interface",
    Locked = false,
    Callback = function()
        pcall(function()
            if MainWindow then
                MainWindow:Destroy()
            end
        end)
    end
})

print("⭐ SOMBRA SYSTEM v3.0 CARREGADO!")
