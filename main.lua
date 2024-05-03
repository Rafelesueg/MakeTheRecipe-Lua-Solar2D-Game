local piatti = {"Carbonara", "Pizza Margherita", "Insalata Caesar", "Risotto ai funghi", "Tiramisù", 
                "Hamburger con patatine fritte", "Sushi assortito", "Lasagne al forno", "Tagliatelle al ragù", "Gelato al cioccolato"}

local ingredienti = {
    ["Carbonara"] = {"Spaghetti", "Uova", "Guanciale", "Pecorino romano"},
    ["Pizza Margherita"] = {"Pizza base", "Salsa di pomodoro", "Mozzarella", "Basilico"},
    ["Insalata Caesar"] = {"Lattuga", "Croutons", "Parmigiano", "Salsa Caesar"},
    ["Risotto ai funghi"] = {"Riso", "Funghi", "Brodo", "Burro"},
    ["Tiramisù"] = {"Savoiardi", "Mascarpone", "Caffè", "Cacao"},
    ["Hamburger con patatine fritte"] = {"Pane per hamburger", "Hamburger di carne", "Lattuga", "Pomodoro"},
    ["Sushi assortito"] = {"Riso per sushi", "Pesce crudo", "Alga nori", "Wasabi"},
    ["Lasagne al forno"] = {"Pasta per lasagne", "Ragù", "Besciamella", "Parmigiano"},
    ["Tagliatelle al ragù"] = {"Tagliatelle", "Ragù", "Pecorino romano", "Pepe"},
    ["Gelato al cioccolato"] = {"Latte", "Panna", "Cioccolato", "Zucchero"}
}

-- Funzione per mischiare un'array
local function shuffle(t)
    local n = #t
    while n > 2 do
        local k = math.random(n)
        t[n], t[k] = t[k], t[n]
        n = n - 1
    end
    return t
end

local livello = 1
local punteggio = 0
local tempo_disponibile = 5
local tempo_attuale = tempo_disponibile
local ingredientiText = {}
local ingredientiInseriti = {}
local count = 1
local ricettaText = nil

local function rimuoviIngredienti()
    for i = 1, #ingredientiText do
        ingredientiText[i]:removeSelf()
    end
    ingredientiText = {}
    if ricettaText then
        ricettaText:removeSelf()
        ricettaText = nil
    end
end

local timerDiConteggio -- Variabile globale per il timer
local tempo_iniziale -- Memorizza il tempo iniziale per il livello corrente

local function rimuoviTimer()
    if timerDiConteggio then
        timer.cancel(timerDiConteggio)
        timerDiConteggio = nil
    end
end

