# HELIOS Game Design Document

HELIOS models a solar society whose currently-empty Imperial throne is fought over between various factions on Earth, Mars, and beyond. You are master of one of these factions, and will run smear campaigns, raise illegal militias, co-opt the Imperial military, and engage in legislative horse-trading with your opponents in order to be elected the new Emperor.

## Game Mechanics

### Factions

Factions is the game mechanic that slots the player and AI players into the political landscape, and is essentially the 'player color/flag'. Victory, espionage, combat, and political party concepts are done at the Factional level.

All of solar society is composed of citizens of different Factions, and this impacts everything in the game: each map tile has its population split up amongst factions, military units are made up of soldiers belonging to different factions, electoral representatives each belong to a faction, and so on. Each faction is sympathetic to a player (either Human or AI). For every unit, city, and representative in the game, the player with a plurality of political support 'controls' that asset.

### Ideas

Ideas is the game mechanic that portions out map control to the players according to their Faction's innate characteristics. 


There are many ideas that live in the solar society: from Martian Secessionism to Hedonism. Each Faction capitalizes on these ideas to form a support base: the Cumorah faction, for example, enjoys broad support in areas where the ideas of Postcolonialism, Mormonism, or Communalism are popular. This gives them power in places like Mars, Latin America, and Io. The Amerus faction, by contrast, enjoys broad support in areas where the ideas of Centralization, Christianity, and Hedonism are popular, such as Eurasia, Luna, and Titan.

Ideas start out baked into the scenario map: each tile has a disposition to each Idea in the game, although most tiles only care about a smaller subset of Ideas in practice.

The ideas of a player's Faction flavor the entire playthrough of the game, since it will determine where the player can most easily muster factional support, dictate the impact of certain media campaigns, and who one can ally with easily.


### Media <--Expansion?

The Media is a game mechanic available for Factions to shift the distribution and strength of Ideas on the map. This has the indirect result of weakening/bolstering certain factions in large and sometimes tricky ways without having to engage in military conflict.


Every turn, a news arc occurs: this is what the media of the empire talks about for the turn. The news arc is represented by a fixed amount of space on the 'front page', and this space is filled up proportionally by rectangles representing all the Ideas in circulation. In principle, the contents of this page are random, but in reality Factions spend an amount of Media Influence to add front-page space weighting to their Ideas. The top three Ideas with the most weight added to them get the most space on the front-page, which makes them particularly potent. 

Every news arc amplifies or dampens the ideas to the degree to which they dominate the news: a large negative story on Martian Secessionism will reduce the idea of Secessionism on Mars, reducing the power of support for Factions that cater to that idea.

<Note> Maybe there is a Faction that specializes in Media Influence that players can play as in order to secure governorships and ministries (and election), but has proportionally less factional assets (must rely on Media + Legislative control, since sucks at creating independent factional assets)


### The Legislature

The Legislature (and the elections & bills it enables) is the game mechanic responsible for portioning out Imperial assets to the players, and rewards players who can secure player-to-player agreements and popular support.

Every turn, a legislative session occurs: this lets Factions introduce bills, issue edicts, and elect Regents and Emperors. The legislature is a body of dozens of representatives who each represent a constituency and together represent the citizens of the solar empire. 

#### Introducing a Bill

#### Issuing an Edict

Edicts are bills that do not require ratification by the legislature, but serve to announce to everyone an executive action made by the Regent or a Governor. The primary edicts are Ministry appointments and states of emergency.

#### Casting a Vote

### The Regency

The Regency is the mechanism by which a player can win the game, by winning several elections in a row (Regency, Acclamation and then Ascension).

The Regency begins empty on the first turn of the game. 

On the second turn of the game, and every five turns thereafter, an election is held by the legislature to elect a new Regent from amongst the players. This takes the shape of an automatic bill being submitted to the legislature, with options for each faction represented in the legislature. No abstention is allowed. 

