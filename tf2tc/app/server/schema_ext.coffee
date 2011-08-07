

exports.actions =
    allGroups: (cb) ->
        cb exports.direct.allGroups()

    qualCycle: (cb) ->
        cb exports.direct.qualCycle()

    offerItems: (cb) ->
        cb exports.direct.offerItems()


exports.direct =
    allGroups: ->
        groups exports.items

    qualCycle: ->
        quals exports.items

    offerItems: ->
        offerItems exports.items

    items: () ->
        exports.items


groups = (items) ->
    select = (pred) ->
        k for k, i of items when pred(k, i)

    commodities: select (a, b) -> a in ['5000', '5001', '5002', '5021']
    genuine_hats: select (a, b) -> G in b._q and b.craft_class=='hat'
    genuine_weapons: select (a, b) -> G in b._q and b.craft_class=='weapon'
    hats: select (a, b) -> b.item_class=='tf_wearable' and b._t == ALWAYS

    metal: select (a, b) -> b.item_type_name=='Craft Item' and b.craft_class=='craft_bar'
    offers: select (a, b) -> (a < 0) and (b.item_class=='Offer')
    promos: select (a, b) -> a in ['126', '143', '162', '161', '160']
    tools: select (a, b) -> b.item_class=='tool' and b._t == ALWAYS
    tradables: select (a, b) -> b._t == ALWAYS
    untradables: select (a, b) -> b._t == NEVER
    vintage_hats: select (a, b) -> V in b._q and b.craft_class=='hat'
    vintage_weapons: select (a, b) -> V in b._q and b.craft_class=='weapon'
    weapons: select (a, b) -> b.craft_class=='weapon' and b._t == ALWAYS

quals = (items) ->
    m = {}
    m[k] = i._q for k, i of items
    m


offerItems = (items) ->
    m = {}
    m[k] = items[k] for k in groups(items).offers
    m


C=6  # common, aka unique
G=1  # genuine
N=0  # normal
S=11 # strange
U=5  # unusual
V=3  # vintage

NEVER=0
ALWAYS=1
GIFT=-1


# this is a mapping of schema items to very simple item
# definitions.  these simplified definitions contain the '_q'
# property, which is a list of known qualities that the item can
# have, and the '_t' property, which is a value that denotes how the item can
# be traded.

