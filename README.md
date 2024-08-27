# MakeTheRecipe v1.0

# Game explained
### MakeTheRecipe è un memory game sulla cucina.
L'obiettivo del gioco è quello di inserire nell'ordine corretto gli ingredienti al fine di preparare il piatto che viene proposto ad ogni livello.
All'avanzamento di ogni livello, saranno assegnati 10 punti e vi sarà un reset del timer a 10 secondi utili per superare il livello:
* Al mancato superamento del livello causato dall'inserimento nell'ordine non corretto, il punteggio verrà azzerato e bisognerà ricominciare dal primo livello.
> [ La sconfitta verrà segnalata con un output di testo che darà anche la possibilità di ricominciare. ]
* Allo scadere del tempo utile, il punteggio verrà azzerato e bisognerà ricominciare dal primo livello.
> [ La notifica verrà segnalata con un output di testo che darà anche la possibilità di ricominciare. ]
* Al superamento di tutti i livelli, sarà mostrato a schermo il punteggio effettuato. -> *LIVELLO * 10 / LIVELLI_DISPONIBILI* 
> [ La notifica verrà segnalata con un output di testo che darà anche la possibilità di ricominciare. ]

![alt text](https://i.imgur.com/JHcP0Ep_d.webp?maxwidth=760&fidelity=grand)

# Game structure
Il gioco è stato sviluppato in modo da render **modulabile l'inserimento e rimozione di più ricette**, difatti troviamo due tabelle separate 'piatti' e 'ingredienti'.

### PIATTI: tabella utile per stampare in modo modulare il piatto da preparare e utilizzata nell'algoritmo di controllo sull'ordine di inserimento.
main.lua: riga 1-4
> local piatti = {

    "Carbonara", "Pizza Margherita", "Risotto ai funghi", "Tiramisù", 
    "Hamburger con patatine fritte", "Sushi assortito", "Lasagne al forno", "Tagliatelle al ragù", "Gelato al cioccolato",
    "Spaghetti Aglio, Olio e Peperoncino", "Bruschetta al Pomodoro", "Caprese Salad", "Pasta al Pesto",
    "Insalata di Pollo Caesar", "Pasta alla Puttanesca", "Frittata di Verdure", "Risotto al Limone"}
>}

### INGREDIENTI: tabella utile per stampare in modo modulare gli ingredienti da inserire e utilizzata nell'algoritmo di controllo sull'ordine di inserimento.
main.lua: riga 6-24
> local ingredienti = {

    ["Carbonara"] = {"Spaghetti", "Uova", "Guanciale", "Pecorino romano"},
    ["Pizza Margherita"] = {"Pizza base", "Salsa di pomodoro", "Mozzarella", "Basilico"},
    ["Risotto ai funghi"] = {"Riso", "Funghi", "Brodo", "Burro"},
    ["Tiramisù"] = {"Savoiardi", "Mascarpone", "Caffè", "Cacao"},
    ["Hamburger con patatine fritte"] = {"Pane per hamburger", "Hamburger di carne", "Lattuga", "Pomodoro"},
    ["Sushi assortito"] = {"Riso per sushi", "Pesce crudo", "Alga nori", "Wasabi"},
    ["Lasagne al forno"] = {"Pasta per lasagne", "Ragù", "Besciamella", "Parmigiano"},
    ["Tagliatelle al ragù"] = {"Tagliatelle", "Ragù", "Pecorino romano", "Pepe"},
    ["Gelato al cioccolato"] = {"Latte", "Panna", "Cioccolato", "Zucchero"},
    ["Spaghetti Aglio, Olio e Peperoncino"] = {"Spaghetti", "Aglio", "Olio d'oliva", "Peperoncino"},
    ["Bruschetta al Pomodoro"] = {"Pane rustico", "Pomodori maturi", "Aglio", "Basilico fresco"},
    ["Caprese Salad"] = {"Pomodori", "Mozzarella di bufala", "Basilico", "Olio d'oliva extra vergine"},
    ["Pasta al Pesto"] = {"Pasta", "Basilico fresco", "Olio d'oliva", "Pinoli"},
    ["Insalata di Pollo Caesar"] = {"Lattuga romana", "Petto di pollo grigliato", "Crostini di pane", "Salsa Caesar"},
    ["Pasta alla Puttanesca"] = {"Pasta", "Pomodori pelati", "Acciughe sott'olio", "Olive nere"},
    ["Frittata di Verdure"] = {"Uova", "Zucchine", "Pomodori", "Cipolla"},
    ["Risotto al Limone"] = {"Riso Arborio", "Limone", "Brodo vegetale", "Parmigiano grattugiato"}

>}

