module Scenes.Level.Grids.Model exposing
    ( initModel
    , updateModel, updateModelRec
    , viewModel
    )

{-| Model module

@docs initModel
@docs updateModel, updateModelRec
@docs viewModel

-}

import Base exposing (GlobalData, Msg(..))
import Canvas exposing (Renderable, empty)
import Html.Attributes exposing (action)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Scenes.Level.Grids.Common exposing (EnvC, GridsStatus(..), Model, PlotEffect(..), initGrids1, nullModel)
import Scenes.Level.Grids.Render exposing (renderGrids)
import Scenes.Level.Grids.Update exposing (checkErodePermission, clickPos2Loc, modifyPlotEffect, updatePlayerTurn, updateProtectCell)
import Scenes.Level.SceneInit exposing (LevelInit)


{-| initModel
Add components here
-}
initModel : EnvC -> LevelInit -> Model
initModel _ _ =
    initGrids1


{-| updateModel
Default update function

Add your logic to handle msg here

-}
updateModel : EnvC -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModel env model =
    case model.status of
        Active ->
            case env.msg of
                MouseDown x ( a, b ) ->
                    let
                        judge =
                            clickPos2Loc env model ( a, b )
                    in
                    case judge of
                        Just loc ->
                            ( model
                            , [ ( LayerName "Avatar", LayerMsgClickLoc loc ) ]
                            , env
                            )

                        Nothing ->
                            ( model
                            , [ ( LayerName "Avatar", LayerMsgClickLoc ( -1, -1 ) ) ]
                            , env
                            )

                _ ->
                    ( model, [], env )

        _ ->
            ( model, [], env )


{-| updateModelRec
Default update function

Add your logic to handle LayerMsg here

-}
updateModelRec : EnvC -> LayerMsg -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModelRec env lmsg model =
    case lmsg of
        LayerMsgPlayerTurn ->
            updatePlayerTurn env model

        LayerMsgErodePermission loc x ->
            checkErodePermission env model loc

        LayerMsgProtectCell loc x ->
            updateProtectCell env model loc x

        _ ->
            ( model, [], env )


viewModel : EnvC -> Model -> Renderable
viewModel env model =
    let
        rend =
            case model.status of
                Inactive ->
                    []

                _ ->
                    [ renderGrids env model
                    ]
    in
    Canvas.group
        []
        rend
