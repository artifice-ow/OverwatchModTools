# Global Variables

#!define modes M
#!define savedBots S
#!define noClip N
#!define heroes H

# Player Variables

#!define mode A
#!define behavior B
#!define menu C
#!define fly D
#!define cursor E
#!define flyPosition P
#!define heroMenu F
#!define currHero G
#!define currTeam T

# RULE: SETUP: Set global variables
# TYPE: declaration
# PURPOSE: Set global variables
@Rule "SETUP: Set global variables"
@Event global
# Setup Hero array
heroes = []
# Tanks
heroes.append(Hero.DVA)
heroes.append(Hero.HAMMOND)
heroes.append(Hero.ORISA)
heroes.append(Hero.REINHARDT)
heroes.append(Hero.ROADHOG)
heroes.append(Hero.SIGMA)
heroes.append(Hero.WINSTON)
heroes.append(Hero.ZARYA)
# Damage
heroes.append(Hero.ASHE)
heroes.append(Hero.BASTION)
heroes.append(Hero.DOOMFIST)
heroes.append(Hero.GENJI)
heroes.append(Hero.HANZO)
heroes.append(Hero.JUNKRAT)
heroes.append(Hero.MCCREE)
heroes.append(Hero.MEI)
heroes.append(Hero.PHARAH)
heroes.append(Hero.REAPER)
heroes.append(Hero.SOLDIER)
heroes.append(Hero.SOMBRA)
heroes.append(Hero.SYMMETRA)
heroes.append(Hero.TORBJORN)
heroes.append(Hero.TRACER)
heroes.append(Hero.WIDOWMAKER)
# Support
heroes.append(Hero.ANA)
heroes.append(Hero.BAPTISTE)
heroes.append(Hero.BRIGITTE)
heroes.append(Hero.LUCIO)
heroes.append(Hero.MERCY)
heroes.append(Hero.MOIRA)
heroes.append(Hero.ZENYATTA)

# Setup Modes Array
modes = []
# Normal Play
modes.append(vect(0,1,0))
# Team Builder
modes.append(vect(1,0,0))
# Behavior modifier
modes.append(vect(1,0,0))

# RULE: SETUP: Set player properties
# TYPE: declaration
# PURPOSE: Setup player properties so each player is more like an object
@Rule "SETUP: Set player properties"
@Event eachPlayer
# Set player properties
eventPlayer.mode = 0
hudHeader(eventPlayer, "Play", Position.TOP, 0, Color.PURPLE, HudReeval.VISIBILITY_AND_STRING)
eventPlayer.menu = getLastCreatedText()
eventPlayer.currTeam = Team.1

# RULE: SETUP: Set bot properties
# TYPE: declaration
# PURPOSE: Setup bot properties so each bot is more like an object
@Rule "SETUP: Set bot properties"
@Event eachPlayer
# CONDITION: 
if eventPlayer.isDummy():
    # Set bot properties
    eventPlayer.behavior = 0

@Rule "SETUP: NoClip Properties"
@Event eachPlayer
# NoClip Properties
# x = Default NoClip Access, y = Name-tag Visibility, z = null
N[0] = vect(1, 1, 0)
# x = Default move speed (m/s), y = Default boost speed (m/s), z = NoClip camera smoothing
N[1] = vect(20, 20, 60)
# Set player NoClip permissions to default permissions
eventPlayer.N[0] = N[0].x == 1

# RULE: SETUP: Skip assembly
# TYPE: setup
# PURPOSE: Skips assembly
@Rule "SETUP: Skip assembly"
@Event global
# CONDITION: Is in assembly
if isAssemblingHeroes():
    setMatchTime(0)

# RULE: SETUP: Skip setup
# TYPE: setup
# PURPOSE: Skips setupo
@Rule "SETUP: Skip setup"
@Event global
# CONDITION: Is in setup
if isInSetup():
    setMatchTime(0)


@Rule "FUNCTION: NoClip Activator"
@Event eachPlayer
# CONDITION: Event Player has NoClip access and presses Ultimate key
if eventPlayer.N[0] and eventPlayer.fly == true:
    # Activate NoClip
    eventPlayer.N[2] = true
    eventPlayer.fly = false


