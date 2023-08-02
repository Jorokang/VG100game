module Scenes.Level.Grids.Common exposing
    ( Model, nullModel, EnvC
    , Cell, Grid, GridLoc, GridsStatus(..), Plot, PlotEffect(..), SingleAnimation, TableLight
    , emptyPlot, initGrids1, initGridsLevel1, initGridsLevel2, initGridsLevel3, initGridsLevel4
    )

{-| Common module


# Basic data

@docs Model, nullModel, EnvC


# Data types

@docs Cell, Grid, GridLoc, GridsStatus, Plot, PlotEffect, SingleAnimation, TableLight


# Functions

@docs emptyPlot, initGrids1, initGridsLevel1, initGridsLevel2, initGridsLevel3, initGridsLevel4

-}

import Canvas exposing (Point)
import Lib.Env.Env as Env
import Random
import Scenes.Level.Frame.Functions exposing (allGrids)
import Scenes.Level.Grids.Random exposing (randomGrids)
import Scenes.Level.LayerBase exposing (CommonData)


{-| Status of grids
-}
type GridsStatus
    = Active
    | Stopped
    | Inactive


{-| represents the effect of the plot
-}
type PlotEffect
    = Empty
    | Angry
    | Lazy


{-| GridLoc same as enemy
-}
type alias GridLoc =
    ( Int, Int )


{-| Cell same as enemy
-}
type alias Cell a =
    { val : a
    , loc : GridLoc
    }


{-| Grid same as enemy
-}
type alias Grid a =
    List (Cell a)


{-| Animation data
-}
type alias SingleAnimation =
    { offset : Point
    , v : Point
    , static_v : Point
    , b1 : Float
    , b2 : Float
    , active : Bool
    }


{-| Plot is the basic unit of map
-}
type alias Plot =
    { effect : PlotEffect
    , protection : Int --indicates how many turns is this plot protected. 0 for no protection.
    , anima : List SingleAnimation
    , sprite_id : Int
    }


{-| Table light object
-}
type alias TableLight =
    { loc : GridLoc
    , dir : GridLoc
    , last_rounds : Int
    }


{-| Model of Grids
-}
type alias Model =
    { status : GridsStatus
    , map_size : GridLoc
    , grids : Grid Plot
    , last_click : Point
    , table_lights : List TableLight
    , rand_num : Int
    , seed : Random.Seed
    }


{-| Null model
-}
nullModel : Model
nullModel =
    let
        ( number, seed ) =
            randomGrids (Random.initialSeed 0)
    in
    { status = Stopped
    , map_size = ( 0, 0 )
    , grids = []
    , last_click = ( 0, 0 )
    , table_lights = []
    , rand_num = number
    , seed = seed
    }


{-| An empty plot
-}
emptyPlot : Plot
emptyPlot =
    { effect = Empty
    , protection = 0
    , anima = []
    , sprite_id = 0
    }


addAnima : Plot -> Point -> Float -> Float -> Plot
addAnima p v b1 b2 =
    let
        a1 =
            { offset = ( 0, 0 )
            , v = v
            , static_v = v
            , b1 = b1
            , b2 = b2
            , active = True
            }
    in
    { p | anima = a1 :: p.anima }


{-| Initialize grids 1
-}
initGrids1 : Model
initGrids1 =
    let
        ( number, seed ) =
            randomGrids (Random.initialSeed 0)
    in
    { status = Active
    , map_size = ( 3, 4 )
    , grids = []
    , last_click = ( 0, 0 )
    , table_lights = []
    , rand_num = number
    , seed = seed
    }
        |> genGrids


{-| Initialize grids for level 1
-}
initGridsLevel1 : Model
initGridsLevel1 =
    let
        ( number, seed ) =
            randomGrids (Random.initialSeed 0)
    in
    { status = Active
    , map_size = ( 2, 2 )
    , grids = []
    , last_click = ( 0, 0 )
    , table_lights = []
    , rand_num = number
    , seed = seed
    }
        |> genGrids


{-| Initialize grids for level 2
-}
initGridsLevel2 : Model
initGridsLevel2 =
    let
        ( number, seed ) =
            randomGrids (Random.initialSeed 0)
    in
    { status = Active
    , map_size = ( 4, 3 )
    , grids = []
    , last_click = ( 0, 0 )
    , table_lights = []
    , rand_num = number
    , seed = seed
    }
        |> genGrids


{-| Initialize grids for level 3
-}
initGridsLevel3 : Model
initGridsLevel3 =
    let
        ( number, seed ) =
            randomGrids (Random.initialSeed 0)
    in
    { status = Active
    , map_size = ( 5, 5 )
    , grids = []
    , last_click = ( 0, 0 )
    , table_lights = []
    , rand_num = number
    , seed = seed
    }
        |> genGrids


{-| Initialize grids for level 4
-}
initGridsLevel4 : Int -> Model
initGridsLevel4 rand_num =
    let
        ( number, seed ) =
            randomGrids (Random.initialSeed 0)
    in
    { status = Active
    , map_size = ( 2 + modBy 5 rand_num, 2 + modBy 4 rand_num )
    , grids = []
    , last_click = ( 0, 0 )
    , table_lights = []
    , rand_num = number
    , seed = seed
    }
        |> genGrids


{-| generate a grids with no-effect plots of the given map size
-}
genGrids : Model -> Model
genGrids model =
    List.foldr mapPlot model (allGrids model.map_size)


mapPlot : GridLoc -> Model -> Model
mapPlot loc model =
    let
        ( x, y ) =
            loc

        v =
            ( 0, toFloat (modBy 10 model.rand_num) / 40 )

        b1 =
            6

        b2 =
            -6

        nanima =
            { offset = ( 0, 0 )
            , v = v
            , static_v = v
            , b1 = b1
            , b2 = b2
            , active = True
            }

        plot =
            { effect = Empty
            , protection = 0
            , anima = [ nanima ]
            , sprite_id = 0
            }

        c =
            { val = plot
            , loc = loc
            }

        ( number, seed ) =
            randomGrids model.seed
    in
    { model
        | grids = c :: model.grids
        , rand_num = number
        , seed = seed
    }


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
