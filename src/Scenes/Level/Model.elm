module Scenes.Level.Model exposing
    ( handleLayerMsg
    , updateModel
    , viewModel
    )

{-| Scene update module

@docs handleLayerMsg
@docs updateModel
@docs viewModel

-}

import Canvas exposing (Renderable)
import Lib.Audio.Base exposing (AudioOption(..))
import Lib.Env.Env exposing (Env, EnvC, addCommonData, noCommonData)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Lib.Layer.LayerHandler exposing (updateLayer, viewLayer)
import Lib.Scene.Base exposing (SceneInitData(..), SceneOutputMsg(..))
import Lib.Scene.Transitions.Base exposing (SingleTrans, genTransition, nullTransition)
import Scenes.Hall.SceneInit exposing (initHallLoose, initHallWin)
import Scenes.Level.Common exposing (Model)
import Scenes.Level.LayerBase exposing (CommonData)
import Scenes.Level.Transition exposing (hallTransitionIn0, hallTransitionIn1, levelTransitionOut0, levelTransitionOut1)


{-| handleLayerMsg

Handle Layer Messages

-}
handleLayerMsg : EnvC CommonData -> LayerMsg -> Model -> ( Model, List SceneOutputMsg, EnvC CommonData )
handleLayerMsg env lmsg model =
    case lmsg of
        LayerSoundMsg name path opt ->
            ( model, [ SOMPlayAudio name path opt ], env )

        LayerStopSoundMsg name ->
            ( model, [ SOMStopAudio name ], env )

        LayerMsgLevelComplete x ->
            handleLayerMsgLevelComplete env model x

        _ ->
            ( model, [], env )


handleLayerMsgLevelComplete : EnvC CommonData -> Model -> Int -> ( Model, List SceneOutputMsg, EnvC CommonData )
handleLayerMsgLevelComplete env model x =
    case x of
        0 ->
            let
                trans =
                    Just (genTransition 300 100 levelTransitionOut0 hallTransitionIn0)
            in
            ( model, [ SOMChangeScene ( HallInitData initHallLoose, "Hall", trans ) ], env )

        1 ->
            let
                trans =
                    Just (genTransition 150 100 levelTransitionOut1 hallTransitionIn1)
            in
            ( model, [ SOMChangeScene ( HallInitData initHallWin, "Hall", trans ) ], env )

        _ ->
            ( model, [], env )


{-| updateModel

Default update function. Normally you won't change this function.

-}
updateModel : Env -> Model -> ( Model, List SceneOutputMsg, Env )
updateModel env model =
    let
        ( newdata, msgs, newenv ) =
            updateLayer (addCommonData model.commonData env) model.layers

        nmodel =
            { model | commonData = newenv.commonData, layers = newdata }

        ( newmodel, newsow, newgd2 ) =
            List.foldl
                (\x ( y, lmsg, cgd ) ->
                    let
                        ( model2, msg2, env2 ) =
                            handleLayerMsg cgd x y
                    in
                    ( model2, lmsg ++ msg2, env2 )
                )
                ( nmodel, [], newenv )
                msgs
    in
    ( newmodel, newsow, noCommonData newgd2 )


{-| Default view function
-}
viewModel : Env -> Model -> Renderable
viewModel env model =
    viewLayer (addCommonData model.commonData env) model.layers
