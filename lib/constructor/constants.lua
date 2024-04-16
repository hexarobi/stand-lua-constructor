-- Constructor Constants

local SCRIPT_VERSION = "0.48b2"
local constants = {}

constants.spawn_modes = {"Offset From Parent", "World Position"}

constants.driving_styles = {
    Normal = 786603,
    Rushed = 1074528293,
    ["Ignore Lights"] = 2883621,
    ["Avoid Traffic"] = 786468,
}

-- From https://alloc8or.re/gta5/doc/enums/eTaskTypeIndex.txt
constants.ped_task_types = {
    HandsUp = 0,
    ClimbLadder = 1,
    ExitVehicle = 2,
    CombatRoll = 3,
    AimGunOnFoot = 4,
    MovePlayer = 5,
    PlayerOnFoot = 6,
    Weapon = 8,
    PlayerWeapon = 9,
    PlayerIdles = 10,
    AimGun = 12,
    Complex = 12,
    FSMClone = 12,
    MotionBase = 12,
    Move = 12,
    MoveBase = 12,
    NMBehaviour = 12,
    NavBase = 12,
    Scenario = 12,
    SearchBase = 12,
    SearchInVehicleBase = 12,
    ShockingEvent = 12,
    TrainBase = 12,
    VehicleFSM = 12,
    VehicleGoTo = 12,
    VehicleMissionBase = 12,
    VehicleTempAction = 12,
    Pause = 14,
    DoNothing = 15,
    GetUp = 16,
    GetUpAndStandStill = 17,
    FallOver = 18,
    FallAndGetUp = 19,
    Crawl = 20,
    ComplexOnFire = 25,
    DamageElectric = 26,
    TriggerLookAt = 28,
    ClearLookAt = 29,
    SetCharDecisionMaker = 30,
    SetPedDefensiveArea = 31,
    UseSequence = 32,
    MoveStandStill = 34,
    ComplexControlMovement = 35,
    MoveSequence = 36,
    AmbientClips = 38,
    MoveInAir = 39,
    NetworkClone = 40,
    UseClimbOnRoute = 41,
    UseDropDownOnRoute = 42,
    UseLadderOnRoute = 43,
    SetBlockingOfNonTemporaryEvents = 44,
    ForceMotionState = 45,
    SlopeScramble = 46,
    GoToAndClimbLadder = 47,
    ClimbLadderFully = 48,
    Rappel = 49,
    Vault = 50,
    DropDown = 51,
    AffectSecondaryBehaviour = 52,
    AmbientLookAtEvent = 53,
    OpenDoor = 54,
    ShovePed = 55,
    SwapWeapon = 56,
    GeneralSweep = 57,
    Police = 58,
    PoliceOrderResponse = 59,
    PursueCriminal = 60,
    ArrestPed = 62,
    ArrestPed2 = 63,
    Busted = 64,
    FirePatrol = 65,
    HeliOrderResponse = 66,
    HeliPassengerRappel = 67,
    AmbulancePatrol = 68,
    PoliceWantedResponse = 69,
    Swat = 70,
    SwatWantedResponse = 72,
    SwatOrderResponse = 73,
    SwatGoToStagingArea = 74,
    SwatFollowInLine = 75,
    Witness = 76,
    GangPatrol = 77,
    Army = 78,
    ShockingEventWatch = 80,
    ShockingEventGoto = 82,
    ShockingEventHurryAway = 83,
    ShockingEventReactToAircraft = 84,
    ShockingEventReact = 85,
    ShockingEventBackAway = 86,
    ShockingPoliceInvestigate = 87,
    ShockingEventStopAndStare = 88,
    ShockingNiceCarPicture = 89,
    ShockingEventThreatResponse = 90,
    TakeOffHelmet = 92,
    CarReactToVehicleCollision = 93,
    CarReactToVehicleCollisionGetOut = 95,
    DyingDead = 97,
    WanderingScenario = 100,
    WanderingInRadiusScenario = 101,
    MoveBetweenPointsScenario = 103,
    ChatScenario = 104,
    CowerScenario = 106,
    DeadBodyScenario = 107,
    SayAudio = 114,
    WaitForSteppingOut = 116,
    CoupleScenario = 117,
    UseScenario = 118,
    UseVehicleScenario = 119,
    Unalerted = 120,
    StealVehicle = 121,
    ReactToPursuit = 122,
    HitWall = 125,
    Cower = 126,
    Crouch = 127,
    Melee = 128,
    MoveMeleeMovement = 129,
    MeleeActionResult = 130,
    MeleeUpperbodyAnims = 131,
    MoVEScripted = 133,
    ScriptedAnimation = 134,
    SynchronizedScene = 135,
    ComplexEvasiveStep = 137,
    WalkRoundCarWhileWandering = 138,
    ComplexStuckInAir = 140,
    WalkRoundEntity = 141,
    MoveWalkRoundVehicle = 142,
    ReactToGunAimedAt = 144,
    DuckAndCover = 146,
    AggressiveRubberneck = 147,
    InVehicleBasic = 150,
    CarDriveWander = 151,
    LeaveAnyCar = 152,
    ComplexGetOffBoat = 153,
    CarSetTempAction = 155,
    BringVehicleToHalt = 156,
    CarDrive = 157,
    PlayerDrive = 159,
    EnterVehicle = 160,
    EnterVehicleAlign = 161,
    OpenVehicleDoorFromOutside = 162,
    EnterVehicleSeat = 163,
    CloseVehicleDoorFromInside = 164,
    InVehicleSeatShuffle = 165,
    ExitVehicleSeat = 167,
    CloseVehicleDoorFromOutside = 168,
    ControlVehicle = 169,
    MotionInAutomobile = 170,
    MotionOnBicycle = 171,
    MotionOnBicycleController = 172,
    MotionInVehicle = 173,
    MotionInTurret = 174,
    ReactToBeingJacked = 175,
    ReactToBeingAskedToLeaveVehicle = 176,
    TryToGrabVehicleDoor = 177,
    GetOnTrain = 178,
    GetOffTrain = 179,
    RideTrain = 180,
    MountThrowProjectile = 190,
    GoToCarDoorAndStandStill = 195,
    MoveGoToVehicleDoor = 196,
    SetPedInVehicle = 197,
    SetPedOutOfVehicle = 198,
    VehicleMountedWeapon = 199,
    VehicleGun = 200,
    VehicleProjectile = 201,
    SmashCarWindow = 204,
    MoveGoToPoint = 205,
    MoveAchieveHeading = 206,
    MoveFaceTarget = 207,
    ComplexGoToPointAndStandStillTimed = 208,
    MoveGoToPointAndStandStill = 208,
    MoveFollowPointRoute = 209,
    MoveSeekEntity_CEntitySeekPosCalculatorStandard = 210,
    MoveSeekEntity_CEntitySeekPosCalculatorLastNavMeshIntersection = 211,
    MoveSeekEntity_CEntitySeekPosCalculatorLastNavMeshIntersection2 = 212,
    MoveSeekEntity_CEntitySeekPosCalculatorXYOffsetFixed = 213,
    MoveSeekEntity_CEntitySeekPosCalculatorXYOffsetFixed2 = 214,
    ExhaustedFlee = 215,
    GrowlAndFlee = 216,
    ScenarioFlee = 217,
    SmartFlee = 218,
    FlyAway = 219,
    WalkAway = 220,
    Wander = 221,
    WanderInArea = 222,
    FollowLeaderInFormation = 223,
    GoToPointAnyMeans = 224,
    TurnToFaceEntityOrCoord = 225,
    FollowLeaderAnyMeans = 226,
    FlyToPoint = 228,
    FlyingWander = 229,
    GoToPointAiming = 230,
    GoToScenario = 231,
    SeekEntityAiming = 233,
    SlideToCoord = 234,
    SwimmingWander = 235,
    MoveTrackingEntity = 237,
    MoveFollowNavMesh = 238,
    MoveGoToPointOnRoute = 239,
    EscapeBlast = 240,
    MoveWander = 241,
    MoveBeInFormation = 242,
    MoveCrowdAroundLocation = 243,
    MoveCrossRoadAtTrafficLights = 244,
    MoveWaitForTraffic = 245,
    MoveGoToPointStandStillAchieveHeading = 246,
    MoveGetOntoMainNavMesh = 251,
    MoveSlideToCoord = 252,
    MoveGoToPointRelativeToEntityAndStandStill = 253,
    HelicopterStrafe = 254,
    GetOutOfWater = 256,
    MoveFollowEntityOffset = 259,
    FollowWaypointRecording = 261,
    MotionPed = 264,
    MotionPedLowLod = 265,
    HumanLocomotion = 268,
    MotionBasicLocomotionLowLod = 269,
    MotionStrafing = 270,
    MotionTennis = 271,
    MotionAiming = 272,
    BirdLocomotion = 273,
    FlightlessBirdLocomotion = 274,
    FishLocomotion = 278,
    QuadLocomotion = 279,
    MotionDiving = 280,
    MotionSwimming = 281,
    MotionParachuting = 282,
    MotionDrunk = 283,
    RepositionMove = 284,
    MotionAimingTransition = 285,
    ThrowProjectile = 286,
    Cover = 287,
    MotionInCover = 288,
    AimAndThrowProjectile = 289,
    Gun = 290,
    AimFromGround = 291,
    AimGunVehicleDriveBy = 295,
    AimGunScripted = 296,
    ReloadGun = 298,
    WeaponBlocked = 299,
    EnterCover = 300,
    ExitCover = 301,
    AimGunFromCoverIntro = 302,
    AimGunFromCoverOutro = 303,
    AimGunBlindFire = 304,
    CombatClosestTargetInArea = 307,
    CombatAdditionalTask = 308,
    InCover = 309,
    AimSweep = 313,
    SharkCircle = 319,
    SharkAttack = 320,
    Agitated = 321,
    AgitatedAction = 322,
    Confront = 323,
    Intimidate = 324,
    Shove = 325,
    Shoved = 326,
    CrouchToggle = 328,
    Revive = 329,
    Parachute = 335,
    ParachuteObject = 336,
    TakeOffPedVariation = 337,
    CombatSeekCover = 340,
    CombatFlank = 342,
    Combat = 343,
    CombatMounted = 344,
    MoveCircle = 345,
    MoveCombatMounted = 346,
    Search = 347,
    SearchOnFoot = 348,
    SearchInAutomobile = 349,
    SearchInBoat = 350,
    SearchInHeli = 351,
    ThreatResponse = 352,
    Investigate = 353,
    StandGuardFSM = 354,
    Patrol = 355,
    ShootAtTarget = 356,
    SetAndGuardArea = 357,
    StandGuard = 358,
    Separate = 359,
    StayInCover = 360,
    VehicleCombat = 361,
    VehiclePersuit = 362,
    VehicleChase = 363,
    DraggingToSafety = 364,
    DraggedToSafety = 365,
    VariedAimPose = 366,
    MoveWithinAttackWindow = 367,
    MoveWithinDefensiveArea = 368,
    ShootOutTire = 369,
    ShellShocked = 370,
    BoatChase = 371,
    BoatCombat = 372,
    BoatStrafe = 373,
    HeliChase = 374,
    HeliCombat = 375,
    SubmarineCombat = 376,
    SubmarineChase = 377,
    PlaneChase = 378,
    TargetUnreachable = 379,
    TargetUnreachableInInterior = 380,
    TargetUnreachableInExterior = 381,
    StealthKill = 382,
    Writhe = 383,
    Advance = 384,
    Charge = 385,
    MoveToTacticalPoint = 386,
    ToHurtTransit = 387,
    AnimatedHitByExplosion = 388,
    NMRelax = 389,
    NMPose = 391,
    NMBrace = 392,
    NMBuoyancy = 393,
    NMInjuredOnGround = 394,
    NMShot = 395,
    NMHighFall = 396,
    NMBalance = 397,
    NMElectrocute = 398,
    NMPrototype = 399,
    NMExplosion = 400,
    NMOnFire = 401,
    NMScriptControl = 402,
    NMJumpRollFromRoadVehicle = 403,
    NMFlinch = 404,
    NMSit = 405,
    NMFallDown = 406,
    BlendFromNM = 407,
    NMControl = 408,
    NMDangle = 409,
    NMGenericAttach = 412,
    NMDraggingToSafety = 414,
    NMThroughWindscreen = 415,
    NMRiverRapids = 416,
    NMSimple = 417,
    RageRagdoll = 418,
    JumpVault = 421,
    Jump = 422,
    Fall = 423,
    ReactAimWeapon = 425,
    Chat = 426,
    MobilePhone = 427,
    ReactToDeadPed = 428,
    SearchForUnknownThreat = 430,
    Bomb = 432,
    Detonator = 433,
    AnimatedAttach = 435,
    CutScene = 441,
    ReactToExplosion = 442,
    ReactToImminentExplosion = 443,
    DiveToGround = 444,
    ReactAndFlee = 445,
    Sidestep = 446,
    CallPolice = 447,
    ReactInDirection = 448,
    ReactToBuddyShot = 449,
    VehicleGoToAutomobileNew = 454,
    VehicleGoToPlane = 455,
    VehicleGoToHelicopter = 456,
    VehicleGoToSubmarine = 457,
    VehicleGoToBoat = 458,
    VehicleGoToPointAutomobile = 459,
    VehicleGoToPointWithAvoidanceAutomobile = 460,
    VehiclePursue = 461,
    VehicleRam = 462,
    VehicleSpinOut = 463,
    VehicleApproach = 464,
    VehicleThreePointTurn = 465,
    VehicleDeadDriver = 466,
    VehicleCruiseNew = 467,
    VehicleCruiseBoat = 468,
    VehicleStop = 469,
    VehiclePullOver = 470,
    VehiclePassengerExit = 471,
    VehicleFlee = 472,
    VehicleFleeAirborne = 473,
    VehicleFleeBoat = 474,
    VehicleFollowRecording = 475,
    VehicleFollow = 476,
    VehicleBlock = 477,
    VehicleBlockCruiseInFront = 478,
    VehicleBlockBrakeInFront = 479,
    VehicleBlockBackAndForth = 478,
    VehicleCrash = 481,
    VehicleLand = 482,
    VehicleLandPlane = 483,
    VehicleHover = 484,
    VehicleAttack = 485,
    VehicleAttackTank = 486,
    VehicleCircle = 487,
    VehiclePoliceBehaviour = 488,
    VehiclePoliceBehaviourHelicopter = 489,
    VehiclePoliceBehaviourBoat = 490,
    VehicleEscort = 491,
    VehicleHeliProtect = 492,
    VehiclePlayerDriveAutomobile = 494,
    VehiclePlayerDriveBike = 495,
    VehiclePlayerDriveBoat = 496,
    VehiclePlayerDriveSubmarine = 497,
    VehiclePlayerDriveSubmarineCar = 498,
    VehiclePlayerDriveAmphibiousAutomobile = 499,
    VehiclePlayerDrivePlane = 500,
    VehiclePlayerDriveHeli = 501,
    VehiclePlayerDriveAutogyro = 502,
    VehiclePlayerDriveDiggerArm = 503,
    VehiclePlayerDriveTrain = 504,
    VehiclePlaneChase = 505,
    VehicleNoDriver = 506,
    VehicleAnimation = 507,
    VehicleConvertibleRoof = 508,
    VehicleParkNew = 509,
    VehicleFollowWaypointRecording = 510,
    VehicleGoToNavmesh = 511,
    VehicleReactToCopSiren = 512,
    VehicleGotoLongRange = 513,
    VehicleWait = 514,
    VehicleReverse = 515,
    VehicleBrake = 516,
    VehicleHandBrake = 517,
    VehicleTurn = 518,
    VehicleGoForward = 519,
    VehicleSwerve = 520,
    VehicleFlyDirection = 521,
    VehicleHeadonCollision = 522,
    VehicleBoostUseSteeringAngle = 523,
    VehicleShotTire = 524,
    VehicleBurnout = 525,
    VehicleRevEngine = 526,
    VehicleSurfaceInSubmarine = 527,
    VehiclePullAlongside = 528,
    VehicleTransformToSubmarine = 529,
    AnimatedFallback = 530,
}

constants.landing_gear_states = {
    "Deployed",
    "Closing",
    "Opening",
    "Retracted",
}

constants.ped_max_hair_tint = 63
constants.ped_max_makeup_tint = 63
constants.ped_head_overlays = {
    {
        overlay_id=0,
        name="Blemishes",
        max_index=23,
    },
    {
        overlay_id=1,
        name="Facial Hair",
        max_index=28,
    },
    {
        overlay_id=2,
        name="Eyebrows",
        max_index=33,
    },
    {
        overlay_id=3,
        name="Ageing",
        max_index=14,
    },
    {
        overlay_id=4,
        name="Makeup",
        max_index=74,
    },
    {
        overlay_id=5,
        name="Blush",
        max_index=6,
    },
    {
        overlay_id=6,
        name="Complexion",
        max_index=11,
    },
    {
        overlay_id=7,
        name="Sun Damage",
        max_index=10,
    },
    {
        overlay_id=8,
        name="Lipstick",
        max_index=9,
    },
    {
        overlay_id=9,
        name="Moles/Freckles",
        max_index=17,
    },
    {
        overlay_id=10,
        name="Chest Hair",
        max_index=16,
    },
    {
        overlay_id=11,
        name="Body Blemishes",
        max_index=11,
    },
    {
        overlay_id=12,
        name="Add Body Blemishes",
        max_index=1,
    },
}