exports.items =
    '-3':
        name: 'Promos'
        _q: [C, V]
        _t: ALWAYS
        item_class: 'Offer'
        item_description: 'Use this when you want promo offers.'
        item_name: 'Promo Offers'
        item_type_name: 'Offer'

    '-2':
        name: 'Hats'
        _q: [C, G, V, U]
        _t: ALWAYS
        item_class: 'Offer'
        item_description: 'Use this when you want hat offers.'
        item_name: 'Hat Offers'
        item_type_name: 'Offer'

    '-1':
        name: 'Open'
        _q: [C, S, G, V, U]
        _t: ALWAYS
        item_class: 'Offer'
        item_description: 'Use this when you want other kinds of offers.'
        item_name: 'Offers'
        item_type_name: 'Offer'

    '0':
        name: 'TF_WEAPON_BAT'
        item_class: 'tf_weapon_bat'
        item_type_name: 'Bat'
        craft_class: 'weapon'
        _q: [C]
        _t: NEVER

    '1':
        name: 'TF_WEAPON_BOTTLE'
        item_class: 'tf_weapon_bottle'
        item_type_name: 'Bottle'
        craft_class: 'weapon'
        _q: [C]
        _t: NEVER

    '2':
        name: 'TF_WEAPON_FIREAXE'
        item_class: 'tf_weapon_fireaxe'
        item_type_name: 'Fire Axe'
        craft_class: 'weapon'
        _q: [C]
        _t: NEVER

    '3':
        name: 'TF_WEAPON_CLUB'
        item_class: 'tf_weapon_club'
        item_type_name: 'Kukri'
        craft_class: 'weapon'
        _q: [C]
        _t: NEVER

    '4':
        name: 'TF_WEAPON_KNIFE'
        item_class: 'tf_weapon_knife'
        item_type_name: 'Knife'
        craft_class: 'weapon'
        _q: [C]
        _t: NEVER

    '5':
        name: 'TF_WEAPON_FISTS'
        item_class: 'tf_weapon_fists'
        item_type_name: 'Fists'
        craft_class: 'weapon'
        _q: [C]
        _t: NEVER

    '6':
        name: 'TF_WEAPON_SHOVEL'
        item_class: 'tf_weapon_shovel'
        item_type_name: 'Shovel'
        craft_class: 'weapon'
        _q: [C]
        _t: NEVER

    '7':
        name: 'TF_WEAPON_WRENCH'
        item_class: 'tf_weapon_wrench'
        item_type_name: 'Wrench'
        craft_class: 'weapon'
        _q: [C]
        _t: NEVER

    '8':
        name: 'TF_WEAPON_BONESAW'
        item_class: 'tf_weapon_bonesaw'
        item_type_name: 'Bonesaw'
        craft_class: 'weapon'
        _q: [C]
        _t: NEVER

    '9':
        name: 'TF_WEAPON_SHOTGUN_PRIMARY'
        item_class: 'tf_weapon_shotgun_primary'
        item_type_name: 'Shotgun'
        craft_class: 'weapon'
        _q: [C]
        _t: NEVER

    '10':
        name: 'TF_WEAPON_SHOTGUN_SOLDIER'
        item_class: 'tf_weapon_shotgun_soldier'
        item_type_name: 'Shotgun'
        craft_class: 'weapon'
        _q: [C]
        _t: NEVER

    '11':
        name: 'TF_WEAPON_SHOTGUN_HWG'
        item_class: 'tf_weapon_shotgun_hwg'
        item_type_name: 'Shotgun'
        craft_class: 'weapon'
        _q: [C]
        _t: NEVER

    '12':
        name: 'TF_WEAPON_SHOTGUN_PYRO'
        item_class: 'tf_weapon_shotgun_pyro'
        item_type_name: 'Shotgun'
        craft_class: 'weapon'
        _q: [C]
        _t: NEVER

    '13':
        name: 'TF_WEAPON_SCATTERGUN'
        item_class: 'tf_weapon_scattergun'
        item_type_name: 'Scattergun'
        craft_class: 'weapon'
        _q: [C]
        _t: NEVER

    '14':
        name: 'TF_WEAPON_SNIPERRIFLE'
        item_class: 'tf_weapon_sniperrifle'
        item_type_name: 'Sniper Rifle'
        craft_class: 'weapon'
        _q: [C]
        _t: NEVER

    '15':
        name: 'TF_WEAPON_MINIGUN'
        item_class: 'tf_weapon_minigun'
        item_type_name: 'Minigun'
        craft_class: 'weapon'
        _q: [C]
        _t: NEVER

    '16':
        name: 'TF_WEAPON_SMG'
        item_class: 'tf_weapon_smg'
        item_type_name: 'SMG'
        craft_class: 'weapon'
        _q: [C]
        _t: NEVER

    '17':
        name: 'TF_WEAPON_SYRINGEGUN_MEDIC'
        item_class: 'tf_weapon_syringegun_medic'
        item_type_name: 'Syringe Gun'
        craft_class: 'weapon'
        _q: [C]
        _t: NEVER

    '18':
        name: 'TF_WEAPON_ROCKETLAUNCHER'
        item_class: 'tf_weapon_rocketlauncher'
        item_type_name: 'Rocket Launcher'
        craft_class: 'weapon'
        _q: [C]
        _t: NEVER

    '19':
        name: 'TF_WEAPON_GRENADELAUNCHER'
        item_class: 'tf_weapon_grenadelauncher'
        item_type_name: 'Grenade Launcher'
        craft_class: 'weapon'
        _q: [C]
        _t: NEVER

    '20':
        name: 'TF_WEAPON_PIPEBOMBLAUNCHER'
        item_class: 'tf_weapon_pipebomblauncher'
        item_type_name: 'Stickybomb Launcher'
        craft_class: 'weapon'
        _q: [C]
        _t: NEVER

    '21':
        name: 'TF_WEAPON_FLAMETHROWER'
        item_class: 'tf_weapon_flamethrower'
        item_type_name: 'Flame Thrower'
        craft_class: 'weapon'
        _q: [C]
        _t: NEVER

    '22':
        name: 'TF_WEAPON_PISTOL'
        item_class: 'tf_weapon_pistol'
        item_type_name: 'Pistol'
        craft_class: 'weapon'
        _q: [C]
        _t: NEVER

    '23':
        name: 'TF_WEAPON_PISTOL_SCOUT'
        item_class: 'tf_weapon_pistol_scout'
        item_type_name: 'Pistol'
        craft_class: 'weapon'
        _q: [C]
        _t: NEVER

    '24':
        name: 'TF_WEAPON_REVOLVER'
        item_class: 'tf_weapon_revolver'
        item_type_name: 'Revolver'
        craft_class: 'weapon'
        _q: [C]
        _t: NEVER

    '25':
        name: 'TF_WEAPON_PDA_ENGINEER_BUILD'
        item_class: 'tf_weapon_pda_engineer_build'
        item_type_name: 'PDA'
        craft_class: 'weapon'
        _q: [C]
        _t: NEVER

    '26':
        name: 'TF_WEAPON_PDA_ENGINEER_DESTROY'
        item_class: 'tf_weapon_pda_engineer_destroy'
        item_type_name: 'PDA'
        craft_class: 'weapon'
        _q: [C]
        _t: NEVER

    '27':
        name: 'TF_WEAPON_PDA_SPY'
        item_class: 'tf_weapon_pda_spy'
        item_type_name: 'PDA'
        craft_class: 'weapon'
        _q: [C]
        _t: NEVER

    '28':
        name: 'TF_WEAPON_BUILDER'
        item_class: 'tf_weapon_builder'
        item_type_name: 'PDA'
        craft_class: 'weapon'
        _q: [C]
        _t: NEVER

    '29':
        name: 'TF_WEAPON_MEDIGUN'
        item_class: 'tf_weapon_medigun'
        item_type_name: 'Medi Gun'
        craft_class: 'weapon'
        _q: [C]
        _t: NEVER

    '30':
        name: 'TF_WEAPON_INVIS'
        item_class: 'tf_weapon_invis'
        item_type_name: 'Invis Watch'
        craft_class: 'weapon'
        _q: [C]
        _t: NEVER

    '35':
        name: 'The Kritzkrieg'
        item_class: 'tf_weapon_medigun'
        item_type_name: 'Medi Gun'
        craft_class: 'weapon'
        _q: [C, V]
        _t: ALWAYS

    '36':
        name: 'The Blutsauger'
        item_class: 'tf_weapon_syringegun_medic'
        item_type_name: 'Syringe Gun'
        craft_class: 'weapon'
        _q: [C, V]
        _t: ALWAYS

    '37':
        name: 'The Ubersaw'
        item_class: 'tf_weapon_bonesaw'
        item_type_name: 'Bonesaw'
        craft_class: 'weapon'
        _q: [C, V]
        _t: ALWAYS

    '38':
        name: 'The Axtinguisher'
        item_class: 'tf_weapon_fireaxe'
        item_type_name: 'Fire Axe'
        craft_class: 'weapon'
        _q: [C, V]
        _t: ALWAYS

    '39':
        name: 'The Flare Gun'
        item_class: 'tf_weapon_flaregun'
        item_type_name: 'Flare Gun'
        craft_class: 'weapon'
        _q: [C, V]
        _t: ALWAYS

    '40':
        name: 'The Backburner'
        item_class: 'tf_weapon_flamethrower'
        item_type_name: 'Flame Thrower'
        craft_class: 'weapon'
        _q: [C, V]
        _t: ALWAYS

    '41':
        name: 'Natascha'
        item_class: 'tf_weapon_minigun'
        item_type_name: 'Minigun'
        craft_class: 'weapon'
        _q: [C, S, V]
        _t: ALWAYS

    '42':
        name: 'The Sandvich'
        item_class: 'tf_weapon_lunchbox'
        item_type_name: 'Lunch Box'
        craft_class: 'weapon'
        _q: [C, V]
        _t: ALWAYS

    '43':
        name: 'The Killing Gloves of Boxing'
        item_class: 'tf_weapon_fists'
        item_type_name: 'Boxing Gloves'
        craft_class: 'weapon'
        _q: [C, V]
        _t: ALWAYS

    '44':
        name: 'The Sandman'
        item_class: 'tf_weapon_bat_wood'
        item_type_name: 'Bat'
        craft_class: 'weapon'
        _q: [C, V]
        _t: ALWAYS

    '45':
        name: 'The Force-a-Nature'
        item_class: 'tf_weapon_scattergun'
        item_type_name: 'Scattergun'
        craft_class: 'weapon'
        _q: [C, V]
        _t: ALWAYS

    '46':
        name: 'Bonk! Atomic Punch'
        item_class: 'tf_weapon_lunchbox_drink'
        item_type_name: 'Lunch Box'
        craft_class: 'weapon'
        _q: [C, V]
        _t: ALWAYS

    '47':
        name: 'Demoman\'s Fro'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '48':
        name: 'Mining Light'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '49':
        name: 'Football Helmet'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '50':
        name: 'Prussian Pickelhaube'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '51':
        name: 'Pyro\'s Beanie'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '52':
        name: 'Batter\'s Helmet'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '53':
        name: 'Trophy Belt'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '54':
        name: 'Soldier\'s Stash'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '55':
        name: 'Fancy Fedora'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '56':
        name: 'The Huntsman'
        item_class: 'tf_weapon_compound_bow'
        item_type_name: 'Bow'
        craft_class: 'weapon'
        _q: [C, V]
        _t: ALWAYS

    '57':
        name: 'The Razorback'
        item_class: 'tf_wearable'
        item_type_name: 'Shield'
        craft_class: 'weapon'
        _q: [C, V]
        _t: ALWAYS

    '58':
        name: 'Jarate'
        item_class: 'tf_weapon_jar'
        item_type_name: 'Jar Based Karate'
        craft_class: 'weapon'
        _q: [C, V]
        _t: ALWAYS

    '59':
        name: 'The Dead Ringer'
        item_class: 'tf_weapon_invis'
        item_type_name: 'Invis Watch'
        craft_class: 'weapon'
        _q: [C, V]
        _t: ALWAYS

    '60':
        name: 'The Cloak and Dagger'
        item_class: 'tf_weapon_invis'
        item_type_name: 'Invis Watch'
        craft_class: 'weapon'
        _q: [C, V]
        _t: ALWAYS

    '61':
        name: 'The Ambassador'
        item_class: 'tf_weapon_revolver'
        item_type_name: 'Revolver'
        craft_class: 'weapon'
        _q: [C, V]
        _t: ALWAYS

    '94':
        name: 'Texas Ten Gallon'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '95':
        name: 'Engineer\'s Cap'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '96':
        name: 'Officer\'s Ushanka'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '97':
        name: 'Tough Guy\'s Toque'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '98':
        name: 'Stainless Pot'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '99':
        name: 'Tyrant\'s Helm'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '100':
        name: 'Glengarry Bonnet'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '101':
        name: 'Vintage Tyrolean'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '102':
        name: 'Respectless Rubber Glove'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '103':
        name: 'Camera Beard'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V]
        _t: ALWAYS

    '104':
        name: 'Otolaryngologist\'s Mirror'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '105':
        name: 'Brigade Helm'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '106':
        name: 'Bonk Helm'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '107':
        name: 'Ye Olde Baker Boy'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '108':
        name: 'Backbiter\'s Billycock'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '109':
        name: 'Professional\'s Panama'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '110':
        name: 'Master\'s Yellow Belt'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '111':
        name: 'Baseball Bill\'s Sports Shine'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V]
        _t: ALWAYS

    '115':
        name: 'Mildly Disturbing Halloween Mask'
        item_class: 'tf_wearable'
        item_type_name: 'Holiday Hat'
        craft_class: null
        _q: [C]
        _t: NEVER

    '116':
        name: 'Ghastly Gibus'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: null
        _q: [C]
        _t: NEVER

    '117':
        name: 'Ritzy Rick\'s Hair Fixative'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V]
        _t: ALWAYS

    '118':
        name: 'Texas Slim\'s Dome Shine'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V]
        _t: ALWAYS

    '120':
        name: 'Scotsman\'s Stove Pipe'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '121':
        name: 'Web Easteregg Medal'
        item_class: 'tf_wearable'
        item_type_name: 'Medal'
        craft_class: null
        _q: [C]
        _t: ALWAYS

    '122':
        name: 'CheatDetectedMinor'
        item_class: 'tf_wearable'
        item_type_name: 'CheatDetector'
        craft_class: null
        _q: [C]
        _t: NEVER

    '123':
        name: 'CheatDetectedMajor'
        item_class: 'tf_wearable'
        item_type_name: 'CheatDetector'
        craft_class: null
        _q: [C]
        _t: NEVER

    '124':
        name: 'CheatDetectedHonesty'
        item_class: 'tf_wearable'
        item_type_name: 'CheatDetector'
        craft_class: null
        _q: [C]
        _t: NEVER

    '125':
        name: 'Honest Halo'
        item_class: 'tf_wearable'
        item_type_name: 'Aura of Incorruptibility'
        craft_class: null
        _q: [C]
        _t: NEVER

    '126':
        name: 'L4D Hat'
        item_class: 'tf_wearable'
        item_type_name: 'Veteran\'s Beret'
        craft_class: null
        _q: [C, V]
        _t: ALWAYS

    '127':
        name: 'The Direct Hit'
        item_class: 'tf_weapon_rocketlauncher_directhit'
        item_type_name: 'Rocket Launcher'
        craft_class: 'weapon'
        _q: [C, S, V]
        _t: ALWAYS

    '128':
        name: 'The Equalizer'
        item_class: 'tf_weapon_shovel'
        item_type_name: 'Pickaxe'
        craft_class: 'weapon'
        _q: [C, V]
        _t: ALWAYS

    '129':
        name: 'The Buff Banner'
        item_class: 'tf_weapon_buff_item'
        item_type_name: 'Battle Banner'
        craft_class: 'weapon'
        _q: [C, V]
        _t: ALWAYS

    '130':
        name: 'The Scottish Resistance'
        item_class: 'tf_weapon_pipebomblauncher'
        item_type_name: 'Stickybomb Launcher'
        craft_class: 'weapon'
        _q: [C, V]
        _t: ALWAYS

    '131':
        name: 'The Chargin\' Targe'
        item_class: 'tf_wearable_demoshield'
        item_type_name: 'Shield'
        craft_class: 'weapon'
        _q: [C, S, V]
        _t: ALWAYS

    '132':
        name: 'The Eyelander'
        item_class: 'tf_weapon_sword'
        item_type_name: 'Sword'
        craft_class: 'weapon'
        _q: [C, S, V]
        _t: ALWAYS

    '133':
        name: 'The Gunboats'
        item_class: 'tf_wearable'
        item_type_name: 'Boots'
        craft_class: 'weapon'
        _q: [C, V]
        _t: ALWAYS

    '134':
        name: 'Propaganda Contest First Place'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: null
        _q: [C]
        _t: NEVER

    '135':
        name: 'Towering Pillar of Hats'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '136':
        name: 'Propaganda Contest Second Place'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: null
        _q: [C]
        _t: NEVER

    '137':
        name: 'Noble Amassment of Hats'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '138':
        name: 'Propaganda Contest Third Place'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: null
        _q: [C]
        _t: NEVER

    '139':
        name: 'Modest Pile of Hat'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '140':
        name: 'The Wrangler'
        item_class: 'tf_weapon_laser_pointer'
        item_type_name: 'Laser Pointer'
        craft_class: 'weapon'
        _q: [C, V]
        _t: ALWAYS

    '141':
        name: 'The Frontier Justice'
        item_class: 'tf_weapon_sentry_revenge'
        item_type_name: 'Shotgun'
        craft_class: 'weapon'
        _q: [C, V]
        _t: ALWAYS

    '142':
        name: 'The Gunslinger'
        item_class: 'tf_weapon_robot_arm'
        item_type_name: 'Robot Arm'
        craft_class: 'weapon'
        _q: [C, V]
        _t: ALWAYS

    '143':
        name: 'OSX Item'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: null
        _q: [C]
        _t: ALWAYS

    '144':
        name: 'Medic Mask'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V]
        _t: ALWAYS

    '145':
        name: 'Heavy Hair'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '146':
        name: 'Demoman Hallmark'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '147':
        name: 'Spy Noble Hair'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '148':
        name: 'Engineer Welding Mask'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '150':
        name: 'Scout Beanie'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '151':
        name: 'Pyro Brain Sucker'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '152':
        name: 'Soldier Samurai Hat'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '153':
        name: 'The Homewrecker'
        item_class: 'tf_weapon_fireaxe'
        item_type_name: 'Sledgehammer'
        craft_class: 'weapon'
        _q: [C, V]
        _t: ALWAYS

    '154':
        name: 'The Pain Train'
        item_class: 'tf_weapon_shovel'
        item_type_name: 'Makeshift Club'
        craft_class: 'weapon'
        _q: [C, S, V]
        _t: ALWAYS

    '155':
        name: 'The Southern Hospitality'
        item_class: 'tf_weapon_wrench'
        item_type_name: 'Wrench'
        craft_class: 'weapon'
        _q: [C, V]
        _t: ALWAYS

    '158':
        name: 'Sniper Pith Helmet'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '159':
        name: 'The Dalokohs Bar'
        item_class: 'tf_weapon_lunchbox'
        item_type_name: 'Lunch Box'
        craft_class: 'weapon'
        _q: [C, V]
        _t: ALWAYS

    '160':
        name: 'TTG Max Pistol'
        item_class: 'tf_weapon_pistol'
        item_type_name: 'Pistol'
        craft_class: null
        _q: [V]
        _t: ALWAYS

    '161':
        name: 'TTG Sam Revolver'
        item_class: 'tf_weapon_revolver'
        item_type_name: 'Revolver'
        craft_class: null
        _q: [C]
        _t: ALWAYS

    '162':
        name: 'TTG Max Hat'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: null
        _q: [C]
        _t: ALWAYS

    '163':
        name: 'Crit-a-Cola'
        item_class: 'tf_weapon_lunchbox_drink'
        item_type_name: 'Lunch Box'
        craft_class: 'weapon'
        _q: [C, V]
        _t: ALWAYS

    '164':
        name: 'Employee Badge A'
        item_class: 'tf_wearable'
        item_type_name: 'Badge'
        craft_class: null
        _q: [C]
        _t: NEVER

    '165':
        name: 'Employee Badge B'
        item_class: 'tf_wearable'
        item_type_name: 'Badge'
        craft_class: null
        _q: [C]
        _t: NEVER

    '166':
        name: 'Employee Badge C'
        item_class: 'tf_wearable'
        item_type_name: 'Badge'
        craft_class: null
        _q: [C]
        _t: NEVER

    '169':
        name: 'Golden Wrench'
        item_class: 'tf_weapon_wrench'
        item_type_name: 'Wrench'
        craft_class: null
        _q: [C]
        _t: NEVER

    '170':
        name: 'Employee Badge Plat'
        item_class: 'tf_wearable'
        item_type_name: 'Badge'
        craft_class: null
        _q: [C]
        _t: NEVER

    '171':
        name: 'The Tribalman\'s Shiv'
        item_class: 'tf_weapon_club'
        item_type_name: 'Kukri'
        craft_class: 'weapon'
        _q: [C, V]
        _t: ALWAYS

    '172':
        name: 'The Scotsman\'s Skullcutter'
        item_class: 'tf_weapon_sword'
        item_type_name: 'Axe'
        craft_class: 'weapon'
        _q: [C, V]
        _t: ALWAYS

    '173':
        name: 'The Vita-Saw'
        item_class: 'tf_weapon_bonesaw'
        item_type_name: 'Bonesaw'
        craft_class: 'weapon'
        _q: [C]
        _t: ALWAYS

    '174':
        name: 'Scout Whoopee Cap'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '175':
        name: 'Pyro Monocle'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V]
        _t: ALWAYS

    '177':
        name: 'Medic Goggles'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '178':
        name: 'Engineer Earmuffs'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '179':
        name: 'Demoman Tricorne'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '180':
        name: 'Spy Beret'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '181':
        name: 'Sniper Fishing Hat'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '182':
        name: 'Pyro Helm'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '183':
        name: 'Soldier Drill Hat'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '184':
        name: 'Medic Gatsby'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '185':
        name: 'Heavy Do-rag'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, V, U]
        _t: ALWAYS

    '189':
        name: 'Parasite Hat'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: null
        _q: [C]
        _t: ALWAYS

    '190':
        name: 'Upgradeable TF_WEAPON_BAT'
        item_class: 'tf_weapon_bat'
        item_type_name: 'Bat'
        craft_class: null
        _q: [C, S]
        _t: ALWAYS

    '191':
        name: 'Upgradeable TF_WEAPON_BOTTLE'
        item_class: 'tf_weapon_bottle'
        item_type_name: 'Bottle'
        craft_class: null
        _q: [C, S]
        _t: ALWAYS

    '192':
        name: 'Upgradeable TF_WEAPON_FIREAXE'
        item_class: 'tf_weapon_fireaxe'
        item_type_name: 'Fire Axe'
        craft_class: null
        _q: [C, S]
        _t: ALWAYS

    '193':
        name: 'Upgradeable TF_WEAPON_CLUB'
        item_class: 'tf_weapon_club'
        item_type_name: 'Kukri'
        craft_class: null
        _q: [C, S]
        _t: ALWAYS

    '194':
        name: 'Upgradeable TF_WEAPON_KNIFE'
        item_class: 'tf_weapon_knife'
        item_type_name: 'Knife'
        craft_class: null
        _q: [C, S]
        _t: ALWAYS

    '195':
        name: 'Upgradeable TF_WEAPON_FISTS'
        item_class: 'tf_weapon_fists'
        item_type_name: 'Fists'
        craft_class: null
        _q: [C, S]
        _t: ALWAYS

    '196':
        name: 'Upgradeable TF_WEAPON_SHOVEL'
        item_class: 'tf_weapon_shovel'
        item_type_name: 'Shovel'
        craft_class: null
        _q: [C, S]
        _t: ALWAYS

    '197':
        name: 'Upgradeable TF_WEAPON_WRENCH'
        item_class: 'tf_weapon_wrench'
        item_type_name: 'Wrench'
        craft_class: null
        _q: [C, S]
        _t: ALWAYS

    '198':
        name: 'Upgradeable TF_WEAPON_BONESAW'
        item_class: 'tf_weapon_bonesaw'
        item_type_name: 'Bonesaw'
        craft_class: null
        _q: [C, S]
        _t: ALWAYS

    '199':
        name: 'Upgradeable TF_WEAPON_SHOTGUN_PRIMARY'
        item_class: 'tf_weapon_shotgun_primary'
        item_type_name: 'Shotgun'
        craft_class: null
        _q: [C, S]
        _t: ALWAYS

    '200':
        name: 'Upgradeable TF_WEAPON_SCATTERGUN'
        item_class: 'tf_weapon_scattergun'
        item_type_name: 'Scattergun'
        craft_class: null
        _q: [C, S]
        _t: ALWAYS

    '201':
        name: 'Upgradeable TF_WEAPON_SNIPERRIFLE'
        item_class: 'tf_weapon_sniperrifle'
        item_type_name: 'Sniper Rifle'
        craft_class: null
        _q: [C, S]
        _t: ALWAYS

    '202':
        name: 'Upgradeable TF_WEAPON_MINIGUN'
        item_class: 'tf_weapon_minigun'
        item_type_name: 'Minigun'
        craft_class: null
        _q: [C, S]
        _t: ALWAYS

    '203':
        name: 'Upgradeable TF_WEAPON_SMG'
        item_class: 'tf_weapon_smg'
        item_type_name: 'SMG'
        craft_class: null
        _q: [C, S]
        _t: ALWAYS

    '204':
        name: 'Upgradeable TF_WEAPON_SYRINGEGUN_MEDIC'
        item_class: 'tf_weapon_syringegun_medic'
        item_type_name: 'Syringe Gun'
        craft_class: null
        _q: [C, S]
        _t: ALWAYS

    '205':
        name: 'Upgradeable TF_WEAPON_ROCKETLAUNCHER'
        item_class: 'tf_weapon_rocketlauncher'
        item_type_name: 'Rocket Launcher'
        craft_class: null
        _q: [C, S]
        _t: ALWAYS

    '206':
        name: 'Upgradeable TF_WEAPON_GRENADELAUNCHER'
        item_class: 'tf_weapon_grenadelauncher'
        item_type_name: 'Grenade Launcher'
        craft_class: null
        _q: [C, S]
        _t: ALWAYS

    '207':
        name: 'Upgradeable TF_WEAPON_PIPEBOMBLAUNCHER'
        item_class: 'tf_weapon_pipebomblauncher'
        item_type_name: 'Stickybomb Launcher'
        craft_class: null
        _q: [C, S]
        _t: ALWAYS

    '208':
        name: 'Upgradeable TF_WEAPON_FLAMETHROWER'
        item_class: 'tf_weapon_flamethrower'
        item_type_name: 'Flame Thrower'
        craft_class: null
        _q: [C, S]
        _t: ALWAYS

    '209':
        name: 'Upgradeable TF_WEAPON_PISTOL'
        item_class: 'tf_weapon_pistol'
        item_type_name: 'Pistol'
        craft_class: null
        _q: [C, S]
        _t: ALWAYS

    '210':
        name: 'Upgradeable TF_WEAPON_REVOLVER'
        item_class: 'tf_weapon_revolver'
        item_type_name: 'Revolver'
        craft_class: null
        _q: [C, S]
        _t: ALWAYS

    '211':
        name: 'Upgradeable TF_WEAPON_MEDIGUN'
        item_class: 'tf_weapon_medigun'
        item_type_name: 'Medi Gun'
        craft_class: null
        _q: [C, S]
        _t: ALWAYS

    '212':
        name: 'Upgradeable TF_WEAPON_INVIS'
        item_class: 'tf_weapon_invis'
        item_type_name: 'Invis Watch'
        craft_class: null
        _q: [C, S]
        _t: ALWAYS

    '213':
        name: 'The Attendant'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '214':
        name: 'The Powerjack'
        item_class: 'tf_weapon_fireaxe'
        item_type_name: 'Sledgehammer'
        craft_class: 'weapon'
        _q: [C, S]
        _t: ALWAYS

    '215':
        name: 'The Degreaser'
        item_class: 'tf_weapon_flamethrower'
        item_type_name: 'Flame Thrower'
        craft_class: 'weapon'
        _q: [C]
        _t: ALWAYS

    '216':
        name: 'Rimmed Raincatcher'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '219':
        name: 'The Milkman'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '220':
        name: 'The Shortstop'
        item_class: 'tf_weapon_handgun_scout_primary'
        item_type_name: 'Peppergun'
        craft_class: 'weapon'
        _q: [C]
        _t: ALWAYS

    '221':
        name: 'The Holy Mackerel'
        item_class: 'tf_weapon_bat_fish'
        item_type_name: 'Fish'
        craft_class: 'weapon'
        _q: [C]
        _t: ALWAYS

    '222':
        name: 'Mad Milk'
        item_class: 'tf_weapon_jar_milk'
        item_type_name: 'Non-Milk Substance'
        craft_class: 'weapon'
        _q: [C]
        _t: ALWAYS

    '223':
        name: 'The Familiar Fez'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '224':
        name: 'L\'Etranger'
        item_class: 'tf_weapon_revolver'
        item_type_name: 'Revolver'
        craft_class: 'weapon'
        _q: [C]
        _t: ALWAYS

    '225':
        name: 'Your Eternal Reward'
        item_class: 'tf_weapon_knife'
        item_type_name: 'Knife'
        craft_class: 'weapon'
        _q: [C]
        _t: ALWAYS

    '226':
        name: 'The Battalion\'s Backup'
        item_class: 'tf_weapon_buff_item'
        item_type_name: 'Battle Banner'
        craft_class: 'weapon'
        _q: [C]
        _t: ALWAYS

    '227':
        name: 'The Grenadier\'s Softcap'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '228':
        name: 'The Black Box'
        item_class: 'tf_weapon_rocketlauncher'
        item_type_name: 'Rocket Launcher'
        craft_class: 'weapon'
        _q: [C]
        _t: ALWAYS

    '229':
        name: 'Ol\' Snaggletooth'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '230':
        name: 'The Sydney Sleeper'
        item_class: 'tf_weapon_sniperrifle'
        item_type_name: 'Sniper Rifle'
        craft_class: 'weapon'
        _q: [C]
        _t: ALWAYS

    '231':
        name: 'Darwin\'s Danger Shield'
        item_class: 'tf_wearable'
        item_type_name: 'Shield'
        craft_class: 'weapon'
        _q: [C]
        _t: ALWAYS

    '232':
        name: 'The Bushwacka'
        item_class: 'tf_weapon_club'
        item_type_name: 'Kukri'
        craft_class: 'weapon'
        _q: [C]
        _t: ALWAYS

    '233':
        name: 'Gift - 1 Player'
        item_class: 'tf_wearable'
        item_type_name: 'Gift'
        craft_class: null
        _q: [C]
        _t: NEVER

    '234':
        name: 'Gift - 24 Players'
        item_class: 'tf_wearable'
        item_type_name: 'Gift'
        craft_class: null
        _q: [C]
        _t: NEVER

    '237':
        name: 'Rocket Jumper'
        item_class: 'tf_weapon_rocketlauncher'
        item_type_name: 'Rocket Launcher'
        craft_class: 'weapon'
        _q: [C]
        _t: ALWAYS

    '239':
        name: 'Gloves of Running Urgently'
        item_class: 'tf_weapon_fists'
        item_type_name: 'Boxing Gloves'
        craft_class: 'weapon'
        _q: [C, U]
        _t: ALWAYS

    '240':
        name: 'Worms Gear'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: null
        _q: [C]
        _t: ALWAYS

    '241':
        name: 'Duel MiniGame'
        item_class: 'tf_wearable'
        item_type_name: 'Usable Item'
        craft_class: null
        _q: [C]
        _t: ALWAYS

    '242':
        name: 'Duel Medal Bronze'
        item_class: 'tf_wearable'
        item_type_name: 'Badge'
        craft_class: null
        _q: [C]
        _t: NEVER

    '243':
        name: 'Duel Medal Silver'
        item_class: 'tf_wearable'
        item_type_name: 'Badge'
        craft_class: null
        _q: [C]
        _t: NEVER

    '244':
        name: 'Duel Medal Gold'
        item_class: 'tf_wearable'
        item_type_name: 'Badge'
        craft_class: null
        _q: [C]
        _t: NEVER

    '245':
        name: 'Duel Medal Plat'
        item_class: 'tf_wearable'
        item_type_name: 'Badge'
        craft_class: null
        _q: [C]
        _t: NEVER

    '246':
        name: 'Pugilist\'s Protector'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '247':
        name: 'Old Guadalajara'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '248':
        name: 'Napper\'s Respite'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '249':
        name: 'Bombing Run'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '250':
        name: 'Chieftain\'s Challenge'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '251':
        name: 'Stout Shako'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '252':
        name: 'Dr\'s Dapper Topper'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '253':
        name: 'Handyman\'s Handle'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '254':
        name: 'Hard Counter'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '255':
        name: 'Sober Stuntman'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '259':
        name: 'Carouser\'s Capotain'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '260':
        name: 'Wiki Cap'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: null
        _q: [C]
        _t: NEVER

    '261':
        name: 'Mann Co. Cap'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: null
        _q: [C]
        _t: NEVER

    '262':
        name: 'Polycount Pin'
        item_class: 'tf_wearable'
        item_type_name: 'Badge'
        craft_class: null
        _q: [C]
        _t: NEVER

    '263':
        name: 'Ellis Hat'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: null
        _q: [C]
        _t: ALWAYS

    '264':
        name: 'Frying Pan'
        item_class: 'tf_weapon_shovel'
        item_type_name: 'Frying Pan'
        craft_class: null
        _q: [C]
        _t: ALWAYS

    '265':
        name: 'Stickybomb Jumper'
        item_class: 'tf_weapon_pipebomblauncher'
        item_type_name: 'Stickybomb Launcher'
        craft_class: 'weapon'
        _q: [C]
        _t: ALWAYS

    '266':
        name: 'The Horseless Headless Horseman\'s Headtaker'
        item_class: 'tf_weapon_sword'
        item_type_name: 'Axe'
        craft_class: 'weapon'
        _q: [U]
        _t: ALWAYS

    '267':
        name: 'Haunted Metal Scrap'
        item_class: 'craft_item'
        item_type_name: 'Craft Item'
        craft_class: 'craft_bar'
        _q: [U]
        _t: GIFT

    '268':
        name: 'Halloween Mask - Scout'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: null
        _q: [C]
        _t: ALWAYS

    '269':
        name: 'Halloween Mask - Sniper'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: null
        _q: [C]
        _t: ALWAYS

    '270':
        name: 'Halloween Mask - Soldier'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: null
        _q: [C]
        _t: ALWAYS

    '271':
        name: 'Halloween Mask - Demoman'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: null
        _q: [C]
        _t: ALWAYS

    '272':
        name: 'Halloween Mask - Medic'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: null
        _q: [C]
        _t: ALWAYS

    '273':
        name: 'Halloween Mask - Heavy'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: null
        _q: [C]
        _t: ALWAYS

    '274':
        name: 'Halloween Mask - Spy'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: null
        _q: [C]
        _t: ALWAYS

    '275':
        name: 'Halloween Mask - Engineer'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: null
        _q: [C]
        _t: ALWAYS

    '276':
        name: 'Halloween Mask - Pyro'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: null
        _q: [C]
        _t: ALWAYS

    '277':
        name: 'Halloween Mask - Saxton Hale'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: null
        _q: [C]
        _t: ALWAYS

    '278':
        name: 'Horseless Headless Horseman\'s Head'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: null
        _q: [C]
        _t: GIFT

    '279':
        name: 'Ghastly Gibus 2010'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: null
        _q: [C]
        _t: ALWAYS

    '280':
        name: 'Halloween Noise Maker - Black Cat'
        item_class: 'tf_wearable'
        item_type_name: 'Party Favor'
        craft_class: null
        _q: [C]
        _t: ALWAYS

    '281':
        name: 'Halloween Noise Maker - Gremlin'
        item_class: 'tf_wearable'
        item_type_name: 'Party Favor'
        craft_class: null
        _q: [C]
        _t: ALWAYS

    '282':
        name: 'Halloween Noise Maker - Werewolf'
        item_class: 'tf_wearable'
        item_type_name: 'Party Favor'
        craft_class: null
        _q: [C]
        _t: ALWAYS

    '283':
        name: 'Halloween Noise Maker - Witch'
        item_class: 'tf_wearable'
        item_type_name: 'Party Favor'
        craft_class: null
        _q: [C]
        _t: ALWAYS

    '284':
        name: 'Halloween Noise Maker - Banshee'
        item_class: 'tf_wearable'
        item_type_name: 'Party Favor'
        craft_class: null
        _q: [C]
        _t: ALWAYS

    '286':
        name: 'Halloween Noise Maker - Crazy Laugh'
        item_class: 'tf_wearable'
        item_type_name: 'Party Favor'
        craft_class: null
        _q: [C]
        _t: ALWAYS

    '287':
        name: 'Spine-Chilling Skull'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'haunted_hat'
        _q: [C]
        _t: ALWAYS

    '288':
        name: 'Halloween Noise Maker - Stabby'
        item_class: 'tf_wearable'
        item_type_name: 'Party Favor'
        craft_class: null
        _q: [C]
        _t: ALWAYS

    '289':
        name: 'Voodoo Juju'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'haunted_hat'
        _q: [C]
        _t: ALWAYS

    '290':
        name: 'Cadaver\'s Cranium'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '291':
        name: 'Horrific Headsplitter'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C]
        _t: ALWAYS

    '292':
        name: 'Poker Visor'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: null
        _q: [C]
        _t: ALWAYS

    '294':
        name: 'TTG Max Pistol - Poker Night'
        item_class: 'tf_weapon_pistol'
        item_type_name: 'Pistol'
        craft_class: null
        _q: [C]
        _t: NEVER

    '295':
        name: 'TTG Glasses'
        item_class: 'tf_wearable'
        item_type_name: 'Glasses'
        craft_class: null
        _q: [C]
        _t: GIFT

    '296':
        name: 'TTG Badge'
        item_class: 'tf_wearable'
        item_type_name: 'Badge'
        craft_class: null
        _q: [C]
        _t: GIFT

    '297':
        name: 'TTG Watch'
        item_class: 'tf_weapon_invis'
        item_type_name: 'Invis Watch'
        craft_class: null
        _q: [C]
        _t: GIFT

    '298':
        name: 'Iron Curtain'
        item_class: 'tf_weapon_minigun'
        item_type_name: 'Minigun'
        craft_class: null
        _q: [C]
        _t: GIFT

    '299':
        name: 'Portal 2 Pin'
        item_class: 'tf_wearable'
        item_type_name: 'Badge'
        craft_class: null
        _q: [G]
        _t: ALWAYS

    '302':
        name: 'Camera Helm'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: null
        _q: [C]
        _t: NEVER

    '303':
        name: 'Berliner\'s Bucket Helm'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '304':
        name: 'The Amputator'
        item_class: 'tf_weapon_bonesaw'
        item_type_name: 'Bonesaw'
        craft_class: 'weapon'
        _q: [C, V]
        _t: ALWAYS

    '305':
        name: 'The Crusader\'s Crossbow'
        item_class: 'tf_weapon_crossbow'
        item_type_name: 'Crossbow'
        craft_class: 'weapon'
        _q: [C, V]
        _t: ALWAYS

    '306':
        name: 'Scotch Bonnet'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '307':
        name: 'The Ullapool Caber'
        item_class: 'tf_weapon_stickbomb'
        item_type_name: 'Stick Bomb'
        craft_class: 'weapon'
        _q: [C, V]
        _t: ALWAYS

    '308':
        name: 'The Loch-n-Load'
        item_class: 'tf_weapon_grenadelauncher'
        item_type_name: 'Grenade Launcher'
        craft_class: 'weapon'
        _q: [C, V]
        _t: ALWAYS

    '309':
        name: 'Big Chief'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '310':
        name: 'Warrior\'s Spirit'
        item_class: 'tf_weapon_fists'
        item_type_name: 'Boxing Gloves'
        craft_class: 'weapon'
        _q: [C, V]
        _t: ALWAYS

    '311':
        name: 'The Buffalo Steak Sandvich'
        item_class: 'tf_weapon_lunchbox'
        item_type_name: 'Lunch Box'
        craft_class: 'weapon'
        _q: [C, V]
        _t: ALWAYS

    '312':
        name: 'The Brass Beast'
        item_class: 'tf_weapon_minigun'
        item_type_name: 'Minigun'
        craft_class: 'weapon'
        _q: [C, V]
        _t: ALWAYS

    '313':
        name: 'Magnificent Mongolian'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '314':
        name: 'Larrikin Robin'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '315':
        name: 'Blighted Beak'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '316':
        name: 'Pyromancer\'s Mask'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '317':
        name: 'The Candy Cane'
        item_class: 'tf_weapon_bat'
        item_type_name: 'Bat'
        craft_class: 'weapon'
        _q: [C]
        _t: ALWAYS

    '318':
        name: 'Prancer\'s Pride'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '319':
        name: 'Detective Noir'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '321':
        name: 'Madame Dixie'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '322':
        name: 'Buckaroos Hat'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '323':
        name: 'German Gonzila'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '324':
        name: 'Flipped Trilby'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '325':
        name: 'The Boston Basher'
        item_class: 'tf_weapon_bat'
        item_type_name: 'Bat'
        craft_class: 'weapon'
        _q: [C]
        _t: ALWAYS

    '326':
        name: 'The Back Scratcher'
        item_class: 'tf_weapon_fireaxe'
        item_type_name: 'Garden Rake'
        craft_class: 'weapon'
        _q: [C]
        _t: ALWAYS

    '327':
        name: 'The Claidheamohmor'
        item_class: 'tf_weapon_sword'
        item_type_name: 'Sword'
        craft_class: 'weapon'
        _q: [C]
        _t: ALWAYS

    '329':
        name: 'The Jag'
        item_class: 'tf_weapon_wrench'
        item_type_name: 'Wrench'
        craft_class: 'weapon'
        _q: [C]
        _t: ALWAYS

    '330':
        name: 'Coupe D\'isaster'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C]
        _t: ALWAYS

    '331':
        name: 'Fists of Steel'
        item_class: 'tf_weapon_fists'
        item_type_name: 'Boxing Gloves'
        craft_class: 'weapon'
        _q: [C]
        _t: ALWAYS

    '332':
        name: 'Treasure Hat 1'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: null
        _q: [C]
        _t: GIFT

    '333':
        name: 'Treasure Hat 2'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: null
        _q: [C]
        _t: GIFT

    '334':
        name: 'Treasure Hat 3'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: null
        _q: [C]
        _t: GIFT

    '335':
        name: 'KF Pyro Mask'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: null
        _q: [C, V]
        _t: ALWAYS

    '336':
        name: 'KF Pyro Tie'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: null
        _q: [C, V]
        _t: ALWAYS

    '337':
        name: 'Le Party Phantom'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '338':
        name: 'Industrial Festivizer'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '339':
        name: 'Exquisite Rack'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '340':
        name: 'Defiant Spartan'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '341':
        name: 'A Rather Festive Tree'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '342':
        name: 'Prince Tavish\'s Crown'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '343':
        name: 'Friendly Item'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: null
        _q: [C]
        _t: GIFT

    '344':
        name: 'Crocleather Slouch'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '345':
        name: 'MNC Hat'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: null
        _q: [C]
        _t: ALWAYS

    '346':
        name: 'MNC Mascot Hat'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: null
        _q: [C]
        _t: ALWAYS

    '347':
        name: 'MNC Mascot Outfit'
        item_class: 'tf_wearable'
        item_type_name: 'Apparel'
        craft_class: null
        _q: [C]
        _t: ALWAYS

    '348':
        name: 'Sharpened Volcano Fragment'
        item_class: 'tf_weapon_fireaxe'
        item_type_name: 'RIFT Fire Axe'
        craft_class: null
        _q: [C, G, V]
        _t: ALWAYS

    '349':
        name: 'Sun-on-a-Stick'
        item_class: 'tf_weapon_bat'
        item_type_name: 'RIFT Fire Mace'
        craft_class: null
        _q: [C, G, V]
        _t: ALWAYS

    '351':
        name: 'The Detonator'
        item_class: 'tf_weapon_flaregun'
        item_type_name: 'Flare Gun'
        craft_class: 'weapon'
        _q: [C]
        _t: ALWAYS

    '354':
        name: 'The Concheror'
        item_class: 'tf_weapon_buff_item'
        item_type_name: 'Sashimono'
        craft_class: 'weapon'
        _q: [C, G, V]
        _t: ALWAYS

    '355':
        name: 'The Fan O\'War'
        item_class: 'tf_weapon_bat'
        item_type_name: 'Gunbai'
        craft_class: 'weapon'
        _q: [C, G, V]
        _t: ALWAYS

    '356':
        name: 'Conniver\'s Kunai'
        item_class: 'tf_weapon_knife'
        item_type_name: 'Kunai'
        craft_class: 'weapon'
        _q: [C, G, V]
        _t: ALWAYS

    '357':
        name: 'The Half-Zatoichi'
        item_class: 'tf_weapon_katana'
        item_type_name: 'Katana'
        craft_class: 'weapon'
        _q: [C, G, V]
        _t: ALWAYS

    '358':
        name: 'Heavy Topknot'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '359':
        name: 'Demo Kabuto'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '360':
        name: 'Hero\'s Hachimaki'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '361':
        name: 'Spy Oni Mask'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '362':
        name: 'Charity Noise Maker - Bell'
        item_class: 'tf_wearable'
        item_type_name: 'Party Favor'
        craft_class: null
        _q: [C]
        _t: ALWAYS

    '363':
        name: 'Medic Geisha Hair'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, G, U]
        _t: ALWAYS

    '364':
        name: 'Charity Noise Maker - Tingsha'
        item_class: 'tf_wearable'
        item_type_name: 'Party Favor'
        craft_class: null
        _q: [C]
        _t: ALWAYS

    '365':
        name: 'Promotional Noise Maker - Koto'
        item_class: 'tf_wearable'
        item_type_name: 'Party Favor'
        craft_class: null
        _q: [C]
        _t: ALWAYS

    '377':
        name: 'Hottie\'s Hoodie'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '378':
        name: 'The Team Captain'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '379':
        name: 'Western Wear'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '380':
        name: 'Large Luchadore'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '381':
        name: 'Medic\'s Mountain Cap'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '382':
        name: 'Big Country'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '383':
        name: 'Grimm Hatte'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '384':
        name: 'Professor\'s Peculiarity'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: null
        _q: [C, U]
        _t: ALWAYS

    '386':
        name: 'Teddy Roosebelt'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C]
        _t: ALWAYS

    '387':
        name: 'Sight for Sore Eyes'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C]
        _t: ALWAYS

    '388':
        name: 'Private Eye'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '389':
        name: 'Googly Gazer'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C]
        _t: ALWAYS

    '390':
        name: 'Reggaelator'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '391':
        name: 'Honcho\'s Headgear'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '392':
        name: 'Pocket Medic'
        item_class: 'tf_wearable'
        item_type_name: 'Badge'
        craft_class: 'hat'
        _q: [C]
        _t: ALWAYS

    '393':
        name: 'Villain\'s Veil'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '394':
        name: 'Connoisseur\'s Cap'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '395':
        name: 'Furious Fukaamigasa'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '397':
        name: 'Charmer\'s Chapeau'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '398':
        name: 'Doctor\'s Sack'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '399':
        name: 'Ol\' Geezer'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '400':
        name: 'Desert Marauder'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '401':
        name: 'The Shahanshah'
        item_class: 'tf_weapon_club'
        item_type_name: 'Kukri'
        craft_class: 'weapon'
        _q: [C]
        _t: ALWAYS

    '402':
        name: 'The Bazaar Bargain'
        item_class: 'tf_weapon_sniperrifle_decap'
        item_type_name: 'Sniper Rifle'
        craft_class: 'weapon'
        _q: [C]
        _t: ALWAYS

    '403':
        name: 'Sultan\'s Ceremonial'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C]
        _t: ALWAYS

    '404':
        name: 'The Persian Persuader'
        item_class: 'tf_weapon_sword'
        item_type_name: 'Sword'
        craft_class: 'weapon'
        _q: [C]
        _t: ALWAYS

    '405':
        name: 'Ali Baba\'s Wee Booties'
        item_class: 'tf_wearable'
        item_type_name: 'Boots'
        craft_class: 'weapon'
        _q: [C]
        _t: ALWAYS

    '406':
        name: 'The Splendid Screen'
        item_class: 'tf_wearable_demoshield'
        item_type_name: 'Shield'
        craft_class: 'weapon'
        _q: [C]
        _t: ALWAYS

    '408':
        name: 'Humanitarian\'s Hachimaki'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: null
        _q: [C]
        _t: NEVER

    '409':
        name: 'Benefactor\'s Kanmuri'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: null
        _q: [C]
        _t: NEVER

    '410':
        name: 'Mangnanimous Monarch'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: null
        _q: [C]
        _t: NEVER

    '411':
        name: 'The Quick-Fix'
        item_class: 'tf_weapon_medigun'
        item_type_name: 'Medi Gun Prototype'
        craft_class: 'weapon'
        _q: [C]
        _t: ALWAYS

    '412':
        name: 'The Overdose'
        item_class: 'tf_weapon_syringegun_medic'
        item_type_name: 'Syringe Gun Prototype'
        craft_class: 'weapon'
        _q: [C]
        _t: ALWAYS

    '413':
        name: 'The Solemn Vow'
        item_class: 'tf_weapon_bonesaw'
        item_type_name: 'Bust of Hippocrates'
        craft_class: 'weapon'
        _q: [C]
        _t: ALWAYS

    '414':
        name: 'The Liberty Launcher'
        item_class: 'tf_weapon_rocketlauncher'
        item_type_name: 'Rocket Launcher'
        craft_class: 'weapon'
        _q: [C]
        _t: ALWAYS

    '415':
        name: 'The Reserve Shooter'
        item_class: 'tf_weapon_shotgun_soldier'
        item_type_name: 'Shotgun'
        craft_class: 'weapon'
        _q: [C]
        _t: ALWAYS

    '416':
        name: 'The Market Gardener'
        item_class: 'tf_weapon_shovel'
        item_type_name: 'Shovel'
        craft_class: 'weapon'
        _q: [C]
        _t: ALWAYS

    '417':
        name: 'Jumper\'s Jeepcap'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '420':
        name: 'Potato Hat'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: null
        _q: [G]
        _t: ALWAYS

    '422':
        name: 'Resurrection Associate Pin'
        item_class: 'tf_wearable'
        item_type_name: 'Badge'
        craft_class: null
        _q: [C]
        _t: ALWAYS

    '423':
        name: 'Saxxy'
        item_class: 'saxxy'
        item_type_name: 'TF_Weapon_Symbol'
        craft_class: null
        _q: [C]
        _t: NEVER

    '424':
        name: 'Tomislav'
        item_class: 'tf_weapon_minigun'
        item_type_name: 'Minigun'
        craft_class: 'weapon'
        _q: [C]
        _t: ALWAYS

    '425':
        name: 'The Family Business'
        item_class: 'tf_weapon_shotgun_heavy'
        item_type_name: 'Shotgun'
        craft_class: 'weapon'
        _q: [C]
        _t: ALWAYS

    '426':
        name: 'The Eviction Notice'
        item_class: 'tf_weapon_fists'
        item_type_name: 'Boxing Gloves'
        craft_class: 'weapon'
        _q: [C]
        _t: ALWAYS

    '427':
        name: 'Capone\'s Capper'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '429':
        name: 'Moustachium Bar'
        item_class: 'craft_item'
        item_type_name: 'Craft Item'
        craft_class: null
        _q: [C]
        _t: NEVER

    '430':
        name: 'SpaceChem Fishcake Fragment'
        item_class: 'craft_item'
        item_type_name: 'Fishcake Fragment'
        craft_class: null
        _q: [C]
        _t: NEVER

    '431':
        name: 'SpaceChem Pin Fragment'
        item_class: 'craft_item'
        item_type_name: 'Pin Fragment'
        craft_class: null
        _q: [C]
        _t: NEVER

    '432':
        name: 'SpaceChem Pin'
        item_class: 'tf_wearable'
        item_type_name: 'Badge'
        craft_class: null
        _q: [C]
        _t: ALWAYS

    '433':
        name: 'Fishcake'
        item_class: 'tf_weapon_lunchbox'
        item_type_name: 'Fishcake'
        craft_class: null
        _q: [C]
        _t: ALWAYS

    '434':
        name: 'Bucket Hat'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, G, U]
        _t: ALWAYS

    '435':
        name: 'Traffic Cone'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, G, U]
        _t: ALWAYS

    '436':
        name: 'Polish War Babushka'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, G, U]
        _t: ALWAYS

    '437':
        name: 'Janissary Hat'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, G, U]
        _t: ALWAYS

    '438':
        name: 'Replay Taunt'
        item_class: 'tf_wearable'
        item_type_name: 'Special Taunt'
        craft_class: null
        _q: [C]
        _t: NEVER

    '444':
        name: 'The Mantreads'
        item_class: 'tf_wearable'
        item_type_name: 'Boots'
        craft_class: 'weapon'
        _q: [C]
        _t: ALWAYS

    '445':
        name: 'Armored Authority'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '446':
        name: 'Fancy Dress Uniform'
        item_class: 'tf_wearable'
        item_type_name: 'Uniform'
        craft_class: 'hat'
        _q: [C]
        _t: ALWAYS

    '447':
        name: 'The Disciplinary Action'
        item_class: 'tf_weapon_shovel'
        item_type_name: 'Riding Crop'
        craft_class: 'weapon'
        _q: [C]
        _t: ALWAYS

    '448':
        name: 'The Soda Popper'
        item_class: 'tf_weapon_soda_popper'
        item_type_name: 'Scattergun'
        craft_class: 'weapon'
        _q: [C]
        _t: ALWAYS

    '449':
        name: 'The Winger'
        item_class: 'tf_weapon_handgun_scout_secondary'
        item_type_name: 'Pistol'
        craft_class: 'weapon'
        _q: [C]
        _t: ALWAYS

    '450':
        name: 'The Atomizer'
        item_class: 'tf_weapon_bat'
        item_type_name: 'Bat'
        craft_class: 'weapon'
        _q: [C]
        _t: ALWAYS

    '451':
        name: 'Bonk Boy'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '452':
        name: 'Three-Rune Blade'
        item_class: 'tf_weapon_bat'
        item_type_name: 'Sword'
        craft_class: 'weapon'
        _q: [C, G]
        _t: ALWAYS

    '453':
        name: 'Hero\'s Tail'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, G]
        _t: ALWAYS

    '454':
        name: 'Sign of the Wolf\'s School'
        item_class: 'tf_wearable'
        item_type_name: 'Medallion'
        craft_class: 'hat'
        _q: [C, G]
        _t: ALWAYS

    '457':
        name: 'The Postal Pummeler'
        item_class: 'tf_weapon_fireaxe'
        item_type_name: 'Mailbox'
        craft_class: 'weapon'
        _q: [C]
        _t: ALWAYS

    '459':
        name: 'Cosa Nostra Cap'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '460':
        name: 'The Enforcer'
        item_class: 'tf_weapon_revolver'
        item_type_name: 'Revolver'
        craft_class: 'weapon'
        _q: [C]
        _t: ALWAYS

    '461':
        name: 'The Big Earner'
        item_class: 'tf_weapon_knife'
        item_type_name: 'Knife'
        craft_class: 'weapon'
        _q: [C]
        _t: ALWAYS

    '462':
        name: 'The Made Man'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Rose'
        craft_class: 'hat'
        _q: [C]
        _t: ALWAYS

    '463':
        name: 'Laugh Taunt'
        item_class: 'tf_wearable'
        item_type_name: 'Special Taunt'
        craft_class: null
        _q: [C]
        _t: ALWAYS

    '465':
        name: 'Conjurer\'s Cowl'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, G]
        _t: ALWAYS

    '466':
        name: 'The Maul'
        item_class: 'tf_weapon_fireaxe'
        item_type_name: 'Sledgehammer'
        craft_class: 'weapon'
        _q: [C, G]
        _t: ALWAYS

    '467':
        name: 'Medic MtG Hat'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C]
        _t: ALWAYS

    '468':
        name: 'Scout MtG Hat'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '470':
        name: 'Lo-Fi Longwave'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: null
        _q: [C]
        _t: NEVER

    '471':
        name: 'Loyalty Reward'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: null
        _q: [C]
        _t: NEVER

    '472':
        name: 'Free Trial Premium Upgrade'
        item_class: 'upgrade'
        item_type_name: 'Map Stamp'
        craft_class: null
        _q: [C]
        _t: NEVER

    '473':
        name: 'Spiral Sallet'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: null
        _q: [C]
        _t: GIFT

    '477':
        name: 'Meet the Medic Heroic Taunt'
        item_class: 'tf_wearable'
        item_type_name: 'Special Taunt'
        craft_class: null
        _q: [C]
        _t: GIFT

    '478':
        name: 'Copper\'s Hard Top'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '479':
        name: 'Security Shades'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C]
        _t: ALWAYS

    '480':
        name: 'Tam O\'Shanter'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C, U]
        _t: ALWAYS

    '481':
        name: 'Stately Steel Toe'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C]
        _t: ALWAYS

    '482':
        name: 'Nessie\'s Nine Iron'
        item_class: 'tf_weapon_sword'
        item_type_name: 'Golf Club'
        craft_class: 'weapon'
        _q: [C]
        _t: ALWAYS

    '483':
        name: 'Rogue\'s Col Roule'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Shirt'
        craft_class: 'hat'
        _q: [C]
        _t: ALWAYS

    '484':
        name: 'Prairie Heel Biters'
        item_class: 'tf_wearable'
        item_type_name: 'Spurs'
        craft_class: 'hat'
        _q: [C]
        _t: ALWAYS

    '485':
        name: 'Big Steel Jaw of Summer Fun'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: 'hat'
        _q: [C]
        _t: ALWAYS

    '486':
        name: 'Summer Shades'
        item_class: 'tf_wearable'
        item_type_name: 'Glasses'
        craft_class: null
        _q: [C]
        _t: GIFT

    '490':
        name: 'Scout Flip-Flops'
        item_class: 'tf_wearable'
        item_type_name: 'Flip-Flops'
        craft_class: null
        _q: [C]
        _t: GIFT

    '491':
        name: 'Lucky No. 42'
        item_class: 'tf_wearable'
        item_type_name: 'Beach Towel'
        craft_class: null
        _q: [C]
        _t: GIFT

    '492':
        name: 'Summer Hat'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: null
        _q: [C]
        _t: GIFT

    '493':
        name: 'Promotional Noise Maker - Fireworks'
        item_class: 'tf_wearable'
        item_type_name: 'Party Favor'
        craft_class: null
        _q: [C]
        _t: NEVER

    '1899':
        name: 'World Traveler'
        item_class: 'tf_wearable'
        item_type_name: 'TF_Wearable_Hat'
        craft_class: null
        _q: [C]
        _t: NEVER

    '1900':
        name: 'Map Token Egypt'
        item_class: 'map_token'
        item_type_name: 'Map Stamp'
        craft_class: null
        _q: [C]
        _t: NEVER

    '1901':
        name: 'Map Token Coldfront'
        item_class: 'map_token'
        item_type_name: 'Map Stamp'
        craft_class: null
        _q: [C]
        _t: NEVER

    '1902':
        name: 'Map Token Fastlane'
        item_class: 'map_token'
        item_type_name: 'Map Stamp'
        craft_class: null
        _q: [C]
        _t: NEVER

    '1903':
        name: 'Map Token Turbine'
        item_class: 'map_token'
        item_type_name: 'Map Stamp'
        craft_class: null
        _q: [C]
        _t: NEVER

    '1904':
        name: 'Map Token Steel'
        item_class: 'map_token'
        item_type_name: 'Map Stamp'
        craft_class: null
        _q: [C]
        _t: NEVER

    '1905':
        name: 'Map Token Junction'
        item_class: 'map_token'
        item_type_name: 'Map Stamp'
        craft_class: null
        _q: [C]
        _t: NEVER

    '1906':
        name: 'Map Token Watchtower'
        item_class: 'map_token'
        item_type_name: 'Map Stamp'
        craft_class: null
        _q: [C]
        _t: NEVER

    '1907':
        name: 'Map Token Hoodoo'
        item_class: 'map_token'
        item_type_name: 'Map Stamp'
        craft_class: null
        _q: [C]
        _t: NEVER

    '1908':
        name: 'Map Token Offblast'
        item_class: 'map_token'
        item_type_name: 'Map Stamp'
        craft_class: null
        _q: [C]
        _t: NEVER

    '1909':
        name: 'Map Token Yukon'
        item_class: 'map_token'
        item_type_name: 'Map Stamp'
        craft_class: null
        _q: [C]
        _t: NEVER

    '1910':
        name: 'Map Token Harvest'
        item_class: 'map_token'
        item_type_name: 'Map Stamp'
        craft_class: null
        _q: [C]
        _t: NEVER

    '1911':
        name: 'Map Token Freight'
        item_class: 'map_token'
        item_type_name: 'Map Stamp'
        craft_class: null
        _q: [C]
        _t: NEVER

    '1912':
        name: 'Map Token Mountain Lab'
        item_class: 'map_token'
        item_type_name: 'Map Stamp'
        craft_class: null
        _q: [C]
        _t: NEVER

    '1913':
        name: 'Map Token Manor Event'
        item_class: 'map_token'
        item_type_name: 'Map Stamp'
        craft_class: null
        _q: [C]
        _t: NEVER

    '1914':
        name: 'Map Token Nightfall'
        item_class: 'map_token'
        item_type_name: 'Map Stamp'
        craft_class: null
        _q: [C]
        _t: NEVER

    '1915':
        name: 'Map Token Frontier'
        item_class: 'map_token'
        item_type_name: 'Map Stamp'
        craft_class: null
        _q: [C]
        _t: NEVER

    '1916':
        name: 'Map Token Lakeside'
        item_class: 'map_token'
        item_type_name: 'Map Stamp'
        craft_class: null
        _q: [C]
        _t: NEVER


    '2000':
        name: 'Polycount Pyro Bundle'
        item_class: 'bundle'
        item_type_name: 'Item Bundle'
        craft_class: null
        _q: [C]
        _v: NEVER

    '2001':
        name: 'Polycount Spy Bundle'
        item_class: 'bundle'
        item_type_name: 'Item Bundle'
        craft_class: null
        _q: [C]
        _v: NEVER

    '2002':
        name: 'Polycount Soldier Bundle'
        item_class: 'bundle'
        item_type_name: 'Item Bundle'
        craft_class: null
        _q: [C]
        _v: NEVER

    '2003':
        name: 'Polycount Sniper Bundle'
        item_class: 'bundle'
        item_type_name: 'Item Bundle'
        craft_class: null
        _q: [C]
        _v: NEVER

    '2004':
        name: 'Polycount Scout Bundle'
        item_class: 'bundle'
        item_type_name: 'Item Bundle'
        craft_class: null
        _q: [C]
        _v: NEVER

    '2005':
        name: 'Polycount Bundle'
        item_class: 'bundle'
        item_type_name: 'Item Bundle'
        craft_class: null
        _q: [C]
        _v: NEVER

    '2006':
        name: 'Halloween Noise Maker Bundle'
        item_class: 'bundle'
        item_type_name: 'Item Bundle'
        craft_class: null
        _q: [C]
        _v: NEVER

    '2007':
        name: 'Map Token Bundle'
        item_class: 'bundle'
        item_type_name: 'Item Bundle'
        craft_class: null
        _q: [C]
        _v: NEVER

    '2008':
        name: 'Medieval Medic Bundle'
        item_class: 'bundle'
        item_type_name: 'Item Bundle'
        craft_class: null
        _q: [C]
        _v: NEVER

    '2009':
        name: 'Hibernating Bear Bundle'
        item_class: 'bundle'
        item_type_name: 'Item Bundle'
        craft_class: null
        _q: [C]
        _v: NEVER

    '2010':
        name: 'Expert\'s Ordnance Bundle'
        item_class: 'bundle'
        item_type_name: 'Item Bundle'
        craft_class: null
        _q: [C]
        _v: NEVER

    '2011':
        name: 'Winter Update Bundle'
        item_class: 'bundle'
        item_type_name: 'Item Bundle'
        craft_class: null
        _q: [C]
        _v: NEVER

    '2012':
        name: 'Fancy Hat Bundle'
        item_class: 'bundle'
        item_type_name: 'Item Bundle'
        craft_class: null
        _q: [C]
        _v: NEVER

    '2013':
        name: 'Excessive Bundle of Bundles'
        item_class: 'bundle'
        item_type_name: 'Item Bundle'
        craft_class: null
        _q: [C]
        _v: NEVER

    '2014':
        name: 'Nasty Weapon Bundle'
        item_class: 'bundle'
        item_type_name: 'Item Bundle'
        craft_class: null
        _q: [C]
        _v: NEVER

    '2015':
        name: 'Map Token Bundle 2'
        item_class: 'bundle'
        item_type_name: 'Item Bundle'
        craft_class: null
        _q: [C]
        _v: NEVER

    '2016':
        name: 'Shogun Complete Bundle'
        item_class: 'bundle'
        item_type_name: 'Item Bundle'
        craft_class: null
        _q: [C]
        _v: NEVER

    '2017':
        name: 'Japan Charity Bundle'
        item_class: 'bundle'
        item_type_name: 'Item Bundle'
        craft_class: null
        _q: [C]
        _v: NEVER

    '2018':
        name: 'Scout Starter Bundle'
        item_class: 'bundle'
        item_type_name: 'Item Bundle'
        craft_class: null
        _q: [C]
        _v: NEVER

    '2019':
        name: 'Soldier Starter Bundle'
        item_class: 'bundle'
        item_type_name: 'Item Bundle'
        craft_class: null
        _q: [C]
        _v: NEVER

    '2020':
        name: 'Pyro Starter Bundle'
        item_class: 'bundle'
        item_type_name: 'Item Bundle'
        craft_class: null
        _q: [C]
        _v: NEVER

    '2021':
        name: 'Demoman Starter Bundle'
        item_class: 'bundle'
        item_type_name: 'Item Bundle'
        craft_class: null
        _q: [C]
        _v: NEVER

    '2022':
        name: 'Heavy Starter Bundle'
        item_class: 'bundle'
        item_type_name: 'Item Bundle'
        craft_class: null
        _q: [C]
        _v: NEVER

    '2023':
        name: 'Engineer Starter Bundle'
        item_class: 'bundle'
        item_type_name: 'Item Bundle'
        craft_class: null
        _q: [C]
        _v: NEVER

    '2024':
        name: 'Medic Starter Bundle'
        item_class: 'bundle'
        item_type_name: 'Item Bundle'
        craft_class: null
        _q: [C]
        _v: NEVER

    '2025':
        name: 'Sniper Starter Bundle'
        item_class: 'bundle'
        item_type_name: 'Item Bundle'
        craft_class: null
        _q: [C]
        _v: NEVER

    '2026':
        name: 'Spy Starter Bundle'
        item_class: 'bundle'
        item_type_name: 'Item Bundle'
        craft_class: null
        _q: [C]
        _v: NEVER

    '2028':
        name: 'Mobster Monday Bundle'
        item_class: 'bundle'
        item_type_name: 'Item Bundle'
        craft_class: null
        _q: [C]
        _v: NEVER

    '2029':
        name: 'TimbukTuesday Bundle'
        item_class: 'bundle'
        item_type_name: 'Item Bundle'
        craft_class: null
        _q: [C]
        _v: NEVER

    '2030':
        name: 'World War Wednesday Bundle'
        item_class: 'bundle'
        item_type_name: 'Item Bundle'
        craft_class: null
        _q: [C]
        _v: NEVER

    '2031':
        name: 'Meet the Medic! Bundle'
        item_class: 'bundle'
        item_type_name: 'Item Bundle'
        craft_class: null
        _q: [C]
        _v: NEVER

    '2032':
        name: 'Uber Bundle'
        item_class: 'bundle'
        item_type_name: 'Item Bundle'
        craft_class: null
        _q: [C]
        _v: NEVER

    '2033':
        name: 'Summer Sun Bundle'
        item_class: 'bundle'
        item_type_name: 'Item Bundle'
        craft_class: null
        _q: [C]
        _v: NEVER

    '5000':
        name: 'Craft Bar Level 1'
        item_class: 'craft_item'
        item_type_name: 'Craft Item'
        craft_class: 'craft_bar'
        _q: [C]
        _t: ALWAYS

    '5001':
        name: 'Craft Bar Level 2'
        item_class: 'craft_item'
        item_type_name: 'Craft Item'
        craft_class: 'craft_bar'
        _q: [C]
        _t: ALWAYS

    '5002':
        name: 'Craft Bar Level 3'
        item_class: 'craft_item'
        item_type_name: 'Craft Item'
        craft_class: 'craft_bar'
        _q: [C]
        _t: ALWAYS

    '5003':
        name: 'Scout Class Token'
        item_class: 'class_token'
        item_type_name: 'Craft Item'
        craft_class: 'craft_token'
        _q: [C]
        _t: ALWAYS

    '5004':
        name: 'Sniper Class Token'
        item_class: 'class_token'
        item_type_name: 'Craft Item'
        craft_class: 'craft_token'
        _q: [C]
        _t: ALWAYS

    '5005':
        name: 'Soldier Class Token'
        item_class: 'class_token'
        item_type_name: 'Craft Item'
        craft_class: 'craft_token'
        _q: [C]
        _t: ALWAYS

    '5006':
        name: 'Demoman Class Token'
        item_class: 'class_token'
        item_type_name: 'Craft Item'
        craft_class: 'craft_token'
        _q: [C]
        _t: ALWAYS

    '5007':
        name: 'Heavy Class Token'
        item_class: 'class_token'
        item_type_name: 'Craft Item'
        craft_class: 'craft_token'
        _q: [C]
        _t: ALWAYS

    '5008':
        name: 'Medic Class Token'
        item_class: 'class_token'
        item_type_name: 'Craft Item'
        craft_class: 'craft_token'
        _q: [C]
        _t: ALWAYS

    '5009':
        name: 'Pyro Class Token'
        item_class: 'class_token'
        item_type_name: 'Craft Item'
        craft_class: 'craft_token'
        _q: [C]
        _t: ALWAYS

    '5010':
        name: 'Spy Class Token'
        item_class: 'class_token'
        item_type_name: 'Craft Item'
        craft_class: 'craft_token'
        _q: [C]
        _t: ALWAYS

    '5011':
        name: 'Engineer Class Token'
        item_class: 'class_token'
        item_type_name: 'Craft Item'
        craft_class: 'craft_token'
        _q: [C]
        _t: ALWAYS

    '5012':
        name: 'Slot Token - Primary'
        item_class: 'slot_token'
        item_type_name: 'Craft Item'
        craft_class: 'craft_token'
        _q: [C]
        _t: ALWAYS

    '5013':
        name: 'Slot Token - Secondary'
        item_class: 'slot_token'
        item_type_name: 'Craft Item'
        craft_class: 'craft_token'
        _q: [C]
        _t: ALWAYS

    '5014':
        name: 'Slot Token - Melee'
        item_class: 'slot_token'
        item_type_name: 'Craft Item'
        craft_class: 'craft_token'
        _q: [C]
        _t: ALWAYS

    '5018':
        name: 'Slot Token - PDA2'
        item_class: 'slot_token'
        item_type_name: 'Craft Item'
        craft_class: 'craft_token'
        _q: [C]
        _t: ALWAYS

    '5020':
        name: 'Name Tag'
        item_class: 'tool'
        item_type_name: 'Tool'
        craft_class: 'tool'
        _q: [C]
        _t: ALWAYS

    '5021':
        name: 'Decoder Ring'
        item_class: 'tool'
        item_type_name: 'Tool'
        craft_class: 'tool'
        _q: [C]
        _t: ALWAYS

    '5022':
        name: 'Supply Crate'
        item_class: 'supply_crate'
        item_type_name: 'TF_LockedCrate'
        craft_class: 'supply_crate'
        _q: [C]
        _t: ALWAYS

    '5023':
        name: 'Paint Can'
        item_class: 'tool'
        item_type_name: 'Tool'
        craft_class: 'tool'
        _q: [C]
        _t: NEVER

    '5027':
        name: 'Paint Can 1'
        item_class: 'tool'
        item_type_name: 'Tool'
        craft_class: 'tool'
        _q: [C]
        _t: ALWAYS

    '5028':
        name: 'Paint Can 2'
        item_class: 'tool'
        item_type_name: 'Tool'
        craft_class: 'tool'
        _q: [C]
        _t: ALWAYS

    '5029':
        name: 'Paint Can 3'
        item_class: 'tool'
        item_type_name: 'Tool'
        craft_class: 'tool'
        _q: [C]
        _t: ALWAYS

    '5030':
        name: 'Paint Can 4'
        item_class: 'tool'
        item_type_name: 'Tool'
        craft_class: 'tool'
        _q: [C]
        _t: ALWAYS

    '5031':
        name: 'Paint Can 5'
        item_class: 'tool'
        item_type_name: 'Tool'
        craft_class: 'tool'
        _q: [C]
        _t: ALWAYS

    '5032':
        name: 'Paint Can 6'
        item_class: 'tool'
        item_type_name: 'Tool'
        craft_class: 'tool'
        _q: [C]
        _t: ALWAYS

    '5033':
        name: 'Paint Can 7'
        item_class: 'tool'
        item_type_name: 'Tool'
        craft_class: 'tool'
        _q: [C]
        _t: ALWAYS

    '5034':
        name: 'Paint Can 8'
        item_class: 'tool'
        item_type_name: 'Tool'
        craft_class: 'tool'
        _q: [C]
        _t: ALWAYS

    '5035':
        name: 'Paint Can 9'
        item_class: 'tool'
        item_type_name: 'Tool'
        craft_class: 'tool'
        _q: [C]
        _t: ALWAYS

    '5036':
        name: 'Paint Can 10'
        item_class: 'tool'
        item_type_name: 'Tool'
        craft_class: 'tool'
        _q: [C]
        _t: ALWAYS

    '5037':
        name: 'Paint Can 11'
        item_class: 'tool'
        item_type_name: 'Tool'
        craft_class: 'tool'
        _q: [C]
        _t: ALWAYS

    '5038':
        name: 'Paint Can 12'
        item_class: 'tool'
        item_type_name: 'Tool'
        craft_class: 'tool'
        _q: [C]
        _t: ALWAYS

    '5039':
        name: 'Paint Can 13'
        item_class: 'tool'
        item_type_name: 'Tool'
        craft_class: 'tool'
        _q: [C]
        _t: ALWAYS

    '5040':
        name: 'Paint Can 14'
        item_class: 'tool'
        item_type_name: 'Tool'
        craft_class: 'tool'
        _q: [C]
        _t: ALWAYS

    '5041':
        name: 'Supply Crate 2'
        item_class: 'supply_crate'
        item_type_name: 'TF_LockedCrate'
        craft_class: 'supply_crate'
        _q: [C]
        _t: ALWAYS

    '5042':
        name: 'Gift Wrap'
        item_class: 'tool'
        item_type_name: 'Tool'
        craft_class: 'tool'
        _q: [C]
        _t: ALWAYS

    '5043':
        name: 'Wrapped Gift'
        item_class: 'tool'
        item_type_name: 'Gift'
        craft_class: null
        _q: [C]
        _t: ALWAYS

    '5044':
        name: 'Description Tag'
        item_class: 'tool'
        item_type_name: 'Tool'
        craft_class: 'tool'
        _q: [C]
        _t: ALWAYS

    '5045':
        name: 'Supply Crate 3'
        item_class: 'supply_crate'
        item_type_name: 'TF_LockedCrate'
        craft_class: 'supply_crate'
        _q: [C]
        _t: ALWAYS

    '5046':
        name: 'Paint Can Team Color'
        item_class: 'tool'
        item_type_name: 'Tool'
        craft_class: 'tool'
        _q: [C]
        _t: ALWAYS

    '5048':
        name: 'Winter Crate'
        item_class: 'supply_crate'
        item_type_name: 'TF_LockedCrate'
        craft_class: 'supply_crate'
        _q: [C]
        _t: NEVER

    '5049':
        name: 'Winter Key'
        item_class: 'tool'
        item_type_name: 'Tool'
        craft_class: 'tool'
        _q: [C]
        _t: NEVER

    '5050':
        name: 'Backpack Expander'
        item_class: 'tool'
        item_type_name: 'Tool'
        craft_class: null
        _q: [C]
        _t: ALWAYS

    '5051':
        name: 'Paint Can 15'
        item_class: 'tool'
        item_type_name: 'Tool'
        craft_class: 'tool'
        _q: [C]
        _t: ALWAYS

    '5052':
        name: 'Paint Can 16'
        item_class: 'tool'
        item_type_name: 'Tool'
        craft_class: 'tool'
        _q: [C]
        _t: ALWAYS

    '5053':
        name: 'Paint Can 17'
        item_class: 'tool'
        item_type_name: 'Tool'
        craft_class: 'tool'
        _q: [C]
        _t: ALWAYS

    '5054':
        name: 'Paint Can 18'
        item_class: 'tool'
        item_type_name: 'Tool'
        craft_class: 'tool'
        _q: [C]
        _t: ALWAYS

    '5055':
        name: 'Paint Can 19'
        item_class: 'tool'
        item_type_name: 'Tool'
        craft_class: 'tool'
        _q: [C]
        _t: ALWAYS

    '5056':
        name: 'Paint Can 20'
        item_class: 'tool'
        item_type_name: 'Tool'
        craft_class: 'tool'
        _q: [C]
        _t: ALWAYS

    '5057':
        name: 'Christmas Key 2010'
        item_class: 'tool'
        item_type_name: 'Tool'
        craft_class: 'tool'
        _q: [C]
        _t: NEVER

    '5060':
        name: 'Paint Can Team Color 2'
        item_class: 'tool'
        item_type_name: 'Tool'
        craft_class: 'tool'
        _q: [C]
        _t: ALWAYS

    '5061':
        name: 'Paint Can Team Color 3'
        item_class: 'tool'
        item_type_name: 'Tool'
        craft_class: 'tool'
        _q: [C]
        _t: ALWAYS

    '5062':
        name: 'Paint Can Team Color 4'
        item_class: 'tool'
        item_type_name: 'Tool'
        craft_class: 'tool'
        _q: [C]
        _t: ALWAYS

    '5063':
        name: 'Paint Can Team Color 5'
        item_class: 'tool'
        item_type_name: 'Tool'
        craft_class: 'tool'
        _q: [C]
        _t: ALWAYS

    '5064':
        name: 'Paint Can Team Color 6'
        item_class: 'tool'
        item_type_name: 'Tool'
        craft_class: 'tool'
        _q: [C]
        _t: ALWAYS

    '5065':
        name: 'Paint Can Team Color 7'
        item_class: 'tool'
        item_type_name: 'Tool'
        craft_class: 'tool'
        _q: [C]
        _t: ALWAYS

    '5066':
        name: 'Summer Crate'
        item_class: 'supply_crate'
        item_type_name: 'TF_LockedCrate'
        craft_class: 'supply_crate'
        _q: [C]
        _t: ALWAYS

    '5067':
        name: 'Summer Key'
        item_class: 'tool'
        item_type_name: 'Tool'
        craft_class: 'tool'
        _q: [C]
        _t: NEVER

    '5500':
        name: 'RIFT Spider Hat Code'
        item_class: 'tool'
        item_type_name: 'TF_ClaimCode'
        craft_class: null
        _q: [C]
        _t: NEVER

    '439':
        name: "Lord Cockswain's Pith Helmet"
        _q: [C]
        _t: ALWAYS
        item_class: "tf_wearable"
        item_description: ""
        item_name: "Lord Cockswain's Pith Helmet"
        item_type_name: "TF_Wearable_Hat"

    '440':
        name: "Lord Cockswain's Novelty Mutton Chops and Pipe"
        _q: [C]
        _t: ALWAYS
        item_class: "tf_wearable"
        item_description: ""
        item_name: "Lord Cockswain's Novelty Mutton Chops and Pipe"
        item_type_name: "TF_Wearable_FacialHair"

    '441':
        name: "The Cow Mangler 5000"
        _q: [C]
        _t: ALWAYS
        item_class: "tf_weapon_particle_cannon"
        item_description: ''
        item_name: "Cow Mangler 5000"
        item_type_name: "Focused Wave Projector"

    '442':
        name: "The Righteous Bison"
        _q: [C, G]
        _t: ALWAYS
        item_class: "tf_weapon_raygun"
        item_description: ""
        item_name: "Righteous Bison"
        item_type_name: "Indivisible Particle Smasher"

    '443':
        name: "Dr. Grordbort's Crest"
        _q: [C]
        _t: ALWAYS
        item_class: "tf_wearable"
        item_description: "A symbol of service in the Venusian legions."
        item_name: "Dr. Grordbort's Crest"
        item_type_name: "Badge"

    '496':
        name: "TournamentMedal - GWJ Winners"
        _q: [C]
        _t: NEVER
        item_class: "tf_wearable"
        item_description: ""
        item_name: "TF_TournamentMedal_GWJ_1st"
        item_type_name: "TF_Wearable_TournamentMedal"

    '497':
        name: "TournamentMedal - GWJ Runnerups"
        _q: [C]
        _t: NEVER
        item_class: "tf_wearable"
        item_description: ""
        item_name: "TF_TournamentMedal_GWJ_2nd"
        item_type_name: "TF_Wearable_TournamentMedal"

    '498':
        name: "TournamentMedal - GWJ Participants"
        _q: [C]
        _t: NEVER
        item_class: "tf_wearable"
        item_description: ""
        item_name: "TF_TournamentMedal_GWJ_3rd"
        item_type_name: "TF_Wearable_TournamentMedal"

    '499':
        name: "TournamentMedal - ETF2LHL Winners"
        _q: [C]
        _t: NEVER
        item_class: "tf_wearable"
        item_description: ""
        item_name: "TF_TournamentMedal_ETF2LHL_1st"
        item_type_name: "TF_Wearable_TournamentMedal"

    '500':
        name: "TournamentMedal - ETF2LHL 2nd"
        _q: [C]
        _t: NEVER
        item_class: "tf_wearable"
        item_description: ""
        item_name: "TF_TournamentMedal_ETF2LHL_2nd"
        item_type_name: "TF_Wearable_TournamentMedal"

    '501':
        name: "TournamentMedal - ETF2LHL 3rd"
        _q: [C]
        _t: NEVER
        item_class: "tf_wearable"
        item_description: ""
        item_name: "TF_TournamentMedal_ETF2LHL_3rd"
        item_type_name: "TF_Wearable_TournamentMedal"

    '502':
        name: "TournamentMedal - ETF2LHL Participants"
        _q: [C]
        _t: NEVER
        item_class: "tf_wearable"
        item_description: ""
        item_name: "TF_TournamentMedal_ETF2LHL_4th"
        item_type_name: "TF_Wearable_TournamentMedal"

    '503':
        name: "TournamentMedal - UGCHL Participants"
        _q: [C]
        _t: NEVER
        item_class: "tf_wearable"
        item_description: ""
        item_name: "TF_TournamentMedal_UGCHL_Participant"
        item_type_name: "TF_Wearable_TournamentMedal"

    '504':
        name: "TournamentMedal - UGCHLDiv1 Winners"
        _q: [C]
        _t: NEVER
        item_class: "tf_wearable"
        item_description: ""
        item_name: "TF_TournamentMedal_UGCHLDiv1_1st"
        item_type_name: "TF_Wearable_TournamentMedal"

    '505':
        name: "TournamentMedal - UGCHLDiv1 2nd"
        _q: [C]
        _t: NEVER
        item_class: "tf_wearable"
        item_description: ""
        item_name: "TF_TournamentMedal_UGCHLDiv1_2nd"
        item_type_name: "TF_Wearable_TournamentMedal"

    '506':
        name: "TournamentMedal - UGCHLDiv1 3rd"
        _q: [C]
        _t: NEVER
        item_class: "tf_wearable"
        item_description: ""
        item_name: "TF_TournamentMedal_UGCHLDiv1_3rd"
        item_type_name: "TF_Wearable_TournamentMedal"

    '507':
        name: "TournamentMedal - UGCHLDiv2 Winners"
        _q: [C]
        _t: NEVER
        item_class: "tf_wearable"
        item_description: ""
        item_name: "TF_TournamentMedal_UGCHLDiv2_1st"
        item_type_name: "TF_Wearable_TournamentMedal"

    '508':
        name: "TournamentMedal - UGCHLDiv2 2nd"
        _q: [C]
        _t: NEVER
        item_class: "tf_wearable"
        item_description: ""
        item_name: "TF_TournamentMedal_UGCHLDiv2_2nd"
        item_type_name: "TF_Wearable_TournamentMedal"

    '509':
        name: "TournamentMedal - UGCHLDiv2 3rd"
        _q: [C]
        _t: NEVER
        item_class: "tf_wearable"
        item_description: ""
        item_name: "TF_TournamentMedal_UGCHLDiv2_3rd"
        item_type_name: "TF_Wearable_TournamentMedal"

    '510':
        name: "TournamentMedal - UGCHLDiv3 Winners"
        _q: [C]
        _t: NEVER
        item_class: "tf_wearable"
        item_description: ""
        item_name: "TF_TournamentMedal_UGCHLDiv3_1st"
        item_type_name: "TF_Wearable_TournamentMedal"

    '511':
        name: "TournamentMedal - UGCHLDiv3 2nd"
        _q: [C]
        _t: NEVER
        item_class: "tf_wearable"
        item_description: ""
        item_name: "TF_TournamentMedal_UGCHLDiv3_2nd"
        item_type_name: "TF_Wearable_TournamentMedal"

    '512':
        name: "TournamentMedal - UGCHLDiv3 3rd"
        _q: [C]
        _t: ALWAYS
        item_class: "tf_wearable"
        item_description: ""
        item_name: "TF_TournamentMedal_UGCHLDiv3_3rd"
        item_type_name: "TF_Wearable_TournamentMedal"

    '513':
        name: "The Original"
        _q: [C, G]
        _t: ALWAYS
        item_class: "tf_weapon_rocketlauncher"
        item_description: ''
        item_name: "Original"
        item_type_name: "Rocket Launcher"

    '514':
        name: "Mask of the Shaman"
        _q: [C, G]
        _t: ALWAYS
        item_class: "tf_wearable"
        item_description: "An invincibility mask made by the Ancients. It hasn’t worked in a long, long time."
        item_name: "Mask of the Shaman"
        item_type_name: "TF_Wearable_Mask"

    '515':
        name: "Pilotka"
        _q: [C, G]
        _t: ALWAYS
        item_class: "tf_wearable"
        item_description: ''
        item_name: "Pilotka"
        item_type_name: "TF_Wearable_Hat"

    '516':
        name: "Stahlhelm"
        _q: [C, G]
        _t: ALWAYS
        item_class: "tf_wearable"
        item_description: ''
        item_name: "Stahlhelm"
        item_type_name: "TF_Wearable_Hat"

    '517':
        name: "Tamrielic Relic"
        _q: [C, G]
        _t: ALWAYS
        item_class: "tf_wearable"
        item_description: "Designed to inspire fear, the dragons this helm was based on were less than impressed."
        item_name: "Tamrielic Relic"
        item_type_name: "TF_Wearable_Hat"

    '518':
        name: "The Anger"
        _q: [C, G]
        _t: ALWAYS
        item_class: "tf_wearable"
        item_description: ''
        item_name: "Anger"
        item_type_name: "TF_Wearable_Hat"

    '519':
        name: "Pip-Boy"
        _q: [C, G]
        _t: ALWAYS
        item_class: "tf_wearable"
        item_description: "Using modern super-deluxe resolution graphics!"
        item_name: "Pip-Boy"
        item_type_name: "TF_Wearable_Armband"

    '520':
        name: "Wingstick"
        _q: [C, G]
        _t: ALWAYS
        item_class: "tf_wearable"
        item_description: ''
        item_name: "Wingstick"
        item_type_name: "TF_Wearable_Wingstick"

    '2034':
        name: "Dr. Grordbort's Victory Pack"
        _q: [C]
        _t: NEVER
        item_class: "bundle"
        item_description: "Grab the whole pack of Dr. Grordbort items, designed by WETA Workshop!"
        item_name: "Dr. Grordbort's Victory Pack"
        item_type_name: "Item Bundle"

    '2035':
        name: "Dr. Grordbort ComicCon Promo Code"
        _q: [C]
        _t: NEVER
        item_class: "bundle"
        item_description: ""
        item_name: "TF_Bundle_DrGComicCon"
        item_type_name: "Item Bundle"

