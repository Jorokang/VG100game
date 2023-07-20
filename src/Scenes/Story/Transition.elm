module Scenes.Story.Transition exposing (..)

import Canvas exposing (Point, Renderable, rect, shapes, text)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Advanced exposing (filter)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Color exposing (rgb255)
import Lib.Coordinate.Coordinates exposing (lengthToReal, posToReal)
import Lib.Scene.Transitions.Base exposing (SingleTrans, genTransition, nullTransition)


rawTransition : SingleTrans
rawTransition _ _ _ =
    Canvas.empty


{-| The transition setting for Story layer
-}
storyTransitionOut : SingleTrans
storyTransitionOut env rend f =
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
                , fill (Color.rgb255 20 30 40)
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
hallTransitionIn : SingleTrans
hallTransitionIn env rend f =
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
                , fill (Color.rgb255 20 30 40)
                ]
                [ rect (posToReal env ( 0, 0 )) (lengthToReal env 1920) (lengthToReal env 1080) ]
    in
    Canvas.group
        []
        [ rend1
        , rend2
        ]
