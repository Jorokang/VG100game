module Scenes.Level.Grids.Update exposing (..)

import Canvas exposing (Point)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import List
import Scenes.Level.Frame.Functions exposing (addLoc, addPoint, cellLength, negPoint, point2Int, pointDistance)
import Scenes.Level.Grids.Common exposing (Cell, EnvC, Grid, GridLoc, Model, Plot, PlotEffect(..), SingleAnimation, TableLight, emptyPlot)


{-| Update player turn beginning
-}
updatePlayerTurn : EnvC -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updatePlayerTurn env model =
    model
        |> reduceGridProtection
        |> updateTableLights env


{-| check erode permission
-}
checkErodePermission : EnvC -> Model -> GridLoc -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
checkErodePermission env model loc =
    if List.any (checkSingleErodePermission loc) model.grids then
        ( model
        , [ ( LayerName "Enemy", LayerMsgErodePermission loc 1 ) ]
        , env
        )

    else
        ( model
        , [ ( LayerName "Enemy", LayerMsgErodePermission loc 0 ) ]
        , env
        )


{-| check single cell available
(tool function used for map)
-}
checkSingleErodePermission : GridLoc -> Cell Plot -> Bool
checkSingleErodePermission loc x =
    if x.loc == loc && x.val.protection <= 0 then
        True

    else
        False


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
        val =
            x.val

        p =
            val.protection

        new_val =
            if p > 0 then
                { val | protection = p - 1 }

            else
                val
    in
    { x | val = new_val }


{-| update protecting a cell
-}
updateProtectCell : EnvC -> Model -> GridLoc -> Int -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateProtectCell env model loc rounds =
    ( addProtection model loc rounds
    , [ ( LayerName "Enemy", LayerMsgProtectCell loc rounds ) ]
    , env
    )


{-| add rounds for partucular cell
-}
addProtection : Model -> GridLoc -> Int -> Model
addProtection model loc rounds =
    { model | grids = List.map (addSingleProtection loc rounds) model.grids }


{-| add protection ofr a specific cell (tool function used for mapping)
-}
addSingleProtection : GridLoc -> Int -> Cell Plot -> Cell Plot
addSingleProtection loc rounds x =
    let
        val =
            x.val

        n_val =
            { val | protection = val.protection + rounds }
    in
    if x.loc == loc then
        { x | val = n_val }

    else
        x


{-| generate a new table light
-}
genTableLight : Model -> GridLoc -> GridLoc -> Int -> Model
genTableLight model loc dir last_rounds =
    let
        new_tl =
            { loc = loc
            , dir = dir
            , last_rounds = last_rounds
            }
    in
    { model | table_lights = new_tl :: model.table_lights }


{-| update all table lights in a new round
-}
updateTableLights : EnvC -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateTableLights env model =
    let
        new_tls =
            List.filter checkTableLight (List.map updateTableLight model.table_lights)
    in
    ( { model | table_lights = new_tls }
    , List.map genClearCommandsTableLights model.table_lights
    , env
    )


{-| update a single table light (tool function for the above function)
-}
updateTableLight : TableLight -> TableLight
updateTableLight tl =
    { tl
        | loc = addLoc tl.loc tl.dir
        , last_rounds = tl.last_rounds - 1
    }


{-| check whether a single table light exists (last rounds > 0)
-}
checkTableLight : TableLight -> Bool
checkTableLight tl =
    tl.last_rounds > 0


{-| generate clear cells command
-}
genClearCommandsTableLights : TableLight -> ( LayerTarget, LayerMsg )
genClearCommandsTableLights tl =
    ( LayerName "Frame", LayerMsgClearCell tl.loc )


{-| update grid animation
-}
updateGridAnimation : Model -> Model
updateGridAnimation model =
    { model | grids = List.map updatePlotAnimation model.grids }


{-| update single plot animation
-}
updatePlotAnimation : Cell Plot -> Cell Plot
updatePlotAnimation cell =
    let
        p =
            cell.val

        np =
            { p | anima = List.map updateSingleAnimation p.anima }
    in
    { cell | val = np }


{-| update single animation
-}
updateSingleAnimation : SingleAnimation -> SingleAnimation
updateSingleAnimation p =
    let
        n_offset =
            addPoint p.offset p.v

        diso =
            pointDistance ( 0, 0 ) n_offset
    in
    if diso < p.b2 || diso > p.b1 then
        { p
            | v = negPoint p.v
            , offset = n_offset
        }

    else
        { p | offset = n_offset }
