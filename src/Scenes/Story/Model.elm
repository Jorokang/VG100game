module Scenes.Story.Model exposing
    ( handleLayerMsg
    , updateModel
    , viewModel
    )

{-| Scene update module

@docs handleLayerMsg
@docs updateModel
@docs viewModel

-}

import Canvas exposing (Renderable, text, rect)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Canvas.Settings.Advanced exposing (filter)
import Lib.Audio.Base exposing (AudioOption(..))
import Lib.Env.Env exposing (Env, EnvC, addCommonData, noCommonData)
import Lib.Layer.Base exposing (LayerMsg(..))
import Lib.Layer.LayerHandler exposing (updateLayer, viewLayer)
import Lib.Scene.Base exposing (SceneOutputMsg(..), SceneInitData(..))
import Scenes.Story.Common exposing (Model)
import Scenes.Story.LayerBase exposing (CommonData)
import Lib.Scene.Transitions.Base exposing (SingleTrans, genTransition, nullTransition)
import Lib.Coordinate.Coordinates exposing (posToReal)
import Scenes.Story.Transition exposing (rawTransition, storyTransitionOut, hallTransitionIn)


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
        
        LayerStringMsg scene_name ->
            let
                sid =
                    NullSceneInitData

                trans =
                    Just ( genTransition 100 100 storyTransitionOut hallTransitionIn )
            in
            ( model, [ SOMChangeScene ( sid, scene_name, trans ) ], env )

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
