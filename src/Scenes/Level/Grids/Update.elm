module Scenes.Level.Grids.Update exposing (..)

import Scenes.Level.Grids.Common exposing (EnvC, Model, Cell, GridLoc, Plot, PlotEffect(..))
import List
import Tuple

{-| modify the effect of a particular plot in grids -}
modifyPlotEffect : Model -> GridLoc -> PlotEffect -> Model
modifyPlotEffect model loc new_effcet =
    let
        complementGrids =
            List.filter (mapComplementGrids loc) model.grids
        new_cell =  {
                        val = { effect = new_effcet }
                    ,   loc = loc
                    }
        new_grids = new_cell :: complementGrids
        ( locx, locy ) =
            loc
        ( sx, sy ) =
            model.map_size
    in
    
    if ( locx<0 || locy<0 || locx>sx || locy>sy ) then
        model
    else
        { model | grids = new_grids }

{-| check if a GridLoc is not contained (for map) -}
mapComplementGrids : GridLoc -> Cell Plot -> Bool
mapComplementGrids new_loc x =
    if (new_loc == x.loc ) then
        False
    else
        True