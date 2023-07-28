module Scenes.Level.Enemy.Common exposing
    ( Model, nullModel, EnvC
    , Cell, EnemyBlock, EnemyCore, EnemyState(..), ErodePriority(..), GridLoc, MinorEyes
    , initEnemy1, initEnemyLevel1, initEnemyLevel2, initEnemyLevel3, maxEyeV
    )

{-| Common module


# Basic data

@docs Model, nullModel, EnvC


# Data types

@docs Cell, EnemyBlock, EnemyCore, EnemyState, ErodePriority, GridLoc, MinorEyes, EnemyState, ErodePriority


# Functions

@docs initEnemy1, initEnemyLevel1, initEnemyLevel2, initEnemyLevel3, maxEyeV

-}

import Canvas exposing (Point)
import Color exposing (Color)
import Lib.Env.Env as Env
import Random
import Scenes.Level.Enemy.Random exposing (randomEnemy)
import Scenes.Level.LayerBase exposing (CommonData)


{-| Model
Add your own data here.
-}
type EnemyState
    = EnemyAlive
    | EnemySettingTarget
    | EnemyMoving
    | EnemyStopped
    | EnemyDead


type ErodePriority
    = ErodeNearest
    | ErodeRandom


type alias GridLoc =
    ( Int, Int )


type alias Cell a =
    { val : a
    , loc : GridLoc
    }


type alias Grid a =
    List (Cell a)


type alias EnemyCore =
    { color : Color
    , hp : Int
    }


type alias EnemyBlock =
    { color : Color
    , hp : Int
    }


type alias EnemyEye =
    { pos : Point
    , v : Point
    , target : Point
    , target_eroded : Bool
    , target_loc : GridLoc
    }


type alias MinorEyes =
    { pos : Point
    , active : Bool
    }


type alias Model =
    { status : EnemyState
    , body : Grid EnemyBlock
    , core : Cell EnemyCore
    , map_size : GridLoc
    , seed : Random.Seed
    , randNum : Int
    , time : Int
    , target : GridLoc
    , eye : EnemyEye
    , recursion_times : Int
    , target_priority : List ErodePriority
    , eroding : Bool
    , meye1 : MinorEyes
    , meye2 : MinorEyes
    , static_priority : List ErodePriority
    , level_id : Int
    }


{-| nullModel
-}
nullEnemyCore : Cell EnemyCore
nullEnemyCore =
    { val =
        { color = Color.red
        , hp = 0
        }
    , loc = ( 0, 0 )
    }


nullEnemyEye : EnemyEye
nullEnemyEye =
    { pos = ( 350, 150 )
    , v = ( 0, 0 )
    , target = ( 350, 150 )
    , target_eroded = True
    , target_loc = ( 3, 1 )
    }


maxEyeV : Float
maxEyeV =
    5


nullModel : Model
nullModel =
    let
        ( number, seed ) =
            randomEnemy (Random.initialSeed 0)
    in
    { status = EnemyStopped
    , body = []
    , core = nullEnemyCore
    , map_size = ( 0, 0 )
    , seed = seed
    , randNum = number
    , time = 0
    , target = ( -1, -1 )
    , eye = nullEnemyEye
    , recursion_times = 0
    , target_priority = []
    , static_priority = []
    , eroding = False
    , meye1 = initMinorEyeNull
    , meye2 = initMinorEyeNull
    , level_id = -1
    }


initEnemy1 : Model
initEnemy1 =
    let
        ( number, seed ) =
            randomEnemy (Random.initialSeed 0)
    in
    { status = EnemyAlive
    , body =
        [ { val =
                { color = Color.black
                , hp = 1
                }
          , loc = ( 3, 1 )
          }
        ]
    , core = nullEnemyCore
    , map_size = ( 3, 4 )
    , seed = seed
    , randNum = number
    , time = 0
    , target = ( -1, -1 )
    , eye = nullEnemyEye
    , recursion_times = 0
    , target_priority = []
    , static_priority = []
    , eroding = True
    , meye1 = initMinorEyeNull
    , meye2 = initMinorEyeNull
    , level_id = -1
    }


