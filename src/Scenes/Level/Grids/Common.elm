module Scenes.Level.Grids.Common exposing
    ( Model, nullModel, EnvC
    , Cell, Grid, GridLoc, GridsStatus(..), Plot, PlotEffect(..), genEmptyPlots, initGrids1
    )

{-| Common module

@docs Model, nullModel, EnvC

-}

import Lib.Env.Env as Env
import Scenes.Level.Frame.Functions exposing (allGrids)
import Scenes.Level.LayerBase exposing (CommonData)


type GridsStatus
    = Active
    | Stopped
    | Closed


type
    PlotEffect
    --represents the effect of the plot
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


type alias Plot =
    { effect : PlotEffect
    }


type alias Model =
    { status : GridsStatus
    , map_size : GridLoc
    , grids : Grid Plot
    }



--null model


nullModel : Model
nullModel =
    { status = Stopped
    , map_size = ( 0, 0 )
    , grids = []
    }


emptyPlot : Plot
emptyPlot =
    { effect = Empty
    }



--grids for testing


initGrids1 : Model
initGrids1 =
    { status = Closed
    , map_size = ( 3, 4 )
    , grids = genEmptyPlots ( 3, 4 )
    }


{-| generate a grids with no-effect plots of the given map size
-}
genEmptyPlots : GridLoc -> Grid Plot
genEmptyPlots map_size =
    List.map (mapPlot emptyPlot) (allGrids map_size)


mapPlot : Plot -> GridLoc -> Cell Plot
mapPlot plot loc =
    { val = plot
    , loc = loc
    }


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
