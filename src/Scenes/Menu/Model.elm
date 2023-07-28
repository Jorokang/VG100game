module Scenes.Menu.Model exposing
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
import Lib.Scene.Base exposing (SceneOutputMsg(..), SceneInitData(..))
import Scenes.Menu.Common exposing (Model)
import Scenes.Menu.LayerBase exposing (CommonData)
import Canvas exposing (Point, Renderable, rect, shapes, text)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Advanced exposing (filter)
import Lib.Coordinate.Coordinates exposing (lengthToReal, posToReal)
import Lib.Scene.Transitions.Base exposing (SingleTrans, genTransition, nullTransition)
import Scenes.Story.SceneInit exposing (nullStoryInit)
import Color


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
                sid = StoryInitData nullStoryInit
                trans =
                    Just (genTransition 100 100 transitionOut transitionIn)
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



{-| The transition setting for Story layer
-}
transitionOut : SingleTrans
transitionOut env rend f =
    let
        f1 =
            f * 0.6

        str1 =
            "opacity(" ++ String.fromInt (round ((1 - f1) * 100.0)) ++ "%)"

        str2 =
            "opacity(" ++ String.fromInt (round (f1 * 100.0)) ++ "%)"

        rend1 =
            Canvas.group [ filter str1 ] [ rend ]

        rend2 =
            shapes
                [ filter str2
                , fill Color.white
                ]
                [ rect (posToReal env ( 0, 0 )) (lengthToReal env 1920) (lengthToReal env 1080) ]
    in
    Canvas.group
        []
        [ rend1
        , rend2
        ]


{-| The transition setting for Hall layer
-}
transitionIn : SingleTrans
transitionIn env rend f =
    let
        f1 =
            f * 0.6 + 0.4

        str1 =
            "opacity(" ++ String.fromInt (round ((1 - f1) * 100.0)) ++ "%)"

        str2 =
            "opacity(" ++ String.fromInt (round (f1 * 100.0)) ++ "%)"

        rend1 =
            Canvas.group [ filter str2 ] [ rend ]

        rend2 =
            shapes
                [ filter str1
                , fill Color.white
                ]
                [ rect (posToReal env ( 0, 0 )) (lengthToReal env 1920) (lengthToReal env 1080) ]
    in
    Canvas.group
        []
        [ rend1
        , rend2
        ]
