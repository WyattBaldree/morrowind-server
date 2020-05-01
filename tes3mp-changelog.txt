0.7.0
-----

* Synchronization of custom records for spells, potions, enchantments, creatures, NPCs, armor, books, clothing, miscellaneous items and weapons
* Synchronization of weather
* Synchronization of world map exploration
* Synchronization of spells cast through items
* Synchronization of player reputations
* Reworked attack synchronization now accounts for "cast on strike" enchantments, knockdowns and projectile speeds
* Reworked container synchronization that relies on server approval of every container change
* Reworked object synchronization that relies on server approval of every action on objects and tracks whether actions originated from regular gameplay, the console or from ingame scripts
* Reworked time synchronization that preserves ingame date and does not allow for any unilateral clientside time changes
* Reworked summoning synchronization that prevents duplicate summons and retains summon durations
* Reworked inventory, equipment, attribute, skill and dynamic stat packets that are sent more often while containing minimal instead of maximal data
* Packet for activation of objects
* Packet for using items in inventory
* Packet for actor AI
* Packet for actor deaths, used to track their killers
* Packet for overriding collision on objects
* Packet for setting momentum of players
* Packet for saving and loading marked locations and selected spells
* Player scales and disguises as creatures are now included in shapeshift packets
* Soulgem souls are now included in item and object placement packets
* Physics framerate caps and enforced log levels are now included in game settings packets
* Journal entry timestamps are now included in journal packets
* The value of the OnPCDrop variable for player-placed objects is now preserved by being included in object placement packets
* Video play packets no longer have hardcoded synchronization
* Death packets now include clear information about the killers, and deaths through spells are no longer treated as suicides
* Inventory packets no longer include bound items, preventing them from becoming persistent upon quitting
* Fix broken check in equipment synchronization that was preventing throwing weapon synchronization from working
* Fix rare inability to start up game caused by use of potentially invalid pointer for storing cell unloads
* Death as a werewolf now removes status as known werewolf, to prevent infinite aggression from NPCs
* Death as a criminal now prevents witnesses to previous crimes from continuing combat
* Players are now kicked from the server when failing to reply to its handshake
* Players can no longer open up their rest menu before logging in
* NPC followers now follow players correctly from interiors to exteriors and vice versa, and are able to follow non-authority players
* NPCs can now start combat through dialogue with non-authority players
* The console window now displays the unique index of a selected object

0.6.2
-----

* Packet for quick keys
* Packet for player sounds
* Packet for player animations
* Packet for console commands
* Enchantment charge values are now included in item and object placement packets
* Settings packet can now be used to separately enable or disable resting in beds, resting in the wilderness and waiting
* Changes in attribute and skill modifiers now send their respective packets
* Attribute and skill packets using 0 as a modifier can now remove all attribute or skill fortification effects from a player
* Completion of vendor trades and skill training now sends inventory packets
* Item drag and dropping is now finished when arrested or when moved to another cell by the server
* Window minimization no longer pauses the game
* Actor speech captions are now searched for in dialogues instead of being sent in packets

0.6.1
-----

* Record player positions before their last cell change
* Remove inertia from players who are teleported via a packet
* Fix data loss caused by server packets attempting to add invalid items, spells and quests
* Fix client crashes caused by items with state disabling scripts, as well as their side effects of making players disappear to others
* Fix server crashes caused by improper interior initialization when exterior 0, 0 is loaded
* Fix server freezes caused by infinite topic packet spam from local scripts
* Fix spell casting probability synchronization
* Prevent players from using excessively long names

0.6.0
-----

* Synchronization of NPC & creature positions, stats, equipment, speech, attacks, spells & animations
* Reworked server browser with major stability fixes and additional information about servers
* Synchronization of client & server plugins (non-automated)
* Synchronization of leveled & summoned creature spawns
* Synchronization of rotation animations
* Synchronization of journal entries
* Synchronization of faction ranks, reputation and expulsion states
* Synchronization of dialogue topics
* Synchronization of kill counts checked in quest progression
* Synchronization of trap states
* Synchronization of object states (i.e. whether they are enabled or disabled)
* Synchronization of player werewolf states
* Synchronization of time of day
* Packet for saving and loading of read skill books
* Fix to messagebox buttons for client scripts
* Fix to synchronization of object locking/unlocking
* Packet for jailing players
* Packet for setting the difficulty for each player
* Bandwidth optimization for all packet types
* Various fixes to client & server crashes

0.5.2
-----

* Fix to server crash caused by not deleting empty cells upon players disconnecting
* Fix to client freezes caused by invalid spells and races
* Fix to players not being spawned when using other base master files
* Fix to visual glitch where flying players bounced up and down continuously

0.5.1
-----

* Fix to server crash caused by incorrect cell comparison added by bandwidth optimization changes
* Fix to server browser freeze caused by connection failures and incomplete data received from master server

0.5.0
-----

* Server browser
* Synchronization of containers
* Reworked world packets allowing for the saving and loading of world state, including container state
* Bandwidth optimization by forwarding the most frequent player packets only to other players in the same loaded cells

0.4.1
-----

* Packet for saving and loading spellbooks

0.4.0
-----

* Synchronization of spells
* Packet for saving and loading inventories
* Being in a menu no longer prevents you from sending packets about your client
* Fixes to freezes and problems caused by players moving around in cells from expansions/plugins that are not loaded by others

0.3.0
-----

* Synchronization of world object removal, placement, scaling, locking and unlocking
* Synchronization of local, global and member script variables for specific scripts
* Synchronization for the setdelete, placeat, setscale, lock and unlock console commands
* Player markers on minimap
* Death reasons in chat
* Fix to client freeze related to players logging in at the same time
* Fix to server crash related to sending information about invalid players

0.2.0
-----

* Packets for saving and loading classes, birthsigns, dynamic stats, levels, level progress, attribute bonuses from skill increases and progress towards skill increases
* Version checking to prevent mismatches between clients and servers

0.0.1b
------

* Synchronization of attributes and skills
* Fix to memory leaks related to player initialization on Windows servers
* Fix to various graphical glitches
* Main menu buttons for starting, saving and loading games are now disabled

0.0.1a
------

* Combat animation
* Synchronization of melee and ranged (bow, crossbow, throwable weapons) combat
* Synchronization of health, magicka, fatigue and death
* Synchronization of cell changes
* Server-side Lua scripting
* Chat

0.0.1
-----

* Initial networking and packet architecture
* Synchronization of player character generation
* Synchronization of player position
* Synchronization of player attack states (unarmed, armed with a weapon, using a spell)
* Synchronization of movement and jump animations
