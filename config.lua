Config = {}

Config.banks = {
    { name = "Valentine Bank", x = -308.50, y = 776.24, z = 118.75, city = "Valentine", blipsprite = -2128054417 },
    { name = "Blackwater Bank", x = -813.18, y = -1277.60, z = 43.68, city = "Blackwater", blipsprite = -2128054417 },
    { name = "Saint Denis Bank", x = 2644.08, y = -1292.21, z = 52.29, city = "Saint Denis", blipsprite = -2128054417 },
    { name = "Rhodes Bank", x = 1294.14, y = -1303.06, z = 77.04, city = "Rhodes", blipsprite = -2128054417 },
}

Config.adminwebhook = ""
Config.webhookavatar = "https://www.pngmart.com/files/5/Bank-PNG-Transparent-Picture.png"
Config.gold = true

Config.CostSlot = 10 -- COST FOR UPGRADE SLOT + 1
Config.MaxSlots = 100 -- MAX SLOT FOR UPDATE
Config.keys = {
    G = 0x760A9C6F,
}

Config.language = {
    openmenu = "Menu",
    bank = "Bank",
    welcome = "Welcome To The Bank",
    cashbalance = "Money: $",
    goldbalance = "Gold: ",
    cashbalance2 = "Your Savings.",
    takecash = "Withdraw Cash",
    depocash = "Deposit Cash",
    takegold = "Withdraw Gold",
    depogold = "Deposit Gold",
    takecash2 = "Withdraw Your Cash",
    depocash2 = "Deposit Your Cash",
    takegold2 = "Withdraw Your Gold",
    depogold2 = "Deposit Your Gold",
    depoitem = "Use your Safebox",
    depoitem2 = "Space Available: ",
    confirm = "Confirm",
    amount = "Amount",
    youdepo = "You Deposited $",
    youdepog = "You Deposited G",
    invalid = "Invalid Amount",
    withdrew = "You Withdrew $",
    withdrewg = "You Withdrew G",
    withc = "Withdraw Cash",
    withg = "Withdraw Gold",
    depoc = "Deposit Cash",
    depog = "Deposit Gold",
    namebank = "Bank Inventory",
    limit = "You cannot carry other items",
    maxlimit = "You have reached the max of the item",
    upgradeitem = "Upgrade Slot Safe Box",
    upgradeitem2 = "Cost for upgrade slots: " .. Config.CostSlot .. " $/each",
    nomoney = "You haven't money",
    success = "You upgraded Safe Box by paying $ ",
    maxslots = "You have reached the maximum slots: "
}
