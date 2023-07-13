module Scenes.Level.Enemy.Common exposing
    ( Model, nullModel, EnvC
    , Cell, EnemyBlock, EnemyCore, EnemyState(..), GridLoc, initEnemy1, maxEyeV
    )

{-| Common module

@docs Model, nullModel, EnvC

-}

import Canvas exposing (Point)
import Color exposing (Color)
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
    = Alive
    | Stopped
    | Dead


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
    }


{-| nullModel
-}
nullEnemyCore : Cell EnemyCore
nullEnemyCore =
    { val =
        { color = Color.red
        , hp = 1
        }
    , loc = ( 3, 1 )
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
    { status = Stopped
    , body = []
    , core = nullEnemyCore
    , map_size = ( 0, 0 )
    , seed = seed
    , randNum = number
    , time = 0
    , target = ( -1, -1 )
    , eye = nullEnemyEye
    }


initEnemy1 : Model
initEnemy1 =
    let
        ( number, seed ) =
            randomEnemy (Random.initialSeed 0)
    in
    { status = Alive
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
    }


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