### Il codice è composto da varie funzioni che ne permettono la:
- [x] Generazione dell'ordine randomica degli ingredienti all'avvio di ogni livello. ->  **shuffle()**
- [x] Gestione dello scorrimento del timer e di pulizia lista in caso di avanzamento/reset livello. -> **rimuoviTimer() & rimuoviIngredienti()**
- [x] Gestione del controllo sull'ordine di inserimento. -> **controllaIngredientiSelezionati()**
- [x] Gestione degli eventi di vittoria/sconfitta con relativi OUTPUT visivi testuali.
- [x] Schermata di primo Boot con caricamento, citazione all'ateneo, crediti di sviluppo, regole del gioco e tasto per iniziare. -> **mostraSchermataCaricamento() & avviaGioco()**

### Soluzione ai livelli:
    ["Carbonara"] = {"Spaghetti", "Uova", "Guanciale", "Pecorino romano"},
    ["Pizza Margherita"] = {"Pizza base", "Salsa di pomodoro", "Mozzarella", "Basilico"},
    ["Risotto ai funghi"] = {"Riso", "Funghi", "Brodo", "Burro"},
    ["Tiramisù"] = {"Savoiardi", "Mascarpone", "Caffè", "Cacao"},
    ["Hamburger con patatine fritte"] = {"Pane per hamburger", "Hamburger di carne", "Lattuga", "Pomodoro"},
    ["Sushi assortito"] = {"Riso per sushi", "Pesce crudo", "Alga nori", "Wasabi"},
    ["Lasagne al forno"] = {"Pasta per lasagne", "Ragù", "Besciamella", "Parmigiano"},
    ["Tagliatelle al ragù"] = {"Tagliatelle", "Ragù", "Pecorino romano", "Pepe"},
    ["Gelato al cioccolato"] = {"Latte", "Panna", "Cioccolato", "Zucchero"},
    ["Spaghetti Aglio, Olio e Peperoncino"] = {"Spaghetti", "Aglio", "Olio d'oliva", "Peperoncino"},
    ["Bruschetta al Pomodoro"] = {"Pane rustico", "Pomodori maturi", "Aglio", "Basilico fresco"},
    ["Caprese Salad"] = {"Pomodori", "Mozzarella di bufala", "Basilico", "Olio d'oliva extra vergine"},
    ["Pasta al Pesto"] = {"Pasta", "Basilico fresco", "Olio d'oliva", "Pinoli"},
    ["Insalata di Pollo Caesar"] = {"Lattuga romana", "Petto di pollo grigliato", "Crostini di pane", "Salsa Caesar"},
    ["Pasta alla Puttanesca"] = {"Pasta", "Pomodori pelati", "Acciughe sott'olio", "Olive nere"},
    ["Frittata di Verdure"] = {"Uova", "Zucchine", "Pomodori", "Cipolla"},
    ["Risotto al Limone"] = {"Riso Arborio", "Limone", "Brodo vegetale", "Parmigiano grattugiato"}


> [!NOTE]
> Gioco programmato in LUA con l'engine Corona based in Solar2D, tutto il codice è frutto di studio e ricerca online, il font utilizzato è "Gameplay" scaricato gratuitamente da [Dafont.com](https://www.dafont.com/gameplay.font) l'immagine sfondo del gioco è stata generata dall'intelligenza artificiale [Copilot by Microsoft](https://copilot.microsoft.com/).