constants.ped_config_flags = {
    { name="0xC63DE95E", index=1 },
    { name="NoCriticalHits", index=2 },
    { name="DrownsInWater", index=3 },
    { name="DisableReticuleFixedLockon", index=4 },
    { name="0x37D196F4", index=5 },
    { name="0xE2462399", index=6 },
    { name="UpperBodyDamageAnimsOnly", index=7 },
    { name="0xEDDEB838", index=8 },
    { name="0xB398B6FD", index=9 },
    { name="0xF6664E68", index=10 },
    { name="0xA05E7CA3", index=11 },
    { name="0xCE394045", index=12 },
    { name="NeverLeavesGroup", index=13 },
    { name="0xCD8D1411", index=14 },
    { name="0xB031F1A9", index=15 },
    { name="0xFE65BEE3", index=16 },
    { name="BlockNonTemporaryEvents", index=17 },
    { name="0x380165BD", index=18 },
    { name="0x07C045C7", index=19 },
    { name="0x583B5E2D", index=20 },
    { name="0x475EDA58", index=21 },
    { name="0x8629D05B", index=22 },
    { name="0x1522968B", index=23 },
    { name="IgnoreSeenMelee", index=24 },
    { name="0x4CC09C4B", index=25 },
    { name="0x034F3053", index=26 },
    { name="0xD91BA7CC", index=27 },
    { name="0x5C8DC66E", index=28 },
    { name="GetOutUndriveableVehicle", index=29 },
    { name="0x6580B9D2", index=30 },
    { name="0x0EF7A297", index=31 },
    { name="WillFlyThruWindscreen", index=32 },
    { name="DieWhenRagdoll", index=33 },
    { name="HasHelmet", index=34 },
    { name="UseHelmet", index=35 },
    { name="DontTakeOffHelmet", index=36 },
    { name="0xB130D17B", index=37 },
    { name="0x5F071200", index=38 },
    { name="DisableEvasiveDives", index=39 },
    { name="0xC287AAFF", index=40 },
    { name="0x203328CC", index=41 },
    { name="DontInfluenceWantedLevel", index=42 },
    { name="DisablePlayerLockon", index=43 },
    { name="DisableLockonToRandomPeds", index=44 },
    { name="AllowLockonToFriendlyPlayers", index=45 },
    { name="0xDB115BFA", index=46 },
    { name="PedBeingDeleted", index=47 },
    { name="BlockWeaponSwitching", index=48 },
    { name="0xF8E99565", index=49 },
    { name="0xDD17FEE6", index=50 },
    { name="0x7ED9B2C9", index=51 },
    { name="NoCollison", index=52 },
    { name="0x5A6C1F6E", index=53 },
    { name="0xD749FC41", index=54 },
    { name="0x357F63F3", index=55 },
    { name="0xC5E60961", index=56 },
    { name="0x29275C3E", index=57 },
    { name="IsFiring", index=58 },
    { name="WasFiring", index=59 },
    { name="IsStanding", index=60 },
    { name="WasStanding", index=61 },
    { name="InVehicle", index=62 },
    { name="OnMount", index=63 },
    { name="AttachedToVehicle", index=64 },
    { name="IsSwimming", index=65 },
    { name="WasSwimming", index=66 },
    { name="IsSkiing", index=67 },
    { name="IsSitting", index=68 },
    { name="KilledByStealth", index=69 },
    { name="KilledByTakedown", index=70 },
    { name="Knockedout", index=71 },
    { name="0x3E3C4560", index=72 },
    { name="0x2994C7B7", index=73 },
    { name="0x6D59D275", index=74 },
    { name="UsingCoverPoint", index=75 },
    { name="IsInTheAir", index=76 },
    { name="0x2D493FB7", index=77 },
    { name="IsAimingGun", index=78 },
    { name="0x14D69875", index=79 },
    { name="0x40B05311", index=80 },
    { name="0x8B230BC5", index=81 },
    { name="0xC74E5842", index=82 },
    { name="0x9EA86147", index=83 },
    { name="0x674C746C", index=84 },
    { name="0x3E56A8C2", index=85 },
    { name="0xC144A1EF", index=86 },
    { name="0x0548512D", index=87 },
    { name="0x31C93909", index=88 },
    { name="0xA0269315", index=89 },
    { name="0xD4D59D4D", index=90 },
    { name="0x411D4420", index=91 },
    { name="0xDF4AEF0D", index=92 },
    { name="ForcePedLoadCover", index=93 },
    { name="0x300E4CD3", index=94 },
    { name="0xF1C5BF04", index=95 },
    { name="0x89C2EF13", index=96 },
    { name="VaultFromCover", index=97 },
    { name="0x02A852C8", index=98 },
    { name="0x3D9407F1", index=99 },
    { name="IsDrunk", index=100 },
    { name="ForcedAim", index=101 },
    { name="0xB942D71A", index=102 },
    { name="0xD26C55A8", index=103 },
    { name="OpenDoorArmIK", index=104 },
    { name="ForceReload", index=105 },
    { name="DontActivateRagdollFromVehicleImpact", index=106 },
    { name="DontActivateRagdollFromBulletImpact", index=107 },
    { name="DontActivateRagdollFromExplosions", index=108 },
    { name="DontActivateRagdollFromFire", index=109 },
    { name="DontActivateRagdollFromElectrocution", index=110 },
    { name="0x83C0A4BF", index=111 },
    { name="0x0E0FAF8C", index=112 },
    { name="KeepWeaponHolsteredUnlessFired", index=113 },
    { name="0x43B80B79", index=114 },
    { name="0x0D2A9309", index=115 },
    { name="GetOutBurningVehicle", index=116 },
    { name="BumpedByPlayer", index=117 },
    { name="RunFromFiresAndExplosions", index=118 },
    { name="TreatAsPlayerDuringTargeting", index=119 },
    { name="IsHandCuffed", index=120 },
    { name="IsAnkleCuffed", index=121 },
    { name="DisableMelee", index=122 },
    { name="DisableUnarmedDrivebys", index=123 },
    { name="JustGetsPulledOutWhenElectrocuted", index=124 },
    { name="0x5FED6BFD", index=125 },
    { name="WillNotHotwireLawEnforcementVehicle", index=126 },
    { name="WillCommandeerRatherThanJack", index=127 },
    { name="CanBeAgitated", index=128 },
    { name="ForcePedToFaceLeftInCover", index=129 },
    { name="ForcePedToFaceRightInCover", index=130 },
    { name="BlockPedFromTurningInCover", index=131 },
    { name="KeepRelationshipGroupAfterCleanUp", index=132 },
    { name="ForcePedToBeDragged", index=133 },
    { name="PreventPedFromReactingToBeingJacked", index=134 },
    { name="IsScuba", index=135 },
    { name="WillArrestRatherThanJack", index=136 },
    { name="RemoveDeadExtraFarAway", index=137 },
    { name="RidingTrain", index=138 },
    { name="ArrestResult", index=139 },
    { name="CanAttackFriendly", index=140 },
    { name="WillJackAnyPlayer", index=141 },
    { name="0x6901E731", index=142 },
    { name="0x9EC9BF6C", index=143 },
    { name="WillJackWantedPlayersRatherThanStealCar", index=144 },
    { name="ShootingAnimFlag", index=145 },
    { name="DisableLadderClimbing", index=146 },
    { name="StairsDetected", index=147 },
    { name="SlopeDetected", index=148 },
    { name="0x1A15670B", index=149 },
    { name="CowerInsteadOfFlee", index=150 },
    { name="CanActivateRagdollWhenVehicleUpsideDown", index=151 },
    { name="AlwaysRespondToCriesForHelp", index=152 },
    { name="DisableBloodPoolCreation", index=153 },
    { name="ShouldFixIfNoCollision", index=154 },
    { name="CanPerformArrest", index=155 },
    { name="CanPerformUncuff", index=156 },
    { name="CanBeArrested", index=157 },
    { name="0xF7960FF5", index=158 },
    { name="PlayerPreferFrontSeatMP", index=159 },
    { name="0x0C6C3099", index=160 },
    { name="0x645F927A", index=161 },
    { name="0xA86549B9", index=162 },
    { name="0x8AAF337A", index=163 },
    { name="0x13BAA6E7", index=164 },
    { name="0x5FB9D1F5", index=165 },
    { name="IsInjured", index=166 },
    { name="DontEnterVehiclesInPlayersGroup", index=167 },
    { name="0xD8072639", index=168 },
    { name="PreventAllMeleeTaunts", index=169 },
    { name="ForceDirectEntry", index=170 },
    { name="AlwaysSeeApproachingVehicles", index=171 },
    { name="CanDiveAwayFromApproachingVehicles", index=172 },
    { name="AllowPlayerToInterruptVehicleEntryExit", index=173 },
    { name="OnlyAttackLawIfPlayerIsWanted", index=174 },
    { name="0x90008BFA", index=175 },
    { name="0x07C7A910", index=176 },
    { name="PedsJackingMeDontGetIn", index=177 },
    { name="0xCE4E8BE2", index=178 },
    { name="PedIgnoresAnimInterruptEvents", index=179 },
    { name="IsInCustody", index=180 },
    { name="ForceStandardBumpReactionThresholds", index=181 },
    { name="LawWillOnlyAttackIfPlayerIsWanted", index=182 },
    { name="IsAgitated", index=183 },
    { name="PreventAutoShuffleToDriversSeat", index=184 },
    { name="UseKinematicModeWhenStationary", index=185 },
    { name="EnableWeaponBlocking", index=186 },
    { name="HasHurtStarted", index=187 },
    { name="DisableHurt", index=188 },
    { name="PlayerIsWeird", index=189 },
    { name="0x32FC208B", index=190 },
    { name="0x0C296E5A", index=191 },
    { name="0xE63B73EC", index=192 },
    { name="DoNothingWhenOnFootByDefault", index=193 },
    { name="UsingScenario", index=194 },
    { name="VisibleOnScreen", index=195 },
    { name="0xD88C58A1", index=196 },
    { name="0x5A3DCF43", index=197 },
    { name="0xEA02B420", index=198 },
    { name="DontActivateRagdollOnVehicleCollisionWhenDead", index=199 },
    { name="HasBeenInArmedCombat", index=200 },
    { name="0x5E6466F6", index=201 },
    { name="Avoidance_Ignore_All", index=202 },
    { name="Avoidance_Ignored_by_All", index=203 },
    { name="Avoidance_Ignore_Group1", index=204 },
    { name="Avoidance_Member_of_Group1", index=205 },
    { name="ForcedToUseSpecificGroupSeatIndex", index=206 },
    { name="0x415B26B9", index=207 },
    { name="DisableExplosionReactions", index=208 },
    { name="DodgedPlayer", index=209 },
    { name="WaitingForPlayerControlInterrupt", index=210 },
    { name="ForcedToStayInCover", index=211 },
    { name="GeneratesSoundEvents", index=212 },
    { name="ListensToSoundEvents", index=213 },
    { name="AllowToBeTargetedInAVehicle", index=214 },
    { name="WaitForDirectEntryPointToBeFreeWhenExiting", index=215 },
    { name="OnlyRequireOnePressToExitVehicle", index=216 },
    { name="ForceExitToSkyDive", index=217 },
    { name="0x3C7DF9DF", index=218 },
    { name="0x848FFEF2", index=219 },
    { name="DontEnterLeadersVehicle", index=220 },
    { name="DisableExitToSkyDive", index=221 },
    { name="0x84F722FA", index=222 },
    { name="Shrink", index=223 },
    { name="0x728AA918", index=224 },
    { name="DisablePotentialToBeWalkedIntoResponse", index=225 },
    { name="DisablePedAvoidance", index=226 },
    { name="ForceRagdollUponDeath", index=227 },
    { name="0x1EA7225F", index=228 },
    { name="DisablePanicInVehicle", index=229 },
    { name="AllowedToDetachTrailer", index=230 },
    { name="0xFC3E572D", index=231 },
    { name="0x08E9F9CF", index=232 },
    { name="0x2D3BA52D", index=233 },
    { name="0xFD2F53EA", index=234 },
    { name="0x31A1B03B", index=235 },
    { name="IsHoldingProp", index=236 },
    { name="BlocksPathingWhenDead", index=237 },
    { name="0xCE57C9A3", index=238 },
    { name="0x26149198", index=239 },
    { name="ForceSkinCharacterCloth", index=240 },
    { name="LeaveEngineOnWhenExitingVehicles", index=241 },
    { name="PhoneDisableTextingAnimations", index=242 },
    { name="PhoneDisableTalkingAnimations", index=243 },
    { name="PhoneDisableCameraAnimations", index=244 },
    { name="DisableBlindFiringInShotReactions", index=245 },
    { name="AllowNearbyCoverUsage", index=246 },
    { name="0x0C754ACA", index=247 },
    { name="CanPlayInCarIdles", index=248 },
    { name="CanAttackNonWantedPlayerAsLaw", index=249 },
    { name="WillTakeDamageWhenVehicleCrashes", index=250 },
    { name="AICanDrivePlayerAsRearPassenger", index=251 },
    { name="PlayerCanJackFriendlyPlayers", index=252 },
    { name="OnStairs", index=253 },
    { name="0xE1A2F73F", index=254 },
    { name="AIDriverAllowFriendlyPassengerSeatEntry", index=255 },
    { name="0xF1EB20A9", index=256 },
    { name="AllowMissionPedToUseInjuredMovement", index=257 },
    { name="0x329DCF1A", index=258 },
    { name="0x8D90DD1B", index=259 },
    { name="0xB8A292B7", index=260 },
    { name="PreventUsingLowerPrioritySeats", index=261 },
    { name="0x2AF558F0", index=262 },
    { name="0x82251455", index=263 },
    { name="0x30CF498B", index=264 },
    { name="0xE1CD50AF", index=265 },
    { name="0x72E4AE48", index=266 },
    { name="0xC2657EA1", index=267 },
    { name="TeleportToLeaderVehicle", index=268 },
    { name="Avoidance_Ignore_WeirdPedBuffer", index=269 },
    { name="OnStairSlope", index=270 },
    { name="0xA0897933", index=271 },
    { name="DontBlipCop", index=272 },
    { name="ClimbedShiftedFence", index=273 },
    { name="0xF7823618", index=274 },
    { name="KillWhenTrapped", index=275 },
    { name="EdgeDetected", index=276 },
    { name="0x92B67896", index=277 },
    { name="0xCAD677C9", index=278 },
    { name="AvoidTearGas", index=279 },
    { name="0x5276AC7B", index=280 },
    { name="DisableGoToWritheWhenInjured", index=281 },
    { name="OnlyUseForcedSeatWhenEnteringHeliInGroup", index=282 },
    { name="0x9139724D", index=283 },
    { name="0xA1457461", index=284 },
    { name="DisableWeirdPedEvents", index=285 },
    { name="ShouldChargeNow", index=286 },
    { name="RagdollingOnBoat", index=287 },
    { name="HasBrandishedWeapon", index=288 },
    { name="0x1B9EE8A1", index=289 },
    { name="0xF3F5758C", index=290 },
    { name="0x2A9307F1", index=291 },
    { name="FreezePosition", index=292 },
    { name="0xA06A3C6C", index=293 },
    { name="DisableShockingEvents", index=294 },
    { name="0xF8DA25A5", index=295 },
    { name="NeverReactToPedOnRoof", index=296 },
    { name="0xB31F1187", index=297 },
    { name="0x84315402", index=298 },
    { name="DisableShockingDrivingOnPavementEvents", index=299 },
    { name="0xC7829B67", index=300 },
    { name="DisablePedConstraints", index=301 },
    { name="ForceInitialPeekInCover", index=302 },
    { name="0x2ADA871B", index=303 },
    { name="0x47BC8A58", index=304 },
    { name="DisableJumpingFromVehiclesAfterLeader", index=305 },
    { name="0x4A133C50", index=306 },
    { name="0xC58099C3", index=307 },
    { name="0xF3D76D41", index=308 },
    { name="0xB0EEE9F2", index=309 },
    { name="IsInCluster", index=310 },
    { name="ShoutToGroupOnPlayerMelee", index=311 },
    { name="IgnoredByAutoOpenDoors", index=312 },
    { name="0xD4136C22", index=313 },
    { name="ForceIgnoreMeleeActiveCombatant", index=314 },
    { name="CheckLoSForSoundEvents", index=315 },
    { name="0xD5C98277", index=316 },
    { name="CanSayFollowedByPlayerAudio", index=317 },
    { name="ActivateRagdollFromMinorPlayerContact", index=318 },
    { name="0xD8BE1D54", index=319 },
    { name="ForcePoseCharacterCloth", index=320 },
    { name="HasClothCollisionBounds", index=321 },
    { name="HasHighHeels", index=322 },
    { name="0x86B01E54", index=323 },
    { name="DontBehaveLikeLaw", index=324 },
    { name="0xC03B736C", index=325 },
    { name="DisablePoliceInvestigatingBody", index=326 },
    { name="DisableWritheShootFromGround", index=327 },
    { name="LowerPriorityOfWarpSeats", index=328 },
    { name="DisableTalkTo", index=329 },
    { name="DontBlip", index=330 },
    { name="IsSwitchingWeapon", index=331 },
    { name="IgnoreLegIkRestrictions", index=332 },
    { name="0x150468FD", index=333 },
    { name="0x914EBD6B", index=334 },
    { name="0x79AF3B6D", index=335 },
    { name="0x75C7A632", index=336 },
    { name="0x52D530E2", index=337 },
    { name="0xDB2A90E0", index=338 },
    { name="AllowTaskDoNothingTimeslicing", index=339 },
    { name="0x12ADB567", index=340 },
    { name="0x105C8518", index=341 },
    { name="NotAllowedToJackAnyPlayers", index=342 },
    { name="0xED152C3E", index=343 },
    { name="0xA0EFE6A8", index=344 },
    { name="AlwaysLeaveTrainUponArrival", index=345 },
    { name="0xCDDFE830", index=346 },
    { name="OnlyWritheFromWeaponDamage", index=347 },
    { name="UseSloMoBloodVfx", index=348 },
    { name="EquipJetpack", index=349 },
    { name="PreventDraggedOutOfCarThreatResponse", index=350 },
    { name="0xE13D1F7C", index=351 },
    { name="0x40E25FB9", index=352 },
    { name="0x930629D9", index=353 },
    { name="0xECCF0C7F", index=354 },
    { name="0xB6E9613B", index=355 },
    { name="ForceDeepSurfaceCheck", index=356 },
    { name="DisableDeepSurfaceAnims", index=357 },
    { name="DontBlipNotSynced", index=358 },
    { name="IsDuckingInVehicle", index=359 },
    { name="PreventAutoShuffleToTurretSeat", index=360 },
    { name="DisableEventInteriorStatusCheck", index=361 },
    { name="HasReserveParachute", index=362 },
    { name="UseReserveParachute", index=363 },
    { name="TreatDislikeAsHateWhenInCombat", index=364 },
    { name="OnlyUpdateTargetWantedIfSeen", index=365 },
    { name="AllowAutoShuffleToDriversSeat", index=366 },
    { name="0xD7E07D37", index=367 },
    { name="0x03C4FD24", index=368 },
    { name="0x7675789A", index=369 },
    { name="0xB7288A88", index=370 },
    { name="0xC06B6291", index=371 },
    { name="PreventReactingToSilencedCloneBullets", index=372 },
    { name="DisableInjuredCryForHelpEvents", index=373 },
    { name="NeverLeaveTrain", index=374 },
    { name="DontDropJetpackOnDeath", index=375 },
    { name="0x147F1FFB", index=376 },
    { name="0x4376DD79", index=377 },
    { name="0xCD3DB518", index=378 },
    { name="0xFE4BA4B6", index=379 },
    { name="DisableAutoEquipHelmetsInBikes", index=380 },
    { name="0xBCD816CD", index=381 },
    { name="0xCF02DD69", index=382 },
    { name="0xF73AFA2E", index=383 },
    { name="0x80B9A9D0", index=384 },
    { name="0xF601F7EE", index=385 },
    { name="0xA91350FC", index=386 },
    { name="0x3AB23B96", index=387 },
    { name="IsClimbingLadder", index=388 },
    { name="HasBareFeet", index=389 },
    { name="UNUSED_REPLACE_ME_2", index=390 },
    { name="GoOnWithoutVehicleIfItIsUnableToGetBackToRoad", index=391 },
    { name="BlockDroppingHealthSnacksOnDeath", index=392 },
    { name="0xC11D3E8F", index=393 },
    { name="ForceThreatResponseToNonFriendToFriendMeleeActions", index=394 },
    { name="DontRespondToRandomPedsDamage", index=395 },
    { name="AllowContinuousThreatResponseWantedLevelUpdates", index=396 },
    { name="KeepTargetLossResponseOnCleanup", index=397 },
    { name="PlayersDontDragMeOutOfCar", index=398 },
    { name="BroadcastRepondedToThreatWhenGoingToPointShooting", index=399 },
    { name="IgnorePedTypeForIsFriendlyWith", index=400 },
    { name="TreatNonFriendlyAsHateWhenInCombat", index=401 },
    { name="DontLeaveVehicleIfLeaderNotInVehicle", index=402 },
    { name="0x5E5B9591", index=403 },
    { name="AllowMeleeReactionIfMeleeProofIsOn", index=404 },
    { name="0x77840177", index=405 },
    { name="0x1C7ACAC4", index=406 },
    { name="UseNormalExplosionDamageWhenBlownUpInVehicle", index=407 },
    { name="DisableHomingMissileLockForVehiclePedInside", index=408 },
    { name="DisableTakeOffScubaGear", index=409 },
    { name="IgnoreMeleeFistWeaponDamageMult", index=410 },
    { name="LawPedsCanFleeFromNonWantedPlayer", index=411 },
    { name="ForceBlipSecurityPedsIfPlayerIsWanted", index=412 },
    { name="IsHolsteringWeapon", index=413 },
    { name="UseGoToPointForScenarioNavigation", index=414 },
    { name="DontClearLocalPassengersWantedLevel", index=415 },
    { name="BlockAutoSwapOnWeaponPickups", index=416 },
    { name="ThisPedIsATargetPriorityForAI", index=417 },
    { name="IsSwitchingHelmetVisor", index=418 },
    { name="ForceHelmetVisorSwitch", index=419 },
    { name="0xCFF5F6DE", index=420 },
    { name="UseOverrideFootstepPtFx", index=421 },
    { name="DisableVehicleCombat", index=422 },
    { name="0xFE401D26", index=423 },
    { name="FallsLikeAircraft", index=424 },
    { name="0x2B42AE82", index=425 },
    { name="UseLockpickVehicleEntryAnimations", index=426 },
    { name="IgnoreInteriorCheckForSprinting", index=427 },
    { name="SwatHeliSpawnWithinLastSpottedLocation", index=428 },
    { name="DisableStartEngine", index=429 },
    { name="IgnoreBeingOnFire", index=430 },
    { name="DisableTurretOrRearSeatPreference", index=431 },
    { name="DisableWantedHelicopterSpawning", index=432 },
    { name="UseTargetPerceptionForCreatingAimedAtEvents", index=433 },
    { name="DisableHomingMissileLockon", index=434 },
    { name="ForceIgnoreMaxMeleeActiveSupportCombatants", index=435 },
    { name="StayInDefensiveAreaWhenInVehicle", index=436 },
    { name="DontShoutTargetPosition", index=437 },
    { name="DisableHelmetArmor", index=438 },
    { name="0xCB7F3A1E", index=439 },
    { name="0x50178878", index=440 },
    { name="PreventVehExitDueToInvalidWeapon", index=441 },
    { name="IgnoreNetSessionFriendlyFireCheckForAllowDamage", index=442 },
    { name="DontLeaveCombatIfTargetPlayerIsAttackedByPolice", index=443 },
    { name="CheckLockedBeforeWarp", index=444 },
    { name="DontShuffleInVehicleToMakeRoom", index=445 },
    { name="GiveWeaponOnGetup", index=446 },
    { name="DontHitVehicleWithProjectiles", index=447 },
    { name="DisableForcedEntryForOpenVehiclesFromTryLockedDoor", index=448 },
    { name="FiresDummyRockets", index=449 },
    { name="PedIsArresting", index=450 },
    { name="IsDecoyPed", index=451 },
    { name="HasEstablishedDecoy", index=452 },
    { name="BlockDispatchedHelicoptersFromLanding", index=453 },
    { name="DontCryForHelpOnStun", index=454 },
    { name="0xB68D3EAB", index=455 },
    { name="CanBeIncapacitated", index=456 },
    { name="0x4BD5EBAD", index=457 },
    { name="DontChangeTargetFromMelee", index=458 },
}

constants.radio_station_map= {
    ["RADIO_11_TALK_02"] = "Blaine County Radio",
    ["RADIO_12_REGGAE"] = "The Blue Ark",
    ["RADIO_13_JAZZ"] = "Worldwide FM",
    ["RADIO_14_DANCE_02"] = "FlyLo FM",
    ["RADIO_15_MOTOWN"] = "The Lowdown 9.11",
    ["RADIO_20_THELAB"] = "The Lab",
    ["RADIO_16_SILVERLAKE"] = "Radio Mirror Park",
    ["RADIO_17_FUNK"] = "Space 103.2",
    ["RADIO_18_90S_ROCK"] = "Vinewood Boulevard Radio",
    ["RADIO_21_DLC_XM17"] = "Blonded Los Santos 97.8 FM",
    ["RADIO_22_DLC_BATTLE_MIX1_RADIO"] = "Los Santos Underground Radio",
    ["RADIO_23_DLC_XM19_RADIO"] = "iFruit Radio",
    ["RADIO_19_USER"] = "Self Radio",
    ["RADIO_01_CLASS_ROCK"] = "Los Santos Rock Radio",
    ["RADIO_02_POP"] = "Non-Stop-Pop FM",
    ["RADIO_03_HIPHOP_NEW"] = "Radio Los Santos",
    ["RADIO_04_PUNK"] = "Channel X",
    ["RADIO_05_TALK_01"] = "West Coast Talk Radio",
    ["RADIO_06_COUNTRY"] = "Rebel Radio",
    ["RADIO_07_DANCE_01"] = "Soulwax FM",
    ["RADIO_08_MEXICAN"] = "East Los FM",
    ["RADIO_09_HIPHOP_OLD"] = "West Coast Classics",
    ["RADIO_36_AUDIOPLAYER"] = "Media Player",
    ["RADIO_35_DLC_HEI4_MLR"] = "The Music Locker",
    ["RADIO_34_DLC_HEI4_KULT"] = "Kult FM",
    ["RADIO_27_DLC_PRHEI4"] = "Still Slipping Los Santos",
}

constants.radio_station_codes = {"OFF"}
constants.radio_station_names = {"Off"}
for code, station_name in pairs(constants.radio_station_map) do
    table.insert(constants.radio_station_codes, code)
    table.insert(constants.radio_station_names, station_name)
end

constants.rotation_orders = {
    { "ZYX", {}, "Rotate around the z-axis, then the y-axis and finally the x-axis.", 0 },
    { "YZX", {}, "Rotate around the y-axis, then the z-axis and finally the x-axis.", 1 },
    { "ZXY", {}, "Rotate around the z-axis, then the x-axis and finally the y-axis.", 2 },
    { "XZY", {}, "Rotate around the x-axis, then the z-axis and finally the y-axis.", 3 },
    { "YXZ", {}, "Rotate around the y-axis, then the x-axis and finally the z-axis.", 4 },
    { "XYZ", {}, "Rotate around the x-axis, then the y-axis and finally the z-axis.", 5 },
}

constants.ped_props = {
    {index=0, name="Hats"},
    {index=1, name="Glasses"},
    {index=2, name="Earrings"},
    {index=6, name="Watch"},
    {index=7, name="Bracelet"},
}

constants.ped_components = {
    {index=1, name="Mask"},
    {index=2, name="Hair"},
    {index=8, name="Shirt"},
    {index=11, name="Jacket"},
    {index=4, name="Pants"},
    {index=6, name="Shoes"},
    {index=7, name="Necktie"},
    {index=3, name="Gloves"},
    {index=5, name="Parachute / Bag"},
    {index=9, name="Body Armor"},
    {index=10, name="Decals"},
}

constants.tire_position_names = {
    { name="Front Left", index=0 },
    { name="Front Right", index=1 },
    { name="Mid Left", index=2 },
    { name="Mid Right", index=3 },
    { name="Rear Left", index=4 },
    { name="Rear Right", index=5 },
    { name="6 Wheeler Left", index=45 },
    { name="6 Wheeler Right", index=47 },
}

constants.detached_wheel_names = {
    { name="Front Left", index=0 },
    { name="Front Right", index=1 },
    { name="Mid Left", index=4 },
    { name="Mid Right", index=5 },
    { name="Rear Left", index=2 },
    { name="Rear Right", index=3 },
}

constants.door_lock_status = {
    "None",
    "Unlocked",
    "Locked",
    "Lockout Player Only",
    "Locked Player Inside",
    "Locked Initially",
    "Force Shut Doors",
    "Locked by can be damaged",
    "Locked but trunk unlocked",
    "Locked, no passengers",
    "Cannot enter",
}

constants.vehicle_paint_types = {
    "Normal", "Metallic", "Pearl", "Matte", "Metal", "Chrome"
}

constants.headlight_colors = {
    "Stock", "White", "Blue", "Light Blue", "Green", "Lime", "Yellow", "Gold", "Orange", "Red", "Pink", "Hot Pink", "Purple", "Blacklight"
}