@Rule "FUNCTION: NoClip Toggle"
@Event eachPlayer
# CONDITION: Event Player activation is set to true or if permissions changed while using NoClip
if (eventPlayer.N[2] or not eventPlayer.N[0] and eventPlayer.N[1]):
    eventPlayer.N[1] = not eventPlayer.N[1]
    # If Event Player is using NoClip goto relevant actions to turn it off
    if not eventPlayer.N[1]:
        goto lbl_0
    # Turn on NoClip
    # Camera Setup
    eventPlayer.P = eventPlayer.getEyePosition()
    eventPlayer.setCamera(eventPlayer.P, eventPlayer.P + eventPlayer.getFacingDirection(), N[1].z)
    eventPlayer.N[3] = eventPlayer.getFacingDirection()
    eventPlayer.teleport(vect(getAllPlayers().index(eventPlayer) * 25, 500, 0))
    eventPlayer.setFacing(eventPlayer.N[3], Relativity.TO_WORLD)
    eventPlayer.startAcceleration(vect(getAllPlayers().index(eventPlayer) * 25, 500, 0) - eventPlayer.getPosition(), 10000, 12.8, Relativity.TO_WORLD, AccelReeval.DIRECTION_RATE_AND_MAX_SPEED)
    # Disable abilities
    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.ULTIMATE)
    eventPlayer.disallowButton(Button.INTERACT)
    eventPlayer.disallowButton(Button.JUMP)
    eventPlayer.disallowButton(Button.CROUCH)
    # Set invincibility
    eventPlayer.N[5] = eventPlayer.hasStatusEffect(Status.INVINCIBLE)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 9999)
    # Chase camera position so pVar.P always equals position of NoClip player
    chase(eventPlayer.P, eventPlayer.P + eventPlayer.getFacingDirection() * 1000 * eventPlayer.getThrottle().z + (worldVector(Vector.LEFT, eventPlayer, Transform.ROTATION) * eventPlayer.getThrottle().x + vect(0, eventPlayer.isHoldingButton(Button.JUMP) * 1 + eventPlayer.isHoldingButton(Button.CROUCH) * -1, 0)) * 1000, rate=(N[1].x * (not eventPlayer.isHoldingButton(Button.ABILITY_1))) + N[1].y * eventPlayer.isHoldingButton(Button.ABILITY_1), ChaseReeval.DESTINATION_AND_RATE)
    # Turn off NoClip
    lbl_0:
    # If player isn't using No Clip, skip this process
    if eventPlayer.N[1]:
        goto lbl_1
    # Set camera movement to 0
    eventPlayer.stopAcceleration()
    eventPlayer.applyImpulse(eventPlayer.getVelocity() * -1 * 0.001 * 0.001 * 0.001 * 0.001 * 0.001 * 0.001, 1, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait(0.032)
    eventPlayer.applyImpulse(eventPlayer.getVelocity() * -1 * 0.001 * 0.001 * 0.001 * 0.001 * 0.001 * 0.001, 1, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    # Set player to camera location
    eventPlayer.N[3] = eventPlayer.getFacingDirection()
    eventPlayer.teleport(eventPlayer.P - eventPlayer.getEyePosition() - eventPlayer.getPosition())
    stopChasingVariable(eventPlayer.P)
    eventPlayer.setFacing(eventPlayer.N[3], Relativity.TO_WORLD)
    # Turn abilities on
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.allowButton(Button.ULTIMATE)
    eventPlayer.allowButton(Button.INTERACT)
    eventPlayer.allowButton(Button.JUMP)
    eventPlayer.allowButton(Button.CROUCH)
    #Clear invincibility
    if eventPlayer.N[5]:
        goto lbl_2
    eventPlayer.clearStatusEffect(Status.INVINCIBLE)
    # Stop Camera
    lbl_2:
    eventPlayer.stopCamera()
    # Reset activation condition
    lbl_1:
    eventPlayer.N[2] = false


@Rule "FUNCTION: NoClip Bug Workaround"
@Event eachPlayer
if eventPlayer.N[1] and (eventPlayer.getThrottle() != vect(0, 0, 0) or eventPlayer.isHoldingButton(Button.JUMP) or eventPlayer.isHoldingButton(Button.CROUCH)):
    do:
        wait(0.1, Wait.ABORT_WHEN_FALSE)
        eventPlayer.N[6] = eventPlayer.getThrottle()
    while true

# RULE: FUNCTION: Next Mode
# TYPE: function
# PURPOSE: Go to the next mode on INTERACT
@Rule "FUNCTION: Next Mode"
@Event eachPlayer
# CONDITION: Player presses INTERACT while game is in progress
if eventPlayer.isHoldingButton(Button.INTERACT) and isGameInProgress():
    # set player mode
    if eventPlayer.mode >= (len(modes) - 1):
        goto lbl_0
    eventPlayer.mode++
    goto lbl_1
    lbl_0:
    eventPlayer.mode = 0
    lbl_1:

# RULE: FUNCTION: Previous Hero
# TYPE: function
# PURPOSE: Go to the prev hero on ULTIMATE
@Rule "FUNCTION: Previous Hero"
@Event eachPlayer
# CONDITION: Player presses ULTIMATE while game is in progress and mode is set to Pick Heroes
if eventPlayer.isHoldingButton(Button.ULTIMATE) and not eventPlayer.isHoldingButton(Button.ABILITY_1) and isGameInProgress() and eventPlayer.mode == 1:
    # go to prev hero
    if eventPlayer.currHero <= 0:
        goto lbl_0
    eventPlayer.currHero--
    goto lbl_1
    lbl_0:
    eventPlayer.currHero = (len(heroes) - 1)
    lbl_1:

# RULE: FUNCTION: Next Hero
# TYPE: function
# PURPOSE: Go to the next hero on ABILITY 2
@Rule "FUNCTION: Next Hero"
@Event eachPlayer
# CONDITION: Player presses ABILITY 2 while game is in progress and mode is set to Pick Heroes
if eventPlayer.isHoldingButton(Button.ABILITY_2) and not eventPlayer.isHoldingButton(Button.ABILITY_1) and isGameInProgress() and eventPlayer.mode == 1:
    # go to next hero
    if eventPlayer.currHero >= (len(heroes) - 1):
        goto lbl_0
    eventPlayer.currHero++
    goto lbl_1
    lbl_0:
    eventPlayer.currHero = 0
    lbl_1:

# RULE: FUNCTION: Change Team
# TYPE: function
# PURPOSE: Changes team for picked hero when user presses ABILITY 1 and ABILITY 2
@Rule "FUNCTION: Change Team"
@Event eachPlayer
# CONDITION: Player presses ABILITY 1 and 2 at the same time while game is in progress and mode is set to pick heroes
if eventPlayer.isHoldingButton(Button.ABILITY_2) and eventPlayer.isHoldingButton(Button.ABILITY_1) and isGameInProgress() and eventPlayer.mode == 1:
    if eventPlayer.currTeam == Team.1:
        goto lbl_0
    eventPlayer.currTeam = Team.1
    destroyHudText(eventPlayer.heroMenu)
    hudText(eventPlayer, heroIcon(H[eventPlayer.G]), eventPlayer.T, H[eventPlayer.G], Position.LEFT, 0, Color.BLUE, Color.BLUE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    eventPlayer.heroMenu = getLastCreatedText()
    goto lbl_1
    lbl_0:
    eventPlayer.currTeam = Team.2
    destroyHudText(eventPlayer.heroMenu)
    hudText(eventPlayer, heroIcon(H[eventPlayer.G]), eventPlayer.T, H[eventPlayer.G], Position.LEFT, 0, Color.RED, Color.RED, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    eventPlayer.heroMenu = getLastCreatedText()
    lbl_1:

# RULE: FUNCTION: Place/Move Hero
# TYPE: function
# PURPOSE: Places specified hero or moves identical hero
@Rule "FUNCTION: Place/Move Hero"
@Event eachPlayer
# CONDITION: Player presses PRIMARY FIRE while game is in progress and mode is set to pick heroes
if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) and not eventPlayer.isHoldingButton(Button.ABILITY_1) and isGameInProgress() and eventPlayer.mode == 1:
    if any([player.getCurrentHero() == heroes[eventPlayer.currHero] for player in getPlayers(eventPlayer.currTeam)]):
        goto lbl_0
    createDummy(heroes[eventPlayer.currHero], eventPlayer.currTeam, -1, raycast(eventPlayer.flyPosition, eventPlayer.flyPosition + eventPlayer.getFacingDirection() * 1000, include=getAllPlayers(), exclude=eventPlayer,includePlayerObjects=false).getHitPosition(), eventPlayer.getFacingDirection())
    goto lbl_1
    lbl_0:
    getPlayersOnHero(eventPlayer.currTeam, heroes[eventPlayer.currHero]).teleport(raycast(eventPlayer.flyPosition, eventPlayer.flyPosition + eventPlayer.getFacingDirection() * 1000, include=getAllPlayers(), exclude=eventPlayer,includePlayerObjects=false).getHitPosition())
    lbl_1: 

# RULE: FUNCTION: Select Hero
# TYPE: function
# PURPOSE: Select hero at cursor
@Rule "FUNCTION: Select Hero"
@Event eachPlayer
# CONDITION: Player presses PRIMARY FIRE and ABILITY 1while game is in progress and mode is set to pick heroes
if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) and eventPlayer.isHoldingButton(Button.ABILITY_1) and isGameInProgress() and eventPlayer.mode == 1:
    if all([hero != raycast(eventPlayer.flyPosition, eventPlayer.flyPosition + eventPlayer.getFacingDirection() * 1000, include=getAllPlayers(), exclude=eventPlayer,includePlayerObjects=false).getPlayerHit().getCurrentHero() for hero in heroes]):
        
        eventPlayer.currHero = heroes.index(raycast(eventPlayer.flyPosition, eventPlayer.flyPosition + eventPlayer.getFacingDirection() * 1000, include=getAllPlayers(), exclude=eventPlayer,includePlayerObjects=false).getPlayerHit().getCurrentHero())
        eventPlayer.currTeam = raycast(eventPlayer.flyPosition, eventPlayer.flyPosition + eventPlayer.getFacingDirection() * 1000, include=getAllPlayers(), exclude=eventPlayer,includePlayerObjects=false).getPlayerHit().getTeam()
    

# RULE: MODE: Normal Play
# TYPE: mode
# PURPOSE: initialise normal play mode
@Rule "MODE: Normal Play"
@Event eachPlayer
# CONDITION: Mode is set to 0
if eventPlayer.mode == 0 and isGameInProgress():
    #set HUD
    destroyEffect(eventPlayer.cursor)
    destroyHudText(eventPlayer.heroMenu)
    destroyHudText(eventPlayer.menu)
    hudHeader(eventPlayer, "Play", Position.TOP, 1, Color.PURPLE, HudReeval.VISIBILITY_AND_STRING)
    eventPlayer.menu = getLastCreatedText()
    if not eventPlayer.N[1]:
        goto lbl_0
    eventPlayer.fly = true
    goto lbl_1:
    lbl_0:
    lbl_1:
    

# RULE: MODE: Pick Heroes
# TYPE: mode
# PURPOSE: initialise pick heroes mode
@Rule "MODE: Pick Heroes"
@Event eachPlayer
# CONDITION: Mode is set to 1
if eventPlayer.mode == 1 and isGameInProgress():
    #set HUD
    destroyEffect(eventPlayer.cursor)
    createEffect(eventPlayer,Effect.RING,Color.PURPLE,raycast(eventPlayer.flyPosition, eventPlayer.flyPosition + eventPlayer.getFacingDirection() * 1000, include=getAllPlayers(), exclude=eventPlayer,includePlayerObjects=false).getHitPosition(),1,EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.cursor = getLastCreatedEntity()
    destroyHudText(eventPlayer.menu)
    hudHeader(eventPlayer, "Pick Heroes", Position.TOP, 1, Color.PURPLE, HudReeval.VISIBILITY_AND_STRING)
    eventPlayer.menu = getLastCreatedText()
    if eventPlayer.N[1]:
        goto lbl_0
    eventPlayer.fly = true
    goto lbl_1:
    lbl_0:
    lbl_1:
    destroyHudText(eventPlayer.heroMenu)
    hudText(eventPlayer, heroIcon(heroes[eventPlayer.currHero]), eventPlayer.currTeam, heroes[eventPlayer.currHero], Position.LEFT, 0, Color.BLUE, Color.BLUE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    eventPlayer.heroMenu = getLastCreatedText()
    
# RULE: MODE: Behavior Builder
# TYPE: mode
# PURPOSE: initialise behavior builder mode
@Rule "MODE: Behavior Builder"
@Event eachPlayer
# CONDITION: Mode is set to 2
if eventPlayer.mode == 2 and isGameInProgress():
    #set HUD
    destroyEffect(eventPlayer.cursor)
    createEffect(eventPlayer,Effect.RING,Color.PURPLE,raycast(eventPlayer.flyPosition, eventPlayer.flyPosition + eventPlayer.getFacingDirection() * 1000, include=getAllPlayers(), exclude=eventPlayer,includePlayerObjects=false).getHitPosition(),1,EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.cursor = getLastCreatedEntity()
    destroyHudText(eventPlayer.menu)
    hudHeader(eventPlayer, "Build Heroes", Position.TOP, 1, Color.PURPLE, HudReeval.VISIBILITY_AND_STRING)
    eventPlayer.menu = getLastCreatedText()
    if eventPlayer.N[1]:
        goto lbl_0
    eventPlayer.fly = true
    goto lbl_1:
    lbl_0:
    lbl_1:
