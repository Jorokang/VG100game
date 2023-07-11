module Scenes.Level.Grids.Update exposing (..)

import Canvas exposing (Point)
import List
import Scenes.Level.Frame.Functions exposing (addPoint, cellLength, coorChange, lengthChange, negPoint, nullCoorData, point2Int)
import Scenes.Level.Grids.Common exposing (Cell, EnvC, GridLoc, Model, Plot, PlotEffect(..))


{-| Judge the mouse click and give the grid location of the click.
-}
clickPos2Loc : EnvC -> Model -> Point -> Maybe GridLoc
clickPos2Loc env model click_pos =
    let
        --real_l = round (lengthChange env cellLength nullCoorData)
        --real_origin = coorChange env (0,0) nullCoorData
        rl =
            round cellLength

        ( rx, ry ) =
            point2Int click_pos

        ( locx, locy ) =
            ( rx // rl, ry // rl )

        ( sx, sy ) =
            model.map_size
    in
    if locx < 0 || locx > sx || locy < 0 || locy > sy then
        Nothing

    else
        Just ( locx, locy )


{-| modify the effect of a particular plot in grids
-}
modifyPlotEffect : Model -> GridLoc -> PlotEffect -> Model
modifyPlotEffect model loc new_effcet =
    let
        complementGrids =
            List.filter (mapComplementGrids loc) model.grids

        new_cell =
            { val = { effect = new_effcet }
            , loc = loc
            }

        new_grids =
            new_cell :: complementGrids

        ( locx, locy ) =
            loc

        ( sx, sy ) =
            model.map_size
    in
    if locx < 0 || locy < 0 || locx > sx || locy > sy then
        model

    else
        { model | grids = new_grids }


{-| check if a GridLoc is not contained (for map)
-}
mapComplementGrids : GridLoc -> Cell Plot -> Bool
mapComplementGrids new_loc x =
    if new_loc == x.loc then
        False

    else
        True