constants.standard_colors = {
    {
        index=0,
        name="MetallicBlack",
        hex="#0d1116",
        rgb={r=13, g=17, b=22},
    },
    {
        index=1,
        name="MetallicGraphiteBlack",
        hex="#1c1d21",
        rgb={r=28, g=29, b=33 },
    },
    {
        index=2,
        name="MetallicBlackSteal",
        hex="#32383d",
        rgb={r=50, g=56, b=61 },
    },
    {
        index=3,
        name="MetallicDarkSilver",
        hex="#454b4f",
        rgb={r=69, g=75, b=79 },
    },
    {
        index=4,
        name="MetallicSilver",
        hex="#999da0",
        rgb={r=153, g=157, b=160 },
    },
    {
        index=5,
        name="MetallicBlueSilver",
        hex="#c2c4c6",
        rgb={r=194, g=196, b=198 },
    },
    {
        index=6,
        name="MetallicSteelGray",
        hex="#979a97",
        rgb={r=151, g=154, b=151 },
    },
    {
        index=7,
        name="MetallicShadowSilver",
        hex="#637380",
        rgb={r=99, g=115, b=128 },
    },
    {
        index=8,
        name="MetallicStoneSilver",
        hex="#63625c",
        rgb={r=99, g=98, b=92 },
    },
    {
        index=9,
        name="MetallicMidnightSilver",
        hex="#3c3f47",
        rgb={r=60, g=63, b=71 },
    },
    {
        index=10,
        name="MetallicGunMetal",
        hex="#444e54",
        rgb={r=68, g=78, b=84 },
    },
    {
        index=11,
        name="MetallicAnthraciteGrey",
        hex="#1d2129",
        rgb={r=29, g=33, b=41 },
    },
    {
        index=12,
        name="MatteBlack",
        hex="#13181f",
        rgb={r=19, g=24, b=31 },
    },
    {
        index=13,
        name="MatteGray",
        hex="#26282a",
        rgb={r=38, g=40, b=42 },
    },
    {
        index=14,
        name="MatteLightGrey",
        hex="#515554",
        rgb={r=81, g=85, b=84 },
    },
    {
        index=15,
        name="UtilBlack",
        hex="#151921",
        rgb={r=21, g=25, b=33 },
    },
    {
        index=16,
        name="UtilBlackPoly",
        hex="#1e2429",
        rgb={r=30, g=36, b=41 },
    },
    {
        index=17,
        name="UtilDarksilver",
        hex="#333a3c",
        rgb={r=51, g=58, b=60 },
    },
    {
        index=18,
        name="UtilSilver",
        hex="#8c9095",
        rgb={r=140, g=144, b=149 },
    },
    {
        index=19,
        name="UtilGunMetal",
        hex="#39434d",
        rgb={r=57, g=67, b=77 },
    },
    {
        index=20,
        name="UtilShadowSilver",
        hex="#506272",
        rgb={r=80, g=98, b=114 },
    },
    {
        index=21,
        name="WornBlack",
        hex="#1e232f",
        rgb={r=30, g=35, b=47 },
    },
    {
        index=22,
        name="WornGraphite",
        hex="#363a3f",
        rgb={r=54, g=58, b=63 },
    },
    {
        index=23,
        name="WornSilverGrey",
        hex="#a0a199",
        rgb={r=160, g=161, b=153 },
    },
    {
        index=24,
        name="WornSilver",
        hex="#d3d3d3",
        rgb={r=211, g=211, b=211 },
    },
    {
        index=25,
        name="WornBlueSilver",
        hex="#b7bfca",
        rgb={r=183, g=191, b=202 },
    },
    {
        index=26,
        name="WornShadowSilver",
        hex="#778794",
        rgb={r=119, g=135, b=148 },
    },
    {
        index=27,
        name="MetallicRed",
        hex="#c00e1a",
        rgb={r=192, g=14, b=26 },
    },
    {
        index=28,
        name="MetallicTorinoRed",
        hex="#da1918",
        rgb={r=218, g=25, b=24 },
    },
    {
        index=29,
        name="MetallicFormulaRed",
        hex="#b6111b",
        rgb={r=182, g=17, b=27 },
    },
    {
        index=30,
        name="MetallicBlazeRed",
        hex="#a51e23",
        rgb={r=165, g=30, b=35 },
    },
    {
        index=31,
        name="MetallicGracefulRed",
        hex="#7b1a22",
        rgb={r=123, g=26, b=34 },
    },
    {
        index=32,
        name="MetallicGarnetRed",
        hex="#8e1b1f",
        rgb={r=142, g=27, b=31 },
    },
    {
        index=33,
        name="MetallicDesertRed",
        hex="#6f1818",
        rgb={r=111, g=24, b=24 },
    },
    {
        index=34,
        name="MetallicCabernetRed",
        hex="#49111d",
        rgb={r=73, g=17, b=29 },
    },
    {
        index=35,
        name="MetallicCandyRed",
        hex="#b60f25",
        rgb={r=182, g=15, b=37 },
    },
    {
        index=36,
        name="MetallicSunriseOrange",
        hex="#d44a17",
        rgb={r=212, g=74, b=23 },
    },
    {
        index=37,
        name="MetallicClassicGold",
        hex="#c2944f",
        rgb={r=194, g=148, b=79 },
    },
    {
        index=38,
        name="MetallicOrange",
        hex="#f78616",
        rgb={r=247, g=134, b=22 },
    },
    {
        index=39,
        name="MatteRed",
        hex="#cf1f21",
        rgb={r=207, g=31, b=33 },
    },
    {
        index=40,
        name="MatteDarkRed",
        hex="#732021",
        rgb={r=115, g=32, b=33 },
    },
    {
        index=41,
        name="MatteOrange",
        hex="#f27d20",
        rgb={r=242, g=125, b=32 },
    },
    {
        index=42,
        name="MatteYellow",
        hex="#ffc91f",
        rgb={r=255, g=201, b=31 },
    },
    {
        index=43,
        name="UtilRed",
        hex="#9c1016",
        rgb={r=156, g=16, b=22 },
    },
    {
        index=44,
        name="UtilBrightRed",
        hex="#de0f18",
        rgb={r=222, g=15, b=24 },
    },
    {
        index=45,
        name="UtilGarnetRed",
        hex="#8f1e17",
        rgb={r=143, g=30, b=23 },
    },
    {
        index=46,
        name="WornRed",
        hex="#a94744",
        rgb={r=169, g=71, b=68 },
    },
    {
        index=47,
        name="WornGoldenRed",
        hex="#b16c51",
        rgb={r=177, g=108, b=81 },
    },
    {
        index=48,
        name="WornDarkRed",
        hex="#371c25",
        rgb={r=55, g=28, b=37 },
    },
    {
        index=49,
        name="MetallicDarkGreen",
        hex="#132428",
        rgb={r=19, g=36, b=40 },
    },
    {
        index=50,
        name="MetallicRacingGreen",
        hex="#122e2b",
        rgb={r=18, g=46, b=43 },
    },
    {
        index=51,
        name="MetallicSeaGreen",
        hex="#12383c",
        rgb={r=18, g=56, b=60 },
    },
    {
        index=52,
        name="MetallicOliveGreen",
        hex="#31423f",
        rgb={r=49, g=66, b=63 },
    },
    {
        index=53,
        name="MetallicGreen",
        hex="#155c2d",
        rgb={r=21, g=92, b=45 },
    },
    {
        index=54,
        name="MetallicGasolineBlueGreen",
        hex="#1b6770",
        rgb={r=27, g=103, b=112 },
    },
    {
        index=55,
        name="MatteLimeGreen",
        hex="#66b81f",
        rgb={r=102, g=184, b=31 },
    },
    {
        index=56,
        name="UtilDarkGreen",
        hex="#22383e",
        rgb={r=34, g=56, b=62 },
    },
    {
        index=57,
        name="UtilGreen",
        hex="#1d5a3f",
        rgb={r=29, g=90, b=63 },
    },
    {
        index=58,
        name="WornDarkGreen",
        hex="#2d423f",
        rgb={r=45, g=66, b=63 },
    },
    {
        index=59,
        name="WornGreen",
        hex="#45594b",
        rgb={r=69, g=89, b=75 },
    },
    {
        index=60,
        name="WornSeaWash",
        hex="#65867f",
        rgb={r=101, g=134, b=127 },
    },
    {
        index=61,
        name="MetallicMidnightBlue",
        hex="#222e46",
        rgb={r=34, g=46, b=70 },
    },
    {
        index=62,
        name="MetallicDarkBlue",
        hex="#233155",
        rgb={r=35, g=49, b=85 },
    },
    {
        index=63,
        name="MetallicSaxonyBlue",
        hex="#304c7e",
        rgb={r=48, g=76, b=126 },
    },
    {
        index=64,
        name="MetallicBlue",
        hex="#47578f",
        rgb={r=71, g=87, b=143 },
    },
    {
        index=65,
        name="MetallicMarinerBlue",
        hex="#637ba7",
        rgb={r=99, g=123, b=167 },
    },
    {
        index=66,
        name="MetallicHarborBlue",
        hex="#394762",
        rgb={r=57, g=71, b=98 },
    },
    {
        index=67,
        name="MetallicDiamondBlue",
        hex="#d6e7f1",
        rgb={r=214, g=231, b=241 },
    },
    {
        index=68,
        name="MetallicSurfBlue",
        hex="#76afbe",
        rgb={r=118, g=175, b=190 },
    },
    {
        index=69,
        name="MetallicNauticalBlue",
        hex="#345e72",
        rgb={r=52, g=94, b=114 },
    },
    {
        index=70,
        name="MetallicBrightBlue",
        hex="#0b9cf1",
        rgb={r=11, g=156, b=241 },
    },
    {
        index=71,
        name="MetallicPurpleBlue",
        hex="#2f2d52",
        rgb={r=47, g=45, b=82 },
    },
    {
        index=72,
        name="MetallicSpinnakerBlue",
        hex="#282c4d",
        rgb={r=40, g=44, b=77 },
    },
    {
        index=73,
        name="MetallicUltraBlue",
        hex="#2354a1",
        rgb={r=35, g=84, b=161 },
    },
    {
        index=74,
        name="MetallicBrightBlue",
        hex="#6ea3c6",
        rgb={r=110, g=163, b=198 },
    },
    {
        index=75,
        name="UtilDarkBlue",
        hex="#112552",
        rgb={r=17, g=37, b=82 },
    },
    {
        index=76,
        name="UtilMidnightBlue",
        hex="#1b203e",
        rgb={r=27, g=32, b=62 },
    },
    {
        index=77,
        name="UtilBlue",
        hex="#275190",
        rgb={r=39, g=81, b=144 },
    },
    {
        index=78,
        name="UtilSeaFoamBlue",
        hex="#608592",
        rgb={r=96, g=133, b=146 },
    },
    {
        index=79,
        name="UtilLightningblue",
        hex="#2446a8",
        rgb={r=36, g=70, b=168 },
    },
    {
        index=80,
        name="UtilMauiBluePoly",
        hex="#4271e1",
        rgb={r=66, g=113, b=225 },
    },
    {
        index=81,
        name="UtilBrightBlue",
        hex="#3b39e0",
        rgb={r=59, g=57, b=224 },
    },
    {
        index=82,
        name="MatteDarkBlue",
        hex="#1f2852",
        rgb={r=31, g=40, b=82 },
    },
    {
        index=83,
        name="MatteBlue",
        hex="#253aa7",
        rgb={r=37, g=58, b=167 },
    },
    {
        index=84,
        name="MatteMidnightBlue",
        hex="#1c3551",
        rgb={r=28, g=53, b=81 },
    },
    {
        index=85,
        name="WornDarkblue",
        hex="#4c5f81",
        rgb={r=76, g=95, b=129 },
    },
    {
        index=86,
        name="WornBlue",
        hex="#58688e",
        rgb={r=88, g=104, b=142 },
    },
    {
        index=87,
        name="WornLightblue",
        hex="#74b5d8",
        rgb={r=116, g=181, b=216 },
    },
    {
        index=88,
        name="MetallicTaxiYellow",
        hex="#ffcf20",
        rgb={r=255, g=207, b=32 },
    },
    {
        index=89,
        name="MetallicRaceYellow",
        hex="#fbe212",
        rgb={r=251, g=226, b=18 },
    },
    {
        index=90,
        name="MetallicBronze",
        hex="#916532",
        rgb={r=145, g=101, b=50 },
    },
    {
        index=91,
        name="MetallicYellowBird",
        hex="#e0e13d",
        rgb={r=224, g=225, b=61 },
    },
    {
        index=92,
        name="MetallicLime",
        hex="#98d223",
        rgb={r=152, g=210, b=35 },
    },
    {
        index=93,
        name="MetallicChampagne",
        hex="#9b8c78",
        rgb={r=155, g=140, b=120 },
    },
    {
        index=94,
        name="MetallicPuebloBeige",
        hex="#503218",
        rgb={r=80, g=50, b=24 },
    },
    {
        index=95,
        name="MetallicDarkIvory",
        hex="#473f2b",
        rgb={r=71, g=63, b=43 },
    },
    {
        index=96,
        name="MetallicChocoBrown",
        hex="#221b19",
        rgb={r=34, g=27, b=25 },
    },
    {
        index=97,
        name="MetallicGoldenBrown",
        hex="#653f23",
        rgb={r=101, g=63, b=35 },
    },
    {
        index=98,
        name="MetallicLightBrown",
        hex="#775c3e",
        rgb={r=119, g=92, b=62 },
    },
    {
        index=99,
        name="MetallicStrawBeige",
        hex="#ac9975",
        rgb={r=172, g=153, b=117 },
    },
    {
        index=100,
        name="MetallicMossBrown",
        hex="#6c6b4b",
        rgb={r=108, g=107, b=75 },
    },
    {
        index=101,
        name="MetallicBistonBrown",
        hex="#402e2b",
        rgb={r=64, g=46, b=43 },
    },
    {
        index=102,
        name="MetallicBeechwood",
        hex="#a4965f",
        rgb={r=164, g=150, b=95 },
    },
    {
        index=103,
        name="MetallicDarkBeechwood",
        hex="#46231a",
        rgb={r=70, g=35, b=26 },
    },
    {
        index=104,
        name="MetallicChocoOrange",
        hex="#752b19",
        rgb={r=117, g=43, b=25 },
    },
    {
        index=105,
        name="MetallicBeachSand",
        hex="#bfae7b",
        rgb={r=191, g=174, b=123 },
    },
    {
        index=106,
        name="MetallicSunBleechedSand",
        hex="#dfd5b2",
        rgb={r=223, g=213, b=178 },
    },
    {
        index=107,
        name="MetallicCream",
        hex="#f7edd5",
        rgb={r=247, g=237, b=213 },
    },
    {
        index=108,
        name="UtilBrown",
        hex="#3a2a1b",
        rgb={r=58, g=42, b=27 },
    },
    {
        index=109,
        name="UtilMediumBrown",
        hex="#785f33",
        rgb={r=120, g=95, b=51 },
    },
    {
        index=110,
        name="UtilLightBrown",
        hex="#b5a079",
        rgb={r=181, g=160, b=121 },
    },
    {
        index=111,
        name="MetallicWhite",
        hex="#fffff6",
        rgb={r=255, g=255, b=246 },
    },
    {
        index=112,
        name="MetallicFrostWhite",
        hex="#eaeaea",
        rgb={r=234, g=234, b=234 },
    },
    {
        index=113,
        name="WornHoneyBeige",
        hex="#b0ab94",
        rgb={r=176, g=171, b=148 },
    },
    {
        index=114,
        name="WornBrown",
        hex="#453831",
        rgb={r=69, g=56, b=49 },
    },
    {
        index=115,
        name="WornDarkBrown",
        hex="#2a282b",
        rgb={r=42, g=40, b=43 },
    },
    {
        index=116,
        name="Wornstrawbeige",
        hex="#726c57",
        rgb={r=114, g=108, b=87 },
    },
    {
        index=117,
        name="BrushedSteel",
        hex="#6a747c",
        rgb={r=106, g=116, b=124 },
    },
    {
        index=118,
        name="BrushedBlacksteel",
        hex="#354158",
        rgb={r=53, g=65, b=88 },
    },
    {
        index=119,
        name="BrushedAluminium",
        hex="#9ba0a8",
        rgb={r=155, g=160, b=168 },
    },
    {
        index=120,
        name="Chrome",
        hex="#5870a1",
        rgb={r=88, g=112, b=161 },
    },
    {
        index=121,
        name="WornOffWhite",
        hex="#eae6de",
        rgb={r=234, g=230, b=222 },
    },
    {
        index=122,
        name="UtilOffWhite",
        hex="#dfddd0",
        rgb={r=223, g=221, b=208 },
    },
    {
        index=123,
        name="WornOrange",
        hex="#f2ad2e",
        rgb={r=242, g=173, b=46 },
    },
    {
        index=124,
        name="WornLightOrange",
        hex="#f9a458",
        rgb={r=249, g=164, b=88 },
    },
    {
        index=125,
        name="MetallicSecuricorGreen",
        hex="#83c566",
        rgb={r=131, g=197, b=102 },
    },
    {
        index=126,
        name="WornTaxiYellow",
        hex="#f1cc40",
        rgb={r=241, g=204, b=64 },
    },
    {
        index=127,
        name="policecarblue",
        hex="#4cc3da",
        rgb={r=76, g=195, b=218 },
    },
    {
        index=128,
        name="MatteGreen",
        hex="#4e6443",
        rgb={r=78, g=100, b=67 },
    },
    {
        index=129,
        name="MatteBrown",
        hex="#bcac8f",
        rgb={r=188, g=172, b=143 },
    },
    {
        index=130,
        name="WornOrange",
        hex="#f8b658",
        rgb={r=248, g=182, b=88 },
    },
    {
        index=131,
        name="MatteWhite",
        hex="#fcf9f1",
        rgb={r=252, g=249, b=241 },
    },
    {
        index=132,
        name="WornWhite",
        hex="#fffffb",
        rgb={r=255, g=255, b=251 },
    },
    {
        index=133,
        name="WornOliveArmyGreen",
        hex="#81844c",
        rgb={r=129, g=132, b=76 },
    },
    {
        index=134,
        name="PureWhite",
        hex="#ffffff",
        rgb={r=255, g=255, b=255 },
    },
    {
        index=135,
        name="HotPink",
        hex="#f21f99",
        rgb={r=242, g=31, b=153 },
    },
    {
        index=136,
        name="Salmonpink",
        hex="#fdd6cd",
        rgb={r=253, g=214, b=205 },
    },
    {
        index=137,
        name="MetallicVermillionPink",
        hex="#df5891",
        rgb={r=223, g=88, b=145 },
    },
    {
        index=138,
        name="Orange",
        hex="#f6ae20",
        rgb={r=246, g=174, b=32 },
    },
    {
        index=139,
        name="Green",
        hex="#b0ee6e",
        rgb={r=176, g=238, b=110 },
    },
    {
        index=140,
        name="Blue",
        hex="#08e9fa",
        rgb={r=8, g=233, b=250 },
    },
    {
        index=141,
        name="MettalicBlackBlue",
        hex="#0a0c17",
        rgb={r=10, g=12, b=23 },
    },
    {
        index=142,
        name="MetallicBlackPurple",
        hex="#0c0d18",
        rgb={r=12, g=13, b=24 },
    },
    {
        index=143,
        name="MetallicBlackRed",
        hex="#0e0d14",
        rgb={r=14, g=13, b=20 },
    },
    {
        index=144,
        name="HunterGreen",
        hex="#9f9e8a",
        rgb={r=159, g=158, b=138 },
    },
    {
        index=145,
        name="MetallicPurple",
        hex="#621276",
        rgb={r=98, g=18, b=118 },
    },
    {
        index=146,
        name="MetaillicVDarkBlue",
        hex="#0b1421",
        rgb={r=11, g=20, b=33 },
    },
    {
        index=147,
        name="ModShopBlack1",
        hex="#11141a",
        rgb={r=17, g=20, b=26 },
    },
    {
        index=148,
        name="MattePurple",
        hex="#6b1f7b",
        rgb={r=107, g=31, b=123 },
    },
    {
        index=149,
        name="MatteDarkPurple",
        hex="#1e1d22",
        rgb={r=30, g=29, b=34 },
    },
    {
        index=150,
        name="MetallicLavaRed",
        hex="#bc1917",
        rgb={r=188, g=25, b=23 },
    },
    {
        index=151,
        name="MatteForestGreen",
        hex="#2d362a",
        rgb={r=45, g=54, b=42 },
    },
    {
        index=152,
        name="MatteOliveDrab",
        hex="#696748",
        rgb={r=105, g=103, b=72 },
    },
    {
        index=153,
        name="MatteDesertBrown",
        hex="#7a6c55",
        rgb={r=122, g=108, b=85 },
    },
    {
        index=154,
        name="MatteDesertTan",
        hex="#c3b492",
        rgb={r=195, g=180, b=146 },
    },
    {
        index=155,
        name="MatteFoilageGreen",
        hex="#5a6352",
        rgb={r=90, g=99, b=82 },
    },
    {
        index=156,
        name="DefaultAlloyColor",
        hex="#81827f",
        rgb={r=129, g=130, b=127 },
    },
    {
        index=157,
        name="EpsilonBlue",
        hex="#afd6e4",
        rgb={r=175, g=214, b=228 },
    },
    {
        index=158,
        name="PureGold",
        hex="#7a6440",
        rgb={r=122, g=100, b=64 },
    },
    {
        index=159,
        name="BrushedGold",
        hex="#7f6a48",
        rgb={r=127, g=106, b=72},
    },
}

