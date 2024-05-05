local piatti = {"Carbonara", "Pizza Margherita", "Risotto ai funghi", "Tiramisù", 
                "Hamburger", "Sushi assortito", "Lasagne al forno", "Tagliatelle", "Gelato al cioccolato",
                "Spaghetti Aglio, Olio e Peperoncino", "Bruschetta al Pomodoro", "Caprese Salad", "Pasta al Pesto",
                "Insalata di Pollo Caesar", "Pasta alla Puttanesca", "Frittata di Verdure", "Risotto al Limone"}

local ingredienti = {
    ["Carbonara"] = {"Spaghetti", "Uova", "Guanciale", "Pecorino romano"},
    ["Pizza Margherita"] = {"Pizza base", "Salsa di pomodoro", "Mozzarella", "Basilico"},
    ["Risotto ai funghi"] = {"Riso", "Funghi", "Brodo", "Burro"},
    ["Tiramisù"] = {"Savoiardi", "Mascarpone", "Caffè", "Cacao"},
    ["Hamburger"] = {"Pane per hamburger", "Hamburger di carne", "Lattuga", "Pomodoro"},
    ["Sushi assortito"] = {"Riso per sushi", "Pesce crudo", "Alga nori", "Wasabi"},
    ["Lasagne al forno"] = {"Pasta per lasagne", "Ragù", "Besciamella", "Parmigiano"},
    ["Tagliatelle"] = {"Tagliatelle", "Ragù", "Pecorino romano", "Pepe"},
    ["Gelato al cioccolato"] = {"Latte", "Panna", "Cioccolato", "Zucchero"},
    ["Spaghetti Aglio, Olio e Peperoncino"] = {"Spaghetti", "Aglio", "Olio d'oliva", "Peperoncino"},
    ["Bruschetta al Pomodoro"] = {"Pane rustico", "Pomodori maturi", "Aglio", "Basilico fresco"},
    ["Caprese Salad"] = {"Pomodori", "Mozzarella di bufala", "Basilico", "Olio d'oliva extra vergine"},
    ["Pasta al Pesto"] = {"Pasta", "Basilico fresco", "Olio d'oliva", "Pinoli"},
    ["Insalata di Pollo Caesar"] = {"Lattuga romana", "Petto di pollo grigliato", "Crostini di pane", "Salsa Caesar"},
    ["Pasta alla Puttanesca"] = {"Pasta", "Pomodori pelati", "Acciughe sott'olio", "Olive nere"},
    ["Frittata di Verdure"] = {"Uova", "Zucchine", "Pomodori", "Cipolla"},
    ["Risotto al Limone"] = {"Riso Arborio", "Limone", "Brodo vegetale", "Parmigiano grattugiato"}
}


-- Funzione per mischiare gli ingredienti e renderli randomici ogni volta
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
local tempo_disponibile = 10
local tempo_attuale = tempo_disponibile
local ingredientiText = {}
local ingredientiInseriti = {}
local count = 1
local ricettaText = nil

-- Funzione per rimuovere gli ingredienti quando c'è bisogno di rimuovere la lista in caso di tempo scaduto o di errore.
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

-- Variabili per il timer
local timerDiConteggio 

-- Funzione per rimuovere il timer quando viene richiamato l'avvio del livello, per evitare che il tempo scorra più velocemente
local function rimuoviTimer()
    if timerDiConteggio then
        timer.cancel(timerDiConteggio)
        timerDiConteggio = nil
    end
end

-- Variabili comode per aggiustare la posizione degli elementi
local screenWidth = display.contentWidth
local screenHeight = display.contentHeight
local centerX = screenWidth/2
local centerY = screenHeight/2

local function avviaLivello()
    local background = display.newImageRect("Images.xcassets/bg.jpeg", screenWidth, screenHeight) -- Imposta la dimensione appropriata
    background.x = centerX
    background.y = centerY
    -- Rimuovi gli oggetti di visualizzazione degli ingredienti dal livello precedente
    rimuoviIngredienti()

    -- Rimuovere gli oggetti di visualizzazione del: punteggio,tempo,livello e ricetta dal livello precedente
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

    -- Visualizzazione del punteggio, livello e ricetta
    punteggioText = display.newText("Punteggio: " .. punteggio, display.contentCenterX - 100, display.contentCenterY - 225, "Gameplay.ttf", 12)
    lvlText = display.newText("Livello: " .. livello, display.contentCenterX + 110, display.contentCenterY - 225, "Gameplay.ttf", 12)
    ricettaText = display.newText("" .. piatti[livello], display.contentCenterX + 5 , display.contentCenterY - 35, "Gameplay.ttf", 16)
    ricettaText:setFillColor(204, 102, 0)

    -- Dichiaro gli alimenti da mischiare e li inserisco in questa table e richiamo il metodo creato sopra shuffle()
    local ingredientiMischiati = {}
    for _, ingrediente in ipairs(ingredienti[piatti[livello]]) do
        table.insert(ingredientiMischiati, ingrediente)
    end
    shuffle(ingredientiMischiati)

    -- Funzione per controllare che gli ingredienti selezionati siano nella stessa posizione della lista normalmente ordinata
    local function controllaIngredientiSelezionati()
        -- Controllo se gli elementi inseriti sono tutti e procedo
        if #ingredientiInseriti == #ingredienti[piatti[livello]] then
            local ingredientiRichiesti = ingredienti[piatti[livello]]
            local tuttiPresenti = true
            
            -- Verifica che tutti gli ingredienti inseriti siano corretti e nella stessa posizione della ricetta
            for i, ingrediente in ipairs(ingredientiInseriti) do
                -- Gestione errore e tasto ricomincia
                if ingredientiInseriti[i] ~= ingredientiRichiesti[i] then
                    tuttiPresenti = false
                    timer.cancel(timerDiConteggio)
                    rimuoviIngredienti()
                    local failText = display.newText("Ordine sbagliato!", display.contentCenterX, display.contentCenterY + 20, "Gameplay.ttf", 16)
                    failText:setFillColor(1, 0, 0)
                    local ricominciaButton = display.newText("Ricomincia", display.contentCenterX, display.contentCenterY + 40, "Gameplay.ttf", 18)
                    
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
                -- Gestione avanzamento livello
            if tuttiPresenti then
                punteggio = punteggio + 10
                livello = livello + 1
                count = 0
                ingredientiInseriti = {}
                ingredientiRichiesti = {}
                if livello <= #piatti then
                    avviaLivello()
                else
                    -- Gestione vittoria e tasto ricomincia
                    local winText = display.newText("Hai vinto!", display.contentCenterX, display.contentCenterY + 20, "Gameplay.ttf", 18)
                    rimuoviIngredienti()
                    winText:setFillColor(0, 1, 0)
                    local ricominciaButton = display.newText("Ricomincia", display.contentCenterX, display.contentCenterY + 40, "Gameplay.ttf", 20)
                    
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

    -- Generazione lista attraverso l'iterazione della lista ingredientiMischiati
    local posY = display.contentCenterY
    local posX = display.contentCenterX - 50
    for i, ingrediente in ipairs(ingredientiMischiati) do
        local ingredienteText = display.newText("" .. ingrediente, posX, posY, "Gameplay.ttf", 8)
        ingredienteText.anchorX = 0
        ingredienteText:setFillColor(39, 135, 124)
        table.insert(ingredientiText, ingredienteText)       
        ingredienteText.isEnabled = true  -- Campo per tenere traccia dello stato dell'oggetto
        ingredienteText:addEventListener("tap", function(event)
            if ingredienteText.isEnabled then  -- Controlla se l'oggetto è abilitato
                ingredientiInseriti[count] = ingrediente
                ingredienteText:setFillColor(0.5, 0.5, 0.5)
                controllaIngredientiSelezionati()
                count = count + 1
                ingredienteText.isEnabled = false  -- Disabilita l'oggetto dopo il clic, un debug per non fare inserire più volte lo stesso ingrediente
            end
        end)
        
        posY = posY + 20
    end

    -- Gestione del tempo, resetto il timer ad ogni avanzamento di livello con la funzione rimuoviTimer() e proseguo con la stampa del tempo e con la gestione del tempo scaduto
    rimuoviTimer()
    tempo_attuale = tempo_disponibile
    tempoText = display.newText("Tempo: " .. tempo_attuale, display.contentCenterX + 10, display.contentCenterY - 225, "Gameplay.ttf", 12)
    timerDiConteggio = timer.performWithDelay(1000, function()
        tempo_attuale = tempo_attuale - 1
        tempoText.text = "Tempo: " .. tempo_attuale
        if tempo_attuale <= 0 then
            -- Visualizza il messaggio "Tempo Scaduto"
            rimuoviIngredienti()
            local tempoScadutoText = display.newText("Tempo Scaduto", display.contentCenterX, display.contentCenterY + 20, "Gameplay.ttf", 20)
            tempoScadutoText:setFillColor(1, 0, 0)
            local ricominciaButton = display.newText("Ricomincia", display.contentCenterX, display.contentCenterY + 40, "Gameplay.ttf", 20)
            
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

-- Boot prima del gioco, scheramata di caricamento con citazione al corso di studi e all'Ateneo

local function mostraSchermataCaricamento()
    -- Creazione della schermata di caricamento
    local loadingBackground = display.newRect(display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight)
    loadingBackground:setFillColor(1)

    local uniLogo = display.newImageRect("Images.xcassets/logo.png", 100, 100)
    uniLogo.anchorX = 0
    uniLogo.x = display.contentCenterY - 130
    uniLogo.y = display.contentCenterX - 100
    local creditText = display.newText("dev by Michele Galuzzo", display.contentCenterX, display.contentCenterY + 100, "Gameplay.ttf", 10)
    creditText:setFillColor(0) 
    local loadingText = display.newText("Caricamento...", display.contentCenterX, display.contentCenterY, "Gameplay.ttf", 14)
    loadingText:setFillColor(0) 
    local loadingText2 = display.newText("Corso di Laurea in", display.contentCenterX, display.contentCenterY - 100, "Gameplay.ttf", 12)
    loadingText2:setFillColor(0) 
    local loadingText3 = display.newText("Scienze e Tecnologie Multimediali", display.contentCenterX, display.contentCenterY - 80, "Gameplay.ttf", 12)
    loadingText3:setFillColor(0) 

    -- Funzione per nascondere la schermata di caricamento e avviare il gioco
    local function avviaGioco()
        -- Rimuovi gli oggetti della schermata di caricamento
        uniLogo:removeSelf()
        loadingText:removeSelf()
        loadingText2:removeSelf()
        loadingText3:removeSelf()
        creditText:removeSelf()

        local tutorialtText = display.newText("inserisci nell'ordine giusto per preparare la ricetta", display.contentCenterX, display.contentCenterY - 50, "Gameplay.ttf", 8)
        tutorialtText:setFillColor(0) 
        local startText = display.newText("INIZIA", display.contentCenterX, display.contentCenterY, "Gameplay.ttf", 20)
        startText:setFillColor(0) 

        startText:addEventListener("tap", function(event)
            avviaLivello()
            startText:removeSelf()
            loadingBackground:removeSelf()
        end)
    end

    -- Avvia la funzione avviaGioco() dopo un breve ritardo
    timer.performWithDelay(5000, avviaGioco)
end

mostraSchermataCaricamento() -- Mostra la schermata di caricamento prima di avviare il gioco
