module Scenes.Level.Grids.Update exposing (..)

import Canvas exposing (Point)
import List
import Scenes.Level.Frame.Functions exposing (addPoint, cellLength, coorChange, lengthChange, negPoint, nullCoorData, point2Int)
import Scenes.Level.Grids.Common exposing (Cell, EnvC, GridLoc, Model, Plot, PlotEffect(..))
import Scenes.Level.Grids.Common exposing (Plot, Cell, Grid, emptyPlot)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))

{-| Update player turn beginning
-}
updatePlayerTurn : EnvC -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updatePlayerTurn env model =
    ( model
        |> reduceGridProtection
    , []
    , env
    )

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
            { val = { emptyPlot | effect = new_effcet }
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

{-| reduce all protection by 1 at the beginning of player's turn
-}
reduceGridProtection : Model -> Model
reduceGridProtection model =
    { model | grids = List.map reduceCellProtection model.grids }

{-| reduce the protection of a single plot
-}
reduceCellProtection : Cell Plot -> Cell Plot
reduceCellProtection x =
    let
        val = x.val
        p = val.protection
        new_val =   if ( p > 0 ) then
                        { val | protection = p-1 }
                    else
                        val
    in
    { x | val = new_val }