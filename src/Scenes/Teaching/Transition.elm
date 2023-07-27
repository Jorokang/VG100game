module Scenes.Teaching.Transition exposing (..)

import Canvas exposing (Point, Renderable, rect, shapes, text)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Advanced exposing (filter)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Color exposing (rgb255)
import Lib.Coordinate.Coordinates exposing (lengthToReal, posToReal)
import Lib.Render.Sprite exposing (renderSprite)
import Lib.Scene.Transitions.Base exposing (SingleTrans, genTransition, nullTransition)
import Scenes.Level.Frame.Functions exposing (addPoint, int2Point)


rawTransition : SingleTrans
rawTransition _ _ _ =
    Canvas.empty


{-| The transition setting for Story layer
-}
teachingTransitionOut : SingleTrans
teachingTransitionOut env rend f =
    let
        str1 =
            "opacity(" ++ String.fromInt (round (f * 100.0)) ++ "%)"

        str2 =
            "opacity(" ++ String.fromInt (round ((1 - f) * 100.0)) ++ "%)"

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


{-| The transition setting for Hall layer
-}
storyTransitionIn : SingleTrans
storyTransitionIn env rend f =
    let
        str1 =
            "opacity(" ++ String.fromInt (round ((1 - f) * 100.0)) ++ "%)"

        str2 =
            "opacity(" ++ String.fromInt (round (f * 100.0)) ++ "%)"

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
