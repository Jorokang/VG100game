module Scenes.Level.Grids.Common exposing
    ( Model, nullModel, EnvC
    , Cell, Grid, GridLoc, GridsStatus(..), Plot, PlotEffect(..), SingleAnimation, TableLight, emptyPlot, initGrids1, initGridsLevel1, initGridsLevel2, initGridsLevel3, initGridsLevel4
    )

{-| Common module

@docs Model, nullModel, EnvC

-}

import Canvas exposing (Point)
import Lib.Env.Env as Env
import Random
import Scenes.Level.Frame.Functions exposing (allGrids)
import Scenes.Level.Grids.Random exposing (randomGrids)
import Scenes.Level.LayerBase exposing (CommonData)


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


type alias GridLoc =
    ( Int, Int )


type alias Cell a =
    { val : a
    , loc : GridLoc
    }


type alias Grid a =
    List (Cell a)


type alias SingleAnimation =
    { offset : Point
    , v : Point
    , static_v : Point
    , b1 : Float
    , b2 : Float
    , active : Bool
    }


type alias Plot =
    { effect : PlotEffect
    , protection : Int --indicates how many turns is this plot protected. 0 for no protection.
    , anima : List SingleAnimation
    , sprite_id : Int
    }


type alias TableLight =
    { loc : GridLoc
    , dir : GridLoc
    , last_rounds : Int
    }


type alias Model =
    { status : GridsStatus
    , map_size : GridLoc
    , grids : Grid Plot
    , last_click : Point
    , table_lights : List TableLight
    , rand_num : Int
    , seed : Random.Seed
    }


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

initGridsLevel4 : Int -> Model
initGridsLevel4 rand_num=
    let
        ( number, seed ) =
            randomGrids (Random.initialSeed 0)
    in
    { status = Active
    , map_size = ( 2+(modBy 5 rand_num), 2+(modBy 4 rand_num) )
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
