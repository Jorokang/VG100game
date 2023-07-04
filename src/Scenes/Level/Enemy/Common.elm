module Scenes.Level.Enemy.Common exposing (Model, nullModel, EnvC, EnemyState(..), initEnemy1, EnemyBlock, Cell, EnemyCore, GridLoc, grid2real)

{-| Common module

@docs Model, nullModel, EnvC

-}

import Canvas exposing (Point)
import Color exposing (Color)
import Lib.Env.Env as Env
import Scenes.Level.LayerBase exposing (CommonData)
import Scenes.Level.Frame.Functions exposing (coorChange, point2Int, int2Point, cellLength)
import Random
import Scenes.Level.Enemy.Random exposing (randomEnemy)
import Time exposing (Posix, now)


{-| Model
Add your own data here.
-}

type EnemyState
    =   Alive
    |   Stopped
    |   Dead

type alias GridLoc =
    ( Int, Int )

type alias Cell a =
    {
        val : a
    ,   loc : GridLoc
    }

type alias Grid a =
    List (Cell a)

type alias EnemyCore = 
    {
        color : Color
    ,   hp : Int
    }

type alias EnemyBlock =
    {
        color : Color
    ,   hp : Int
    }

type alias Model =
    {
        state : EnemyState
    ,   body : Grid EnemyBlock
    ,   core : Cell EnemyCore
    ,   map_size : GridLoc
    ,   seed : Random.Seed
    ,   randNum : Int
    ,   time : Int
    ,   target : GridLoc
    }


{-| nullModel
-}

nullEnemyCore : Cell EnemyCore
nullEnemyCore =
    {
        val = { color = Color.red
            ,   hp = 1
            }
    ,   loc = ( 3, 1 )
    }

nullModel : Model
nullModel =
    let
        (number, seed) =
            randomEnemy (Random.initialSeed 0)
    in
    {
        state = Stopped
    ,   body = []
    ,   core = nullEnemyCore
    ,   map_size = ( 0, 0 )
    ,   seed = seed
    ,   randNum = number
    ,   time = 0
    ,   target = ( -1, -1 )
    }

initEnemy1 : Model
initEnemy1 =
    let
        (number, seed) =
            randomEnemy (Random.initialSeed 0)
    in
    {
        state = Alive
    ,   body = [    {   val = { color = Color.black
                            ,   hp = 1}
                    ,   loc = ( 3, 1 )
                        }
                ]
    ,   core = nullEnemyCore
    ,   map_size = ( 4, 3 )
    ,   seed = seed
    ,   randNum = number
    ,   time = 0
    ,   target = ( -1, -1 )
    }

grid2real : (Int,Int) -> Point
grid2real (x,y) =
    ( (toFloat x)*cellLength , (toFloat y)*cellLength ) 

{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
