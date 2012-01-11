tools = require '../shared/schema_tools.coffee'

exports.all = () ->
    groups = () ->
        tools.groupMaps(items).selectors

    qualities = () ->
        tools.mapObj items, (k, v) -> v._q

    offers = () ->
        tools.mapSeq groups().offers, (i) -> items[i]

    groups: groups()
    quals: qualities()
    offers: offers()


C = tools.basicQualities.common
G = tools.basicQualities.genuine
S = tools.basicQualities.strange
U = tools.basicQualities.unusual
V = tools.basicQualities.vintage


NEVER = tools.tradableFlags.never
ALWAYS = tools.tradableFlags.always
GIFT = tools.tradableFlags.gift


# this is a mapping of schema items to very simple item
# definitions.  these simplified definitions contain the '_q'
# property, which is a list of known qualities that the item can
# have, and the '_t' property, which is a value that denotes how the item can
# be traded.

exports.items = items =
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
        _q: [C, V, S]
        _t: ALWAYS

    '40':
        name: 'The Backburner'
        item_class: 'tf_weapon_flamethrower'
        item_type_name: 'Flame Thrower'
        craft_class: 'weapon'
        _q: [C, V, S]
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
        _q: [C, V, S]
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
        _q: [C, V, S]
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
        _q: [C, V, S]
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
        _q: [C, V, S]
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
        craft_class: 'weapon'
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
        craft_class: 'weapon'
        _q: [C, S]
        _t: ALWAYS

    '198':
        name: 'Upgradeable TF_WEAPON_BONESAW'
        item_class: 'tf_weapon_bonesaw'
        item_type_name: 'Bonesaw'
        craft_class: 'weapon'
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
        craft_class: 'weapon'
        _q: [C, S]
        _t: ALWAYS

    '201':
        name: 'Upgradeable TF_WEAPON_SNIPERRIFLE'
        item_class: 'tf_weapon_sniperrifle'
        item_type_name: 'Sniper Rifle'
        craft_class: 'weapon'
        _q: [C, S]
        _t: ALWAYS

    '202':
        name: 'Upgradeable TF_WEAPON_MINIGUN'
        item_class: 'tf_weapon_minigun'
        item_type_name: 'Minigun'
        craft_class: 'weapon'
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
        craft_class: 'weapon'
        _q: [C, S]
        _t: ALWAYS

    '205':
        name: 'Upgradeable TF_WEAPON_ROCKETLAUNCHER'
        item_class: 'tf_weapon_rocketlauncher'
        item_type_name: 'Rocket Launcher'
        craft_class: 'weapon'
        _q: [C, S]
        _t: ALWAYS

    '206':
        name: 'Upgradeable TF_WEAPON_GRENADELAUNCHER'
        item_class: 'tf_weapon_grenadelauncher'
        item_type_name: 'Grenade Launcher'
        craft_class: 'weapon'
        _q: [C, S]
        _t: ALWAYS

    '207':
        name: 'Upgradeable TF_WEAPON_PIPEBOMBLAUNCHER'
        item_class: 'tf_weapon_pipebomblauncher'
        item_type_name: 'Stickybomb Launcher'
        craft_class: 'weapon'
        _q: [C, S]
        _t: ALWAYS

    '208':
        name: 'Upgradeable TF_WEAPON_FLAMETHROWER'
        item_class: 'tf_weapon_flamethrower'
        item_type_name: 'Flame Thrower'
        craft_class: 'weapon'
        _q: [C, S]
        _t: ALWAYS

    '209':
        name: 'Upgradeable TF_WEAPON_PISTOL'
        item_class: 'tf_weapon_pistol'
        item_type_name: 'Pistol'
        craft_class: 'weapon'
        _q: [C, S]
        _t: ALWAYS

    '210':
        name: 'Upgradeable TF_WEAPON_REVOLVER'
        item_class: 'tf_weapon_revolver'
        item_type_name: 'Revolver'
        craft_class: 'weapon'
        _q: [C, S]
        _t: ALWAYS

    '211':
        name: 'Upgradeable TF_WEAPON_MEDIGUN'
        item_class: 'tf_weapon_medigun'
        item_type_name: 'Medi Gun'
        craft_class: 'weapon'
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
        _q: [C, S]
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
        _q: [C, S]
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
        _q: [C, S]
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
        _q: [C, V, S]
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
        _q: [C, S]
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
        _q: [C, S]
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
        _q: [C, G, V, S]
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
        _t: NEVER

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
        craft_class: 'hat'
        item_class: "tf_wearable"
        item_description: ""
        item_name: "Lord Cockswain's Pith Helmet"
        item_type_name: "TF_Wearable_Hat"

    '440':
        name: "Lord Cockswain's Novelty Mutton Chops and Pipe"
        _q: [C]
        _t: ALWAYS
        craft_class: 'hat'
        item_class: "tf_wearable"
        item_description: ""
        item_name: "Lord Cockswain's Novelty Mutton Chops and Pipe"
        item_type_name: "TF_Wearable_FacialHair"

    '441':
        name: "The Cow Mangler 5000"
        _q: [C]
        _t: ALWAYS
        craft_class: 'weapon'
        item_class: "tf_weapon_particle_cannon"
        item_description: ''
        item_name: "Cow Mangler 5000"
        item_type_name: "Focused Wave Projector"

    '442':
        name: "The Righteous Bison"
        _q: [C, G]
        _t: ALWAYS
        craft_class: 'weapon'
        item_class: "tf_weapon_raygun"
        item_description: ""
        item_name: "Righteous Bison"
        item_type_name: "Indivisible Particle Smasher"

    '443':
        name: "Dr. Grordbort's Crest"
        _q: [C]
        _t: ALWAYS
        craft_class: 'hat'
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
        craft_class: 'weapon'
        item_class: "tf_weapon_rocketlauncher"
        item_description: ''
        item_name: "Original"
        item_type_name: "Rocket Launcher"

    '514':
        name: "Mask of the Shaman"
        _q: [C, G]
        _t: ALWAYS
        craft_class: 'hat'
        item_class: "tf_wearable"
        item_description: "An invincibility mask made by the Ancients. It hasn’t worked in a long, long time."
        item_name: "Mask of the Shaman"
        item_type_name: "TF_Wearable_Mask"

    '515':
        name: "Pilotka"
        _q: [C, G]
        _t: ALWAYS
        craft_class: 'hat'
        item_class: "tf_wearable"
        item_description: ''
        item_name: "Pilotka"
        item_type_name: "TF_Wearable_Hat"

    '516':
        name: "Stahlhelm"
        _q: [C, G]
        _t: ALWAYS
        craft_class: 'hat'
        item_class: "tf_wearable"
        item_description: ''
        item_name: "Stahlhelm"
        item_type_name: "TF_Wearable_Hat"

    '517':
        name: "Tamrielic Relic"
        _q: [C, G]
        _t: ALWAYS
        craft_class: 'hat'
        item_class: "tf_wearable"
        item_description: "Designed to inspire fear, the dragons this helm was based on were less than impressed."
        item_name: "Tamrielic Relic"
        item_type_name: "TF_Wearable_Hat"

    '518':
        name: "The Anger"
        _q: [C, G]
        _t: ALWAYS
        craft_class: 'hat'
        item_class: "tf_wearable"
        item_description: ''
        item_name: "Anger"
        item_type_name: "TF_Wearable_Hat"

    '519':
        name: "Pip-Boy"
        _q: [C, G]
        _t: ALWAYS
        craft_class: 'hat'
        item_class: "tf_wearable"
        item_description: "Using modern super-deluxe resolution graphics!"
        item_name: "Pip-Boy"
        item_type_name: "TF_Wearable_Armband"

    '520':
        name: "Wingstick"
        _q: [C, G]
        _t: ALWAYS
        craft_class: 'hat'
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

    '521':
        name: "Belltower Spec Ops"
        _q: [C, G]
        _t: ALWAYS
        craft_class: 'hat'
        item_class: "tf_wearable"
        item_description: ""
        item_name: "Nanobalaclava"
        item_type_name: "Hat"

    '522':
        name: "The Deus Specs"
        _q: [C, G]
        _t: ALWAYS
        craft_class: 'hat'
        item_class: "tf_wearable"
        item_description: ""
        item_name: "Deus Specs"
        item_type_name: "Glasses"

    '523':
        name: "The Sarif Cap"
        _q: [C, G]
        _t: ALWAYS
        craft_class: 'hat'
        item_class: "tf_wearable"
        item_description: ""
        item_name: "Company Man"
        item_type_name: "Hat"

    '524':
        name: "The Purity Fist"
        _q: [C, G]
        _t: ALWAYS
        craft_class: 'hat'
        item_class: "tf_wearable"
        item_description: ""
        item_name: "Purity Fist"
        item_type_name: "TF_Wearable_Arms"

    '525':
        name: "The Diamondback"
        _q: [C, G]
        _t: ALWAYS
        craft_class: 'weapon'
        item_class: "tf_weapon_revolver"
        item_description: ""
        item_name: "Diamondback"
        item_type_name: "Revolver"

    '526':
        name: "The Machina"
        _q: [C, G]
        _t: ALWAYS
        craft_class: 'weapon'
        item_class: "tf_weapon_sniperrifle"
        item_description: ""
        item_name: "Machina"
        item_type_name: "Sniper Rifle"

    '527':
        name: "The Widowmaker"
        _q: [C, G]
        _t: ALWAYS
        craft_class: 'weapon'
        item_class: "tf_weapon_shotgun_primary"
        item_description: ""
        item_name: "Widowmaker"
        item_type_name: "Shotgun"

    '528':
        name: "The Short Circuit"
        _q: [C, G]
        _t: ALWAYS
        craft_class: 'weapon'
        item_class: "tf_weapon_mechanical_arm"
        item_description: ""
        item_name: "Short Circuit"
        item_type_name: "TF_Weapon_Mechanical_Arm"

    '533':
        name: "Clockwerk's Helm"
        _q: [C]
        _t: NEVER
        item_class: "tf_wearable"
        item_description: "DOTA 2 International Championship Gamescom 2011"
        item_name: "Clockwerk's Helm"
        item_type_name: "Hat"

    '534':
        name: "Sniper's Snipin' Glass"
        _q: [C]
        _t: NEVER
        item_class: "tf_wearable"
        item_description: "DOTA 2 International Championship Gamescom 2011"
        item_name: "Sniper's Snipin' Glass"
        item_type_name: "Hat"

    '535':
        name: "Storm Spirit's Jolly Hat"
        _q: [C]
        _t: NEVER
        item_class: "tf_wearable"
        item_description: "DOTA 2 International Championship Gamescom 2011"
        item_name: "Storm Spirit's Jolly Hat"
        item_type_name: "Hat"

    '2036':
        name: "Bethesda Employee Bundle"
        _q: [C]
        _t: NEVER
        item_class: "bundle"
        item_description: "undefined"
        item_name: "Bethesda Employee Bundle"
        item_type_name: "Item Bundle"

    '2037':
        name: "Tripwire Employee Bundle"
        _q: [C]
        _t: NEVER
        item_class: "bundle"
        item_description: "undefined"
        item_name: "Tripwire Employee Bundle"
        item_type_name: "Item Bundle"

    '2038':
        name: "Bethesda Employee Bundle Genuine"
        _q: [C]
        _t: NEVER
        item_class: "bundle"
        item_description: "undefined"
        item_name: "Bethesda Employee Bundle"
        item_type_name: "Item Bundle"

    '2039':
        name: "Tripwire Employee Bundle Genuine"
        _q: [C]
        _t: NEVER
        item_class: "bundle"
        item_description: "undefined"
        item_name: "Tripwire Employee Bundle"
        item_type_name: "Item Bundle"

    '2040':
        name: "Deus Ex Promo Bundle"
        _q: [C]
        _t: NEVER
        item_class: "bundle"
        item_description: "When will it be the future? Right now! See for yourself with these eight items:"
        item_name: "The Manno-Technology Bundle"
        item_type_name: "Item Bundle"

    '2041':
        name: "Deus Ex Purity Fist PAX Promo"
        _q: [C]
        _t: NEVER
        item_class: "bundle"
        item_description: ""
        item_name: "TF_Bundle_DeusExPAX"
        item_type_name: "Item Bundle"

    '167':
        name: "High Five Taunt"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "tf_wearable"
        item_description: "Don't leave your friends hanging. This is a press-and-hold taunt. Hold down the action slot key to remain in the taunt's pose."
        item_name: "Taunt: The High Five!"
        item_type_name: "Special Taunt"

    '474':
        name: "The Conscientious Objector"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "saxxy"
        item_description: "We gave peace a chance. It didn't work. Custom decals can be applied to this item."
        item_name: "Conscientious Objector"
        item_type_name: "Sign"

    '536':
        name: "Noise Maker - TF Birthday"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "tf_wearable"
        item_description: "undefined"
        item_name: "Noise Maker - TF Birthday"
        item_type_name: "Party Favor"

    '537':
        name: "TF Birthday Hat 2011"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "tf_wearable"
        item_description: ""
        item_name: "Party Hat"
        item_type_name: "Hat"

    '538':
        name: "Killer Exclusive"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "tf_wearable"
        item_description: "Break news, spirits and heads."
        item_name: "Killer Exclusive"
        item_type_name: "Hat"

    '539':
        name: "The El Jefe"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: ""
        item_name: "El Jefe"
        item_type_name: "Hat"

    '540':
        name: "Ball-Kicking Boots"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "tf_wearable"
        item_description: "Show balls who is the boss."
        item_name: "Ball-Kicking Boots"
        item_type_name: "Shoes"

    '541':
        name: "Merc's Pride Scarf"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "tf_wearable"
        item_description: "Wear your loyalty like a brightly-colored noose around your neck."
        item_name: "Merc's Pride Scarf"
        item_type_name: "Scarf"

    '542':
        name: "Noise Maker - Vuvuzela"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "tf_wearable"
        item_description: "undefined"
        item_name: "Noise Maker - Vuvuzela"
        item_type_name: "Party Favor"

    '543':
        name: "Hair of the Dog"
        _q: [C]
        _t: ALWAYS
        craft_class: ""
        item_class: "tf_wearable"
        item_description: ""
        item_name: "Hair of the Dog"
        item_type_name: "Costume Piece"

    '544':
        name: "Scottish Snarl"
        _q: [C]
        _t: ALWAYS
        craft_class: ""
        item_class: "tf_wearable"
        item_description: ""
        item_name: "Scottish Snarl"
        item_type_name: "Costume Piece"

    '545':
        name: "Pickled Paws"
        _q: [C]
        _t: ALWAYS
        craft_class: ""
        item_class: "tf_wearable"
        item_description: ""
        item_name: "Pickled Paws"
        item_type_name: "Costume Piece"

    '546':
        name: "Wrap Battler"
        _q: [C]
        _t: ALWAYS
        craft_class: ""
        item_class: "tf_wearable"
        item_description: ""
        item_name: "Wrap Battler"
        item_type_name: "Costume Piece"

    '547':
        name: "B-ankh!"
        _q: [C]
        _t: ALWAYS
        craft_class: ""
        item_class: "tf_wearable"
        item_description: ""
        item_name: "B-ankh!"
        item_type_name: "Costume Piece"

    '548':
        name: "Futankhamun"
        _q: [C]
        _t: ALWAYS
        craft_class: ""
        item_class: "tf_wearable"
        item_description: ""
        item_name: "Futankhamun"
        item_type_name: "Costume Piece"

    '549':
        name: "Blazing Bull"
        _q: [C]
        _t: ALWAYS
        craft_class: ""
        item_class: "tf_wearable"
        item_description: ""
        item_name: "Blazing Bull"
        item_type_name: "Costume Piece"

    '550':
        name: "Fallen Angel"
        _q: [C]
        _t: ALWAYS
        craft_class: ""
        item_class: "tf_wearable"
        item_description: ""
        item_name: "Fallen Angel"
        item_type_name: "Costume Piece"

    '551':
        name: "Tail From the Crypt"
        _q: [C]
        _t: ALWAYS
        craft_class: ""
        item_class: "tf_wearable"
        item_description: ""
        item_name: "Tail From the Crypt"
        item_type_name: "Costume Piece"

    '552':
        name: "Einstein"
        _q: [C]
        _t: ALWAYS
        craft_class: ""
        item_class: "tf_wearable"
        item_description: ""
        item_name: "Einstein"
        item_type_name: "Costume Piece"

    '553':
        name: "Dr. Gogglestache"
        _q: [C]
        _t: ALWAYS
        craft_class: ""
        item_class: "tf_wearable"
        item_description: ""
        item_name: "Dr. Gogglestache"
        item_type_name: "Costume Piece"

    '554':
        name: "Emerald Jarate"
        _q: [C]
        _t: ALWAYS
        craft_class: ""
        item_class: "tf_wearable"
        item_description: ""
        item_name: "Emerald Jarate"
        item_type_name: "Costume Piece"

    '555':
        name: "Idiot Box"
        _q: [C]
        _t: ALWAYS
        craft_class: ""
        item_class: "tf_wearable"
        item_description: ""
        item_name: "Idiot Box"
        item_type_name: "Costume Piece"

    '556':
        name: "Steel Pipes"
        _q: [C]
        _t: ALWAYS
        craft_class: ""
        item_class: "tf_wearable"
        item_description: ""
        item_name: "Steel Pipes"
        item_type_name: "Costume Piece"

    '557':
        name: "Shoestring Budget"
        _q: [C]
        _t: ALWAYS
        craft_class: ""
        item_class: "tf_wearable"
        item_description: ""
        item_name: "Shoestring Budget"
        item_type_name: "Costume Piece"

    '558':
        name: "Under Cover"
        _q: [C]
        _t: ALWAYS
        craft_class: ""
        item_class: "tf_wearable"
        item_description: ""
        item_name: "Under Cover"
        item_type_name: "Costume Piece"

    '559':
        name: "Griffin's Gog"
        _q: [C]
        _t: ALWAYS
        craft_class: ""
        item_class: "tf_wearable"
        item_description: ""
        item_name: "Griffin's Gog"
        item_type_name: "Costume Piece"

    '560':
        name: "Intangible Ascot"
        _q: [C]
        _t: ALWAYS
        craft_class: ""
        item_class: "tf_wearable"
        item_description: ""
        item_name: "Intangible Ascot"
        item_type_name: "Costume Piece"

    '561':
        name: "Can Opener"
        _q: [C]
        _t: ALWAYS
        craft_class: ""
        item_class: "tf_wearable"
        item_description: ""
        item_name: "Can Opener"
        item_type_name: "Costume Piece"

    '562':
        name: "Soviet Stitch-Up"
        _q: [C]
        _t: ALWAYS
        craft_class: ""
        item_class: "tf_wearable"
        item_description: ""
        item_name: "Soviet Stitch-Up"
        item_type_name: "Costume Piece"

    '563':
        name: "Steel-Toed Stompers"
        _q: [C]
        _t: ALWAYS
        craft_class: ""
        item_class: "tf_wearable"
        item_description: ""
        item_name: "Steel-Toed Stompers"
        item_type_name: "Costume Piece"

    '564':
        name: "Holy Hunter"
        _q: [C]
        _t: ALWAYS
        craft_class: ""
        item_class: "tf_wearable"
        item_description: ""
        item_name: "Holy Hunter"
        item_type_name: "Costume Piece"

    '565':
        name: "Silver Bullets"
        _q: [C]
        _t: ALWAYS
        craft_class: ""
        item_class: "tf_wearable"
        item_description: ""
        item_name: "Silver Bullets"
        item_type_name: "Costume Piece"

    '566':
        name: "Garlic Flank Stake"
        _q: [C]
        _t: ALWAYS
        craft_class: ""
        item_class: "tf_wearable"
        item_description: ""
        item_name: "Garlic Flank Stake"
        item_type_name: "Costume Piece"

    '567':
        name: "Buzz Killer"
        _q: [C]
        _t: ALWAYS
        craft_class: ""
        item_class: "tf_wearable"
        item_description: ""
        item_name: "Buzz Killer"
        item_type_name: "Costume Piece"

    '568':
        name: "Frontier Flyboy"
        _q: [C]
        _t: ALWAYS
        craft_class: ""
        item_class: "tf_wearable"
        item_description: ""
        item_name: "Frontier Flyboy"
        item_type_name: "Costume Piece"

    '569':
        name: "Legend of Bugfoot"
        _q: [C]
        _t: ALWAYS
        craft_class: ""
        item_class: "tf_wearable"
        item_description: ""
        item_name: "Legend of Bugfoot"
        item_type_name: "Costume Piece"

    '570':
        name: "The Last Breath"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: ""
        item_name: "Last Breath"
        item_type_name: "Hat"

    '571':
        name: "Apparition's Aspect"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "undefined"
        item_name: "Apparition's Aspect"
        item_type_name: "Hat"

    '572':
        name: "Unarmed Combat"
        _q: [C]
        _t: ALWAYS
        craft_class: "weapon"
        item_class: "tf_weapon_bat_fish"
        item_description: "So nice of the Spy to lend an arm..."
        item_name: "Unarmed Combat"
        item_type_name: "TF_Weapon_Severed_Arm"

    '574':
        name: "The Wanga Prick"
        _q: [C]
        _t: ALWAYS
        craft_class: "weapon"
        item_class: "tf_weapon_knife"
        item_description: "undefined"
        item_name: "Wanga Prick"
        item_type_name: "Knife"

    '575':
        name: "The Infernal Impaler"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "undefined"
        item_name: "Infernal Impaler"
        item_type_name: "Hat"

    '576':
        name: "Spine-Chilling Skull 2011"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "tf_wearable"
        item_description: "Re-express your undying hatred for the living annually with this skull-themed hate hat."
        item_name: "Spine-Chilling Skull 2011"
        item_type_name: "Hat"

    '577':
        name: "Halloween Giveaway Package 2011 (Cauldron)"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "tf_wearable"
        item_description: "You can pry open the lid of this cauldron to see what strangeness lies within... from your backpack... IF YOU DARE."
        item_name: "Halloween Goodie Cauldron"
        item_type_name: "Package"

    '578':
        name: "Spine-Chilling Skull 2011 Style 1"
        _q: [C]
        _t: ALWAYS
        craft_class: "haunted_hat"
        item_class: "tf_wearable"
        item_description: "Express your dislike for the living."
        item_name: "Spine-Tingling Skull"
        item_type_name: "Hat"

    '579':
        name: "Spine-Chilling Skull 2011 Style 2"
        _q: [C]
        _t: ALWAYS
        craft_class: "haunted_hat"
        item_class: "tf_wearable"
        item_description: "Express your disdain for the living."
        item_name: "Spine-Cooling Skull"
        item_type_name: "Hat"

    '580':
        name: "Spine-Chilling Skull 2011 Style 3"
        _q: [C]
        _t: ALWAYS
        craft_class: "haunted_hat"
        item_class: "tf_wearable"
        item_description: "Express your discontent with the living."
        item_name: "Spine-Twisting Skull"
        item_type_name: "Hat"

    '581':
        name: "MONOCULUS!"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "tf_wearable"
        item_description: "Celebrate the Demo's most serious childhood injury with this gruesome mask based on his missing, haunted eye."
        item_name: "MONOCULUS!"
        item_type_name: "Hat"

    '582':
        name: "Seal Mask"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "tf_wearable"
        item_description: "Turn routine melee attacks into environmental hate crimes with this adorable mask."
        item_name: "Seal Mask"
        item_type_name: "Mask"

    '583':
        name: "Bombinomicon"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "tf_wearable"
        item_description: "'If ye gaze upon one tome-themed badge this year, MAKE IT NOT THIS ONE!' - Merasmus the Magician'"
        item_name: "Bombinomicon"
        item_type_name: "Badge"

    '584':
        name: "Ghastly Gibus 2011"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "tf_wearable"
        item_description: "Elegant simplicity and old-world charm combined with the heady aromas of mould and grave dust."
        item_name: "Ghastly Gibus"
        item_type_name: "Hat"

    '585':
        name: "Cold War Luchador"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "The most terrifying Soviet/Latino partnership since the Cuban Missile Crisis."
        item_name: "Cold War Luchador"
        item_type_name: "Hat"

    '586':
        name: "Mark of the Saint"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: ""
        item_name: "Mark of the Saint"
        item_type_name: "Badge"

    '587':
        name: "Apoco-Fists"
        _q: [C]
        _t: ALWAYS
        craft_class: "weapon"
        item_class: "tf_weapon_fists"
        item_description: "Turn every one of your fingers into the Four Horsemen of the Apocalypse! That's over nineteen Horsemen of the Apocalypse per glove! The most Apocalypse we've ever dared attach to one hand!"
        item_name: "Apoco-Fists"
        item_type_name: "Fists"

    '588':
        name: "The Pomson 6000"
        _q: [C]
        _t: ALWAYS
        craft_class: "weapon"
        item_class: "tf_weapon_drg_pomson"
        item_description: "Being an innovative hand-held irradiating utensil capable of producing rapid pulses of high-amplitude radiation in sufficient quantity as to immolate, maim and otherwise incapacitate the Irish."
        item_name: "Pomson 6000"
        item_type_name: "Indivisible Particle Smasher"

    '589':
        name: "The Eureka Effect"
        _q: [C]
        _t: ALWAYS
        craft_class: "weapon"
        item_class: "tf_weapon_wrench"
        item_description: "Being a tool that eliminates exertion by harnessing the electrical discharges of thunder-storms for the vigorous coercion of bolts, nuts, pipes and similar into their rightful places. May also be used to bludgeon."
        item_name: "Eureka Effect"
        item_type_name: "Wrench"

    '590':
        name: "The Brainiac Hairpiece"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "Being a maths-enhancing hairpiece that endeavors to heighten the senses of any soul, be he a gentle-man of leisure deserving of such a thing, or a loathsome tiller of the earth of whom a beating would not go unwarranted."
        item_name: "Brainiac Hairpiece"
        item_type_name: "Facial Hair"

    '591':
        name: "The Brainiac Goggles"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "Being prescription shooting goggles that endeavor to relieve the eye from the reflection off one's gun barrel whilst also correcting Diplopia, Strabismus, 'Nervous Vision', Early-Onset Old-Eye, and several other varieties of structural defect."
        item_name: "Brainiac Goggles"
        item_type_name: "Hat"

    '592':
        name: "Dr. Grordbort's Copper Crest"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "tf_wearable"
        item_description: "Being a water-soluble, highly poisonous copper crest offering mute testament to one's commitment to the sciences. Prolonged exposure may cause tissue putridity, muscle atrophy and bone softening in the infirm, elderly and those graced with child."
        item_name: "Dr. Grordbort's Copper Crest"
        item_type_name: "Badge"

    '593':
        name: "The Third Degree"
        _q: [C]
        _t: ALWAYS
        craft_class: "weapon"
        item_class: "tf_weapon_fireaxe"
        item_description: "Being a boon to tree-fellers, backwoodsmen and atom-splitters the world over, this miraculous matter-hewing device burns each individual molecule as it cleaves it."
        item_name: "Third Degree"
        item_type_name: "Fire Axe"

    '594':
        name: "The Phlogistinator"
        _q: [C]
        _t: ALWAYS
        craft_class: "weapon"
        item_class: "tf_weapon_flamethrower"
        item_description: "Being a revolutionary appliance capable of awakening the fire element phlogiston that exists in all combustible creatures, which is to say, all of them."
        item_name: "Phlogistinator"
        item_type_name: "Flame Thrower"

    '595':
        name: "The Manmelter"
        _q: [C]
        _t: ALWAYS
        craft_class: "weapon"
        item_class: "tf_weapon_flaregun_revenge"
        item_description: "Being a device that flouts conventional scientific consensus that the molecules composing the human body must be arranged 'just so', and not, for example, across a square-mile radius."
        item_name: "Manmelter"
        item_type_name: "Indivisible Particle Smasher"

    '596':
        name: "The Moonman Backpack"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "Being a repository of the foundational ingredients necessary for a body to live a life of leisure in space—namely one part oxygen, one part mercury, and twelve parts laudanum."
        item_name: "Moonman Backpack"
        item_type_name: "Fuel Tank"

    '597':
        name: "The Bubble Pipe"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "Being an invention that achieves the humanitarian goal of all great men of science, from Lord Holland to the Duke of Wellington, to allow a true gentle-man to smoke a pipe in space."
        item_name: "Bubble Pipe"
        item_type_name: "Hat"

    '598':
        name: "Manniversary Paper Hat"
        _q: [C]
        _t: ALWAYS
        craft_class: ""
        item_class: "tf_wearable"
        item_description: "undefined"
        item_name: "Manniversary Paper Hat"
        item_type_name: "Hat"

    '599':
        name: "Manniversary Giveaway Package"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "tf_wearable"
        item_description: "From your fine friends at Mann Co., celebrating our one-year anniversary.

    This contains a free sample from our fall lineup and can be opened from your backpack."
        item_name: "Manniversary Package"
        item_type_name: "Package"

    '600':
        name: "Your Worst Nightmare"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "This bandanna will teach you to eat things that would make a billy goat puke. Like another billy goat."
        item_name: "Your Worst Nightmare"
        item_type_name: "Hat"

    '601':
        name: "The One-Man Army"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "You send that many men against a bandanna like this, don't forget one thing: A good supply of body bags."
        item_name: "One-Man Army"
        item_type_name: "Hat"

    '602':
        name: "The Counterfeit Billycock"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "This hat is a spy."
        item_name: "Counterfeit Billycock"
        item_type_name: "Hat"

    '603':
        name: "The Outdoorsman"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "Chop wood. Eat syrup. Live in Canada. This hat lets you do it all."
        item_name: "Outdoorsman"
        item_type_name: "Hat"

    '604':
        name: "The Tavish DeGroot Experience"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "Hey, Joe, where you going with that sticky launcher in your hand?"
        item_name: "Tavish DeGroot Experience"
        item_type_name: "Hat"

    '605':
        name: "The Pencil Pusher"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "Measure twice, cut once, shoot first."
        item_name: "Pencil Pusher"
        item_type_name: "Hat"

    '606':
        name: "The Builder's Blueprints"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "Never bring a gun to a blueprint fight."
        item_name: "Builder's Blueprints"
        item_type_name: "Blueprints"

    '607':
        name: "The Buccaneer's Bicorne"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "Hoist the mainsail! Buckle those swashes! Get into a swordfight! Pirate captains yell stuff like this all the time, and now you can too."
        item_name: "Buccaneer's Bicorne"
        item_type_name: "Hat"

    '608':
        name: "The Bootlegger"
        _q: [C]
        _t: ALWAYS
        craft_class: "weapon"
        item_class: "tf_wearable"
        item_description: "Amaze your friends! Impress women! Walk with a limp for life! It's grotesque!"
        item_name: "Bootlegger"
        item_type_name: "Boots"

    '609':
        name: "The Scottish Handshake"
        _q: [C]
        _t: ALWAYS
        craft_class: "weapon"
        item_class: "tf_weapon_bottle"
        item_description: "Your enemies will think you're making peace, right up until the terrifying moment that their hand is very seriously cut! Here's the trick: It's a broken bottle!"
        item_name: "Scottish Handshake"
        item_type_name: "Bottle"

    '610':
        name: "A Whiff of the Old Brimstone"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "Your enemies will clap in delight at the cartoonish innocence of these old-timey bombs, making it that much sweeter when you blow their arms off."
        item_name: "A Whiff of the Old Brimstone"
        item_type_name: "Decorative Bombs"

    '611':
        name: "The Salty Dog"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "Get all of a boat captain's respect without the crushing responsibility of actually captaining a boat or the enormous amount of ongoing maintenance a boat requires!"
        item_name: "Salty Dog"
        item_type_name: "Hat"

    '612':
        name: "The Little Buddy"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "People will think you're in the Navy. But the joke is on them, BECAUSE YOU'RE NOT! That is just one possible benefit of this tricky hat."
        item_name: "Little Buddy"
        item_type_name: "Hat"

    '613':
        name: "The Gym Rat"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "Let's get physical. Physical."
        item_name: "Gym Rat"
        item_type_name: "Hat"

    '614':
        name: "The Hot Dogger"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "There's been a terrible explosion at the hot dog factory! That's what you can tell people, and they'll believe you because you will look like an expert on hot dogs."
        item_name: "Hot Dogger"
        item_type_name: "Hat"

    '615':
        name: "The Birdcage"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "Everyone will wonder what the secret meaning of this mysterious hat is. The secret is you're an idiot."
        item_name: "Birdcage"
        item_type_name: "Hat"

    '616':
        name: "The Surgeon's Stahlhelm"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "Technically, field medics are protected as noncombatants under the Geneva Convention. The next time you get shot be sure to tell your killer. It's a conversation starter!"
        item_name: "Surgeon's Stahlhelm"
        item_type_name: "Hat"

    '617':
        name: "The Backwards Ballcap"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "Stick it to Major League Baseball by not wearing their hat the right way."
        item_name: "Backwards Ballcap"
        item_type_name: "Hat"

    '618':
        name: "The Crocodile Smile"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "How many crocodiles had to die to make this necklace? A lot. That's the point."
        item_name: "Crocodile Smile"
        item_type_name: "Necklace"

    '619':
        name: "Flair!"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "Show enthusiasm! For your favorite things!

    Custom decals can be applied to this item."
        item_name: "Flair!"
        item_type_name: "Flair!"

    '620':
        name: "Couvre Corner"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "Sometimes we put some jokes in these descriptions. But, no joke: This looks good. Really sharp."
        item_name: "Couvre Corner"
        item_type_name: "Pocket Square"

    '621':
        name: "The Surgeon's Stethoscope"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "Look like you know what you're doing when you pronounce people dead."
        item_name: "Surgeon's Stethoscope"
        item_type_name: "Stethoscope"

    '622':
        name: "L'Inspecteur"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "Nobody is not scared of a policeman from France. That is why this hat is so effective."
        item_name: "L'Inspecteur"
        item_type_name: "Hat"

    '623':
        name: "Photo Badge"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "Discourage identity theft. Custom decals can be applied to this item."
        item_name: "Photo Badge"
        item_type_name: "Badge"

    '625':
        name: "Clan Pride"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "Because it's cheaper and less painful than a tattoo Custom decals can be applied to this item."
        item_name: "Clan Pride"
        item_type_name: "Medallion"

    '626':
        name: "The Swagman's Swatter"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "This is the best hat. We couldn't say it if it weren't true. This one's the best."
        item_name: "Swagman's Swatter"
        item_type_name: "Hat"

    '627':
        name: "The Flamboyant Flamenco"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "Help your enemies celebrate Day of the Dead by wearing this hat and then killing them."
        item_name: "Flamboyant Flamenco"
        item_type_name: "Hat"

    '628':
        name: "The Virtual Reality Headset"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "With these on, you can pretend you're winning."
        item_name: "Virtual Reality Headset"
        item_type_name: "Hat"

    '629':
        name: "The Spectre's Spectacles"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "So mysterious. So deadly. So nearsighted."
        item_name: "Spectre's Spectacles"
        item_type_name: "Glasses"

    '630':
        name: "The Stereoscopic Shades"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "If you close an eye, one of the teams will disappear. So don't do that."
        item_name: "Stereoscopic Shades"
        item_type_name: "Glasses"

    '631':
        name: "The Hat With No Name"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "A nameless hat for a nameless man."
        item_name: "Hat With No Name"
        item_type_name: "Hat"

    '632':
        name: "The Cremator's Conscience"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "'Burn him with fire!' 'No, burn him with fire, then hit him with an axe!'"
        item_name: "Cremator's Conscience"
        item_type_name: "Conscience"

    '633':
        name: "The Hermes"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "Don't shoot the messenger. Actually, go ahead and try. Can't be done, pal! Too fast!"
        item_name: "Hermes"
        item_type_name: "Hat"

    '634':
        name: "Point and Shoot"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "The next time someone accuses you of not being a real wizard because you refuse to (read: can't) do spells, poke them in the eye with this magically blinding pointy hat and run."
        item_name: "Point and Shoot"
        item_type_name: "Hat"

    '635':
        name: "War Head"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "Protect your thought-horde from dragons, sorcery, and other make-believe dangers with this spiky lead battle-mask."
        item_name: "War Head"
        item_type_name: "Hat"

    '636':
        name: "Dr. Grordbort's Silver Crest"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "tf_wearable"
        item_description: "Being a highly malleable, thoroughly combustible silver crest that declares one's commitment, and intention, to immolate all creatures on God's Earth."
        item_name: "Dr. Grordbort's Silver Crest"
        item_type_name: "Badge"

    '637':
        name: "The Dashin' Hashshashin"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "When you need to go deep undercover, one disguise is not enough! Put a hood over that ski-mask, then wrap a towel around it. Boldly announce to the world that you are inconspicuous!"
        item_name: "Dashin' Hashshashin"
        item_type_name: "Hat"

    '638':
        name: "The Sharp Dresser"
        _q: [C]
        _t: ALWAYS
        craft_class: "weapon"
        item_class: "tf_weapon_knife"
        item_description: "Every merc's crazy for a sharp-dressed man. With 15th century murder-knives extruding from his cufflinks."
        item_name: "Sharp Dresser"
        item_type_name: "Knife"

    '639':
        name: "Bowtie"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: ""
        item_name: "Dr. Whoa"
        item_type_name: "TF_Wearable_Shirt"

    '640':
        name: "The Top Notch"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "tf_wearable"
        item_description: "Welcome to a secret society so exclusive it makes the Illuminati look like a Costco. How exclusive? You are the only member. This is the only item of its kind in all of existence. So don't craft it, Miney."
        item_name: "Top Notch"
        item_type_name: "Hat"

    '641':
        name: "The Ornament Armament"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "Just a like the Soldier's actual grenades, these shiny glass baubles are purely ornamental. "
        item_name: "Ornament Armament"
        item_type_name: "Decorative Bombs"

    '643':
        name: "The Sandvich Safe"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "Keep sandvich safe with sandvich safe. Okay, is good, no more description. Buy."
        item_name: "Sandvich Safe"
        item_type_name: "Lunchbox"

    '644':
        name: "The Head Warmer"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "This incinerator's insulator keeps your head a perfect 105 degrees, while muffling the hallucinations brought on by wearing a hat that slowly cooks your brain."
        item_name: "Head Warmer"
        item_type_name: "Hat"

    '645':
        name: "The Outback Intellectual"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "Argyle. Pipe-smoking. Individually, they make you look like an idiot. Together, they make you look smart AND stylish! Just like Umberto Eco!"
        item_name: "Outback Intellectual"
        item_type_name: "Apparel"

    '646':
        name: "The Itsy Bitsy Spyer"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "Say, Engie! Is that a miniature Spy in your pocket, or are you just happy to OH GOD STOP HITTING ME WITH THAT WRENCH!"
        item_name: "Itsy Bitsy Spyer"
        item_type_name: "Pocket Buddy"

    '647':
        name: "The All-Father"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "Throughout the history of civilization, the white beard has come to symbolize wisdom and status. Show the world it's possible to be bearded AND stupid with this Heavy- and Soldier-specific face-nest. Shove it, civilization!"
        item_name: "All-Father"
        item_type_name: "Facial Hair"

    '648':
        name: "The Wrap Assassin"
        _q: [C]
        _t: ALWAYS
        craft_class: "weapon"
        item_class: "tf_weapon_bat_giftwrap"
        item_description: "These lovely festive ornaments are so beautifully crafted, your enemies are going to want to see them close up. Indulge them by batting those fragile glass bulbs into their eyes at 90 mph."
        item_name: "Wrap Assassin"
        item_type_name: "Bat"

    '649':
        name: "The Spy-cicle"
        _q: [C]
        _t: ALWAYS
        craft_class: "weapon"
        item_class: "tf_weapon_knife"
        item_description: "It's the perfect gift for the man who has everything: an icicle driven into their back. Even rich people can't buy that in stores."
        item_name: "Spy-cicle"
        item_type_name: "Knife"

    '650':
        name: "The Kringle Collection"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "Do the snow-pants dance with this stylish holiday ensemble from famed Arctic designer Kristoff Kringle."
        item_name: "Kringle Collection"
        item_type_name: "Coat"

    '651':
        name: "The Jingle Belt"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "Slay-bells will be ringing in the slow-roasted ears of your burn victims."
        item_name: "Jingle Belt"
        item_type_name: "Bells"

    '652':
        name: "The Big Elfin Deal"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "You ask me if I wanna be a dentist one more time, pal, I'm gonna kick your teeth in."
        item_name: "Big Elfin Deal"
        item_type_name: "Hat"

    '653':
        name: "The Bootie Time"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "You dasher! You dancer! You prancer! You VIXEN! Pull Santa's sleigh all by yourself, you sexy little man."
        item_name: "Bootie Time"
        item_type_name: "Apparel"

    '654':
        name: "Festive Minigun 2011"
        _q: [C]
        _t: ALWAYS
        craft_class: ""
        item_class: "tf_weapon_minigun"
        item_description: "undefined"
        item_name: "Festive Minigun"
        item_type_name: "Minigun"

    '655':
        name: "Spirit Of Giving"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "tf_wearable"
        item_description: "The more gifts you give away, the bigger your heart will get! Get what gift-givers call 'the Smissmass spirit,' and what cardiologists call hypertrophic cardiomyopathy."
        item_name: "Spirit Of Giving"
        item_type_name: "Badge"

    '656':
        name: "The Holiday Punch"
        _q: [C]
        _t: ALWAYS
        craft_class: "weapon"
        item_class: "tf_weapon_fists"
        item_description: "Be the life of the war party with these laugh-inducing punch-mittens."
        item_name: "Holiday Punch"
        item_type_name: "Fists"

    '658':
        name: "Festive Rocket Launcher 2011"
        _q: [C]
        _t: ALWAYS
        craft_class: ""
        item_class: "tf_weapon_rocketlauncher"
        item_description: "undefined"
        item_name: "Festive Rocket Launcher"
        item_type_name: "Rocket Launcher"

    '659':
        name: "Festive Flamethrower 2011"
        _q: [C]
        _t: ALWAYS
        craft_class: ""
        item_class: "tf_weapon_flamethrower"
        item_description: "undefined"
        item_name: "Festive Flame Thrower"
        item_type_name: "Flame Thrower"

    '660':
        name: "Festive Bat 2011"
        _q: [C]
        _t: ALWAYS
        craft_class: ""
        item_class: "tf_weapon_bat"
        item_description: "undefined"
        item_name: "Festive Bat"
        item_type_name: "Bat"

    '661':
        name: "Festive Stickybomb Launcher 2011"
        _q: [C]
        _t: ALWAYS
        craft_class: ""
        item_class: "tf_weapon_pipebomblauncher"
        item_description: "undefined"
        item_name: "Festive Stickybomb Launcher"
        item_type_name: "Stickybomb Launcher"

    '662':
        name: "Festive Wrench 2011"
        _q: [C]
        _t: ALWAYS
        craft_class: ""
        item_class: "tf_weapon_wrench"
        item_description: "undefined"
        item_name: "Festive Wrench"
        item_type_name: "Wrench"

    '663':
        name: "Festive Medigun 2011"
        _q: [C]
        _t: ALWAYS
        craft_class: ""
        item_class: "tf_weapon_medigun"
        item_description: "undefined"
        item_name: "Festive Medi Gun"
        item_type_name: "Medi Gun"

    '664':
        name: "Festive Sniper Rifle 2011"
        _q: [C]
        _t: ALWAYS
        craft_class: ""
        item_class: "tf_weapon_sniperrifle"
        item_description: "undefined"
        item_name: "Festive Sniper Rifle"
        item_type_name: "Sniper Rifle"

    '665':
        name: "Festive Knife 2011"
        _q: [C]
        _t: ALWAYS
        craft_class: ""
        item_class: "tf_weapon_knife"
        item_description: "undefined"
        item_name: "Festive Knife"
        item_type_name: "Knife"

    '666':
        name: "The B.M.O.C."
        _q: [C]
        _t: ALWAYS
        craft_class: ""
        item_class: "tf_wearable"
        item_description: "Be the Big Man of Christmas with this fur-fringed pom-pom hat!"
        item_name: "B.M.O.C."
        item_type_name: "Hat"

    '667':
        name: "The Holiday Headcase"
        _q: [C]
        _t: ALWAYS
        craft_class: ""
        item_class: "tf_wearable"
        item_description: "Merry Smissmas, everyone! May all your miscellaneous holidays be happy (or somber, depending on your cultural traditions) with this ultra-rare TF item, donated by Steam User BANG!"
        item_name: "Holiday Headcase"
        item_type_name: "Hat"

    '668':
        name: "The Full Head of Steam"
        _q: [C]
        _t: ALWAYS
        craft_class: ""
        item_class: "tf_wearable"
        item_description: "You never took a break from cp_foundry, and now you can prove it with the actual steam whistle used to call the breaks you never took!"
        item_name: "Full Head Of Steam"
        item_type_name: "Hat"

    '669':
        name: "Festive Scattergun 2011"
        _q: [C]
        _t: ALWAYS
        craft_class: ""
        item_class: "tf_weapon_scattergun"
        item_description: "undefined"
        item_name: "Festive Scattergun"
        item_type_name: "Scattergun"

    '670':
        name: "The Stocking Stuffer"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "No need to hang this stocking over the mantle. It's already stuffed. Thanks for nothing, Santa."
        item_name: "Stocking Stuffer"
        item_type_name: "Stocking"

    '671':
        name: "The Brown Bomber"
        _q: [C]
        _t: ALWAYS
        craft_class: "hat"
        item_class: "tf_wearable"
        item_description: "Celebrate Canada's birthday, on whatever day that happens, with this commemorative Canadian Prime Minister's ceremonial dress hat."
        item_name: "Brown Bomber"
        item_type_name: "Hat"

    '673':
        name: "Noise Maker - Winter 2011"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "tf_wearable"
        item_description: "undefined"
        item_name: "Noise Maker - Winter Holiday"
        item_type_name: "Party Favor"

    '675':
        name: "The Ebenezer"
        _q: [C]
        _t: ALWAYS
        craft_class: ""
        item_class: "tf_wearable"
        item_description: "If you are visited by one piece of spectral headwear this night, make it the Ghost of Christmas Hats, donated in true Smissmass spirit by Steam User Jacen."
        item_name: "Ebenezer"
        item_type_name: "Hat"

    '680':
        name: "UGC Tournament Fall 2011 - Platinum 1st Place"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "tf_wearable"
        item_description: "Fall 2011"
        item_name: "UGC Highlander Platinum 1st Place"
        item_type_name: "Tournament Medal"

    '681':
        name: "UGC Tournament Fall 2011 - Platinum 2nd Place"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "tf_wearable"
        item_description: "Fall 2011"
        item_name: "UGC Highlander Platinum 2nd Place"
        item_type_name: "Tournament Medal"

    '682':
        name: "UGC Tournament Fall 2011 - Platinum 3rd Place"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "tf_wearable"
        item_description: "Fall 2011"
        item_name: "UGC Highlander Platinum 3rd Place"
        item_type_name: "Tournament Medal"

    '683':
        name: "UGC Tournament Fall 2011 - Platinum Participant"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "tf_wearable"
        item_description: "Fall 2011"
        item_name: "UGC Highlander Platinum Participant"
        item_type_name: "Tournament Medal"

    '684':
        name: "UGC Tournament Autumn 2011 - Euro Platinum"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "tf_wearable"
        item_description: "Autumn 2011"
        item_name: "UGC Highlander Euro Platinum"
        item_type_name: "Tournament Medal"

    '685':
        name: "UGC Tournament Fall 2011 - Silver 1st Place"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "tf_wearable"
        item_description: "Fall 2011"
        item_name: "UGC Highlander Silver 1st Place"
        item_type_name: "Tournament Medal"

    '686':
        name: "UGC Tournament Fall 2011 - Silver 2nd Place"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "tf_wearable"
        item_description: "Fall 2011"
        item_name: "UGC Highlander Silver 2nd Place"
        item_type_name: "Tournament Medal"

    '687':
        name: "UGC Tournament Fall 2011 - Silver 3rd Place"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "tf_wearable"
        item_description: "Fall 2011"
        item_name: "UGC Highlander Silver 3rd Place"
        item_type_name: "Tournament Medal"

    '688':
        name: "UGC Tournament Fall 2011 - Silver Participant"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "tf_wearable"
        item_description: "Fall 2011"
        item_name: "UGC Highlander Silver Participant"
        item_type_name: "Tournament Medal"

    '689':
        name: "UGC Tournament Autumn 2011 - Euro Silver"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "tf_wearable"
        item_description: "Autumn 2011"
        item_name: "UGC Highlander Euro Silver"
        item_type_name: "Tournament Medal"

    '690':
        name: "UGC Tournament Fall 2011 - Iron 1st Place"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "tf_wearable"
        item_description: "Fall 2011"
        item_name: "UGC Highlander Iron 1st Place"
        item_type_name: "Tournament Medal"

    '691':
        name: "UGC Tournament Fall 2011 - Iron 2nd Place"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "tf_wearable"
        item_description: "Fall 2011"
        item_name: "UGC Highlander Iron 2nd Place"
        item_type_name: "Tournament Medal"

    '692':
        name: "UGC Tournament Fall 2011 - Iron 3rd Place"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "tf_wearable"
        item_description: "Fall 2011"
        item_name: "UGC Highlander Iron 3rd Place"
        item_type_name: "Tournament Medal"

    '693':
        name: "UGC Tournament Autumn 2011 - Euro Iron"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "tf_wearable"
        item_description: "Autumn 2011"
        item_name: "UGC Highlander Euro Iron"
        item_type_name: "Tournament Medal"

    '694':
        name: "UGC Tournament Fall 2011 - Tin 1st Place"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "tf_wearable"
        item_description: "Fall 2011"
        item_name: "UGC Highlander Tin 1st Place"
        item_type_name: "Tournament Medal"

    '695':
        name: "UGC Tournament Fall 2011 - Tin 2nd Place"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "tf_wearable"
        item_description: "Fall 2011"
        item_name: "UGC Highlander Tin 2nd Place"
        item_type_name: "Tournament Medal"

    '696':
        name: "UGC Tournament Fall 2011 - Tin 3rd Place"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "tf_wearable"
        item_description: "Fall 2011"
        item_name: "UGC Highlander Tin 3rd Place"
        item_type_name: "Tournament Medal"

    '697':
        name: "UGC Tournament Fall 2011 - Participant"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "tf_wearable"
        item_description: "Fall 2011"
        item_name: "UGC Highlander Participant"
        item_type_name: "Tournament Medal"

    '698':
        name: "UGC Tournament Autumn 2011 - Euro Participant"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "tf_wearable"
        item_description: "Autumn 2011"
        item_name: "UGC Highlander Euro Participant"
        item_type_name: "Tournament Medal"

    '699':
        name: "Something Special For Someone Special"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "craft_item"
        item_description: ""
        item_name: "Something Special For Someone Special"
        item_type_name: "Ring"

    '1917':
        name: "Map Token Gullywash"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "map_token"
        item_description: "A Control Point Map Made by Jan 'Arnold' Laroy Purchasing this item directly supports the creator of the Gullywash community map.  Show your support today!"
        item_name: "Map Stamp - Gullywash"
        item_type_name: "Map Stamp"

    '2042':
        name: "DOTA2 Gamescom Winners Finals PROMO Bundle"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "bundle"
        item_description: ""
        item_name: "TF_Bundle_DOTA2GamescomWinnersFinals"
        item_type_name: "Item Bundle"

    '2043':
        name: "DOTA2 Gamescom Losers Finals PROMO Bundle"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "bundle"
        item_description: ""
        item_name: "TF_Bundle_DOTA2GamescomLosersFinals"
        item_type_name: "Item Bundle"

    '2044':
        name: "DOTA2 Gamescom Championship PROMO Bundle"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "bundle"
        item_description: ""
        item_name: "TF_Bundle_DOTA2GamescomChampionship"
        item_type_name: "Item Bundle"

    '2045':
        name: "Deus Ex Self-Made Bundle"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "bundle"
        item_description: ""
        item_name: "TF_Bundle_DeusExSelfMade"
        item_type_name: "Item Bundle"

    '2046':
        name: "Shogun Complete Genuine Bundle"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "bundle"
        item_description: "Get all eight items. This haiku is not lying. Get. All. Eight. Items:"
        item_name: "The Emperor's Assortment"
        item_type_name: "Item Bundle"

    '2047':
        name: "Killer Exclusive PCGamer Bundle"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "bundle"
        item_description: ""
        item_name: "TF_Bundle_KillerExclusive"
        item_type_name: "Item Bundle"

    '2048':
        name: "Deus Ex Contest Bundle"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "bundle"
        item_description: ""
        item_name: "TF_Bundle_DeusExContest"
        item_type_name: "Item Bundle"

    '2049':
        name: "Map Token Bundle 3"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "bundle"
        item_description: "Includes one a stamp for each community made map."
        item_name: "Map Stamps Collection"
        item_type_name: "Item Bundle"

    '2050':
        name: "Football Manager 2012 Promo Bundle"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "bundle"
        item_description: "Pick a side and show your pride:"
        item_name: "Footballer's Kit"
        item_type_name: "Item Bundle"

    '2051':
        name: "Demo Halloween 2011 Bundle"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "bundle"
        item_description: "Celebrate Halloween using these items:"
        item_name: "The Highland Hound Bundle"
        item_type_name: "Item Bundle"

    '2052':
        name: "Scout Halloween 2011 Bundle"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "bundle"
        item_description: "Celebrate Halloween using these items:"
        item_name: "The Curse-a-Nature Bundle"
        item_type_name: "Item Bundle"

    '2053':
        name: "Pyro Halloween 2011 Bundle"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "bundle"
        item_description: "Celebrate Halloween using these items:"
        item_name: "The Infernal Imp Bundle"
        item_type_name: "Item Bundle"

    '2054':
        name: "Medic Halloween 2011 Bundle"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "bundle"
        item_description: "Celebrate Halloween using these items:"
        item_name: "The Mad Doktor Bundle"
        item_type_name: "Item Bundle"

    '2055':
        name: "Soldier Halloween 2011 Bundle"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "bundle"
        item_description: "Celebrate Halloween using these items:"
        item_name: "The Tin Soldier Bundle"
        item_type_name: "Item Bundle"

    '2056':
        name: "Spy Halloween 2011 Bundle"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "bundle"
        item_description: "Celebrate Halloween using these items:"
        item_name: "The Invisible Rogue Bundle"
        item_type_name: "Item Bundle"

    '2057':
        name: "Heavy Halloween 2011 Bundle"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "bundle"
        item_description: "Celebrate Halloween using these items:"
        item_name: "The FrankenHeavy Bundle"
        item_type_name: "Item Bundle"

    '2058':
        name: "Sniper Halloween 2011 Bundle"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "bundle"
        item_description: "Celebrate Halloween using these items:"
        item_name: "The Camper Van Helsing Bundle"
        item_type_name: "Item Bundle"

    '2059':
        name: "Engineer Halloween 2011 Bundle"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "bundle"
        item_description: "Celebrate Halloween using these items:"
        item_name: "The Brundle Bundle Bundle"
        item_type_name: "Item Bundle"

    '2060':
        name: "Halloween 2011 Bundle"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "bundle"
        item_description: "Celebrate Halloween using these items:"
        item_name: "Halloween 2011 Costume Bundle of Bundles"
        item_type_name: "Item Bundle"

    '2061':
        name: "Mysterious Promo"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "bundle"
        item_description: "Mysterious Promo"
        item_name: "Mysterious Promo"
        item_type_name: "Item Bundle"

    '2062':
        name: "Dr. Grordbort's Brainiac Pack"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "bundle"
        item_description: "Grab the whole pack of Dr. Grordbort items for the Engineer, designed by WETA Workshop!"
        item_name: "Dr. Grordbort's Brainiac Pack"
        item_type_name: "Item Bundle"

    '2063':
        name: "Dr. Grordbort's Moonman Pack"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "bundle"
        item_description: "Grab the whole pack of Dr. Grordbort items for the Pyro, designed by WETA Workshop!"
        item_name: "Dr. Grordbort's Moonman Pack"
        item_type_name: "Item Bundle"

    '2064':
        name: "Dr. Grordbort's Moonbrain Double Pack"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "bundle"
        item_description: "Grab the whole pack of Dr. Grordbort items for the Pyro and the Engineer, designed by WETA Workshop!"
        item_name: "Dr. Grordbort's Moonbrain Double Pack"
        item_type_name: "Item Bundle"

    '2065':
        name: "Santa's Little Accomplice Bundle"
        _q: [C]
        _t: ALWAYS
        craft_class: "undefined"
        item_class: "bundle"
        item_description: "As seen in the timeless holiday classic, A Smissmas Story:"
        item_name: "Santa's Little Accomplice Bundle"
        item_type_name: "Item Bundle"

    '5026':
        name: "Customize Texture Tool"
        _q: [C]
        _t: ALWAYS
        craft_class: "tool"
        item_class: "tool"
        item_description: "Add a custom decal to eligible items."
        item_name: "Decal Tool"
        item_type_name: "Tool"

    '5068':
        name: "Supply Crate Rare"
        _q: [C]
        _t: ALWAYS
        craft_class: "supply_crate"
        item_class: "supply_crate"
        item_description: "You need a Mann Co. Supply Crate Key to open this. You can pick one up at the Mann Co. Store."
        item_name: "Salvaged Mann Co. Supply Crate"
        item_type_name: "TF_LockedCrate"

    '5070':
        name: "Naughty Winter Crate 2011"
        _q: [C]
        _t: ALWAYS
        craft_class: "supply_crate"
        item_class: "supply_crate"
        item_description: "This crate is unusually festive. Its contents are unknown and  normal keys don't fit the lock.  Some, but not all, of the items in this crate are Strange..."
        item_name: "Naughty Winter Crate"
        item_type_name: "TF_LockedCrate"

    '5071':
        name: "Nice Winter Crate 2011"
        _q: [C]
        _t: ALWAYS
        craft_class: "supply_crate"
        item_class: "supply_crate"
        item_description: "This crate is unusually festive. Its contents are unknown and  normal keys don't fit the lock."
        item_name: "Nice Winter Crate"
        item_type_name: "TF_LockedCrate"

    '5072':
        name: "Naughty Winter Key 2011"
        _q: [C]
        _t: ALWAYS
        craft_class: "tool"
        item_class: "tool"
        item_description: "Used to open locked supply crates."
        item_name: "Mann Co. Supply Crate Key"
        item_type_name: "Tool"

    '5073':
        name: "Nice Winter Key 2011"
        _q: [C]
        _t: ALWAYS
        craft_class: "tool"
        item_class: "tool"
        item_description: "Used to open locked supply crates."
        item_name: "Mann Co. Supply Crate Key"
        item_type_name: "Tool"