constants.bone_index_names = {
    {
        name="Ped",
        bone_names={
            "SKEL_ROOT",
            "SKEL_Pelvis",
            "SKEL_L_Thigh",
            "SKEL_L_Calf",
            "SKEL_L_Foot",
            "SKEL_L_Toe0",
            "IK_L_Foot",
            "PH_L_Foot",
            "MH_L_Knee",
            "SKEL_R_Thigh",
            "SKEL_R_Calf",
            "SKEL_R_Foot",
            "SKEL_R_Toe0",
            "IK_R_Foot",
            "PH_R_Foot",
            "MH_R_Knee",
            "RB_L_ThighRoll",
            "RB_R_ThighRoll",
            "SKEL_Spine_Root",
            "SKEL_Spine0",
            "SKEL_Spine1",
            "SKEL_Spine2",
            "SKEL_Spine3",
            "SKEL_L_Clavicle",
            "SKEL_L_UpperArm",
            "SKEL_L_Forearm",
            "SKEL_L_Hand",
            "SKEL_L_Finger00",
            "SKEL_L_Finger01",
            "SKEL_L_Finger02",
            "SKEL_L_Finger10",
            "SKEL_L_Finger11",
            "SKEL_L_Finger12",
            "SKEL_L_Finger20",
            "SKEL_L_Finger21",
            "SKEL_L_Finger22",
            "SKEL_L_Finger30",
            "SKEL_L_Finger31",
            "SKEL_L_Finger32",
            "SKEL_L_Finger40",
            "SKEL_L_Finger41",
            "SKEL_L_Finger42",
            "PH_L_Hand",
            "IK_L_Hand",
            "RB_L_ForeArmRoll",
            "RB_L_ArmRoll",
            "MH_L_Elbow",
            "SKEL_R_Clavicle",
            "SKEL_R_UpperArm",
            "SKEL_R_Forearm",
            "SKEL_R_Hand",
            "SKEL_R_Finger00",
            "SKEL_R_Finger01",
            "SKEL_R_Finger02",
            "SKEL_R_Finger10",
            "SKEL_R_Finger11",
            "SKEL_R_Finger12",
            "SKEL_R_Finger20",
            "SKEL_R_Finger21",
            "SKEL_R_Finger22",
            "SKEL_R_Finger30",
            "SKEL_R_Finger31",
            "SKEL_R_Finger32",
            "SKEL_R_Finger40",
            "SKEL_R_Finger41",
            "SKEL_R_Finger42",
            "PH_R_Hand",
            "IK_R_Hand",
            "RB_R_ForeArmRoll",
            "RB_R_ArmRoll",
            "MH_R_Elbow",
            "SKEL_Neck_1",
            "SKEL_Head",
            "IK_Head",
            "FACIAL_facialRoot",
            "FB_L_Brow_Out_000",
            "FB_L_Lid_Upper_000",
            "FB_L_Eye_000",
            "FB_L_CheekBone_000",
            "FB_L_Lip_Corner_000",
            "FB_R_Lid_Upper_000",
            "FB_R_Eye_000",
            "FB_R_CheekBone_000",
            "FB_R_Brow_Out_000",
            "FB_R_Lip_Corner_000",
            "FB_Brow_Centre_000",
            "FB_UpperLipRoot_000",
            "FB_UpperLip_000",
            "FB_L_Lip_Top_000",
            "FB_R_Lip_Top_000",
            "FB_Jaw_000",
            "FB_LowerLipRoot_000",
            "FB_LowerLip_000",
            "FB_L_Lip_Bot_000",
            "FB_R_Lip_Bot_000",
            "FB_Tongue_000",
            "RB_Neck_1",
            "IK_Root",
        }
    },
    {
        name="Vehicle",
        bone_names={
            "chassis",
            "chassis_lowlod",
            "chassis_dummy",
            "seat_dside_f",
            "seat_dside_r",
            "seat_dside_r1",
            "seat_dside_r2",
            "seat_dside_r3",
            "seat_dside_r4",
            "seat_dside_r5",
            "seat_dside_r6",
            "seat_dside_r7",
            "seat_pside_f",
            "seat_pside_r",
            "seat_pside_r1",
            "seat_pside_r2",
            "seat_pside_r3",
            "seat_pside_r4",
            "seat_pside_r5",
            "seat_pside_r6",
            "seat_pside_r7",
            "window_lf1",
            "window_lf2",
            "window_lf3",
            "window_rf1",
            "window_rf2",
            "window_rf3",
            "window_lr1",
            "window_lr2",
            "window_lr3",
            "window_rr1",
            "window_rr2",
            "window_rr3",
            "door_dside_f",
            "door_dside_r",
            "door_pside_f",
            "door_pside_r",
            "handle_dside_f",
            "handle_dside_r",
            "handle_pside_f",
            "handle_pside_r",
            "wheel_lf",
            "wheel_rf",
            "wheel_lm1",
            "wheel_rm1",
            "wheel_lm2",
            "wheel_rm2",
            "wheel_lm3",
            "wheel_rm3",
            "wheel_lr",
            "wheel_rr",
            "suspension_lf",
            "suspension_rf",
            "suspension_lm",
            "suspension_rm",
            "suspension_lr",
            "suspension_rr",
            "spring_rf",
            "spring_lf",
            "spring_rr",
            "spring_lr",
            "transmission_f",
            "transmission_m",
            "transmission_r",
            "hub_lf",
            "hub_rf",
            "hub_lm1",
            "hub_rm1",
            "hub_lm2",
            "hub_rm2",
            "hub_lm3",
            "hub_rm3",
            "hub_lr",
            "hub_rr",
            "windscreen",
            "windscreen_r",
            "window_lf",
            "window_rf",
            "window_lr",
            "window_rr",
            "window_lm",
            "window_rm",
            "bodyshell",
            "bumper_f",
            "bumper_r",
            "wing_rf",
            "wing_lf",
            "bonnet",
            "boot",
            "exhaust",
            "exhaust_2",
            "exhaust_3",
            "exhaust_4",
            "exhaust_5",
            "exhaust_6",
            "exhaust_7",
            "exhaust_8",
            "exhaust_9",
            "exhaust_10",
            "exhaust_11",
            "exhaust_12",
            "exhaust_13",
            "exhaust_14",
            "exhaust_15",
            "exhaust_16",
            "engine",
            "overheat",
            "overheat_2",
            "petrolcap",
            "petroltank",
            "petroltank_l",
            "petroltank_r",
            "steering",
            "hbgrip_l",
            "hbgrip_r",
            "headlight_l",
            "headlight_r",
            "taillight_l",
            "taillight_r",
            "indicator_lf",
            "indicator_rf",
            "indicator_lr",
            "indicator_rr",
            "brakelight_l",
            "brakelight_r",
            "brakelight_m",
            "reversinglight_l",
            "reversinglight_r",
            "extralight_1",
            "extralight_2",
            "extralight_3",
            "extralight_4",
            "numberplate",
            "interiorlight",
            "siren1",
            "siren2",
            "siren3",
            "siren4",
            "siren5",
            "siren6",
            "siren7",
            "siren8",
            "siren9",
            "siren10",
            "siren11",
            "siren12",
            "siren13",
            "siren14",
            "siren15",
            "siren16",
            "siren17",
            "siren18",
            "siren19",
            "siren20",
            "siren_glass1",
            "siren_glass2",
            "siren_glass3",
            "siren_glass4",
            "siren_glass5",
            "siren_glass6",
            "siren_glass7",
            "siren_glass8",
            "siren_glass9",
            "siren_glass10",
            "siren_glass11",
            "siren_glass12",
            "siren_glass13",
            "siren_glass14",
            "siren_glass15",
            "siren_glass16",
            "siren_glass17",
            "siren_glass18",
            "siren_glass19",
            "siren_glass20",
            "spoiler",
            "struts",
            "misc_a",
            "misc_b",
            "misc_c",
            "misc_d",
            "misc_e",
            "misc_f",
            "misc_g",
            "misc_h",
            "misc_i",
            "misc_j",
            "misc_k",
            "misc_l",
            "misc_m",
            "misc_n",
            "misc_o",
            "misc_p",
            "misc_q",
            "misc_r",
            "misc_s",
            "misc_t",
            "misc_u",
            "misc_v",
            "misc_w",
            "misc_x",
            "misc_y",
            "misc_z",
            "misc_1",
            "misc_2",
            "weapon_1a",
            "weapon_1b",
            "weapon_1c",
            "weapon_1d",
            "weapon_1a_rot",
            "weapon_1b_rot",
            "weapon_1c_rot",
            "weapon_1d_rot",
            "weapon_2a",
            "weapon_2b",
            "weapon_2c",
            "weapon_2d",
            "weapon_2a_rot",
            "weapon_2b_rot",
            "weapon_2c_rot",
            "weapon_2d_rot",
            "weapon_3a",
            "weapon_3b",
            "weapon_3c",
            "weapon_3d",
            "weapon_3a_rot",
            "weapon_3b_rot",
            "weapon_3c_rot",
            "weapon_3d_rot",
            "weapon_4a",
            "weapon_4b",
            "weapon_4c",
            "weapon_4d",
            "weapon_4a_rot",
            "weapon_4b_rot",
            "weapon_4c_rot",
            "weapon_4d_rot",
            "turret_1base",
            "turret_1barrel",
            "turret_2base",
            "turret_2barrel",
            "turret_3base",
            "turret_3barrel",
            "ammobelt",
            "searchlight_base",
            "searchlight_light",
            "attach_female",
            "roof",
            "roof2",
            "soft_1",
            "soft_2",
            "soft_3",
            "soft_4",
            "soft_5",
            "soft_6",
            "soft_7",
            "soft_8",
            "soft_9",
            "soft_10",
            "soft_11",
            "soft_12",
            "soft_13",
            "forks",
            "mast",
            "carriage",
            "fork_l",
            "fork_r",
            "forks_attach",
            "frame_1",
            "frame_2",
            "frame_3",
            "frame_pickup_1",
            "frame_pickup_2",
            "frame_pickup_3",
            "frame_pickup_4",
            "freight_cont",
            "freight_bogey",
            "freightgrain_slidedoor",
            "door_hatch_r",
            "door_hatch_l",
            "tow_arm",
            "tow_mount_a",
            "tow_mount_b",
            "tipper",
            "combine_reel",
            "combine_auger",
            "slipstream_l",
            "slipstream_r",
            "arm_1",
            "arm_2",
            "arm_3",
            "arm_4",
            "scoop",
            "boom",
            "stick",
            "bucket",
            "shovel_2",
            "shovel_3",
            "Lookat_UpprPiston_head",
            "Lookat_LowrPiston_boom",
            "Boom_Driver",
            "cutter_driver",
            "vehicle_blocker",
            "extra_1",
            "extra_2",
            "extra_3",
            "extra_4",
            "extra_5",
            "extra_6",
            "extra_7",
            "extra_8",
            "extra_9",
            "extra_ten",
            "extra_11",
            "extra_12",
            "break_extra_1",
            "break_extra_2",
            "break_extra_3",
            "break_extra_4",
            "break_extra_5",
            "break_extra_6",
            "break_extra_7",
            "break_extra_8",
            "break_extra_9",
            "break_extra_10",
            "mod_col_1",
            "mod_col_2",
            "mod_col_3",
            "mod_col_4",
            "mod_col_5",
            "handlebars",
            "forks_u",
            "forks_l",
            "wheel_f",
            "swingarm",
            "wheel_r",
            "crank",
            "pedal_r",
            "pedal_l",
            "static_prop",
            "moving_prop",
            "static_prop2",
            "moving_prop2",
            "rudder",
            "rudder2",
            "wheel_rf1_dummy",
            "wheel_rf2_dummy",
            "wheel_rf3_dummy",
            "wheel_rb1_dummy",
            "wheel_rb2_dummy",
            "wheel_rb3_dummy",
            "wheel_lf1_dummy",
            "wheel_lf2_dummy",
            "wheel_lf3_dummy",
            "wheel_lb1_dummy",
            "wheel_lb2_dummy",
            "wheel_lb3_dummy",
            "bogie_front",
            "bogie_rear",
            "rotor_main",
            "rotor_rear",
            "rotor_main_2",
            "rotor_rear_2",
            "elevators",
            "tail",
            "outriggers_l",
            "outriggers_r",
            "rope_attach_a",
            "rope_attach_b",
            "prop_1",
            "prop_2",
            "elevator_l",
            "elevator_r",
            "rudder_l",
            "rudder_r",
            "prop_3",
            "prop_4",
            "prop_5",
            "prop_6",
            "prop_7",
            "prop_8",
            "rudder_2",
            "aileron_l",
            "aileron_r",
            "airbrake_l",
            "airbrake_r",
            "wing_l",
            "wing_r",
            "wing_lr",
            "wing_rr",
            "engine_l",
            "engine_r",
            "nozzles_f",
            "nozzles_r",
            "afterburner",
            "wingtip_1",
            "wingtip_2",
            "gear_door_fl",
            "gear_door_fr",
            "gear_door_rl1",
            "gear_door_rr1",
            "gear_door_rl2",
            "gear_door_rr2",
            "gear_door_rml",
            "gear_door_rmr",
            "gear_f",
            "gear_rl",
            "gear_lm1",
            "gear_rr",
            "gear_rm1",
            "gear_rm",
            "prop_left",
            "prop_right",
            "legs",
            "attach_male",
            "draft_animal_attach_lr",
            "draft_animal_attach_rr",
            "draft_animal_attach_lm",
            "draft_animal_attach_rm",
            "draft_animal_attach_lf",
            "draft_animal_attach_rf",
            "wheelcover_l",
            "wheelcover_r",
            "barracks",
            "pontoon_l",
            "pontoon_r",
            "no_ped_col_step_l",
            "no_ped_col_strut_1_l",
            "no_ped_col_strut_2_l",
            "no_ped_col_step_r",
            "no_ped_col_strut_1_r",
            "no_ped_col_strut_2_r",
            "light_cover",
            "emissives",
            "neon_l",
            "neon_r",
            "neon_f",
            "neon_b",
            "dashglow",
            "doorlight_lf",
            "doorlight_rf",
            "doorlight_lr",
            "doorlight_rr",
            "unknown_id",
            "dials",
            "engineblock",
            "bobble_head",
            "bobble_base",
            "bobble_hand",
            "chassis_Control"
        }
    },
    {
        name = "Weapon",
        bone_names = {
            "gun_root",
            "gun_gripr",
            "gun_gripl",
            "gun_muzzle",
            "gun_vfx_eject",
            "gun_magazine",
            "gun_ammo",
            "gun_vfx_projtrail",
            "gun_barrels",
            "WAPClip",
            "WAPClip_2",
            "WAPScop",
            "WAPScop_2",
            "WAPGrip",
            "WAPGrip_2",
            "WAPSupp",
            "WAPSupp_2",
            "WAPFlsh",
            "WAPFlsh_2",
            "WAPStck",
            "WAPSeWp",
            "WAPLasr",
            "WAPLasr_2",
            "WAPFlshLasr",
            "WAPFlshLasr_2",
            "NM_Butt_Marker",
            "Gun_GripR",
            "Gun_Nuzzle",
            "gun_drum",
        },
    },
}

constants.ped_weapons = {
    {
        name="Pistol",
        is_folder = true,
        items ={
            {
                name="Pistol",
                model="weapon_pistol",
                type="WEAPON",
            },
            {
                name="Pistol (Luxury)",
                model="weapon_pistol",
                component="COMPONENT_PISTOL_VARMOD_LUXE",
                type="WEAPON",
            },
            {
                name="Combat Pistol",
                model="COMPONENT_COMBATPISTOL_VARMOD_LOWRIDER",
                type="WEAPON",
            },
            {
                name="AP Pistol",
                model="COMPONENT_APPISTOL_VARMOD_LUXE",
                type="WEAPON",
            },
            {
                name="Pistol .50",
                model="COMPONENT_PISTOL50_VARMOD_LUXE",
                type="WEAPON",
            },
            {
                name="SNS Pistol",
                model="COMPONENT_SNSPISTOL_VARMOD_LOWRIDER",
                type="WEAPON",
            },
            {
                name="Heavy Pistol",
                model="COMPONENT_HEAVYPISTOL_VARMOD_LUXE",
                type="WEAPON",
            },
            {
                name="SNS Pistol Mk II",
                model="WEAPON_SNSPISTOL_MK2",
                type="WEAPON",
            },
            {
                name="Up-n-Atomizer",
                model="COMPONENT_RAYPISTOL_VARMOD_XMAS18",
                type="WEAPON",
            },
            {
                name="Heavy Revolver Mk II",
                model="WEAPON_REVOLVER_MK2",
                type="WEAPON",
            },
            {
                name="Vintage Pistol",
                model="WEAPON_VINTAGEPISTOL",
                type="WEAPON",
            },
            {
                name="Double-Action Revolver",
                model="WEAPON_DOUBLEACTION",
                type="WEAPON",
            },
            {
                name="Ceramic Pistol",
                model="WEAPON_CERAMICPISTOL",
                type="WEAPON",
            },
            {
                name="Perico Pistol",
                model="WEAPON_GADGETPISTOL",
                type="WEAPON",
            },
            {
                name="Flare Gun",
                model="WEAPON_FLAREGUN",
                type="WEAPON",
            },
            {
                name="Navy Revolver",
                model="WEAPON_NAVYREVOLVER",
                type="WEAPON",
            },
            {
                name="Marksman Pistol",
                model="WEAPON_MARKSMANPISTOL",
                type="WEAPON",
            },
            {
                name="Heavy Revolver",
                model="COMPONENT_REVOLVER_VARMOD_BOSS",
                type="WEAPON",
            },
            {
                name="Pistol Mk II",
                model="WEAPON_PISTOL_MK2",
                type="WEAPON",
            }
        }
    },
    {
        name="Sub Machine Gun",
        is_folder = true,
        items = {
            {
                name="Micro SMG",
                model="COMPONENT_MICROSMG_VARMOD_LUXE",
                type="WEAPON",
            },
            {
                name="SMG",
                model="COMPONENT_SMG_VARMOD_LUXE",
                type="WEAPON",
            },
            {
                name="Assault SMG",
                model="COMPONENT_ASSAULTSMG_VARMOD_LOWRIDER",
                type="WEAPON",
            },
            {
                name="Combat PDW",
                model="WEAPON_COMBATPDW",
                type="WEAPON",
            },
            {
                name="Machine Pistol",
                model="WEAPON_MACHINEPISTOL",
                type="WEAPON",
            },
            {
                name="Mini SMG",
                model="WEAPON_MINISMG",
                type="WEAPON",
            },
            {
                name="SMG Mk II",
                model="WEAPON_SMG_MK2",
                type="WEAPON",
            },
        }
    },
    {
        name="Machine Gun (MG)",
        is_folder = true,
        items ={
            {
                name="MG",
                model="COMPONENT_MG_VARMOD_LOWRIDER",
                type="WEAPON",
            },
            {
                name="Combat MG",
                model="WEAPON_COMBATMG",
                type="WEAPON",
            },
            {
                name="Unholy Hellbringer",
                model="WEAPON_RAYCARBINE",
                type="WEAPON",
            },
            {
                name="Gusenberg Sweeper",
                model="WEAPON_GUSENBERG",
                type="WEAPON",
            },
            {
                name="Combat MG Mk II",
                model="WEAPON_COMBATMG_MK2",
                type="WEAPON",
            },
        }
    },
    {
        name="Rifles",
        is_folder = true,
        items ={
            {
                name="Assault Rifle",
                model="COMPONENT_ASSAULTRIFLE_VARMOD_LUXE",
                type="WEAPON",
            },
            {
                name="Carbine Rifle",
                model="COMPONENT_CARBINERIFLE_VARMOD_LUXE",
                type="WEAPON",
            },
            {
                name="Advanced Rifle",
                model="WEAPON_ADVANCEDRIFLE",
                type="WEAPON",
            },
            {
                name="Bullpup Rifle",
                model="COMPONENT_BULLPUPRIFLE_VARMOD_LOW",
                type="WEAPON",
            },
            {
                name="Special Carbine",
                model="COMPONENT_SPECIALCARBINE_VARMOD_LOWRIDER",
                type="WEAPON",
            },
            {
                name="Special Carbine Mk II",
                model="WEAPON_SPECIALCARBINE_MK2",
                type="WEAPON",
            },
            {
                name="Bullpup Rifle Mk II",
                model="WEAPON_BULLPUPRIFLE_MK2",
                type="WEAPON",
            },
            {
                name="Military Rifle",
                model="WEAPON_MILITARYRIFLE",
                type="WEAPON",
            },
            {
                name="Compact Rifle",
                model="WEAPON_COMPACTRIFLE",
                type="WEAPON",
            },
            {
                name="Carbine Rifle Mk II",
                model="WEAPON_CARBINERIFLE_MK2",
                type="WEAPON",
            },
            {
                name="Assault Rifle Mk II",
                model="WEAPON_ASSAULTRIFLE_MK2",
                type="WEAPON",
            },
            {
                name="Service Carbine",
                model="WEAPON_TACTICALRIFLE",
                type="WEAPON",
            },
            {
                name="Heavy Rifle",
                model="WEAPON_HEAVYRIFLE",
                type="WEAPON",
            },
        }
    },
    {
        name="Sniper",
        is_folder = true,
        items ={
            {
                name="Sniper Rifle",
                model="WEAPON_SNIPERRIFLE",
                type="WEAPON",
            },
            {
                name="Heavy Sniper",
                model="WEAPON_HEAVYSNIPER",
                type="WEAPON",
            },
            {
                name="Marksman Rifle Mk II",
                model="WEAPON_MARKSMANRIFLE_MK2",
                type="WEAPON",
            },
            {
                name="Musket",
                model="WEAPON_MUSKET",
                type="WEAPON",
            },
            {
                name="Marksman Rifle",
                model="WEAPON_MARKSMANRIFLE",
                type="WEAPON",
            },
            {
                name="Heavy Sniper Mk II",
                model="WEAPON_HEAVYSNIPER_MK2",
                type="WEAPON",
            },
            {
                name="Precision Rifle",
                model="WEAPON_PRECISIONRIFLE",
                type="WEAPON",
            },
        }
    },
    {
        name="Melee",
        is_folder = true,
        items ={
            {
                name="Knife",
                model="WEAPON_KNIFE",
                type="WEAPON",
            },
            {
                name="Nightstick",
                model="WEAPON_NIGHTSTICK",
                type="WEAPON",
            },
            {
                name="Hammer",
                model="WEAPON_HAMMER",
                type="WEAPON",
            },
            {
                name="Baseball Bat",
                model="WEAPON_BAT",
                type="WEAPON",
            },
            {
                name="Golf Club",
                model="WEAPON_GOLFCLUB",
                type="WEAPON",
            },
            {
                name="Crowbar",
                model="WEAPON_CROWBAR",
                type="WEAPON",
            },
            {
                name="Bottle",
                model="WEAPON_BOTTLE",
                type="WEAPON",
            },
            {
                name="Antique Cavalry Dagger",
                model="WEAPON_DAGGER",
                type="WEAPON",
            },
            {
                name="Hatchet",
                model="WEAPON_HATCHET",
                type="WEAPON",
            },
            {
                name="Machete",
                model="WEAPON_MACHETE",
                type="WEAPON",
            },
            {
                name="Flashlight",
                model="WEAPON_FLASHLIGHT",
                type="WEAPON",
            },
            {
                name="Switchblade",
                model="COMPONENT_SWITCHBLADE_VARMOD_VAR1",
                type="WEAPON",
            },
            {
                name=" Battle Axe",
                model="WEAPON_BATTLEAXE",
                type="WEAPON",
            },
            {
                name="Pipe Wrench",
                model="WEAPON_WRENCH",
                type="WEAPON",
            },
            {
                name="Pool Cue ",
                model="WEAPON_POOLCUE",
                type="WEAPON",
            },
            {
                name="Stone Hatchet",
                model="WEAPON_STONE_HATCHET",
                type="WEAPON",
            },
        }
    },
    {
        name="Shotguns",
        is_folder = true,
        items ={
            {
                name="Pump Shotgun",
                model="WEAPON_PUMPSHOTGUN",
                type="WEAPON",
            },
            {
                name="Sawed-Off Shotgun",
                model="COMPONENT_SAWNOFFSHOTGUN_VARMOD_LUXE",
                type="WEAPON",
            },
            {
                name="Assault Shotgun",
                model="WEAPON_ASSAULTSHOTGUN",
                type="WEAPON",
            },
            {
                name="Bullpup Shotgun",
                model="WEAPON_BULLPUPSHOTGUN",
                type="WEAPON",
            },
            {
                name="Pump Shotgun Mk II",
                model="WEAPON_PUMPSHOTGUN_MK2",
                type="WEAPON",
            },
            {
                name="Heavy Shotgun",
                model="WEAPON_HEAVYSHOTGUN",
                type="WEAPON",
            },
            {
                name="Combat Shotgun",
                model="WEAPON_COMBATSHOTGUN",
                type="WEAPON",
            },
            {
                name="Double Barrel Shotgun",
                model="WEAPON_DBSHOTGUN",
                type="WEAPON",
            },
            {
                name="Sweeper Shotgun",
                model="WEAPON_AUTOSHOTGUN",
                type="WEAPON",
            },
        }
    },
    {
        name="Heavy",
        is_folder = true,
        items ={
            {
                name="Grenade Launcher",
                model="WEAPON_GRENADELAUNCHER",
                type="WEAPON",
            },
            {
                name="Tear Gas Launcher",
                model="WEAPON_GRENADELAUNCHER_SMOKE",
                type="WEAPON",
            },
            {
                name="RPG",
                model="WEAPON_RPG",
                type="WEAPON",
            },
            {
                name="Minigun",
                model="WEAPON_MINIGUN",
                type="WEAPON",
            },
            {
                name="Widowmaker",
                model="WEAPON_RAYMINIGUN",
                type="WEAPON",
            },
            {
                name="Homing Launcher",
                model="WEAPON_HOMINGLAUNCHER",
                type="WEAPON",
            },
            {
                name="Firework Launcher",
                model="WEAPON_FIREWORK",
                type="WEAPON",
            },
            {
                name="Railgun",
                model="WEAPON_RAILGUN",
                type="WEAPON",
            },
            {
                name="Compact Grenade Launcher",
                model="WEAPON_COMPACTLAUNCHER",
                type="WEAPON",
            },
            {
                name="Compact EMP Launcher",
                model="WEAPON_EMPLAUNCHER",
                type="WEAPON",
            },
        }
    },
    {
        name="Throwables",
        is_folder = true,
        items ={
            {
                name="Grenade",
                model="WEAPON_GRENADE",
                type="WEAPON",
            },
            {
                name="Sticky Bomb",
                model="WEAPON_STICKYBOMB",
                type="WEAPON",
            },
            {
                name="Tear Gas",
                model="WEAPON_SMOKEGRENADE",
                type="WEAPON",
            },
            {
                name="Molotov",
                model="WEAPON_MOLOTOV",
                type="WEAPON",
            },
            {
                name="Baseball",
                model="WEAPON_BALL",
                type="WEAPON",
            },
            {
                name="Flare",
                model="WEAPON_FLARE",
                type="WEAPON",
            },
            {
                name="Snowball",
                model="WEAPON_SNOWBALL",
                type="WEAPON",
            },
            {
                name="Proximity Mine",
                model="WEAPON_PROXMINE",
                type="WEAPON",
            },
            {
                name="Pipe Bomb",
                model="WEAPON_PIPEBOMB",
                type="WEAPON",
            },
        }
    }
}