local function avviaLivello()

    -- Rimuovi gli oggetti di visualizzazione degli ingredienti dal livello precedente
    rimuoviIngredienti()

    -- Rimuovere gli oggetti di visualizzazione del punteggio e del tempo dal livello precedente
    if punteggioText then
        punteggioText:removeSelf()
        punteggioText = nil
    end
    if tempoText then
        tempoText:removeSelf()
        tempoText = nil
    end
    if lvlText then
        lvlText:removeSelf()
        lvlText = nil
    end
    if ricettaText then
        ricettaText:removeSelf()
        ricettaText = nil
    end

    -- Visualizzazione del punteggio e del timer al centro dello schermo
    punteggioText = display.newText("Punteggio: " .. punteggio, display.contentCenterX, display.contentCenterY - 150, "Gameplay.ttf", 20)
    punteggioText:setFillColor(0,0,102)
    lvlText = display.newText("Livello: " .. livello, display.contentCenterX, display.contentCenterY - 100, "Gameplay.ttf", 20)
    
    -- Inizializzazione del testo della ricetta
    ricettaText = display.newText("" .. piatti[livello], display.contentCenterX, display.contentCenterY - 20, "Gameplay.ttf", 16)
    ricettaText:setFillColor(204, 102, 0)

    local ingredientiMischiati = {}
    for _, ingrediente in ipairs(ingredienti[piatti[livello]]) do
        table.insert(ingredientiMischiati, ingrediente)
    end
    shuffle(ingredientiMischiati)

    local function controllaIngredientiSelezionati()
        if #ingredientiInseriti == #ingredienti[piatti[livello]] then
            local ingredientiRichiesti = ingredienti[piatti[livello]]
            local tuttiPresenti = true
            
            -- Verifica che tutti gli ingredienti inseriti siano corretti e nella stessa posizione di quelli richiesti
            for i, ingrediente in ipairs(ingredientiInseriti) do
                if ingredientiInseriti[i] ~= ingredientiRichiesti[i] then
                    tuttiPresenti = false
                    timer.cancel(timerDiConteggio)
                    rimuoviIngredienti()
                    local failText = display.newText("Ordine sbagliato! Hai perso.", display.contentCenterX, display.contentCenterY, "Gameplay.ttf", 16)
                    failText:setFillColor(1, 0, 0)
                    local ricominciaButton = display.newText("Ricomincia", display.contentCenterX, display.contentCenterY + 50, "Gameplay.ttf", 20)
                    ricominciaButton:setFillColor(0, 1, 0)
                    ricominciaButton:addEventListener("tap", function(event)
                        rimuoviIngredienti()
                        punteggio = 0
                        livello = 1
                        count = 1
                        failText.alpha = 0
                        ricominciaButton.alpha = 0
                        ingredientiInseriti = {}
                        ingredientiRichiesti = {}
                        avviaLivello()
                    end)
                end
            end

            if tuttiPresenti then
                punteggio = punteggio + 10
                livello = livello + 1
                count = 0
                ingredientiInseriti = {}
                ingredientiRichiesti = {}
                if livello <= #piatti then
                    avviaLivello()
                else
                    local winText = display.newText("Congratulazioni! Hai vinto!", display.contentCenterX, display.contentCenterY, "Gameplay.ttf", 18)
                    rimuoviIngredienti()
                    winText:setFillColor(0, 1, 0)
                    local ricominciaButton = display.newText("Ricomincia", display.contentCenterX, display.contentCenterY + 50, "Gameplay.ttf", 20)
                    ricominciaButton:setFillColor(0, 1, 0)
                    ricominciaButton:addEventListener("tap", function(event)
                        rimuoviIngredienti()
                        punteggio = 0
                        livello = 1
                        count = 1
                        ricominciaButton.alpha = 0
                        tempoText.alpha = 0
                        ingredientiInseriti = {}
                        ingredientiRichiesti = {}
                        winText.alpha = 0
                        avviaLivello()
                    end)
                end
            end
        end
    end

    local posY = display.contentCenterY
    local posX = display.contentCenterX - 80
    for i, ingrediente in ipairs(ingredientiMischiati) do
        local ingredienteText = display.newText("" .. ingrediente, posX, posY, "Gameplay.ttf", 16)
        ingredienteText.anchorX = 0
        ingredienteText:setFillColor(0.8, 0.8, 0.8)
        table.insert(ingredientiText, ingredienteText)       
        ingredienteText.isEnabled = true  -- Aggiungi un campo per tenere traccia dello stato dell'oggetto
        ingredienteText:addEventListener("tap", function(event)
            if ingredienteText.isEnabled then  -- Controlla se l'oggetto è abilitato
                ingredientiInseriti[count] = ingrediente
                ingredienteText:setFillColor(0.5, 0.5, 0.5)
                controllaIngredientiSelezionati()
                count = count + 1
                ingredienteText.isEnabled = false  -- Disabilita l'oggetto dopo il clic
            end
        end)
        
        posY = posY + 20
    end

    -- Interrompi il timer se è già attivo
    rimuoviTimer()

    -- Riavvia il timer
    if tempo_iniziale then
        tempo_attuale = tempo_iniziale
    else
        tempo_attuale = tempo_disponibile
    end
    tempoText = display.newText("Tempo: " .. tempo_attuale, display.contentCenterX, display.contentCenterY - 125, "Gameplay.ttf", 20)
    timerDiConteggio = timer.performWithDelay(1000, function()
        tempo_attuale = tempo_attuale - 1
        tempoText.text = "Tempo: " .. tempo_attuale
        if tempo_attuale <= 0 then
            -- Visualizza il messaggio "Tempo Scaduto"
            rimuoviIngredienti()
            local tempoScadutoText = display.newText("Tempo Scaduto", display.contentCenterX, display.contentCenterY - 20, "Gameplay.ttf", 20)
            tempoScadutoText:setFillColor(1, 0, 0)
            local ricominciaButton = display.newText("Ricomincia", display.contentCenterX, display.contentCenterY + 50, "Gameplay.ttf", 20)
            ricominciaButton:setFillColor(0, 1, 0)
            ricominciaButton:addEventListener("tap", function(event)
                tempo_attuale = tempo_disponibile
                punteggio = 0
                livello = 1
                count = 1
                ingredientiInseriti = {}
                ingredientiRichiesti = {}
                ricominciaButton.alpha = 0
                tempoScadutoText:removeSelf()
                avviaLivello()
            end)
            -- Interrompi il timer
            timer.cancel(timerDiConteggio)
            timerDiConteggio = nil
        end
    end, tempo_attuale)
end

--[[ avviaLivello() -- Avvia il primo livello ]]

local function mostraSchermataCaricamento()
    -- Creazione della schermata di caricamento
    local loadingBackground = display.newRect(display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight)
    loadingBackground:setFillColor(0) -- Imposta il colore di sfondo su nero

    local loadingText = display.newText("Caricamento...", display.contentCenterX, display.contentCenterY, "Gameplay.ttf", 12)
    loadingText:setFillColor(1) -- Imposta il colore del testo su bianco o qualsiasi altro colore visibile
    local loadingText2 = display.newText("Corso di Laurea in", display.contentCenterX, display.contentCenterY + 50, "Gameplay.ttf", 14)
    loadingText2:setFillColor(1) -- Imposta il colore del testo su bianco o qualsiasi altro colore visibile
    local loadingText3 = display.newText("Scienze e Tecnologie Multimediali", display.contentCenterX, display.contentCenterY + 70, "Gameplay.ttf", 14)
    loadingText3:setFillColor(1) -- Imposta il colore del testo su bianco o qualsiasi altro colore visibile

    -- Funzione per nascondere la schermata di caricamento e avviare il gioco
    local function avviaGioco()
        -- Rimuovi gli oggetti della schermata di caricamento
        loadingBackground:removeSelf()
        loadingText:removeSelf()
        loadingText2:removeSelf()
        loadingText3:removeSelf()
        
        local startText = display.newText("INIZIA", display.contentCenterX, display.contentCenterY, "Gameplay.ttf", 12)
        loadingText:setFillColor(1) -- Imposta il colore del testo su bianco o qualsiasi altro colore visibile
        startText:addEventListener("tap", function(event)
            avviaLivello()
            startText:removeSelf()
        end)
    end

    -- Avvia il gioco dopo un breve ritardo (ad esempio, 1 secondo)
    timer.performWithDelay(5000, avviaGioco)
end

mostraSchermataCaricamento() -- Mostra la schermata di caricamento prima di avviare il gioco
