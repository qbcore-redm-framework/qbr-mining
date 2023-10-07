local Translations = {
    menu = {
        select = 'Select Goods',
        amount = 'Item Amount',
        open = 'talk with '
    },
    error = {
        amount = 'you should put a value for %{text}',
        pickaxe = 'you don\'t have a pickaxe!',
        mined = 'this zone is already mined',
        general = 'there was an error!',
        add_item = 'there was an error during add item!',
        remove_item = 'there was an error during removing item!',
        money = 'you do not have enough money!'
    },
    mining = {
        entrance = 'Mine Entrance',
        zone = 'Mining Zone',
        start = 'to start mining ',
        progress = 'Mining in Progress..',
        success = 'you have found %{text}',
        selling = 'you have sell %{amount} qty of %{item}',
        bought = 'you have bought %{amount} qty of %{item}'
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})