{-| The enemy for level 1
-}
initEnemyLevel1 : Model
initEnemyLevel1 =
    let
        ( number, seed ) =
            randomEnemy (Random.initialSeed 0)
    in
    { status = EnemyAlive
    , body =
        [ { val =
                { color = Color.rgb255 30 30 40
                , hp = 1
                }
          , loc = ( 1, 2 )
          }
        ]
    , core = initEnemyCoreLevel1
    , map_size = ( 2, 2 )
    , seed = seed
    , randNum = number
    , time = 0
    , target = ( -1, -1 )
    , eye = initEnemyEyeLevel1
    , recursion_times = 0
    , target_priority = targetPriorityLevel1
    , static_priority = targetPriorityLevel1
    , eroding = True
    , meye1 = initMinorEyeNull
    , meye2 = initMinorEyeNull
    , level_id = 1
    }


initMinorEyeNull : MinorEyes
initMinorEyeNull =
    { pos = ( 0, 0 )
    , active = False
    }


initEnemyEyeLevel1 : EnemyEye
initEnemyEyeLevel1 =
    { pos = ( 150, 50 )
    , v = ( 0, 0 )
    , target = ( 150, 50 )
    , target_eroded = True
    , target_loc = ( 1, 2 )
    }


initEnemyCoreLevel1 : Cell EnemyCore
initEnemyCoreLevel1 =
    { val =
        { color = Color.red
        , hp = 1
        }
    , loc = ( 1, 2 )
    }


targetPriorityLevel1 : List ErodePriority
targetPriorityLevel1 =
    [ ErodeNearest ]


{-| The enemy for level 2
-}
initEnemyLevel2 : Model
initEnemyLevel2 =
    let
        ( number, seed ) =
            randomEnemy (Random.initialSeed 0)
    in
    { status = EnemyAlive
    , body =
        [ { val =
                { color = Color.rgb255 30 30 40
                , hp = 1
                }
          , loc = ( 4, 3 )
          }
        ]
    , core = initEnemyCoreLevel2
    , map_size = ( 4, 3 )
    , seed = seed
    , randNum = number
    , time = 0
    , target = ( -1, -1 )
    , eye = initEnemyEyeLevel2
    , recursion_times = 0
    , target_priority = targetPriorityLevel2
    , static_priority = targetPriorityLevel2
    , eroding = True
    , meye1 = initMinorEyeNull
    , meye2 = initMinorEyeNull
    , level_id = 2
    }


initEnemyEyeLevel2 : EnemyEye
initEnemyEyeLevel2 =
    { pos = ( 250, 150 )
    , v = ( 0, 0 )
    , target = ( 250, 150 )
    , target_eroded = True
    , target_loc = ( 3, 2 )
    }


initEnemyCoreLevel2 : Cell EnemyCore
initEnemyCoreLevel2 =
    { val =
        { color = Color.purple
        , hp = 1
        }
    , loc = ( 4, 3 )
    }


targetPriorityLevel2 : List ErodePriority
targetPriorityLevel2 =
    [ ErodeNearest, ErodeRandom, ErodeNearest ]


{-| The enemy for level 2
-}
initEnemyLevel3 : Model
initEnemyLevel3 =
    let
        ( number, seed ) =
            randomEnemy (Random.initialSeed 0)
    in
    { status = EnemyAlive
    , body =
        [ { val =
                { color = Color.rgb255 30 30 40
                , hp = 1
                }
          , loc = ( 5, 5 )
          }
        ]
    , core = initEnemyCoreLevel3
    , map_size = ( 5, 5 )
    , seed = seed
    , randNum = number
    , time = 0
    , target = ( -1, -1 )
    , eye = initEnemyEyeLevel3
    , recursion_times = 0
    , target_priority = targetPriorityLevel3
    , static_priority = targetPriorityLevel3
    , eroding = True
    , meye1 = initMinorEyeLevel31
    , meye2 = initMinorEyeLevel32
    , level_id = 3
    }


initMinorEyeLevel31 : MinorEyes
initMinorEyeLevel31 =
    { pos = ( 0, 0 )
    , active = True
    }


initMinorEyeLevel32 : MinorEyes
initMinorEyeLevel32 =
    { pos = ( 0, 0 )
    , active = True
    }


initEnemyEyeLevel3 : EnemyEye
initEnemyEyeLevel3 =
    { pos = ( 250, 250 )
    , v = ( 0, 0 )
    , target = ( 250, 250 )
    , target_eroded = True
    , target_loc = ( 2, 2 )
    }


initEnemyCoreLevel3 : Cell EnemyCore
initEnemyCoreLevel3 =
    { val =
        { color = Color.purple
        , hp = 1
        }
    , loc = ( 4, 5 )
    }


targetPriorityLevel3 : List ErodePriority
targetPriorityLevel3 =
    [ ErodeNearest, ErodeNearest ]


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