constants.animation_flags = {
    ANIM_FLAG_NORMAL = 0,
    ANIM_FLAG_REPEAT = 1,
    ANIM_FLAG_STOP_LAST_FRAME = 2,
    ANIM_FLAG_UPPERBODY = 16,
    ANIM_FLAG_ENABLE_PLAYER_CONTROL = 32,
    ANIM_FLAG_CANCELABLE = 120
}

constants.animations = {
    is_folder = true,
    items = { {
                  is_folder = true,
                  items = { {
                                clip = "bind_pose_180",
                                dictionary = "mp_sleep",
                                loop = true,
                                name = "A-Pose"
                            }, {
                                clip = "michael_tux_fidget",
                                controllable = true,
                                dictionary = "missmic4",
                                emote_duration = 4000,
                                name = "Adjust"
                            }, {
                                clip = "air_guitar",
                                dictionary = "anim@mp_player_intcelebrationfemale@air_guitar",
                                name = "Air Guitar"
                            }, {
                                clip = "ledge_loop",
                                controllable = true,
                                dictionary = "missfbi1",
                                loop = true,
                                name = "Air Plane"
                            }, {
                                clip = "air_synth",
                                dictionary = "anim@mp_player_intcelebrationfemale@air_synth",
                                name = "Air Synth"
                            }, {
                                clip = "actor_berating_loop",
                                controllable = true,
                                dictionary = "misscarsteal4@actor",
                                loop = true,
                                name = "Argue"
                            }, {
                                clip = "argue_a",
                                controllable = true,
                                dictionary = "oddjobs@assassinate@vice@hooker",
                                loop = true,
                                name = "Argue 2"
                            }, {
                                clip = "brotheradrianhasshown_2",
                                controllable = true,
                                dictionary = "special_ped@jane@monologue_5@monologue_5c",
                                emote_duration = 3000,
                                name = "BOI"
                            }, {
                                clip = "wakeup",
                                dictionary = "random@peyote@dog",
                                name = "Bark"
                            }, {
                                clip = "idle_a_bartender",
                                controllable = true,
                                dictionary = "anim@amb@clubhouse@bar@drink@idle_a",
                                loop = true,
                                name = "Bartender"
                            }, {
                                clip = "beast_transform",
                                controllable = true,
                                dictionary = "anim@mp_fm_event@intro",
                                emote_duration = 5000,
                                name = "Beast"
                            }, {
                                clip = "wakeup",
                                dictionary = "random@peyote@bird",
                                name = "Bird"
                            }, {
                                clip = "blow_kiss",
                                dictionary = "anim@mp_player_intcelebrationfemale@blow_kiss",
                                name = "Blow Kiss"
                            }, {
                                clip = "exit",
                                controllable = true,
                                dictionary = "anim@mp_player_intselfieblow_kiss",
                                emote_duration = 2000,
                                name = "Blow Kiss 2"
                            }, {
                                clip = "regal_c_1st",
                                controllable = true,
                                dictionary = "anim@arena@celeb@podium@no_prop@",
                                loop = true,
                                name = "Bow"
                            }, {
                                clip = "regal_a_1st",
                                controllable = true,
                                dictionary = "anim@arena@celeb@podium@no_prop@",
                                loop = true,
                                name = "Bow 2"
                            }, {
                                clip = "bring_it_on",
                                controllable = true,
                                dictionary = "misscommon@response",
                                emote_duration = 3000,
                                name = "Bring It On"
                            }, {
                                clip = "cpr_pumpchest",
                                dictionary = "mini@cpr@char_a@cpr_str",
                                loop = true,
                                name = "CPR"
                            }, {
                                clip = "cpr_pumpchest",
                                controllable = true,
                                dictionary = "mini@cpr@char_a@cpr_str",
                                loop = true,
                                name = "CPR 2"
                            }, {
                                clip = "celebrate",
                                dictionary = "rcmfanatic1celebrate",
                                loop = true,
                                name = "Celebrate"
                            }, {
                                clip = "wakeup",
                                controllable = true,
                                dictionary = "random@peyote@chicken",
                                loop = true,
                                name = "Chicken"
                            }, {
                                clip = "trev_scares_tramp_idle_tramp",
                                dictionary = "switch@trevor@scares_tramp",
                                loop = true,
                                name = "Chill"
                            }, {
                                clip = "base",
                                controllable = true,
                                dictionary = "amb@world_human_cheering@male_a",
                                loop = true,
                                name = "Clap"
                            }, {
                                clip = "angry_clap_a_player_a",
                                dictionary = "anim@arena@celeb@flat@solo@no_props@",
                                loop = true,
                                name = "Clap Angry"
                            }, {
                                clip = "trev_annoys_sunbathers_loop_girl",
                                dictionary = "switch@trevor@annoys_sunbathers",
                                loop = true,
                                name = "Cloudgaze"
                            }, {
                                clip = "trev_annoys_sunbathers_loop_guy",
                                dictionary = "switch@trevor@annoys_sunbathers",
                                loop = true,
                                name = "Cloudgaze 2"
                            }, {
                                clip = "clown_idle_0",
                                dictionary = "rcm_barry2",
                                loop = true,
                                name = "Clown"
                            }, {
                                clip = "clown_idle_1",
                                dictionary = "rcm_barry2",
                                loop = true,
                                name = "Clown 2"
                            }, {
                                clip = "clown_idle_2",
                                dictionary = "rcm_barry2",
                                loop = true,
                                name = "Clown 3"
                            }, {
                                clip = "clown_idle_3",
                                controllable = true,
                                dictionary = "rcm_barry2",
                                loop = true,
                                name = "Clown 4"
                            }, {
                                clip = "clown_idle_6",
                                dictionary = "rcm_barry2",
                                loop = true,
                                name = "Clown 5"
                            }, {
                                clip = "want_some_of_this",
                                controllable = true,
                                dictionary = "mini@triathlon",
                                emote_duration = 2000,
                                name = "Come at me bro"
                            }, {
                                clip = "rcmme_amanda1_stand_loop_cop",
                                dictionary = "anim@amb@nightclub@peds@",
                                loop = true,
                                name = "Cop 2"
                            }, {
                                clip = "idle_b",
                                dictionary = "amb@code_human_police_investigate@idle_a",
                                loop = true,
                                name = "Cop 3"
                            }, {
                                clip = "idle_cough",
                                controllable = true,
                                dictionary = "timetable@gardener@smoking_joint",
                                loop = true,
                                name = "Cough"
                            }, {
                                clip = "grid_girl_race_start",
                                controllable = true,
                                dictionary = "random@street_race",
                                loop = true,
                                name = "Countdown"
                            }, {
                                clip = "front_loop",
                                dictionary = "move_injured_ground",
                                loop = true,
                                name = "Crawl"
                            }, {
                                clip = "idle_a",
                                controllable = true,
                                dictionary = "amb@world_human_hang_out_street@female_arms_crossed@idle_a",
                                loop = true,
                                name = "Crossarms"
                            }, {
                                clip = "idle_b",
                                controllable = true,
                                dictionary = "amb@world_human_hang_out_street@male_c@idle_a",
                                name = "Crossarms 2"
                            }, {
                                clip = "single_team_loop_boss",
                                controllable = true,
                                dictionary = "anim@heists@heist_corona@single_team",
                                loop = true,
                                name = "Crossarms 3"
                            }, {
                                clip = "_car_b_lookout",
                                controllable = true,
                                dictionary = "random@street_race",
                                loop = true,
                                name = "Crossarms 4"
                            }, {
                                clip = "rcmme_amanda1_stand_loop_cop",
                                controllable = true,
                                dictionary = "anim@amb@nightclub@peds@",
                                loop = true,
                                name = "Crossarms 5"
                            }, {
                                clip = "_idle",
                                controllable = true,
                                dictionary = "random@shop_gunstore",
                                loop = true,
                                name = "Crossarms 6"
                            }, {
                                clip = "base_m2",
                                controllable = true,
                                dictionary = "rcmnigel1a_band_groupies",
                                loop = true,
                                name = "Crossarms Side"
                            }, {
                                clip = "sarcastic_left",
                                dictionary = "anim@mp_player_intcelebrationpaired@f_f_sarcastic",
                                name = "Curtsy"
                            }, {
                                clip = "dixn_dance_cntr_open_dix",
                                controllable = true,
                                dictionary = "anim@amb@nightclub@djs@dixon@",
                                loop = true,
                                name = "DJ"
                            }, {
                                clip = "gesture_damn",
                                controllable = true,
                                dictionary = "gestures@m@standing@casual",
                                emote_duration = 1000,
                                name = "Damn"
                            }, {
                                clip = "shoplift_mid",
                                controllable = true,
                                dictionary = "anim@am_hold_up@male",
                                emote_duration = 1000,
                                name = "Damn 2"
                            }, {
                                clip = "loop",
                                controllable = true,
                                dictionary = "mp_player_inteat@pnq",
                                emote_duration = 2500,
                                name = "Drink"
                            }, {
                                clip = "mp_player_int_eat_burger",
                                controllable = true,
                                dictionary = "mp_player_inteat@burger",
                                emote_duration = 3000,
                                name = "Eat"
                            }, {
                                clip = "agitated_idle_a",
                                controllable = true,
                                dictionary = "random@car_thief@agitated@idle_a",
                                emote_duration = 8000,
                                name = "Facepalm"
                            }, {
                                clip = "face_palm",
                                controllable = true,
                                dictionary = "anim@mp_player_intcelebrationfemale@face_palm",
                                emote_duration = 8000,
                                name = "Facepalm 2"
                            }, {
                                clip = "tasered_2",
                                controllable = true,
                                dictionary = "missminuteman_1ig_2",
                                emote_duration = 8000,
                                name = "Facepalm 3"
                            }, {
                                clip = "idle_a",
                                controllable = true,
                                dictionary = "anim@mp_player_intupperface_palm",
                                loop = true,
                                name = "Facepalm 4"
                            }, {
                                clip = "sleep_loop",
                                controllable = true,
                                dictionary = "mp_sleep",
                                loop = true,
                                name = "Fall Asleep"
                            }, {
                                clip = "drunk_fall_over",
                                dictionary = "random@drunk_driver_1",
                                name = "Fall Over"
                            }, {
                                clip = "pistol",
                                dictionary = "mp_suicide",
                                name = "Fall Over 2"
                            }, {
                                clip = "pill",
                                dictionary = "mp_suicide",
                                name = "Fall Over 3"
                            }, {
                                clip = "knockout_plyr",
                                dictionary = "friends@frf@ig_2",
                                name = "Fall Over 4"
                            }, {
                                clip = "victim_fail",
                                dictionary = "anim@gangops@hostage@",
                                name = "Fall Over 5"
                            }, {
                                clip = "intro_male_unarmed_c",
                                dictionary = "anim@deathmatch_intros@unarmed",
                                name = "Fight Me"
                            }, {
                                clip = "intro_male_unarmed_e",
                                dictionary = "anim@deathmatch_intros@unarmed",
                                name = "Fight Me 2"
                            }, {
                                clip = "idle_a",
                                controllable = true,
                                dictionary = "anim@mp_player_intselfiethe_bird",
                                loop = true,
                                name = "Finger"
                            }, {
                                clip = "idle_a_fp",
                                controllable = true,
                                dictionary = "anim@mp_player_intupperfinger",
                                loop = true,
                                name = "Finger 2"
                            }, {
                                clip = "idle_a",
                                controllable = true,
                                dictionary = "anim@mp_player_intupperfind_the_fish",
                                loop = true,
                                name = "Fish Dance"
                            }, {
                                clip = "flip_a_player_a",
                                dictionary = "anim@arena@celeb@flat@solo@no_props@",
                                name = "Flip"
                            }, {
                                clip = "cap_a_player_a",
                                dictionary = "anim@arena@celeb@flat@solo@no_props@",
                                name = "Flip 2"
                            }, {
                                clip = "flip_off_a_1st",
                                controllable = true,
                                dictionary = "anim@arena@celeb@podium@no_prop@",
                                name = "Flip Off"
                            }, {
                                clip = "flip_off_c_1st",
                                controllable = true,
                                dictionary = "anim@arena@celeb@podium@no_prop@",
                                name = "Flip Off 2"
                            }, {
                                clip = "stand_phone_phoneputdown_idle_nowork",
                                controllable = true,
                                dictionary = "anim@amb@business@bgen@bgen_no_work@",
                                loop = true,
                                name = "Fold Arms"
                            }, {
                                clip = "rcmme_amanda1_stand_loop_cop",
                                controllable = true,
                                dictionary = "anim@amb@nightclub@peds@",
                                loop = true,
                                name = "Fold Arms 2"
                            }, {
                                clip = "mp_player_int_gang_sign_a",
                                controllable = true,
                                dictionary = "mp_player_int_uppergang_sign_a",
                                loop = true,
                                name = "Gang Sign"
                            }, {
                                clip = "mp_player_int_gang_sign_b",
                                controllable = true,
                                dictionary = "mp_player_int_uppergang_sign_b",
                                loop = true,
                                name = "Gang Sign 2"
                            }, {
                                clip = "swing_a_mark",
                                dictionary = "rcmnigel1d",
                                name = "Golf Swing"
                            }, {
                                clip = "handsup_base",
                                controllable = true,
                                dictionary = "missminuteman_1ig_2",
                                loop = true,
                                name = "Hands Up"
                            }, {
                                clip = "handshake_guy_a",
                                controllable = true,
                                dictionary = "mp_ped_interaction",
                                emote_duration = 3000,
                                name = "Handshake"
                            }, {
                                clip = "handshake_guy_b",
                                controllable = true,
                                dictionary = "mp_ped_interaction",
                                emote_duration = 3000,
                                name = "Handshake 2"
                            }, {
                                clip = "plyr_takedown_front_headbutt",
                                dictionary = "melee@unarmed@streamed_variations",
                                name = "Headbutt"
                            }, {
                                clip = "idle",
                                controllable = true,
                                dictionary = "move_m@hiking",
                                loop = true,
                                name = "Hiking"
                            }, {
                                clip = "kisses_guy_a",
                                dictionary = "mp_ped_interaction",
                                name = "Hug"
                            }, {
                                clip = "kisses_guy_b",
                                dictionary = "mp_ped_interaction",
                                name = "Hug 2"
                            }, {
                                clip = "hugs_guy_a",
                                dictionary = "mp_ped_interaction",
                                name = "Hug 3"
                            }, {
                                clip = "idle",
                                dictionary = "anim@heists@heist_corona@team_idles@male_a",
                                loop = true,
                                name = "Idle"
                            }, {
                                clip = "idle",
                                controllable = true,
                                dictionary = "mp_move@prostitute@m@french",
                                loop = true,
                                name = "Idle 10"
                            }, {
                                clip = "idle_a",
                                dictionary = "random@countrysiderobbery",
                                loop = true,
                                name = "Idle 11"
                            }, {
                                clip = "idle",
                                dictionary = "anim@heists@heist_corona@team_idles@female_a",
                                loop = true,
                                name = "Idle 2"
                            }, {
                                clip = "ped_b_celebrate_loop",
                                dictionary = "anim@heists@humane_labs@finale@strip_club",
                                loop = true,
                                name = "Idle 3"
                            }, {
                                clip = "celebration_idle_f_a",
                                dictionary = "anim@mp_celebration@idles@female",
                                loop = true,
                                name = "Idle 4"
                            }, {
                                clip = "idle_a",
                                dictionary = "anim@mp_corona_idles@female_b@idle_a",
                                loop = true,
                                name = "Idle 5"
                            }, {
                                clip = "idle_a",
                                dictionary = "anim@mp_corona_idles@male_c@idle_a",
                                loop = true,
                                name = "Idle 6"
                            }, {
                                clip = "idle_a",
                                dictionary = "anim@mp_corona_idles@male_d@idle_a",
                                loop = true,
                                name = "Idle 7"
                            }, {
                                clip = "idle_b",
                                dictionary = "amb@world_human_hang_out_street@male_b@idle_a",
                                name = "Idle 8"
                            }, {
                                clip = "base_idle",
                                dictionary = "friends@fra@ig_1",
                                loop = true,
                                name = "Idle 9"
                            }, {
                                clip = "drunk_driver_stand_loop_dd1",
                                dictionary = "random@drunk_driver_1",
                                loop = true,
                                name = "Idle Drunk"
                            }, {
                                clip = "drunk_driver_stand_loop_dd2",
                                dictionary = "random@drunk_driver_1",
                                loop = true,
                                name = "Idle Drunk 2"
                            }, {
                                clip = "standing_idle_loop_drunk",
                                dictionary = "missarmenian2",
                                loop = true,
                                name = "Idle Drunk 3"
                            }, {
                                clip = "idle_e",
                                dictionary = "random@train_tracks",
                                name = "Inspect"
                            }, {
                                clip = "jazz_hands",
                                controllable = true,
                                dictionary = "anim@mp_player_intcelebrationfemale@jazz_hands",
                                emote_duration = 6000,
                                name = "Jazzhands"
                            }, {
                                clip = "idle_a",
                                controllable = true,
                                dictionary = "amb@world_human_jog_standing@male@idle_a",
                                loop = true,
                                name = "Jog 2"
                            }, {
                                clip = "idle_a",
                                controllable = true,
                                dictionary = "amb@world_human_jog_standing@female@idle_a",
                                loop = true,
                                name = "Jog 3"
                            }, {
                                clip = "idle_a",
                                controllable = true,
                                dictionary = "amb@world_human_power_walker@female@idle_a",
                                loop = true,
                                name = "Jog 4"
                            }, {
                                clip = "walk",
                                controllable = true,
                                dictionary = "move_m@joy@a",
                                loop = true,
                                name = "Jog 5"
                            }, {
                                clip = "jimmy_getknocked",
                                dictionary = "timetable@reunited@ig_2",
                                loop = true,
                                name = "Jumping Jacks"
                            }, {
                                clip = "fob_click",
                                controllable = true,
                                dictionary = "anim@mp_player_intmenu@key_fob@",
                                emote_duration = 1000,
                                loop = false,
                                name = "Key Fob"
                            }, {
                                clip = "idle",
                                dictionary = "rcmextreme3",
                                loop = true,
                                name = "Kneel 2"
                            }, {
                                clip = "idle_a",
                                dictionary = "amb@world_human_bum_wash@male@low@idle_a",
                                loop = true,
                                name = "Kneel 3"
                            }, {
                                clip = "knockdoor_idle",
                                controllable = true,
                                dictionary = "timetable@jimmy@doorknock@",
                                loop = true,
                                name = "Knock"
                            }, {
                                clip = "lift_fibagent_loop",
                                dictionary = "missheistfbi3b_ig7",
                                loop = true,
                                name = "Knock 2"
                            }, {
                                clip = "knuckle_crunch",
                                controllable = true,
                                dictionary = "anim@mp_player_intcelebrationfemale@knuckle_crunch",
                                loop = true,
                                name = "Knuckle Crunch"
                            }, {
                                clip = "laugh_a_player_b",
                                dictionary = "anim@arena@celeb@flat@paired@no_props@",
                                loop = true,
                                name = "LOL"
                            }, {
                                clip = "giggle_a_player_b",
                                dictionary = "anim@arena@celeb@flat@solo@no_props@",
                                loop = true,
                                name = "LOL 2"
                            }, {
                                clip = "lap_dance_girl",
                                dictionary = "mp_safehouse",
                                name = "Lapdance"
                            }, {
                                clip = "priv_dance_idle",
                                dictionary = "mini@strip_club@private_dance@idle",
                                loop = true,
                                name = "Lapdance 2"
                            }, {
                                clip = "priv_dance_p2",
                                dictionary = "mini@strip_club@private_dance@part2",
                                loop = true,
                                name = "Lapdance 3"
                            }, {
                                clip = "priv_dance_p3",
                                dictionary = "mini@strip_club@private_dance@part3",
                                loop = true,
                                name = "Lapdance 4"
                            }, {
                                clip = "idle_a",
                                dictionary = "amb@world_human_leaning@female@wall@back@hand_up@idle_a",
                                loop = true,
                                name = "Lean 2"
                            }, {
                                clip = "idle_a",
                                dictionary = "amb@world_human_leaning@female@wall@back@holding_elbow@idle_a",
                                loop = true,
                                name = "Lean 3"
                            }, {
                                clip = "idle_a",
                                dictionary = "amb@world_human_leaning@male@wall@back@foot_up@idle_a",
                                loop = true,
                                name = "Lean 4"
                            }, {
                                clip = "idle_b",
                                dictionary = "amb@world_human_leaning@male@wall@back@hands_together@idle_b",
                                loop = true,
                                name = "Lean 5"
                            }, {
                                clip = "idle_c",
                                dictionary = "amb@prop_human_bum_shopping_cart@male@idle_a",
                                loop = true,
                                name = "Lean Bar 2"
                            }, {
                                clip = "clubvip_base_laz",
                                dictionary = "anim@amb@nightclub@lazlow@ig1_vip@",
                                loop = true,
                                name = "Lean Bar 3"
                            }, {
                                clip = "ped_b_loop_a",
                                dictionary = "anim@heists@prison_heist",
                                loop = true,
                                name = "Lean Bar 4"
                            }, {
                                clip = "_car_a_flirt_girl",
                                dictionary = "random@street_race",
                                loop = true,
                                name = "Lean Flirt"
                            }, {
                                clip = "idle_a_player_one",
                                controllable = true,
                                dictionary = "anim@mp_ferris_wheel",
                                loop = true,
                                name = "Lean High"
                            }, {
                                clip = "idle_a_player_two",
                                controllable = true,
                                dictionary = "anim@mp_ferris_wheel",
                                loop = true,
                                name = "Lean High 2"
                            }, {
                                clip = "idle_a",
                                controllable = true,
                                dictionary = "timetable@mime@01_gc",
                                loop = true,
                                name = "Leanside"
                            }, {
                                clip = "packer_idle_1_trevor",
                                controllable = true,
                                dictionary = "misscarstealfinale",
                                loop = true,
                                name = "Leanside 2"
                            }, {
                                clip = "waitloop_lamar",
                                controllable = true,
                                dictionary = "misscarstealfinalecar_5_ig_1",
                                loop = true,
                                name = "Leanside 3"
                            }, {
                                clip = "waitloop_lamar",
                                controllable = false,
                                dictionary = "misscarstealfinalecar_5_ig_1",
                                loop = true,
                                name = "Leanside 4"
                            }, {
                                clip = "josh_2_intp1_base",
                                controllable = false,
                                dictionary = "rcmjosh2",
                                loop = true,
                                name = "Leanside 5"
                            }, {
                                clip = "ledge_loop",
                                dictionary = "missfbi1",
                                loop = true,
                                name = "Ledge"
                            }, {
                                clip = "idle_f",
                                controllable = true,
                                dictionary = "random@hitch_lift",
                                loop = true,
                                name = "Lift"
                            }, {
                                clip = "gesture_me_hard",
                                controllable = true,
                                dictionary = "gestures@f@standing@casual",
                                emote_duration = 1000,
                                name = "Me"
                            }, {
                                clip = "fixing_a_ped",
                                controllable = true,
                                dictionary = "mini@repair",
                                loop = true,
                                name = "Mechanic"
                            }, {
                                clip = "idle_a",
                                dictionary = "amb@world_human_vehicle_mechanic@male@base",
                                loop = true,
                                name = "Mechanic 2"
                            }, {
                                clip = "machinic_loop_mechandplayer",
                                dictionary = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                                loop = true,
                                name = "Mechanic 3"
                            }, {
                                clip = "machinic_loop_mechandplayer",
                                controllable = true,
                                dictionary = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                                loop = true,
                                name = "Mechanic 4"
                            }, {
                                clip = "base",
                                dictionary = "amb@medic@standing@tendtodead@base",
                                loop = true,
                                name = "Medic 2"
                            }, {
                                clip = "meditiate_idle",
                                dictionary = "rcmcollect_paperleadinout@",
                                loop = true,
                                name = "Meditiate"
                            }, {
                                clip = "ep_3_rcm_marnie_meditating",
                                dictionary = "rcmepsilonism3",
                                loop = true,
                                name = "Meditiate 2"
                            }, {
                                clip = "base_loop",
                                dictionary = "rcmepsilonism3",
                                loop = true,
                                name = "Meditiate 3"
                            }, {
                                clip = "idle_a",
                                controllable = true,
                                dictionary = "anim@mp_player_intincarrockstd@ps@",
                                loop = true,
                                name = "Metal"
                            }, {
                                clip = "mind_control_b_loop",
                                dictionary = "rcmbarry",
                                loop = true,
                                name = "Mind Control"
                            }, {
                                clip = "bar_1_attack_idle_aln",
                                dictionary = "rcmbarry",
                                loop = true,
                                name = "Mind Control 2"
                            }, {
                                clip = "ig_4_base",
                                controllable = true,
                                dictionary = "timetable@amanda@ig_4",
                                loop = true,
                                name = "Namaste"
                            }, {
                                clip = "idle_c",
                                controllable = true,
                                dictionary = "amb@world_human_bum_standing@twitchy@idle_a",
                                loop = true,
                                name = "Nervous"
                            }, {
                                clip = "nervous_idle",
                                controllable = true,
                                dictionary = "mp_missheist_countrybank@nervous",
                                loop = true,
                                name = "Nervous 2"
                            }, {
                                clip = "nervous_loop",
                                controllable = true,
                                dictionary = "rcmme_tracey1",
                                loop = true,
                                name = "Nervous 3"
                            }, {
                                clip = "fail",
                                controllable = true,
                                dictionary = "anim@heists@ornate_bank@chat_manager",
                                loop = true,
                                name = "No"
                            }, {
                                clip = "mp_player_int_nod_no",
                                controllable = true,
                                dictionary = "mp_player_int_upper_nod",
                                loop = true,
                                name = "No 2"
                            }, {
                                clip = "gesture_no_way",
                                controllable = true,
                                dictionary = "gestures@m@standing@casual",
                                emote_duration = 1500,
                                name = "No Way"
                            }, {
                                clip = "nose_pick",
                                controllable = true,
                                dictionary = "anim@mp_player_intcelebrationfemale@nose_pick",
                                loop = true,
                                name = "Nose Pick"
                            }, {
                                clip = "idle_a",
                                controllable = true,
                                dictionary = "anim@mp_player_intselfiedock",
                                loop = true,
                                name = "OK"
                            }, {
                                clip = "out_of_breath",
                                controllable = true,
                                dictionary = "re@construction",
                                loop = true,
                                name = "Out of Breath"
                            }, {
                                clip = "drunk_loop",
                                dictionary = "missarmenian2",
                                loop = true,
                                name = "Passout"
                            }, {
                                clip = "corpse_search_exit_ped",
                                dictionary = "missarmenian2",
                                loop = true,
                                name = "Passout 2"
                            }, {
                                clip = "body_search",
                                dictionary = "anim@gangops@morgue@table@",
                                loop = true,
                                name = "Passout 3"
                            }, {
                                clip = "cpr_pumpchest_idle",
                                dictionary = "mini@cpr@char_b@cpr_def",
                                loop = true,
                                name = "Passout 4"
                            }, {
                                clip = "flee_backward_loop_shopkeeper",
                                dictionary = "random@mugging4",
                                loop = true,
                                name = "Passout 5"
                            }, {
                                clip = "mp_player_int_peace_sign",
                                controllable = true,
                                dictionary = "mp_player_int_upperpeace_sign",
                                loop = true,
                                name = "Peace"
                            }, {
                                clip = "idle_a",
                                controllable = true,
                                dictionary = "anim@mp_player_intupperpeace",
                                loop = true,
                                name = "Peace 2"
                            }, {
                                clip = "left_peek_a",
                                dictionary = "random@paparazzi@peek",
                                loop = true,
                                name = "Peek"
                            }, {
                                clip = "petting_franklin",
                                dictionary = "creatures@rottweiler@tricks@",
                                loop = true,
                                name = "Petting"
                            }, {
                                clip = "pickup_low",
                                dictionary = "random@domestic",
                                name = "Pickup"
                            }, {
                                clip = "gesture_point",
                                controllable = true,
                                dictionary = "gestures@f@standing@casual",
                                loop = true,
                                name = "Point"
                            }, {
                                clip = "gesture_hand_down",
                                controllable = true,
                                dictionary = "gestures@f@standing@casual",
                                emote_duration = 1000,
                                name = "Point Down"
                            }, {
                                clip = "indicate_right",
                                controllable = true,
                                dictionary = "mp_gun_shop_tut",
                                loop = true,
                                name = "Point Right"
                            }, {
                                clip = "prone_dave",
                                dictionary = "missfbi3_sniping",
                                loop = true,
                                name = "Prone"
                            }, {
                                clip = "struggle_loop_b_thief",
                                controllable = true,
                                dictionary = "random@mugging4",
                                loop = true,
                                name = "Pull"
                            }, {
                                clip = "pull_over_right",
                                controllable = true,
                                dictionary = "misscarsteal3pullover",
                                emote_duration = 1300,
                                name = "Pullover"
                            }, {
                                clip = "loop_punching",
                                controllable = true,
                                dictionary = "rcmextreme2",
                                loop = true,
                                name = "Punching"
                            }, {
                                clip = "pushcar_offcliff_f",
                                dictionary = "missfinale_c2ig_11",
                                loop = true,
                                name = "Push"
                            }, {
                                clip = "pushcar_offcliff_m",
                                dictionary = "missfinale_c2ig_11",
                                loop = true,
                                name = "Push 2"
                            }, {
                                clip = "idle_d",
                                dictionary = "amb@world_human_push_ups@male@idle_a",
                                loop = true,
                                name = "Pushup"
                            }, {
                                clip = "wakeup",
                                dictionary = "random@peyote@rabbit",
                                name = "Rabbit"
                            }, {
                                clip = "generic_radio_chatter",
                                controllable = true,
                                dictionary = "random@arrests",
                                loop = true,
                                name = "Radio"
                            }, {
                                clip = "idle",
                                controllable = true,
                                dictionary = "move_m@intimidation@cop@unarmed",
                                loop = true,
                                name = "Reaching"
                            }, {
                                clip = "idle_a",
                                controllable = true,
                                dictionary = "anim@mp_player_intincarsalutestd@ds@",
                                loop = true,
                                name = "Salute"
                            }, {
                                clip = "idle_a",
                                controllable = true,
                                dictionary = "anim@mp_player_intincarsalutestd@ps@",
                                loop = true,
                                name = "Salute 2"
                            }, {
                                clip = "idle_a",
                                controllable = true,
                                dictionary = "anim@mp_player_intuppersalute",
                                loop = true,
                                name = "Salute 3"
                            }, {
                                clip = "f_distressed_loop",
                                controllable = true,
                                dictionary = "random@domestic",
                                loop = true,
                                name = "Scared"
                            }, {
                                clip = "knees_loop_girl",
                                controllable = true,
                                dictionary = "random@homelandsecurity",
                                loop = true,
                                name = "Scared 2"
                            }, {
                                clip = "screw_you",
                                controllable = true,
                                dictionary = "misscommon@response",
                                loop = true,
                                name = "Screw You"
                            }, {
                                clip = "shakeoff_1",
                                controllable = true,
                                dictionary = "move_m@_idles@shake_off",
                                emote_duration = 3500,
                                name = "Shake Off"
                            }, {
                                clip = "idle_a",
                                dictionary = "random@dealgonewrong",
                                loop = true,
                                name = "Shot"
                            }, {
                                clip = "gesture_shrug_hard",
                                controllable = true,
                                dictionary = "gestures@f@standing@casual",
                                emote_duration = 1000,
                                name = "Shrug"
                            }, {
                                clip = "gesture_shrug_hard",
                                controllable = true,
                                dictionary = "gestures@m@standing@casual",
                                emote_duration = 1000,
                                name = "Shrug 2"
                            }, {
                                clip = "sit_phone_phoneputdown_idle_nowork",
                                dictionary = "anim@amb@business@bgen@bgen_no_work@",
                                loop = true,
                                name = "Sit"
                            }, {
                                clip = "barry_3_sit_loop",
                                dictionary = "rcm_barry3",
                                loop = true,
                                name = "Sit 2"
                            }, {
                                clip = "idle_a",
                                dictionary = "amb@world_human_picnic@male@idle_a",
                                loop = true,
                                name = "Sit 3"
                            }, {
                                clip = "idle_a",
                                dictionary = "amb@world_human_picnic@female@idle_a",
                                loop = true,
                                name = "Sit 4"
                            }, {
                                clip = "owner_idle",
                                dictionary = "anim@heists@fleeca_bank@ig_7_jetski_owner",
                                loop = true,
                                name = "Sit 5"
                            }, {
                                clip = "idle_a_jimmy",
                                dictionary = "timetable@jimmy@mics3_ig_15@",
                                loop = true,
                                name = "Sit 6"
                            }, {
                                clip = "lowalone_base_laz",
                                dictionary = "anim@amb@nightclub@lazlow@lo_alone@",
                                loop = true,
                                name = "Sit 7"
                            }, {
                                clip = "mics3_15_base_jimmy",
                                dictionary = "timetable@jimmy@mics3_ig_15@",
                                loop = true,
                                name = "Sit 8"
                            }, {
                                clip = "idle_a",
                                dictionary = "amb@world_human_stupor@male@idle_a",
                                loop = true,
                                name = "Sit 9"
                            }, {
                                clip = "ig_5_p3_base",
                                dictionary = "timetable@ron@ig_5_p3",
                                loop = true,
                                name = "Sit Chair 2"
                            }, {
                                clip = "base_amanda",
                                dictionary = "timetable@reunited@ig_10",
                                loop = true,
                                name = "Sit Chair 3"
                            }, {
                                clip = "base",
                                dictionary = "timetable@ron@ig_3_couch",
                                loop = true,
                                name = "Sit Chair 4"
                            }, {
                                clip = "mics3_15_base_tracy",
                                dictionary = "timetable@jimmy@mics3_ig_15@",
                                loop = true,
                                name = "Sit Chair 5"
                            }, {
                                clip = "base",
                                dictionary = "timetable@maid@couch@",
                                loop = true,
                                name = "Sit Chair 6"
                            }, {
                                clip = "ig_2_alt1_base",
                                dictionary = "timetable@ron@ron_ig_2_alt1",
                                loop = true,
                                name = "Sit Chair Side"
                            }, {
                                clip = "base",
                                dictionary = "timetable@amanda@drunk@base",
                                loop = true,
                                name = "Sit Drunk"
                            }, {
                                clip = "ig_14_base_tracy",
                                dictionary = "timetable@tracy@ig_14@",
                                loop = true,
                                name = "Sit Lean"
                            }, {
                                clip = "sit_phone_phoneputdown_sleeping-noworkfemale",
                                dictionary = "anim@amb@business@bgen@bgen_no_work@",
                                loop = true,
                                name = "Sit Sad"
                            }, {
                                clip = "hit_loop_ped_b",
                                dictionary = "anim@heists@ornate_bank@hostages@hit",
                                loop = true,
                                name = "Sit Scared"
                            }, {
                                clip = "flinch_loop",
                                dictionary = "anim@heists@ornate_bank@hostages@ped_c@",
                                loop = true,
                                name = "Sit Scared 2"
                            }, {
                                clip = "flinch_loop",
                                dictionary = "anim@heists@ornate_bank@hostages@ped_e@",
                                loop = true,
                                name = "Sit Scared 3"
                            }, {
                                clip = "idle_a",
                                dictionary = "amb@world_human_sit_ups@male@idle_a",
                                loop = true,
                                name = "Sit Up"
                            }, {
                                clip = "plyr_takedown_front_slap",
                                controllable = true,
                                dictionary = "melee@unarmed@streamed_variations",
                                emote_duration = 2000,
                                loop = true,
                                name = "Slap"
                            }, {
                                clip = "idle_c",
                                dictionary = "timetable@tracy@sleep@",
                                loop = true,
                                name = "Sleep"
                            }, {
                                clip = "slide_a_player_a",
                                dictionary = "anim@arena@celeb@flat@solo@no_props@",
                                name = "Slide"
                            }, {
                                clip = "slide_b_player_a",
                                dictionary = "anim@arena@celeb@flat@solo@no_props@",
                                name = "Slide 2"
                            }, {
                                clip = "slide_c_player_a",
                                dictionary = "anim@arena@celeb@flat@solo@no_props@",
                                name = "Slide 3"
                            }, {
                                clip = "slow_clap",
                                controllable = true,
                                dictionary = "anim@mp_player_intcelebrationfemale@slow_clap",
                                loop = true,
                                name = "Slow Clap"
                            }, {
                                clip = "slow_clap",
                                controllable = true,
                                dictionary = "anim@mp_player_intcelebrationmale@slow_clap",
                                loop = true,
                                name = "Slow Clap 2"
                            }, {
                                clip = "idle_a",
                                controllable = true,
                                dictionary = "anim@mp_player_intupperslow_clap",
                                loop = true,
                                name = "Slow Clap 3"
                            }, {
                                clip = "slugger_a_player_a",
                                dictionary = "anim@arena@celeb@flat@solo@no_props@",
                                name = "Slugger"
                            }, {
                                clip = "fidget_sniff_fingers",
                                controllable = true,
                                dictionary = "move_p_m_two_idles@generic",
                                loop = true,
                                name = "Smell"
                            }, {
                                clip = "ex03_train_roof_idle",
                                dictionary = "missexile3",
                                loop = true,
                                name = "Spider-Man"
                            }, {
                                clip = "cs_lamardavis_dual-1",
                                controllable = true,
                                dictionary = "fra_0_int-1",
                                loop = true,
                                name = "Statue 2"
                            }, {
                                clip = "csb_englishdave_dual-0",
                                dictionary = "club_intro2-0",
                                loop = true,
                                name = "Statue 3"
                            }, {
                                clip = "biker_02_stickup_loop",
                                controllable = true,
                                dictionary = "random@countryside_gang_fight",
                                loop = true,
                                name = "Stick Up"
                            }, {
                                clip = "idle_e",
                                dictionary = "mini@triathlon",
                                loop = true,
                                name = "Stretch"
                            }, {
                                clip = "idle_f",
                                dictionary = "mini@triathlon",
                                loop = true,
                                name = "Stretch 2"
                            }, {
                                clip = "idle_d",
                                dictionary = "mini@triathlon",
                                loop = true,
                                name = "Stretch 3"
                            }, {
                                clip = "idle_e",
                                dictionary = "rcmfanatic1maryann_stretchidle_b",
                                loop = true,
                                name = "Stretch 4"
                            }, {
                                clip = "stumble",
                                dictionary = "misscarsteal4@actor",
                                loop = true,
                                name = "Stumble"
                            }, {
                                clip = "damage",
                                dictionary = "stungun@standing",
                                loop = true,
                                name = "Stunned"
                            }, {
                                clip = "base",
                                dictionary = "amb@world_human_sunbathe@male@back@base",
                                loop = true,
                                name = "Sunbathe"
                            }, {
                                clip = "base",
                                dictionary = "amb@world_human_sunbathe@female@back@base",
                                loop = true,
                                name = "Sunbathe 2"
                            }, {
                                clip = "base",
                                dictionary = "rcmbarry",
                                loop = true,
                                name = "Superhero"
                            }, {
                                clip = "base",
                                controllable = true,
                                dictionary = "rcmbarry",
                                loop = true,
                                name = "Superhero 2"
                            }, {
                                clip = "idle_a",
                                dictionary = "random@arrests@busted",
                                loop = true,
                                name = "Surrender"
                            }, {
                                clip = "a2_pose",
                                controllable = true,
                                dictionary = "missfam5_yoga",
                                loop = true,
                                name = "T-Pose"
                            }, {
                                clip = "a2_pose",
                                controllable = true,
                                dictionary = "missfam5_yoga",
                                name = "T-Pose (Once)"
                            }, {
                                clip = "rehearsal_base_idle_director",
                                controllable = true,
                                dictionary = "misscarsteal4@aliens",
                                loop = true,
                                name = "Think"
                            }, {
                                clip = "jh_int_outro_loop_a",
                                controllable = true,
                                dictionary = "missheist_jewelleadinout",
                                loop = true,
                                name = "Think 2"
                            }, {
                                clip = "base",
                                controllable = true,
                                dictionary = "timetable@tracy@ig_8@base",
                                loop = true,
                                name = "Think 3"
                            }, {
                                clip = "b_think",
                                controllable = true,
                                dictionary = "mp_cp_welcome_tutthink",
                                emote_duration = 2000,
                                name = "Think 5"
                            }, {
                                clip = "b_atm_mugging",
                                controllable = true,
                                dictionary = "random@atmrobberygen",
                                loop = true,
                                name = "Threaten"
                            }, {
                                clip = "idle_a",
                                controllable = true,
                                dictionary = "anim@mp_player_intupperthumbs_up",
                                loop = true,
                                name = "Thumbs Up"
                            }, {
                                clip = "idle_a",
                                controllable = true,
                                dictionary = "anim@mp_player_intselfiethumbs_up",
                                loop = true,
                                name = "Thumbs Up 2"
                            }, {
                                clip = "enter",
                                controllable = true,
                                dictionary = "anim@mp_player_intincarthumbs_uplow@ds@",
                                emote_duration = 3000,
                                name = "Thumbs Up 3"
                            }, {
                                clip = "try_trousers_neutral_a",
                                dictionary = "mp_clothing@female@trousers",
                                loop = true,
                                name = "Try Clothes"
                            }, {
                                clip = "try_shirt_positive_a",
                                dictionary = "mp_clothing@female@shirt",
                                loop = true,
                                name = "Try Clothes 2"
                            }, {
                                clip = "try_shoes_positive_a",
                                dictionary = "mp_clothing@female@shoes",
                                loop = true,
                                name = "Try Clothes 3"
                            }, {
                                clip = "001443_01_trvs_28_idle_stripper",
                                dictionary = "switch@trevor@mocks_lapdance",
                                loop = true,
                                name = "Twerk"
                            }, {
                                clip = "cop_b_idle",
                                controllable = true,
                                dictionary = "anim@heists@prison_heiststation@cop_reactions",
                                loop = true,
                                name = "Type"
                            }, {
                                clip = "loop",
                                controllable = true,
                                dictionary = "anim@heists@prison_heistig1_p1_guard_checks_bus",
                                loop = true,
                                name = "Type 2"
                            }, {
                                clip = "hack_loop",
                                controllable = true,
                                dictionary = "mp_prison_break",
                                loop = true,
                                name = "Type 3"
                            }, {
                                clip = "loop",
                                dictionary = "mp_fbi_heist",
                                loop = true,
                                name = "Type 4"
                            }, {
                                clip = "a_uncuff",
                                controllable = true,
                                dictionary = "mp_arresting",
                                loop = true,
                                name = "Uncuff"
                            }, {
                                clip = "_idle_a",
                                controllable = true,
                                dictionary = "random@shop_tattoo",
                                loop = true,
                                name = "Wait"
                            }, {
                                clip = "ig_3_base_tracy",
                                controllable = true,
                                dictionary = "timetable@amanda@ig_3",
                                loop = true,
                                name = "Wait 10"
                            }, {
                                clip = "keeper_base",
                                controllable = true,
                                dictionary = "misshair_shop@hair_dressers",
                                loop = true,
                                name = "Wait 11"
                            }, {
                                clip = "idle",
                                controllable = true,
                                dictionary = "rcmjosh1",
                                loop = true,
                                name = "Wait 12"
                            }, {
                                clip = "base",
                                controllable = true,
                                dictionary = "rcmnigel1a",
                                loop = true,
                                name = "Wait 13"
                            }, {
                                clip = "wait_for_van_c",
                                controllable = true,
                                dictionary = "missbigscore2aig_3",
                                loop = true,
                                name = "Wait 2"
                            }, {
                                clip = "idle_a",
                                dictionary = "amb@world_human_hang_out_street@female_hold_arm@idle_a",
                                loop = true,
                                name = "Wait 3"
                            }, {
                                clip = "idle_a",
                                dictionary = "amb@world_human_hang_out_street@Female_arm_side@idle_a",
                                loop = true,
                                name = "Wait 4"
                            }, {
                                clip = "idle_storeclerk",
                                controllable = true,
                                dictionary = "missclothing",
                                loop = true,
                                name = "Wait 5"
                            }, {
                                clip = "ig_2_base_amanda",
                                controllable = true,
                                dictionary = "timetable@amanda@ig_2",
                                loop = true,
                                name = "Wait 6"
                            }, {
                                clip = "base",
                                controllable = true,
                                dictionary = "rcmnigel1cnmt_1c",
                                loop = true,
                                name = "Wait 7"
                            }, {
                                clip = "idle",
                                controllable = true,
                                dictionary = "rcmjosh1",
                                loop = true,
                                name = "Wait 8"
                            }, {
                                clip = "josh_2_intp1_base",
                                controllable = true,
                                dictionary = "rcmjosh2",
                                loop = true,
                                name = "Wait 9"
                            }, {
                                clip = "idle_a",
                                controllable = true,
                                dictionary = "amb@world_human_stand_fire@male@idle_a",
                                loop = true,
                                name = "Warmth"
                            }, {
                                clip = "wave_a",
                                controllable = true,
                                dictionary = "friends@frj@ig_1",
                                loop = true,
                                name = "Wave"
                            }, {
                                clip = "wave",
                                controllable = true,
                                dictionary = "anim@mp_player_intcelebrationfemale@wave",
                                loop = true,
                                name = "Wave 2"
                            }, {
                                clip = "over_here_idle_a",
                                controllable = true,
                                dictionary = "friends@fra@ig_1",
                                loop = true,
                                name = "Wave 3"
                            }, {
                                clip = "001445_01_gangintimidation_1_female_idle_b",
                                controllable = true,
                                dictionary = "random@mugging5",
                                emote_duration = 3000,
                                name = "Wave 4"
                            }, {
                                clip = "wave_b",
                                controllable = true,
                                dictionary = "friends@frj@ig_1",
                                loop = true,
                                name = "Wave 5"
                            }, {
                                clip = "wave_c",
                                controllable = true,
                                dictionary = "friends@frj@ig_1",
                                loop = true,
                                name = "Wave 6"
                            }, {
                                clip = "wave_d",
                                controllable = true,
                                dictionary = "friends@frj@ig_1",
                                loop = true,
                                name = "Wave 7"
                            }, {
                                clip = "wave_e",
                                controllable = true,
                                dictionary = "friends@frj@ig_1",
                                loop = true,
                                name = "Wave 8"
                            }, {
                                clip = "gesture_hello",
                                controllable = true,
                                dictionary = "gestures@m@standing@casual",
                                loop = true,
                                name = "Wave 9"
                            }, {
                                clip = "hail_taxi",
                                controllable = true,
                                dictionary = "taxi_hail",
                                emote_duration = 1300,
                                name = "Whistle"
                            }, {
                                clip = "hailing_whistle_waive_a",
                                controllable = true,
                                dictionary = "rcmnigel1c",
                                emote_duration = 2000,
                                name = "Whistle 2"
                            }, {
                                clip = "idle_a",
                                controllable = true,
                                dictionary = "anim@mp_player_intupperair_shagging",
                                emote_duration = 1000,
                                loop = true,
                                name = "Yeah"
                            } },
                  name = "Actions"
              }, {
                  is_folder = true,
                  items = { {
                                clip = "hi_dance_facedj_17_v2_male^5",
                                dictionary = "anim@amb@nightclub@dancers@podium_dancers@",
                                loop = true,
                                name = "Dance"
                            }, {
                                clip = "high_center_down",
                                dictionary = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@",
                                loop = true,
                                name = "Dance 2"
                            }, {
                                clip = "high_center",
                                dictionary = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@",
                                loop = true,
                                name = "Dance 3"
                            }, {
                                clip = "high_center_up",
                                dictionary = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@",
                                loop = true,
                                name = "Dance 4"
                            }, {
                                clip = "med_center",
                                dictionary = "anim@amb@casino@mini@dance@dance_solo@female@var_a@",
                                loop = true,
                                name = "Dance 5"
                            }, {
                                clip = "dance_loop_tao",
                                dictionary = "misschinese2_crystalmazemcs1_cs",
                                loop = true,
                                name = "Dance 6"
                            }, {
                                clip = "dance_loop_tao",
                                dictionary = "misschinese2_crystalmazemcs1_ig",
                                loop = true,
                                name = "Dance 7"
                            }, {
                                clip = "dance_m_default",
                                dictionary = "missfbi3_sniping",
                                loop = true,
                                name = "Dance 8"
                            }, {
                                clip = "med_center_up",
                                dictionary = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@",
                                loop = true,
                                name = "Dance 9"
                            }, {
                                clip = "mi_dance_facedj_17_v1_female^1",
                                dictionary = "anim@amb@nightclub@dancers@solomun_entourage@",
                                loop = true,
                                name = "Dance F"
                            }, {
                                clip = "high_center",
                                dictionary = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@",
                                loop = true,
                                name = "Dance F2"
                            }, {
                                clip = "high_center_up",
                                dictionary = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@",
                                loop = true,
                                name = "Dance F3"
                            }, {
                                clip = "hi_dance_facedj_09_v2_female^1",
                                dictionary = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity",
                                loop = true,
                                name = "Dance F4"
                            }, {
                                clip = "hi_dance_facedj_09_v2_female^3",
                                dictionary = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity",
                                loop = true,
                                name = "Dance F5"
                            }, {
                                clip = "high_center_up",
                                dictionary = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@",
                                loop = true,
                                name = "Dance F6"
                            }, {
                                clip = "ambclub_13_mi_hi_sexualgriding_laz",
                                controllable = true,
                                dictionary = "anim@amb@nightclub@lazlow@hi_railing@",
                                loop = true,
                                name = "Dance Glowsticks",
                                props = { {
                                              bone = 28422,
                                              placement = { 0.07, 0.14, 0.0, -80.0, 20.0 },
                                              prop = "ba_prop_battle_glowstick_01"
                                          }, {
                                              bone = 60309,
                                              placement = { 0.07, 0.09, 0.0, -120.0, -20.0 },
                                              prop = "ba_prop_battle_glowstick_01"
                                          } }
                            }, {
                                clip = "ambclub_12_mi_hi_bootyshake_laz",
                                dictionary = "anim@amb@nightclub@lazlow@hi_railing@",
                                loop = true,
                                name = "Dance Glowsticks 2",
                                props = { {
                                              bone = 28422,
                                              placement = { 0.07, 0.14, 0.0, -80.0, 20.0 },
                                              prop = "ba_prop_battle_glowstick_01"
                                          }, {
                                              bone = 60309,
                                              placement = { 0.07, 0.09, 0.0, -120.0, -20.0 },
                                              prop = "ba_prop_battle_glowstick_01"
                                          } }
                            }, {
                                clip = "ambclub_09_mi_hi_bellydancer_laz",
                                dictionary = "anim@amb@nightclub@lazlow@hi_railing@",
                                name = "Dance Glowsticks 3",
                                props = { {
                                              bone = 28422,
                                              placement = { 0.07, 0.14, 0.0, -80.0, 20.0 },
                                              prop = "ba_prop_battle_glowstick_01"
                                          }, {
                                              bone = 60309,
                                              placement = { 0.07, 0.09, 0.0, -120.0, -20.0 },
                                              prop = "ba_prop_battle_glowstick_01"
                                          },
                                          loop = true
                                }
                            }, {
                                clip = "low_center",
                                dictionary = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@",
                                loop = true,
                                name = "Dance Shy"
                            }, {
                                clip = "low_center_down",
                                dictionary = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@",
                                loop = true,
                                name = "Dance Shy 2"
                            }, {
                                clip = "mnt_dnc_buttwag",
                                dictionary = "special_ped@mountain_dancer@monologue_3@monologue_3a",
                                loop = true,
                                name = "Dance Silly"
                            }, {
                                clip = "fidget_short_dance",
                                dictionary = "move_clown@p_m_zero_idles@",
                                loop = true,
                                name = "Dance Silly 2"
                            }, {
                                clip = "fidget_short_dance",
                                dictionary = "move_clown@p_m_two_idles@",
                                loop = true,
                                name = "Dance Silly 3"
                            }, {
                                clip = "danceidle_hi_11_buttwiggle_b_laz",
                                dictionary = "anim@amb@nightclub@lazlow@hi_podium@",
                                loop = true,
                                name = "Dance Silly 4"
                            }, {
                                clip = "idle_a",
                                dictionary = "timetable@tracy@ig_5@idle_a",
                                loop = true,
                                name = "Dance Silly 5"
                            }, {
                                clip = "idle_d",
                                dictionary = "timetable@tracy@ig_8@idle_b",
                                loop = true,
                                name = "Dance Silly 6"
                            }, {
                                clip = "high_center",
                                dictionary = "anim@amb@casino@mini@dance@dance_solo@female@var_b@",
                                loop = true,
                                name = "Dance Silly 7"
                            }, {
                                clip = "the_woogie",
                                dictionary = "anim@mp_player_intcelebrationfemale@the_woogie",
                                loop = true,
                                name = "Dance Silly 8"
                            }, {
                                clip = "dance_loop_tyler",
                                dictionary = "rcmnigel1bnmt_1b",
                                loop = true,
                                name = "Dance Silly 9"
                            }, {
                                clip = "low_center",
                                dictionary = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@",
                                loop = true,
                                name = "Dance Slow"
                            }, {
                                clip = "low_center",
                                dictionary = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@",
                                loop = true,
                                name = "Dance Slow 2"
                            }, {
                                clip = "low_center_down",
                                dictionary = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@",
                                loop = true,
                                name = "Dance Slow 3"
                            }, {
                                clip = "low_center",
                                dictionary = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@",
                                loop = true,
                                name = "Dance Slow 4"
                            }, {
                                clip = "high_center",
                                controllable = true,
                                dictionary = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@",
                                loop = true,
                                name = "Dance Upper"
                            }, {
                                clip = "high_center_up",
                                controllable = true,
                                dictionary = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@",
                                loop = true,
                                name = "Dance Upper 2"
                            } },
                  name = "Dances"
              }, {
                  is_folder = true,
                  items = { {
                                clip = "handshake_guy_a",
                                controllable = true,
                                dictionary = "mp_ped_interaction",
                                emote_duration = 3000,
                                name = "Handshake",
                                sync_offset_front = 0.9,
                                target_animation = "handshake2"
                            }, {
                                clip = "handshake_guy_b",
                                controllable = true,
                                dictionary = "mp_ped_interaction",
                                emote_duration = 3000,
                                name = "Handshake 2",
                                target_animation = "handshake"
                            }, {
                                clip = "kisses_guy_a",
                                controllable = false,
                                dictionary = "mp_ped_interaction",
                                emote_duration = 5000,
                                name = "Hug",
                                sync_offset_front = 1.05,
                                target_animation = "hug2"
                            }, {
                                clip = "kisses_guy_b",
                                controllable = false,
                                dictionary = "mp_ped_interaction",
                                emote_duration = 5000,
                                name = "Hug 2",
                                sync_offset_front = 1.13,
                                target_animation = "hug"
                            } },
                  name = "Interaction"
              }, {
                  is_folder = true,
                  items = { {
                                clip = "try_tie_positive_a",
                                controllable = true,
                                dictionary = "clothingtie",
                                emote_duration = 5000,
                                name = "Adjust Tie"
                            }, {
                                clip = "shadow_boxing",
                                controllable = true,
                                dictionary = "anim@mp_player_intcelebrationmale@shadow_boxing",
                                emote_duration = 4000,
                                name = "Boxing"
                            }, {
                                clip = "shadow_boxing",
                                controllable = true,
                                dictionary = "anim@mp_player_intcelebrationfemale@shadow_boxing",
                                emote_duration = 4000,
                                name = "Boxing 2"
                            }, {
                                clip = "mind_blown",
                                controllable = true,
                                dictionary = "anim@mp_player_intcelebrationmale@mind_blown",
                                emote_duration = 4000,
                                name = "Mind Blown"
                            }, {
                                clip = "mind_blown",
                                controllable = true,
                                dictionary = "anim@mp_player_intcelebrationfemale@mind_blown",
                                emote_duration = 4000,
                                name = "Mind Blown 2"
                            }, {
                                clip = "stinker",
                                controllable = true,
                                dictionary = "anim@mp_player_intcelebrationfemale@stinker",
                                loop = true,
                                name = "Stink"
                            }, {
                                clip = "idle_a",
                                controllable = true,
                                dictionary = "anim@amb@casino@hangout@ped_male@stand@02b@idles",
                                loop = true,
                                name = "Think 4"
                            } },
                  name = "Misc"
              }, {
                  is_folder = true,
                  items = { {
                                clip = "idle",
                                controllable = true,
                                dictionary = "move_p_m_zero_rucksack",
                                loop = true,
                                name = "Backpack",
                                props = { {
                                              bone = 24818,
                                              placement = { 0.07, -0.11, -0.05, 0.0, 90.0, 175.0 },
                                              prop = "p_michael_backpack_s"
                                          } }
                            }, {
                                clip = "idle_c",
                                controllable = true,
                                dictionary = "amb@world_human_drinking@coffee@male@idle_a",
                                loop = true,
                                name = "Beer",
                                props = { {
                                              bone = 28422,
                                              placement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
                                              prop = "prop_amb_beer_bottle"
                                          } }
                            }, {
                                clip = "base",
                                controllable = true,
                                dictionary = "amb@world_human_bum_freeway@male@base",
                                loop = true,
                                name = "Beg",
                                props = { {
                                              bone = 58868,
                                              placement = { 0.19, 0.18, 0.0, 5.0, 0.0, 40.0 },
                                              prop = "prop_beggers_sign_03"
                                          } }
                            }, {
                                clip = "bong_stage3",
                                dictionary = "anim@safehouse@bong",
                                name = "Bong",
                                props = { {
                                              bone = 18905,
                                              placement = { 0.1, -0.25, 0.0, 95.0, 190.0, 180.0 },
                                              prop = "hei_heist_sh_bong_01"
                                          } }
                            }, {
                                clip = "cellphone_text_read_base",
                                controllable = true,
                                dictionary = "cellphone@",
                                loop = true,
                                name = "Book",
                                props = { {
                                              bone = 6286,
                                              placement = { 0.15, 0.03, -0.065, 0.0, 180.0, 90.0 },
                                              prop = "prop_novel_01"
                                          } }
                            }, {
                                clip = "mp_m_waremech_01_dual-0",
                                controllable = true,
                                dictionary = "impexp_int-0",
                                loop = true,
                                name = "Bouquet",
                                props = { {
                                              bone = 24817,
                                              placement = { -0.29, 0.4, -0.02, -90.0, -90.0, 0.0 },
                                              prop = "prop_snow_flower_02"
                                          } }
                            }, {
                                clip = "idle",
                                controllable = true,
                                dictionary = "anim@heists@box_carry@",
                                loop = true,
                                name = "Box",
                                props = { {
                                              bone = 60309,
                                              placement = { 0.025, 0.08, 0.255, -145.0, 290.0, 0.0 },
                                              prop = "hei_prop_heist_box"
                                          } }
                            }, {
                                clip = "static",
                                controllable = true,
                                dictionary = "missheistdocksprep1hold_cellphone",
                                loop = true,
                                name = "Brief 3",
                                props = { {
                                              bone = 57005,
                                              placement = { 0.1, 0.0, 0.0, 0.0, 280.0, 53.0 },
                                              prop = "prop_ld_case_01"
                                          } }
                            }, {
                                clip = "mp_player_int_eat_burger",
                                controllable = true,
                                dictionary = "mp_player_inteat@burger",
                                name = "Burger",
                                props = { {
                                              bone = 18905,
                                              placement = { 0.13, 0.05, 0.02, -50.0, 16.0, 60.0 },
                                              prop = "prop_cs_burger_01"
                                          } }
                            }, {
                                clip = "ped_a_enter_loop",
                                controllable = true,
                                dictionary = "anim@heists@humane_labs@finale@keycards",
                                loop = true,
                                name = "Champagne",
                                props = { {
                                              bone = 18905,
                                              placement = { 0.1, -0.03, 0.03, -100.0, 0.0, -10.0 },
                                              prop = "prop_drink_champ"
                                          } }
                            }, {
                                clip = "enter",
                                controllable = true,
                                dictionary = "amb@world_human_smoking@male@male_a@enter",
                                emote_duration = 2600,
                                name = "Cig",
                                props = { {
                                              bone = 47419,
                                              placement = { 0.015, -0.009, 0.003, 55.0, 0.0, 110.0 },
                                              prop = "prop_amb_ciggy_01"
                                          } }
                            }, {
                                clip = "enter",
                                controllable = true,
                                dictionary = "amb@world_human_smoking@male@male_a@enter",
                                emote_duration = 2600,
                                name = "Cigar",
                                props = { {
                                              bone = 47419,
                                              placement = { 0.01, 0.0, 0.0, 50.0, 0.0, -80.0 },
                                              prop = "prop_cigar_02"
                                          } }
                            }, {
                                clip = "enter",
                                controllable = true,
                                dictionary = "amb@world_human_smoking@male@male_a@enter",
                                emote_duration = 2600,
                                name = "Cigar 2",
                                props = { {
                                              bone = 47419,
                                              placement = { 0.01, 0.0, 0.0, 50.0, 0.0, -80.0 },
                                              prop = "prop_cigar_01"
                                          } }
                            }, {
                                clip = "base",
                                controllable = true,
                                dictionary = "timetable@floyd@clean_kitchen@base",
                                loop = true,
                                name = "Clean",
                                props = { {
                                              bone = 28422,
                                              placement = { 0.0, 0.0, -0.01, 90.0, 0.0, 0.0 },
                                              prop = "prop_sponge_01"
                                          } }
                            }, {
                                clip = "base",
                                controllable = true,
                                dictionary = "amb@world_human_maid_clean@",
                                loop = true,
                                name = "Clean 2",
                                props = { {
                                              bone = 28422,
                                              placement = { 0.0, 0.0, -0.01, 90.0, 0.0, 0.0 },
                                              prop = "prop_sponge_01"
                                          } }
                            }, {
                                clip = "base",
                                controllable = true,
                                dictionary = "missfam4",
                                loop = true,
                                name = "Clipboard",
                                props = { {
                                              bone = 36029,
                                              placement = { 0.16, 0.08, 0.1, -130.0, -50.0, 0.0 },
                                              prop = "p_amb_clipboard_01"
                                          } }
                            }, {
                                clip = "idle_c",
                                controllable = true,
                                dictionary = "amb@world_human_drinking@coffee@male@idle_a",
                                loop = true,
                                name = "Coffee",
                                props = { {
                                              bone = 28422,
                                              placement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
                                              prop = "p_amb_coffeecup_01"
                                          } }
                            }, {
                                clip = "idle_c",
                                controllable = true,
                                dictionary = "amb@world_human_drinking@coffee@male@idle_a",
                                loop = true,
                                name = "Cup",
                                props = { {
                                              bone = 28422,
                                              placement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
                                              prop = "prop_plastic_cup_02"
                                          } }
                            }, {
                                clip = "mp_player_int_eat_burger",
                                controllable = true,
                                dictionary = "mp_player_inteat@burger",
                                name = "Donut",
                                props = { {
                                              bone = 18905,
                                              placement = { 0.13, 0.05, 0.02, -50.0, 16.0, 60.0 },
                                              prop = "prop_amb_donut"
                                          } }
                            }, {
                                clip = "mp_player_int_eat_burger",
                                controllable = true,
                                dictionary = "mp_player_inteat@burger",
                                name = "Ego Bar",
                                props = { {
                                              bone = 60309,
                                              placement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
                                              prop = "prop_choc_ego"
                                          } }
                            }, {
                                clip = "ped_a_enter_loop",
                                controllable = true,
                                dictionary = "anim@heists@humane_labs@finale@keycards",
                                loop = true,
                                name = "Flute",
                                props = { {
                                              bone = 18905,
                                              placement = { 0.1, -0.03, 0.03, -100.0, 0.0, -10.0 },
                                              prop = "prop_champ_flute"
                                          } }
                            }, {
                                clip = "idle_b",
                                controllable = true,
                                dictionary = "amb@world_human_musician@guitar@male@idle_a",
                                loop = true,
                                name = "Guitar",
                                props = { {
                                              bone = 24818,
                                              placement = { -0.1, 0.31, 0.1, 0.0, 20.0, 150.0 },
                                              prop = "prop_acc_guitar_01"
                                          } }
                            }, {
                                clip = "001370_02_trvs_8_guitar_beatdown_idle_busker",
                                controllable = true,
                                dictionary = "switch@trevor@guitar_beatdown",
                                loop = true,
                                name = "Guitar 2",
                                props = { {
                                              bone = 24818,
                                              placement = { -0.05, 0.31, 0.1, 0.0, 20.0, 150.0 },
                                              prop = "prop_acc_guitar_01"
                                          } }
                            }, {
                                clip = "idle_b",
                                controllable = true,
                                dictionary = "amb@world_human_musician@guitar@male@idle_a",
                                loop = true,
                                name = "Guitar Electric",
                                props = { {
                                              bone = 24818,
                                              placement = { -0.1, 0.31, 0.1, 0.0, 20.0, 150.0 },
                                              prop = "prop_el_guitar_01"
                                          } }
                            }, {
                                clip = "idle_b",
                                controllable = true,
                                dictionary = "amb@world_human_musician@guitar@male@idle_a",
                                loop = true,
                                name = "Guitar Electric 2",
                                props = { {
                                              bone = 24818,
                                              placement = { -0.1, 0.31, 0.1, 0.0, 20.0, 150.0 },
                                              prop = "prop_el_guitar_03"
                                          } }
                            }, {
                                clip = "enter",
                                controllable = true,
                                dictionary = "amb@world_human_smoking@male@male_a@enter",
                                emote_duration = 2600,
                                name = "Joint",
                                props = { {
                                              bone = 47419,
                                              placement = { 0.015, -0.009, 0.003, 55.0, 0.0, 110.0 },
                                              prop = "p_cs_joint_02"
                                          } }
                            }, {
                                clip = "base",
                                controllable = true,
                                dictionary = "amb@world_human_tourist_map@male@base",
                                loop = true,
                                name = "Map",
                                props = { {
                                              bone = 28422,
                                              placement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
                                              prop = "prop_tourist_map_01"
                                          } }
                            }, {
                                clip = "loop",
                                controllable = true,
                                dictionary = "mp_character_creation@customise@male_a",
                                loop = true,
                                name = "Mugshot",
                                props = { {
                                              bone = 58868,
                                              placement = { 0.12, 0.24, 0.0, 5.0, 0.0, 70.0 },
                                              prop = "prop_police_id_board"
                                          } }
                            }, {
                                clip = "base",
                                controllable = true,
                                dictionary = "missheistdockssetup1clipboard@base",
                                loop = true,
                                name = "Notepad",
                                props = { {
                                              bone = 18905,
                                              placement = { 0.1, 0.02, 0.05, 10.0, 0.0, 0.0 },
                                              prop = "prop_notepad_01"
                                          }, {
                                              bone = 58866,
                                              placement = { 0.11, -0.02, 0.001, -120.0, 0.0, 0.0 },
                                              prop = "prop_pencil_01"
                                          } }
                            }, {
                                clip = "cellphone_text_read_base",
                                controllable = true,
                                dictionary = "cellphone@",
                                loop = true,
                                name = "Phone",
                                props = { {
                                              bone = 28422,
                                              placement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
                                              prop = "prop_npc_phone_02"
                                          } }
                            }, {
                                clip = "cellphone_call_listen_base",
                                controllable = true,
                                dictionary = "cellphone@",
                                loop = true,
                                name = "Phone Call",
                                props = { {
                                              bone = 28422,
                                              placement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
                                              prop = "prop_npc_phone_02"
                                          } }
                            }, {
                                clip = "ped_a_enter_loop",
                                controllable = true,
                                dictionary = "anim@heists@humane_labs@finale@keycards",
                                loop = true,
                                name = "Rose",
                                props = { {
                                              bone = 18905,
                                              placement = { 0.13, 0.15, 0.0, -100.0, 0.0, -20.0 },
                                              prop = "prop_single_rose"
                                          } }
                            }, {
                                clip = "mp_player_int_eat_burger",
                                controllable = true,
                                dictionary = "mp_player_inteat@burger",
                                name = "Sandwich",
                                props = { {
                                              bone = 18905,
                                              placement = { 0.13, 0.05, 0.02, -50.0, 16.0, 60.0 },
                                              prop = "prop_sandwich_01"
                                          } }
                            }, {
                                clip = "idle_c",
                                controllable = true,
                                dictionary = "amb@world_human_aa_smoke@male@idle_a",
                                loop = true,
                                name = "Smoke 2",
                                props = { {
                                              bone = 28422,
                                              placement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
                                              prop = "prop_cs_ciggy_01"
                                          } }
                            }, {
                                clip = "idle_b",
                                controllable = true,
                                dictionary = "amb@world_human_aa_smoke@male@idle_a",
                                loop = true,
                                name = "Smoke 3",
                                props = { {
                                              bone = 28422,
                                              placement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
                                              prop = "prop_cs_ciggy_01"
                                          } }
                            }, {
                                clip = "idle_b",
                                controllable = true,
                                dictionary = "amb@world_human_smoking@female@idle_a",
                                loop = true,
                                name = "Smoke 4",
                                props = { {
                                              bone = 28422,
                                              placement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
                                              prop = "prop_cs_ciggy_01"
                                          } }
                            }, {
                                clip = "idle_c",
                                controllable = true,
                                dictionary = "amb@world_human_drinking@coffee@male@idle_a",
                                loop = true,
                                name = "Soda",
                                props = { {
                                              bone = 28422,
                                              placement = { 0.0, 0.0, 0.0, 0.0, 0.0, 130.0 },
                                              prop = "prop_ecola_can"
                                          } }
                            }, {
                                clip = "static",
                                controllable = true,
                                dictionary = "missheistdocksprep1hold_cellphone",
                                loop = true,
                                name = "Suitcase",
                                props = { {
                                              bone = 57005,
                                              placement = { 0.39, 0.0, 0.0, 0.0, 266.0, 60.0 },
                                              prop = "prop_ld_suitcase_01"
                                          } }
                            }, {
                                clip = "static",
                                controllable = true,
                                dictionary = "missheistdocksprep1hold_cellphone",
                                loop = true,
                                name = "Suitcase 2",
                                props = { {
                                              bone = 57005,
                                              placement = { 0.1, 0.0, 0.0, 0.0, 280.0, 53.0 },
                                              prop = "prop_security_case_01"
                                          } }
                            }, {
                                clip = "base",
                                controllable = true,
                                dictionary = "amb@world_human_tourist_map@male@base",
                                loop = true,
                                name = "Tablet",
                                props = { {
                                              bone = 28422,
                                              placement = { 0.0, -0.03, 0.0, 20.0, -90.0, 0.0 },
                                              prop = "prop_cs_tablet"
                                          } }
                            }, {
                                clip = "idle_a",
                                controllable = true,
                                dictionary = "amb@code_human_in_bus_passenger_idles@female@tablet@idle_a",
                                loop = true,
                                name = "Tablet 2",
                                props = { {
                                              bone = 28422,
                                              placement = { -0.05, 0.0, 0.0, 0.0, 0.0, 0.0 },
                                              prop = "prop_cs_tablet"
                                          } }
                            }, {
                                clip = "mp_m_waremech_01_dual-0",
                                controllable = true,
                                dictionary = "impexp_int-0",
                                loop = true,
                                name = "Teddy",
                                props = { {
                                              bone = 24817,
                                              delete_on_end = true,
                                              placement = { -0.2, 0.46, -0.016, -180.0, -90.0, 0.0 },
                                              prop = "v_ilev_mr_rasberryclean"
                                          } }
                            }, {
                                clip = "idle_c",
                                controllable = true,
                                dictionary = "amb@world_human_drinking@coffee@male@idle_a",
                                loop = true,
                                name = "Whiskey",
                                props = { {
                                              bone = 28422,
                                              delete_on_end = true,
                                              placement = { 0.01, -0.01, -0.06, 0.0, 0.0, 0.0 },
                                              prop = "prop_drink_whisky"
                                          } }
                            }, {
                                clip = "ped_a_enter_loop",
                                controllable = true,
                                dictionary = "anim@heists@humane_labs@finale@keycards",
                                loop = true,
                                name = "Wine",
                                props = { {
                                              bone = 18905,
                                              delete_on_end = true,
                                              placement = { 0.1, -0.03, 0.03, -100.0, 0.0, -10.0 },
                                              prop = "prop_drink_redwine"
                                          } }
                            } , {
                              clip = "pd_dance_02",
                              controllable = true,
                              dictionary = "mini@strip_club@pole_dance@pole_dance2",
                              loop = true,
                              name = "Strip Pole",
                              props = { {
                                            --bone = 18905,
                                            delete_on_end = true,
                                            placement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
                                            prop = "prop_strip_pole_01"
                                        } }
                          }
                  },
                  name = "Props"
              }, {
                  is_folder = true,
                  items = { {
                                is_folder = true,
                                items = { {
                                              name = "Bird in Tree",
                                              scenario = "PROP_BIRD_IN_TREE"
                                          }, {
                                              name = "Bird on pole",
                                              scenario = "PROP_BIRD_TELEGRAPH_POLE"
                                          }, {
                                              name = "Boar Grazing",
                                              scenario = "WORLD_BOAR_GRAZING"
                                          }, {
                                              name = "Cat Sleeping (Ground)",
                                              scenario = "WORLD_CAT_SLEEPING_GROUND"
                                          }, {
                                              name = "Cat Sleeping (Ledge)",
                                              scenario = "WORLD_CAT_SLEEPING_LEDGE"
                                          }, {
                                              name = "Chicken Hawk Feeding",
                                              scenario = "WORLD_CHICKENHAWK_FEEDING"
                                          }, {
                                              name = "Chicken Hawk Standing",
                                              scenario = "WORLD_CHICKENHAWK_STANDING"
                                          }, {
                                              name = "Cormorant Standing",
                                              scenario = "WORLD_CORMORANT_STANDING"
                                          }, {
                                              name = "Cow Grazing",
                                              scenario = "WORLD_COW_GRAZING"
                                          }, {
                                              name = "Coyote Howl",
                                              scenario = "WORLD_COYOTE_HOWL"
                                          }, {
                                              name = "Coyote Rest",
                                              scenario = "WORLD_COYOTE_REST"
                                          }, {
                                              name = "Coyte Wander",
                                              scenario = "WORLD_COYOTE_WANDER"
                                          }, {
                                              name = "Crow Feeding",
                                              scenario = "WORLD_CROW_FEEDING"
                                          }, {
                                              name = "Crow Standing",
                                              scenario = "WORLD_CROW_STANDING"
                                          }, {
                                              name = "Deer Grazing",
                                              scenario = "WORLD_DEER_GRAZING"
                                          }, {
                                              name = "Dog Barking (Retriever)",
                                              scenario = "WORLD_DOG_BARKING_RETRIEVER"
                                          }, {
                                              name = "Dog Barking (Rottweiler)",
                                              scenario = "WORLD_DOG_BARKING_ROTTWEILER"
                                          }, {
                                              name = "Dog Barking (Shepherd)",
                                              scenario = "WORLD_DOG_BARKING_SHEPHERD"
                                          }, {
                                              name = "Dog Barking (Small)",
                                              scenario = "WORLD_DOG_BARKING_SMALL"
                                          }, {
                                              name = "Dog Sitting (Retriever)",
                                              scenario = "WORLD_DOG_SITTING_RETRIEVER"
                                          }, {
                                              name = "Dog Sitting (Rottweiler)",
                                              scenario = "WORLD_DOG_SITTING_ROTTWEILER"
                                          }, {
                                              name = "Dog Sitting (Shepherd)",
                                              scenario = "WORLD_DOG_SITTING_SHEPHERD"
                                          }, {
                                              name = "Dog Sitting (Small)",
                                              scenario = "WORLD_DOG_SITTING_SMALL"
                                          }, {
                                              name = "Fish Idle",
                                              scenario = "WORLD_FISH_IDLE"
                                          }, {
                                              name = "Gull Feeding",
                                              scenario = "WORLD_GULL_FEEDING"
                                          }, {
                                              name = "Gull Standing",
                                              scenario = "WORLD_GULL_STANDING"
                                          }, {
                                              name = "Hen Pecking",
                                              scenario = "WORLD_HEN_PECKING"
                                          }, {
                                              name = "Hen Standing",
                                              scenario = "WORLD_HEN_STANDING"
                                          }, {
                                              name = "Mountain Lion Rest",
                                              scenario = "WORLD_MOUNTAIN_LION_REST"
                                          }, {
                                              name = "Mountain Lion Wander",
                                              scenario = "WORLD_MOUNTAIN_LION_WANDER"
                                          }, {
                                              name = "Pig Grazing",
                                              scenario = "WORLD_PIG_GRAZING"
                                          }, {
                                              name = "Pigeon Feeding",
                                              scenario = "WORLD_PIGEON_FEEDING"
                                          }, {
                                              name = "Pigeon Standing",
                                              scenario = "WORLD_PIGEON_STANDING"
                                          }, {
                                              name = "Rabbit Eating",
                                              scenario = "WORLD_RABBIT_EATING"
                                          }, {
                                              name = "Rats Eating",
                                              scenario = "WORLD_RATS_EATING"
                                          }, {
                                              name = "Shark Swimming",
                                              scenario = "WORLD_SHARK_SWIM"
                                          } },
                                name = "ANIMALS"
                            }, {
                                is_folder = true,
                                items = { {
                                              name = "AA Coffee",
                                              scenario = "WORLD_HUMAN_AA_COFFEE"
                                          }, {
                                              name = "AA Smoking",
                                              scenario = "WORLD_HUMAN_AA_SMOKE"
                                          }, {
                                              name = "Binoculars",
                                              scenario = "WORLD_HUMAN_BINOCULARS"
                                          }, {
                                              name = "Bum Freeway",
                                              scenario = "WORLD_HUMAN_BUM_FREEWAY"
                                          }, {
                                              name = "Bum Slumped",
                                              scenario = "WORLD_HUMAN_BUM_SLUMPED"
                                          }, {
                                              name = "Bum Standing",
                                              scenario = "WORLD_HUMAN_BUM_STANDING"
                                          }, {
                                              name = "Bum Wash",
                                              scenario = "WORLD_HUMAN_BUM_WASH"
                                          }, {
                                              name = "Campfire",
                                              scenario = "WORLD_HUMAN_STAND_FIRE"
                                          }, {
                                              name = "Car Park Attendant",
                                              scenario = "WORLD_HUMAN_CAR_PARK_ATTENDANT"
                                          }, {
                                              name = "Cheering",
                                              scenario = "WORLD_HUMAN_CHEERING"
                                          }, {
                                              name = "Cleaning",
                                              scenario = "WORLD_HUMAN_MAID_CLEAN"
                                          }, {
                                              name = "Clipboard",
                                              scenario = "WORLD_HUMAN_CLIPBOARD"
                                          }, {
                                              name = "Cop Idle",
                                              scenario = "WORLD_HUMAN_COP_IDLES"
                                          }, {
                                              name = "Drill",
                                              scenario = "WORLD_HUMAN_CONST_DRILL"
                                          }, {
                                              name = "Drinking",
                                              scenario = "WORLD_HUMAN_DRINKING"
                                          }, {
                                              name = "Drug Dealer",
                                              scenario = "WORLD_HUMAN_DRUG_DEALER"
                                          }, {
                                              name = "Drug Dealer Hard",
                                              scenario = "WORLD_HUMAN_DRUG_DEALER_HARD"
                                          }, {
                                              name = "Eat on Wall",
                                              scenario = "WORLD_HUMAN_SEAT_WALL_EATING"
                                          }, {
                                              name = "Fishing",
                                              scenario = "WORLD_HUMAN_STAND_FISHING"
                                          }, {
                                              name = "Gardener",
                                              scenario = "WORLD_HUMAN_GARDENER_PLANT"
                                          }, {
                                              name = "Golfing",
                                              scenario = "WORLD_HUMAN_GOLF_PLAYER"
                                          }, {
                                              name = "Guard Patrol",
                                              scenario = "WORLD_HUMAN_GUARD_PATROL"
                                          }, {
                                              name = "Guard Stand",
                                              scenario = "WORLD_HUMAN_GUARD_STAND"
                                          }, {
                                              name = "Guard Stand (Army)",
                                              scenario = "WORLD_HUMAN_GUARD_STAND_ARMY"
                                          }, {
                                              name = "Hammering",
                                              scenario = "WORLD_HUMAN_HAMMERING"
                                          }, {
                                              name = "Hanging Out",
                                              scenario = "WORLD_HUMAN_HANG_OUT_STREET"
                                          }, {
                                              name = "Hiker Standing",
                                              scenario = "WORLD_HUMAN_HIKER_STANDING"
                                          }, {
                                              name = "Human Statue",
                                              scenario = "WORLD_HUMAN_HUMAN_STATUE"
                                          }, {
                                              name = "Impatient",
                                              scenario = "WORLD_HUMAN_STAND_IMPATIENT"
                                          }, {
                                              name = "Impatient Upright",
                                              scenario = "WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT"
                                          }, {
                                              name = "Janitor",
                                              scenario = "WORLD_HUMAN_JANITOR"
                                          }, {
                                              name = "Jog in place",
                                              scenario = "WORLD_HUMAN_JOG_STANDING"
                                          }, {
                                              name = "Leaf Blower",
                                              scenario = "WORLD_HUMAN_GARDENER_LEAF_BLOWER"
                                          }, {
                                              name = "Leaning",
                                              scenario = "WORLD_HUMAN_LEANING"
                                          }, {
                                              name = "Ledge Eating",
                                              scenario = "WORLD_HUMAN_SEAT_LEDGE_EATING"
                                          }, {
                                              name = "Ledge Sit",
                                              scenario = "WORLD_HUMAN_SEAT_LEDGE"
                                          }, {
                                              name = "Mechanic",
                                              scenario = "WORLD_HUMAN_VEHICLE_MECHANIC"
                                          }, {
                                              name = "Muscle Flex",
                                              scenario = "WORLD_HUMAN_MUSCLE_FLEX"
                                          }, {
                                              name = "Musician",
                                              scenario = "WORLD_HUMAN_MUSICIAN"
                                          }, {
                                              name = "Paparazzi",
                                              scenario = "WORLD_HUMAN_PAPARAZZI"
                                          }, {
                                              name = "Partying",
                                              scenario = "WORLD_HUMAN_PARTYING"
                                          }, {
                                              name = "Phone",
                                              scenario = "WORLD_HUMAN_STAND_MOBILE"
                                          }, {
                                              name = "Phone Filming",
                                              scenario = "WORLD_HUMAN_MOBILE_FILM_SHOCKING"
                                          }, {
                                              name = "Phone Upright",
                                              scenario = "WORLD_HUMAN_STAND_MOBILE_UPRIGHT"
                                          }, {
                                              name = "Picnic",
                                              scenario = "WORLD_HUMAN_PICNIC"
                                          }, {
                                              name = "Prositute (High Class)",
                                              scenario = "WORLD_HUMAN_PROSTITUTE_HIGH_CLASS"
                                          }, {
                                              name = "Prostitute (Low Class)",
                                              scenario = "WORLD_HUMAN_PROSTITUTE_LOW_CLASS"
                                          }, {
                                              name = "Push Ups",
                                              scenario = "WORLD_HUMAN_PUSH_UPS"
                                          }, {
                                              name = "Shine Torch",
                                              scenario = "WORLD_HUMAN_SECURITY_SHINE_TORCH"
                                          }, {
                                              name = "Sit on Steps",
                                              scenario = "WORLD_HUMAN_SEAT_STEPS"
                                          }, {
                                              name = "Sit on Wall",
                                              scenario = "WORLD_HUMAN_SEAT_WALL"
                                          }, {
                                              name = "Situps",
                                              scenario = "WORLD_HUMAN_SIT_UPS"
                                          }, {
                                              name = "Smoking",
                                              scenario = "WORLD_HUMAN_SMOKING"
                                          }, {
                                              name = "Smoking Pot",
                                              scenario = "WORLD_HUMAN_SMOKING_POT"
                                          }, {
                                              name = "Stupor",
                                              scenario = "WORLD_HUMAN_STUPOR"
                                          }, {
                                              name = "Sunbathe",
                                              scenario = "WORLD_HUMAN_SUNBATHE"
                                          }, {
                                              name = "Sunbathe Back",
                                              scenario = "WORLD_HUMAN_SUNBATHE_BACK"
                                          }, {
                                              name = "Superhero",
                                              scenario = "WORLD_HUMAN_SUPERHERO"
                                          }, {
                                              name = "Swimming",
                                              scenario = "WORLD_HUMAN_SWIMMING"
                                          }, {
                                              name = "Tablet on Wall",
                                              scenario = "WORLD_HUMAN_SEAT_WALL_TABLET"
                                          }, {
                                              name = "Tennis Player",
                                              scenario = "WORLD_HUMAN_TENNIS_PLAYER"
                                          }, {
                                              name = "Tourist Map",
                                              scenario = "WORLD_HUMAN_TOURIST_MAP"
                                          }, {
                                              name = "Tourist Phone",
                                              scenario = "WORLD_HUMAN_TOURIST_MOBILE"
                                          }, {
                                              name = "Watch Stand",
                                              scenario = "WORLD_HUMAN_STRIP_WATCH_STAND"
                                          }, {
                                              name = "Weights",
                                              scenario = "WORLD_HUMAN_MUSCLE_FREE_WEIGHTS"
                                          }, {
                                              name = "Welding",
                                              scenario = "WORLD_HUMAN_WELDING"
                                          }, {
                                              name = "Window Browsing",
                                              scenario = "WORLD_HUMAN_WINDOW_SHOP_BROWSE"
                                          }, {
                                              name = "Yoga",
                                              scenario = "WORLD_HUMAN_YOGA"
                                          } },
                                name = "HUMAN"
                            }, {
                                is_folder = true,
                                items = { {
                                              name = "ATM",
                                              scenario = "PROP_HUMAN_ATM"
                                          }, {
                                              name = "BBQ",
                                              scenario = "PROP_HUMAN_BBQ"
                                          }, {
                                              name = "BUM Shopping Cart",
                                              scenario = "PROP_HUMAN_BUM_SHOPPING_CART"
                                          }, {
                                              name = "Bench Press",
                                              scenario = "PROP_HUMAN_SEAT_MUSCLE_BENCH_PRESS"
                                          }, {
                                              name = "Bench Press (Prison)",
                                              scenario = "PROP_HUMAN_SEAT_MUSCLE_BENCH_PRESS_PRISON"
                                          }, {
                                              name = "Bum Bin",
                                              scenario = "PROP_HUMAN_BUM_BIN"
                                          }, {
                                              name = "Bus Stop Wait",
                                              scenario = "PROP_HUMAN_SEAT_BUS_STOP_WAIT"
                                          }, {
                                              name = "Cower",
                                              scenario = "CODE_HUMAN_COWER"
                                          }, {
                                              name = "Cower (Standing)",
                                              scenario = "CODE_HUMAN_STAND_COWER"
                                          }, {
                                              name = "Cross road wait",
                                              scenario = "CODE_HUMAN_CROSS_ROAD_WAIT"
                                          }, {
                                              name = "Ear to Text",
                                              scenario = "EAR_TO_TEXT"
                                          }, {
                                              name = "Ear to Text (Fat)",
                                              scenario = "EAR_TO_TEXT_FAT"
                                          }, {
                                              name = "Impatient",
                                              scenario = "PROP_HUMAN_STAND_IMPATIENT"
                                          }, {
                                              name = "Medic Kneel",
                                              scenario = "CODE_HUMAN_MEDIC_KNEEL"
                                          }, {
                                              name = "Medic Tend",
                                              scenario = "CODE_HUMAN_MEDIC_TEND_TO_DEAD"
                                          }, {
                                              name = "Medic Time of Death",
                                              scenario = "CODE_HUMAN_MEDIC_TIME_OF_DEATH"
                                          }, {
                                              name = "Movie Bulb",
                                              scenario = "PROP_HUMAN_MOVIE_BULB"
                                          }, {
                                              name = "Movie Studio Light",
                                              scenario = "PROP_HUMAN_MOVIE_STUDIO_LIGHT"
                                          }, {
                                              name = "Muscle Chinups",
                                              scenario = "PROP_HUMAN_MUSCLE_CHIN_UPS"
                                          }, {
                                              name = "Muscle Chinups (Army)",
                                              scenario = "PROP_HUMAN_MUSCLE_CHIN_UPS_ARMY"
                                          }, {
                                              name = "Muscle Chinups (Prison)",
                                              scenario = "PROP_HUMAN_MUSCLE_CHIN_UPS_PRISON"
                                          }, {
                                              name = "Park Car",
                                              scenario = "CODE_HUMAN_PARK_CAR"
                                          }, {
                                              name = "Parking Meter",
                                              scenario = "PROP_HUMAN_PARKING_METER"
                                          }, {
                                              name = "Police Crowd Control",
                                              scenario = "CODE_HUMAN_POLICE_CROWD_CONTROL"
                                          }, {
                                              name = "Police Investigate",
                                              scenario = "CODE_HUMAN_POLICE_INVESTIGATE"
                                          }, {
                                              name = "Sit & Drink (Bench)",
                                              scenario = "PROP_HUMAN_SEAT_BENCH_DRINK"
                                          }, {
                                              name = "Sit & Drink (Chair)",
                                              scenario = "PROP_HUMAN_SEAT_CHAIR_DRINK"
                                          }, {
                                              name = "Sit & Drink (Deckchair)",
                                              scenario = "PROP_HUMAN_SEAT_DECKCHAIR_DRINK"
                                          }, {
                                              name = "Sit & Drink Beer (Bench)",
                                              scenario = "PROP_HUMAN_SEAT_BENCH_DRINK_BEER"
                                          }, {
                                              name = "Sit & Drink Beer (Chair)",
                                              scenario = "PROP_HUMAN_SEAT_CHAIR_DRINK_BEER"
                                          }, {
                                              name = "Sit & Eat (Bench)",
                                              scenario = "PROP_HUMAN_SEAT_BENCH_FOOD"
                                          }, {
                                              name = "Sit & Eat (Chair)",
                                              scenario = "PROP_HUMAN_SEAT_CHAIR_FOOD"
                                          }, {
                                              name = "Sit (Armchair)",
                                              scenario = "PROP_HUMAN_SEAT_ARMCHAIR"
                                          }, {
                                              name = "Sit (Bar)",
                                              scenario = "PROP_HUMAN_SEAT_BAR"
                                          }, {
                                              name = "Sit (Bench)",
                                              scenario = "PROP_HUMAN_SEAT_BENCH"
                                          }, {
                                              name = "Sit (Chair)",
                                              scenario = "PROP_HUMAN_SEAT_CHAIR"
                                          }, {
                                              name = "Sit (Computer)",
                                              scenario = "PROP_HUMAN_SEAT_COMPUTER"
                                          }, {
                                              name = "Sit (Deckchair)",
                                              scenario = "PROP_HUMAN_SEAT_DECKCHAIR"
                                          }, {
                                              name = "Sit (Sewing)",
                                              scenario = "PROP_HUMAN_SEAT_SEWING"
                                          }, {
                                              name = "Sit (Stripclub)",
                                              scenario = "PROP_HUMAN_SEAT_STRIP_WATCH"
                                          }, {
                                              name = "Sit (Sunlounger)",
                                              scenario = "PROP_HUMAN_SEAT_SUNLOUNGER"
                                          }, {
                                              name = "Sit MP Player",
                                              scenario = "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER"
                                          }, {
                                              name = "Sit Upright (Chair)",
                                              scenario = "PROP_HUMAN_SEAT_CHAIR_UPRIGHT"
                                          } },
                                name = "HUMAN2"
                            } },
                  name = "Scenarios"
              } }
}

return constants
