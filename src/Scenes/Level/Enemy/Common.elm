module Scenes.Level.Enemy.Common exposing
    ( Model, nullModel, EnvC
    , Cell, EnemyBlock, EnemyCore, EnemyState(..), ErodePriority(..), GridLoc, initEnemy1, initEnemyLevel1, initEnemyLevel2, maxEyeV, targetPriority1
    )

{-| Common module

@docs Model, nullModel, EnvC

-}

import Canvas exposing (Point)
import Color exposing (Color, rgb255)
import Lib.Env.Env as Env
import Random
import Scenes.Level.Enemy.Random exposing (randomEnemy)
import Scenes.Level.Frame.Functions exposing (cellLength, int2Point, point2Int)
import Scenes.Level.LayerBase exposing (CommonData)
import Time exposing (Posix, now)


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
    , eroding = False
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
    , target_priority = targetPriority1
    , eroding = True
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
          , loc = ( 5, 0 )
          }
        ]
    , core = initEnemyCoreLevel1
    , map_size = ( 5, 4 )
    , seed = seed
    , randNum = number
    , time = 0
    , target = ( -1, -1 )
    , eye = initEnemyEyeLevel1
    , recursion_times = 0
    , target_priority = targetPriorityLevel1
    , eroding = True
    }


initEnemyEyeLevel1 : EnemyEye
initEnemyEyeLevel1 =
    { pos = ( 550, 50 )
    , v = ( 0, 0 )
    , target = ( 550, 50 )
    , target_eroded = True
    , target_loc = ( 5, 0 )
    }


initEnemyCoreLevel1 : Cell EnemyCore
initEnemyCoreLevel1 =
    { val =
        { color = Color.red
        , hp = 1
        }
    , loc = ( 5, 0 )
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
          , loc = ( 3, 6 )
          }
        ]
    , core = initEnemyCoreLevel2
    , map_size = ( 4, 6 )
    , seed = seed
    , randNum = number
    , time = 0
    , target = ( -1, -1 )
    , eye = initEnemyEyeLevel2
    , recursion_times = 0
    , target_priority = targetPriorityLevel2
    , eroding = True
    }


initEnemyEyeLevel2 : EnemyEye
initEnemyEyeLevel2 =
    { pos = ( 350, 650 )
    , v = ( 0, 0 )
    , target = ( 350, 650 )
    , target_eroded = True
    , target_loc = ( 3, 6 )
    }


initEnemyCoreLevel2 : Cell EnemyCore
initEnemyCoreLevel2 =
    { val =
        { color = Color.purple
        , hp = 1
        }
    , loc = ( 3, 6 )
    }


targetPriorityLevel2 : List ErodePriority
targetPriorityLevel2 =
    [ ErodeNearest, ErodeRandom, ErodeNearest ]


targetPriority1 : List ErodePriority
targetPriority1 =
    [ ErodeNearest, ErodeNearest ]


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
