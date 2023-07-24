module Scenes.Level.Grids.Common exposing
    ( Model, nullModel, EnvC
    , Cell, Grid, GridLoc, GridsStatus(..), Plot, PlotEffect(..), TableLight, emptyPlot, genEmptyPlots, initGrids1, initGridsLevel1, initGridsLevel2, initGridsLevel3
    )

{-| Common module

@docs Model, nullModel, EnvC

-}

import Canvas exposing (Point)
import Lib.Env.Env as Env
import Scenes.Level.Frame.Functions exposing (allGrids)
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


type alias Plot =
    { effect : PlotEffect
    , protection : Int --indicates how many turns is this plot protected. 0 for no protection.
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
    }


nullModel : Model
nullModel =
    { status = Stopped
    , map_size = ( 0, 0 )
    , grids = []
    , last_click = ( 0, 0 )
    , table_lights = []
    }


emptyPlot : Plot
emptyPlot =
    { effect = Empty
    , protection = 0
    }


initGrids1 : Model
initGrids1 =
    { status = Active
    , map_size = ( 3, 4 )
    , grids = genEmptyPlots ( 3, 4 )
    , last_click = ( 0, 0 )
    , table_lights = []
    }


initGridsLevel1 : Model
initGridsLevel1 =
    { status = Active
    , map_size = ( 2, 2 )
    , grids = genEmptyPlots ( 2, 2 )
    , last_click = ( 0, 0 )
    , table_lights = []
    }


initGridsLevel2 : Model
initGridsLevel2 =
    { status = Active
    , map_size = ( 4, 3 )
    , grids = genEmptyPlots ( 4, 3 )
    , last_click = ( 0, 0 )
    , table_lights = []
    }


initGridsLevel3 : Model
initGridsLevel3 =
    { status = Active
    , map_size = ( 5, 5 )
    , grids = genEmptyPlots ( 5, 5 )
    , last_click = ( 0, 0 )
    , table_lights = []
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