Whoever gets a plurality of votes in an election wins. If no plurality is achieved, the incumbent is re-elected. If there is no incumbent, than a random candidate wins. If the winner has already been declared the Emperor-Elect, the winner becomes the Emperor, winning the game. Otherwise, the winner becomes the Regent.

On the first turn of becoming a Regent or being re-elected, the Regent must issue an edict to the legislature announcing his appointments for each Ministry. Each Ministry must have an appointment made, and no faction may control more than one Ministry. Every faction with representation in the legislature (including the Regent) is eligible for control over a Ministry.

During any turn of a Regent's term, any player may submit a special bill to the legislature calling for an Imperial Acclamation. If the bill passes, the Regent becomes the Emperor-Elect. 

### Ministries

The Imperial Ministry game mechanic makes the Regency a vehicle for the player to get an edge on other factions, by introducing carrots & sticks to sway other factions via the legitimate and powerful might of Imperial assets. Each Ministry is assigned to any Faction the Regent wishes, although each Faction may only have one ministry at a time.

#### Imperial Army

#### Imperial Navy

#### Imperial Police

### Offices

Offices are much like Imperial Ministries, but are reassigned via Legislative Bills. This game mechanic gives minority powers a check on the Regent's power: although the offices are not as strong as the Imperial Ministries, they are more easily used for Factional uses, and can be revoked by the legislature (unlike Ministries).

#### List of Offices

- Lord of Terra (Automatically given to current Regent or Emperor-Elect)
- Governor of Mercury (Appointed by Legislature. Held by Eurasia)
- Governor of Venus (Appointed by Legislature. Held by Pacifica)
- Governor of Luna (Appointed by Legislature. Held by AMERUS)
- Governor of Mars (Appointed by Legislature. Held by Cumorah)
- Governor of Io (Appointed by Legislature. Held by Cumorah)
- Governor of Ganymede (Appointed by Legislature. Held by Pacifica)
- Governor of Callisto (Appointed by Legislature. Held by Eurasia)
- Governor of Europa (Appointed by Legislature. Held by Eurasia)
- Governor of Titan (Appointed by Legislature. Held by AMERUS)

### Faction Assets

Not all things belong to the Imperial Throne: there are several kinds of units and infrastructure that can belong directly to a player. This kind of asset is a game mechanic that lets the player maintain a stable resource pool to work with across elections and ideological fads. These assets are typically illegal or unpopular, however.

#### Faction Units

Faction units are typically illegal units that blend into the civilian population or kept in secret labs.

#### Faction Facilities

Faction facilities range from secret storage compounds to media outlets to private banks, and are used to hide and bolster a faction's wealth and resources.

### Irregular Combat

Factions can carry out tile-specific combat by maintaining different levels of radical activity. This mechanic lets players employ their assets in only a semi-visible way, but at the cost of immovable combat units. This covers units as broad as terrorists and fringe militia to rioters and hackers.

### Regular Combat

Regular combat is employed in public with no regard for Imperial authority. This allows Factions to openly oppose each other by military action, although with dire public consequences: such combat is deeply unpopular and makes the Game Loss Conditions more popular with the solar society.

### The Republic

This mechanic introduces a Game Loss Condition if all players defect too radically from the game goal of electing an Emperor. The longer there is no Emperor, and the more blatantly the Factions raise arms against each other, the more appealing a Republic seems. When Republicanism becomes popular enough, the populace aggressively propose a Plebiscite for Dissolution of the Empire. Should this pass, the Empire crumbles into hundreds of small independent statelets, and the game ends.

## User Experience

### Changing Options

### Starting a Game

### Taking a Turn

### Interacting with the Map

### Looking up Information

### Communicating with other players

### Interacting with the Legislature

### Introducing Legislative Bills

### Voting on Bills & Elections

### Accept/Reject/Craft-ing Interfactional/Secret Diplomatic Agreements

### Planning Attacks

### Initiating Media Campaigns

### Raising Faction Militia and Facilities

### Bolster/Weaken/Transfer/Steal-ing Imperial Military Assets

### Suppress/Sow-ing Factional Dissent

### Managing Budget & Resources

## Game Architecture

### Data structures