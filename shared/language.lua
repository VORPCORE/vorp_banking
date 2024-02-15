Translation = {}

Translation.Langs = {
    English = {
        openmenu     = "Speak to the attendant",
        closemenu    = "The bank is currently closed",
        bank         = "Welcome to",
        welcome      = "Welcome To The Bank",
        cashbalance  = "Money: $",
        goldbalance  = "Gold: ",
        cashbalance2 = "Your Savings.",
        takecash     = "Withdraw Cash",
        depocash     = "Deposit Cash",
        takegold     = "Withdraw Gold",
        depogold     = "Deposit Gold",
        takecash2    = "Withdraw Your Cash",
        depocash2    = "Deposit Your Cash",
        takegold2    = "Withdraw Your Gold",
        depogold2    = "Deposit Your Gold",
        depoitem     = "Use your Safebox",
        depoitem2    = "Space Available: ",
        confirm      = "Confirm",
        amount       = "Amount of slots",
        youdepo      = "You Deposited $",
        youdepog     = "You Deposited G",
        invalid      = "Invalid Amount",
        withdrew     = "You Withdraw $",
        withdrewg    = "You Withdraw G",
        withc        = "Withdraw Cash",
        withg        = "Withdraw Gold",
        depoc        = "Deposit Cash",
        depog        = "Deposit Gold",
        namebank     = "Bank Inventory",
        limit        = "You cannot carry other items",
        maxlimit     = "You have reached the max of the item",
        upgradeitem  = "Upgrade Slot Safe Box",
        upgradeitem2 = "Cost for each slot: $ ",
        nomoney      = "You dont have money",
        success      = "You upgraded Safe Box by paying $ ",
        maxslots     = "You have reached the maximum slots ",
        maxitems     = "The limit for this item is: ",
        depoitem3    = "You have deposited ",
        of           = " of ",
        withitem     = "You have withdrawn ",
        cant         = "You cannot deposit this item",
        closed       = "The bank is currently closed",
        openHours    = "Opening Hours",
        amTimeZone   = "am",
        pmTimeZone   = "pm",
        noaccmoney   = "You can't transfer that much money!",
        transfer     = "You have transferred ",
        to           = " to ",
        transferred  = " successfully.",
        bankacc      = "Additional Bank Accounts",
        bankaccinfo  = "Here you have an overview of your bank accounts in other cities. You can make transfers to your account HERE.",
        transferinfo = "You can have money transferred here. There is a 10% fee applied to each transfer!",
        inputsLang   = {
            -- [ DEPOSIT CASH ]
            confirmCash = "Confirm",            -- Button Name
            insertAmountCash = "insert amount", -- Placeholder Name
            depositCash = "DEPOSIT CASH",       -- Header of Button
            numOnlyCash = "numbers only",       -- if input doesn't match show this message
            -- [ DEPOSIT GOLD ]
            confirmGold = "Confirm",
            insertAmountGold = "insert amount",
            depositGold = "DEPOSIT GOLD",
            numOnlyGold = "numbers only",
            ------------------------------------
            -- [ WITHDRAW CASH ]
            confirmCashW = "Confirm",
            insertAmountCashW = "insert amount",
            withdrawCash = "WITHDRAW CASH",
            numOnlyCashW = "numbers only",
            -- [ WITHDRAW GOLD ]
            confirmGoldW = "Confirm",
            insertAmountGoldW = "insert amount",
            withdrawGold = "WITHDRAW GOLD",
            numOnlyGoldW = "numbers only",
            ------------------------------------
            -- [ MONEY TRANSFER ]
            Transfer = "Transfer",
            depositTransfer = "How much would you like to transfer to your bank account HERE?", -- Button Header
            ------------------------------------
            -- [ UPGRADE SLOTS INV ]
            confirmUp = "Confirm",
            insertAmountUp = "insert amount",
            upgradeSlots = "UP SLOTS",
            numOnlyUp = "numbers only",
        },
        Webhooks = {
            LogTitle = "🏦 Bank Activity Log",
            WithdrawLogDescription = "💸 **Player:** `%s`\n**Withdrew:** `%s`\n**From Bank:** `%s`",
            DepositLogDescription = "💰 **Player:** `%s`\n**Deposited:** `%s`\n**To Bank:** `%s`",
            TransferLogDescription = "🔄 **Player:** `%s`\n**Transferred:** `%s`\n**From Bank:** `%s`\n**To Bank:** `%s`",
            TakeLogDescription = "📤 **Player:** `%s`\n**Take:** `%s %s`\n**From Bank:** `%s`",
            MoveLogDescription = "📥 **Player:** `%s`\n**Moved:** `%s %s`\n**To Bank:** `%s`"
        }
    },
    Portuguese_PT = {
        openmenu     = "Falar com o atendente",
        closemenu    = "The bank is currently closed",
        bank         = "Seja bem-vindo(a) ao",
        welcome      = "Bem-vindo ao Banco",
        cashbalance  = "Dinheiro: $",
        goldbalance  = "Ouro: ",
        cashbalance2 = "As suas Economias.",
        takecash     = "Levantar Dinheiro",
        depocash     = "Depositar Dinheiro",
        takegold     = "Levantar Ouro",
        depogold     = "Depositar Ouro",
        takecash2    = "Levantar o Seu Dinheiro",
        depocash2    = "Depositar o Seu Dinheiro",
        takegold2    = "Levantar o Seu Ouro",
        depogold2    = "Depositar o Seu Ouro",
        depoitem     = "Usar o seu Cofre",
        depoitem2    = "Espaço Disponível: ",
        confirm      = "Confirmar",
        amount       = "Quantidade de espaços",
        youdepo      = "Depositou $",
        youdepog     = "Depositou G",
        invalid      = "Quantidade Inválida",
        withdrew     = "Levantou $",
        withdrewg    = "Levantou G",
        withc        = "Levantar Dinheiro",
        withg        = "Levantar Ouro",
        depoc        = "Depositar Dinheiro",
        depog        = "Depositar Ouro",
        namebank     = "Inventário do Banco",
        limit        = "Não pode transportar outros itens",
        maxlimit     = "Atingiu o máximo do item",
        upgradeitem  = "Melhorar Espaço no Cofre",
        upgradeitem2 = "Custo por cada espaço: $ ",
        nomoney      = "Não tem dinheiro",
        success      = "Melhorou o Cofre pagando $ ",
        maxslots     = "Atingiu o número máximo de espaços: ",
        maxitems     = "O limite para este item é: ",
        depoitem3    = "Depositou ",
        of           = " de ",
        withitem     = "Levantou ",
        cant         = "Não pode depositar este item",
        closed       = "O banco encontra-se fechado",
        openHours    = "Horário de Funcionamento",
        amTimeZone   = "am",
        pmTimeZone   = "pm",
        noaccmoney   = "You can't transfer that much money!",
        transfer     = "You have transferred ",
        to           = " to ",
        transferred  = " successfully.",
        bankacc      = "Additional Bank Accounts",
        bankaccinfo  = "Here you have an overview of your bank accounts in other cities. You can make transfers to your account HERE.",
        transferinfo = "You can have money transferred here. There is a 10% fee applied to each transfer!",
        inputsLang   = {
            -- [ DEPOSITAR DINHEIRO ]
            confirmCash = "Confirmar",            -- Nome do botão
            insertAmountCash = "inserir quantia", -- Nome do espaço reservado (placeholder)
            depositCash = "DEPOSITAR DINHEIRO",   -- Cabeçalho do botão
            numOnlyCash = "apenas números",      -- Mensagem se o input não for válido
            -- [ DEPOSITAR OURO ]
            confirmGold = "Confirmar",
            insertAmountGold = "inserir quantia",
            depositGold = "DEPOSITAR OURO",
            numOnlyGold = "apenas números",
            ------------------------------------
            -- [ LEVANTAR DINHEIRO ]
            confirmCashW = "Confirmar",
            insertAmountCashW = "inserir quantia",
            withdrawCash = "LEVANTAR DINHEIRO",
            numOnlyCashW = "apenas números",
            -- [ LEVANTAR OURO ]
            confirmGoldW = "Confirmar",
            insertAmountGoldW = "inserir quantia",
            withdrawGold = "LEVANTAR OURO",
            numOnlyGoldW = "apenas números",
            ------------------------------------
            -- [ MONEY TRANSFER ]
            Transfer = "Transfer",
            depositTransfer = "How much would you like to transfer to your bank account HERE?", -- Button Header
            ------------------------------------
            -- [ MELHORAR ESPAÇOS DO INVENTÁRIO ]
            confirmUp = "Confirmar",
            insertAmountUp = "inserir quantia",
            upgradeSlots = "MELHORAR ESPAÇOS",
            numOnlyUp = "apenas números",
        }
    },
    Portuguese_BR = {
        openmenu     = "Falar com o atendente",
        closemenu    = "The bank is currently closed",
        bank         = "Seja bem vindo(a) ao",
        welcome      = "Bem-vindo ao Banco",
        cashbalance  = "Dinheiro: $",
        goldbalance  = "Ouro: ",
        cashbalance2 = "Suas Economias.",
        takecash     = "Sacar Dinheiro",
        depocash     = "Depositar Dinheiro",
        takegold     = "Sacar Ouro",
        depogold     = "Depositar Ouro",
        takecash2    = "Sacar Seu Dinheiro",
        depocash2    = "Depositar Seu Dinheiro",
        takegold2    = "Sacar Seu Ouro",
        depogold2    = "Depositar Seu Ouro",
        depoitem     = "Usar seu Cofre",
        depoitem2    = "Espaço Disponível: ",
        confirm      = "Confirmar",
        amount       = "Quantidade de espaços",
        youdepo      = "Você depositou $",
        youdepog     = "Você depositou G",
        invalid      = "Quantidade inválida",
        withdrew     = "Você sacou $",
        withdrewg    = "Você sacou G",
        withc        = "Sacar Dinheiro",
        withg        = "Sacar Ouro",
        depoc        = "Depositar Dinheiro",
        depog        = "Depositar Ouro",
        namebank     = "Inventário do Banco",
        limit        = "Você não pode carregar outros itens",
        maxlimit     = "Você atingiu o máximo deste item",
        upgradeitem  = "Melhorar Espaço no Cofre",
        upgradeitem2 = "Custo por espaço: $ ",
        nomoney      = "Você não tem dinheiro",
        success      = "Você melhorou o Cofre pagando $ ",
        maxslots     = "Você atingiu o número máximo de espaços: ",
        maxitems     = "O limite para este item é: ",
        depoitem3    = "Você depositou ",
        of           = " de ",
        withitem     = "Você sacou ",
        cant         = "Você não pode depositar este item",
        closed       = "O banco está fechado no momento",
        openHours    = "Horário de Funcionamento",
        amTimeZone   = "am",
        pmTimeZone   = "pm",
        noaccmoney   = "You can't transfer that much money!",
        transfer     = "You have transferred ",
        to           = " to ",
        transferred  = " successfully.",
        bankacc      = "Additional Bank Accounts",
        bankaccinfo  = "Here you have an overview of your bank accounts in other cities. You can make transfers to your account HERE.",
        transferinfo = "You can have money transferred here. There is a 10% fee applied to each transfer!",
        inputsLang   = {
            -- [ DEPOSIT CASH ]
            confirmCash = "Confirmar",               -- Nome do Botão
            insertAmountCash = "inserir quantidade", -- Nome do Marcador de posição
            depositCash = "DEPOSITAR DINHEIRO",      -- Cabeçalho do Botão
            numOnlyCash = "apenas números",         -- Se a entrada não corresponder, mostrar esta mensagem
            -- [ DEPOSIT GOLD ]
            confirmGold = "Confirmar",
            insertAmountGold = "inserir quantidade",
            depositGold = "DEPOSITAR OURO",
            numOnlyGold = "apenas números",
            ------------------------------------
            -- [ WITHDRAW CASH ]
            confirmCashW = "Confirmar",
            insertAmountCashW = "inserir quantidade",
            withdrawCash = "SACAR DINHEIRO",
            numOnlyCashW = "apenas números",
            -- [ WITHDRAW GOLD ]
            confirmGoldW = "Confirmar",
            insertAmountGoldW = "inserir quantidade",
            withdrawGold = "SACAR OURO",
            numOnlyGoldW = "apenas números",
            ------------------------------------
            -- [ MONEY TRANSFER ]
            Transfer = "Transfer",
            depositTransfer = "How much would you like to transfer to your bank account HERE?", -- Button Header
            ------------------------------------
            -- [ UPGRADE SLOTS INV ]
            confirmUp = "Confirmar",
            insertAmountUp = "inserir quantidade",
            upgradeSlots = "AUMENTAR ESPAÇOS",
            numOnlyUp = "apenas números",
        }
    },
    Francais = {
        openmenu     = "Parler à l'agent",
        closemenu    = "The bank is currently closed",
        bank         = "Bienvenue à",
        welcome      = "Bienvenue à la Banque",
        cashbalance  = "Argent : $",
        goldbalance  = "Or : ",
        cashbalance2 = "Vos économies.",
        takecash     = "Retirer de l'argent",
        depocash     = "Déposer de l'argent",
        takegold     = "Retirer de l'or",
        depogold     = "Déposer de l'or",
        takecash2    = "Retirer votre argent",
        depocash2    = "Déposer votre argent",
        takegold2    = "Retirer votre or",
        depogold2    = "Déposer votre or",
        depoitem     = "Utilisez votre Coffre",
        depoitem2    = "Espace disponible : ",
        confirm      = "Confirmer",
        amount       = "Nombre d'emplacements",
        youdepo      = "Vous avez déposé $",
        youdepog     = "Vous avez déposé G",
        invalid      = "Montant invalide",
        withdrew     = "Vous avez retiré $",
        withdrewg    = "Vous avez retiré G",
        withc        = "Retirer de l'argent",
        withg        = "Retirer de l'or",
        depoc        = "Déposer de l'argent",
        depog        = "Déposer de l'or",
        namebank     = "Inventaire de la Banque",
        limit        = "Vous ne pouvez pas transporter d'autres objets",
        maxlimit     = "Vous avez atteint la limite de cet objet",
        upgradeitem  = "Améliorer l'emplacement du Coffre",
        upgradeitem2 = "Coût pour chaque emplacement : $",
        nomoney      = "Vous n'avez pas d'argent",
        success      = "Vous avez amélioré le Coffre en payant $",
        maxslots     = "Vous avez atteint le nombre maximum d'emplacements : ",
        maxitems     = "La limite pour cet objet est de : ",
        depoitem3    = "Vous avez déposé ",
        of           = " de ",
        withitem     = "Vous avez retiré ",
        cant         = "Vous ne pouvez pas déposer cet objet",
        closed       = "La banque est actuellement fermée",
        openHours    = "Heures d'ouverture",
        amTimeZone   = "matin",
        pmTimeZone   = "après-midi",
        noaccmoney   = "You can't transfer that much money!",
        transfer     = "You have transferred ",
        to           = " to ",
        transferred  = " successfully.",
        bankacc      = "Additional Bank Accounts",
        bankaccinfo  = "Here you have an overview of your bank accounts in other cities. You can make transfers to your account HERE.",
        transferinfo = "You can have money transferred here. There is a 10% fee applied to each transfer!",
        inputsLang   = {
            -- [ DÉPOSER DE L'ARGENT ]
            confirmCash = "Confirmer",               -- Nom du bouton
            insertAmountCash = "insérer le montant", -- Nom de l'espace réservé
            depositCash = "DÉPOSER DE L'ARGENT",    -- En-tête du bouton
            numOnlyCash = "nombres uniquement",      -- si la saisie ne correspond pas, afficher ce message
            -- [ DÉPOSER DE L'OR ]
            confirmGold = "Confirmer",
            insertAmountGold = "insérer le montant",
            depositGold = "DÉPOSER DE L'OR",
            numOnlyGold = "nombres uniquement",
            ------------------------------------
            -- [ RETIRER DE L'ARGENT ]
            confirmCashW = "Confirmer",
            insertAmountCashW = "insérer le montant",
            withdrawCash = "RETIRER DE L'ARGENT",
            numOnlyCashW = "nombres uniquement",
            -- [ RETIRER DE L'OR ]
            confirmGoldW = "Confirmer",
            insertAmountGoldW = "insérer le montant",
            withdrawGold = "RETIRER DE L'OR",
            numOnlyGoldW = "nombres uniquement",
            ------------------------------------
            -- [ MONEY TRANSFER ]
            Transfer = "Transfer",
            depositTransfer = "How much would you like to transfer to your bank account HERE?", -- Button Header
            ------------------------------------
            -- [ AMÉLIORER LES EMPLACEMENTS DE L'INV ]
            confirmUp = "Confirmer",
            insertAmountUp = "insérer le montant",
            upgradeSlots = "UP SLOTS",
            numOnlyUp = "nombres uniquement",
        }
    },
    German = {
        openmenu     = "Mit dem Mitarbeiter sprechen",
        closemenu    = "Die Bank hat aktuell geschlossen",
        bank         = "Willkommen bei",
        welcome      = "Willkommen in der Bank",
        cashbalance  = "Geld: $",
        goldbalance  = "Gold: ",
        cashbalance2 = "Ihre Ersparnisse.",
        takecash     = "Bargeld abheben",
        depocash     = "Bargeld einzahlen",
        takegold     = "Gold abheben",
        depogold     = "Gold einzahlen",
        takecash2    = "Ihr Bargeld abheben",
        depocash2    = "Ihr Bargeld einzahlen",
        takegold2    = "Ihr Gold abheben",
        depogold2    = "Ihr Gold einzahlen",
        depoitem     = "Verwenden Sie Ihren Safe",
        depoitem2    = "Verfügbarer Platz: ",
        confirm      = "Bestätigen",
        amount       = "Anzahl der Plätze",
        youdepo      = "Sie haben $ eingezahlt",
        youdepog     = "Sie haben G eingezahlt",
        invalid      = "Ungültiger Betrag",
        withdrew     = "Sie haben $ abgehoben",
        withdrewg    = "Sie haben G abgehoben",
        withc        = "Bargeld abheben",
        withg        = "Gold abheben",
        depoc        = "Bargeld einzahlen",
        depog        = "Gold einzahlen",
        namebank     = "Bank Inventar",
        limit        = "Sie können keine anderen Gegenstände tragen",
        maxlimit     = "Sie haben das Maximum für diesen Gegenstand erreicht",
        upgradeitem  = "Safe Box Slot erweitern",
        upgradeitem2 = "Kosten pro Platz: $ ",
        nomoney      = "Sie haben kein Geld",
        success      = "Sie haben den Safe erfolgreich erweitert und $ bezahlt",
        maxslots     = "Sie haben die maximale Anzahl an Plätzen erreicht: ",
        maxitems     = "Das Limit für diesen Gegenstand ist: ",
        depoitem3    = "Sie haben ",
        of           = " von ",
        withitem     = "Sie haben ",
        cant         = "Sie können diesen Gegenstand nicht einzahlen",
        closed       = "Die Bank ist derzeit geschlossen",
        openHours    = "Öffnungszeiten",
        amTimeZone   = "vorm.",
        pmTimeZone   = "nachm.",
        noaccmoney   = "Soviel Geld kannst du nicht überweisen!",
        transfer     = "Du hast ",
        to           = " nach ",
        transferred  = " überwiesen.",
        bankacc      = "Weitere Bankkonten",
        bankaccinfo  = "Hier hast du eine Übersicht, über deine Bankkonten in andern Städten, du kannst Überweisungen auf dein Konto HIER vornehmen.",
        transferinfo = "Du kannst dir Geld hierher überweisen lassen, es fallen 10% Gebühren auf jede Überweisung an! Die Gebühren werden dem zu überweisenden Betrag abgezogen.",
        inputsLang   = {
            -- [ GELD EINZAHLEN ]
            confirmCash = "Bestätigen",          -- Button Name
            insertAmountCash = "Betrag eingeben", -- Placeholder Name
            depositCash = "GELD EINZAHLEN",       -- Überschrift des Buttons
            numOnlyCash = "nur Zahlen",           -- wenn die Eingabe nicht passt, zeige diese Nachricht an
            -- [ GOLD EINZAHLEN ]
            confirmGold = "Bestätigen",
            insertAmountGold = "Betrag eingeben",
            depositGold = "GOLD EINZAHLEN",
            numOnlyGold = "nur Zahlen",
            ------------------------------------
            -- [ GELD ABHEBEN ]
            confirmCashW = "Bestätigen",
            insertAmountCashW = "Betrag eingeben",
            withdrawCash = "GELD ABHEBEN",
            numOnlyCashW = "nur Zahlen",
            -- [ GOLD ABHEBEN ]
            confirmGoldW = "Bestätigen",
            insertAmountGoldW = "Betrag eingeben",
            withdrawGold = "GOLD ABHEBEN",
            numOnlyGoldW = "nur Zahlen",
            ------------------------------------
            -- [ GELD ÜBERWEISUNG ]
            Transfer = "Überweisung",
            depositTransfer = "Welchen Betrag, darf ich auf ihr Bankkonto HIER überweisen?", -- Überschrift des Buttons
            ------------------------------------
            -- [ SLOTS ERWEITERN ]
            confirmUp = "Bestätigen",
            insertAmountUp = "Betrag eingeben",
            upgradeSlots = "PLÄTZE ERWEITERN",
            numOnlyUp = "nur Zahlen",
        }
    },
    Spanish = {
        openmenu     = "Hablar con el empleado",
        closemenu    = "El banco está actualmente cerrado",
        bank         = "Bienvenido a",
        welcome      = "Bienvenido Al Banco",
        cashbalance  = "Dinero: $",
        goldbalance  = "Oro: ",
        cashbalance2 = "Tus Ahorros.",
        takecash     = "Retirar Dinero",
        depocash     = "Depositar Dinero",
        takegold     = "Retirar Oro",
        depogold     = "Depositar Oro",
        takecash2    = "Retirar Tu Dinero",
        depocash2    = "Depositar Tu Dinero",
        takegold2    = "Retirar Tu Oro",
        depogold2    = "Depositar Tu Oro",
        depoitem     = "Usar tu Caja Fuerte",
        depoitem2    = "Espacio Disponible: ",
        confirm      = "Confirmar",
        amount       = "Cantidad de espacios",
        youdepo      = "Has depositado $",
        youdepog     = "Has depositado G",
        invalid      = "Cantidad Inválida",
        withdrew     = "Has retirado $",
        withdrewg    = "Has retirado G",
        withc        = "Retirar Dinero",
        withg        = "Retirar Oro",
        depoc        = "Depositar Dinero",
        depog        = "Depositar Oro",
        namebank     = "Inventario del Banco",
        limit        = "No puedes llevar otros objetos",
        maxlimit     = "Has alcanzado el máximo de este objeto",
        upgradeitem  = "Mejorar Espacios Caja Fuerte",
        upgradeitem2 = "Costo por cada espacio: $ ",
        nomoney      = "No tienes suficiente dinero",
        success      = "Has mejorado tu Caja Fuerte pagando $ ",
        maxslots     = "Has alcanzado el máximo de espacios: ",
        maxitems     = "El límite para este objeto es: ",
        depoitem3    = "Has depositado ",
        of           = " de ",
        withitem     = "Has retirado ",
        cant         = "No puedes depositar este objeto",
        closed       = "El banco está cerrado actualmente",
        openHours    = "Horario de Apertura",
        amTimeZone   = "am",
        pmTimeZone   = "pm",
        noaccmoney   = "You can't transfer that much money!",
        transfer     = "You have transferred ",
        to           = " to ",
        transferred  = " successfully.",
        bankacc      = "Additional Bank Accounts",
        bankaccinfo  = "Here you have an overview of your bank accounts in other cities. You can make transfers to your account HERE.",
        transferinfo = "You can have money transferred here. There is a 10% fee applied to each transfer!",
        inputsLang   = {
            -- [ DEPOSITAR DINERO ]
            confirmCash = "Confirmar",             -- Nombre del Botón
            insertAmountCash = "insertar cantidad", -- Nombre del Marcador de posición
            depositCash = "DEPOSITAR DINERO",       -- Encabezado del Botón
            numOnlyCash = "solo números",           -- Si la entrada no coincide, muestra este mensaje
            -- [ DEPOSITAR ORO ]
            confirmGold = "Confirmar",
            insertAmountGold = "insertar cantidad",
            depositGold = "DEPOSITAR ORO",
            numOnlyGold = "solo números",
            ------------------------------------
            -- [ RETIRAR DINERO ]
            confirmCashW = "Confirmar",
            insertAmountCashW = "insertar cantidad",
            withdrawCash = "RETIRAR DINERO",
            numOnlyCashW = "solo números",
            -- [ RETIRAR ORO ]
            confirmGoldW = "Confirmar",
            insertAmountGoldW = "insertar cantidad",
            withdrawGold = "RETIRAR ORO",
            numOnlyGoldW = "solo números",
            ------------------------------------
            -- [ MONEY TRANSFER ]
            Transfer = "Transfer",
            depositTransfer = "How much would you like to transfer to your bank account HERE?", -- Button Header
            ------------------------------------
            -- [ MEJORAR ESPACIOS INV ]
            confirmUp = "Confirmar",
            insertAmountUp = "insertar cantidad",
            upgradeSlots = "MEJORAR ESPACIOS",
            numOnlyUp = "solo números",
        }
    },
	Romanian = {
		openmenu     = "Vorbiti cu angajatul",
		closemenu    = "Banca este închisă momentan",
		bank         = "Bine ati venit la",
		welcome      = "Bine ati venit la Banca",
		cashbalance  = "Bani: $",
		goldbalance  = "Aur: ",
		cashbalance2 = "Conturile tale.",
		takecash     = "Retrage bani",
		depocash     = "Depune bani",
		takegold     = "Retrage aur",
		depogold     = "Depune aur",
		takecash2    = "Retrage-ti banii",
		depocash2    = "Depune-ti banii",
		takegold2    = "Retrage-ti aurul",
		depogold2    = "Depune-ti aurul",
		depoitem     = "Folosește cutia ta de valori",
		depoitem2    = "Spatiu disponibil: ",
		confirm      = "Confirmă",
		amount       = "Numărul de sloturi",
		youdepo      = "Ai depus $",
		youdepog     = "Ai depus G",
		invalid      = "Sumă invalidă",
		withdrew     = "Ai retras $",
		withdrewg    = "Ai retras G",
		withc        = "Retrage bani",
		withg        = "Retrage aur",
		depoc        = "Depune bani",
		depog        = "Depune aur",
		namebank     = "Inventarul băncii",
		limit        = "Nu poti purta alte obiecte",
		maxlimit     = "Ai atins limita maximă a obiectului",
		upgradeitem  = "Upgrade Slot Cutie de Valori",
		upgradeitem2 = "Cost pentru fiecare slot: $ ",
		nomoney      = "Nu ai bani",
		success      = "Ai upgrade-at cutia de valori, plătind $ ",
		maxslots     = "Ai atins numărul maxim de sloturi: ",
		maxitems     = "Limita pentru acest obiect este: ",
		depoitem3    = "Ai depozitat ",
		of           = " din ",
		withitem     = "Ai retras ",
		cant         = "Nu poti depune acest obiect",
		closed       = "Banca este închisă momentan",
		openHours    = "Orele de deschidere",
		amTimeZone   = "am",
		pmTimeZone   = "pm",
		noaccmoney   = "Nu poti transfera atât de multi bani!",
		transfer     = "Ai transferat ",
		to           = " către ",
		transferred  = " cu succes.",
		bankacc      = "Conturi bancare suplimentare",
		bankaccinfo  = "Aici ai o vedere de ansamblu a conturilor tale bancare în alte orașe. Puteti face transferuri către contul TĂU aici.",
		transferinfo = "Puteti transfera bani aici. Se aplică o taxă de 10% la fiecare transfer!",
        inputsLang   = {
			 -- [ DEPOZITARE BANI ]
			confirmCash = "Confirmă",             -- Numele Butonului
			insertAmountCash = "introdu suma",     -- Numele de Afișare
			depositCash = "DEPOZITEAZĂ BANI",      -- Antetul Butonului
			numOnlyCash = "doar numere",           -- Mesaj afișat dacă input-ul nu este valid
			-- [ DEPOZITARE AUR ]
			confirmGold = "Confirmă",
			insertAmountGold = "introdu suma",
			depositGold = "DEPOZITEAZĂ AUR",
			numOnlyGold = "doar numere",
			------------------------------------
			-- [ RETRAGERE BANI ]
			confirmCashW = "Confirmă",
			insertAmountCashW = "introdu suma",
			withdrawCash = "RETRAGE BANI",
			numOnlyCashW = "doar numere",
			-- [ RETRAGERE AUR ]
			confirmGoldW = "Confirmă",
			insertAmountGoldW = "introdu suma",
			withdrawGold = "RETRAGE AUR",
			numOnlyGoldW = "doar numere",
			------------------------------------
			-- [ TRANSFER DE BANI ]
			Transfer = "Transfer",
			depositTransfer = "Cât dorești să transferi în contul tău bancar AICI?", -- Antetul Butonului
			------------------------------------
			-- [ UPGRADE SLOTURI INVENTAR ]
			confirmUp = "Confirmă",
			insertAmountUp = "introdu suma",
			upgradeSlots = "UPGRADE SLOTURI",
			numOnlyUp = "doar numere",

        }
    },
}
