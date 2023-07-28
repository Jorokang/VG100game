module Scenes.Hall.Model exposing
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
import Lib.Layer.Base exposing (LayerMsg(..))
import Lib.Layer.LayerHandler exposing (updateLayer, viewLayer)
import Lib.Scene.Base exposing (SceneInitData(..), SceneOutputMsg(..))
import Lib.Scene.Transitions.Base exposing (SingleTrans, genTransition, nullTransition)
import Scenes.Hall.Common exposing (Model)
import Scenes.Hall.LayerBase exposing (CommonData)
import Scenes.Level.SceneInit exposing (LevelInit, initLevel1, initLevel2, initLevel3, initLevel4, nullLevelInit)
import Scenes.Story.MainLayer.Random exposing (randomValue)


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

        LayerGoToLevel scene_name cards ->
            let
                trans =
                    Just (genTransition 1 1 rawTransition rawTransition)

                rand =
                    randomValue env
            in
            case scene_name of
                "Level1" ->
                    ( model, [ SOMChangeScene ( LevelInitData (initLevel1 cards), "Level", trans ) ], env )

                "Level2" ->
                    ( model, [ SOMChangeScene ( LevelInitData (initLevel2 cards), "Level", trans ) ], env )

                "Level3" ->
                    ( model, [ SOMChangeScene ( LevelInitData (initLevel3 cards), "Level", trans ) ], env )                
                
                "Level4" ->
                    ( model, [ SOMChangeScene ( LevelInitData (initLevel4 rand cards), "Level", trans ) ], env )

                _ ->
                    ( model, [ SOMChangeScene ( LevelInitData nullLevelInit, "Level", trans ) ], env )

        LayerIntMsg volume ->
            ( model, [ SOMSetVolume ((toFloat volume)/100) ], env )

        _ ->
            ( model, [], env )


rawTransition : SingleTrans
rawTransition _ _ _ =
    Canvas.empty


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
