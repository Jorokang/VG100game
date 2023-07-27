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
import Canvas exposing (Renderable)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Scenes.Level.Frame.Functions exposing (addPoint, negPoint, offsetCoorMap, scaleCoorMap, scalePoint)
import Scenes.Level.Grids.Common exposing (EnvC, GridsStatus(..), Model, PlotEffect(..), initGridsLevel1, initGridsLevel2, initGridsLevel3, nullModel)
import Scenes.Level.Grids.Render exposing (renderGrids, renderLevelBackground, renderStr, renderTableLights)
import Scenes.Level.Grids.Update exposing (checkErodePermission, clickPos2Loc, genTableLight, updateGridAnimation, updatePlayerTurn, updateProtectCell)
import Scenes.Level.SceneInit exposing (LevelInit)


{-| initModel
Add components here
-}
initModel : EnvC -> LevelInit -> Model
initModel _ i =
    case i.level_id of
        1 ->
            initGridsLevel1

        2 ->
            initGridsLevel2

        3 ->
            initGridsLevel3

        _ ->
            nullModel


{-| updateModel
Default update function

Add your logic to handle msg here

-}
updateModel : EnvC -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModel env model =
    case model.status of
        Active ->
            case env.msg of
                Tick _ ->
                    ( { model | last_click = env.globalData.mousePos }
                        |> updateGridAnimation
                    , []
                    , env
                    )

                MouseDown x cpos ->
                    let
                        npos =
                            scalePoint (addPoint cpos (negPoint offsetCoorMap)) (1.0 / scaleCoorMap)

                        judge =
                            clickPos2Loc env model npos
                    in
                    case judge of
                        Just loc ->
                            ( { model | last_click = npos }
                            , [ ( LayerName "Avatar", LayerMsgClickLoc loc ) ]
                            , env
                            )

                        Nothing ->
                            ( { model | last_click = npos }
                            , [ ( LayerName "Avatar", LayerMsgClickLoc ( -1, -1 ) ) ]
                            , env
                            )

                _ ->
                    ( model, [], env )

        _ ->
            ( model, [], env )


updateModelRec : EnvC -> LayerMsg -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModelRec env lmsg model =
    case lmsg of
        LayerMsgPlayerTurn ->
            updatePlayerTurn env model

        LayerMsgErodePermission loc x ->
            checkErodePermission env model loc

        LayerMsgProtectCell loc x ->
            updateProtectCell env model loc x

        LayerMsgGenTableLight loc dir x ->
            ( genTableLight model loc dir x
            , []
            , env
            )

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
                    [ renderLevelBackground env
                    , renderGrids env model
                    , renderTableLights env model
                    , renderStr env ("table lights num : " ++ String.fromInt (List.length model.table_lights)) ( 1000, 500 )
                    ]
    in
    Canvas.group
        []
        rend
