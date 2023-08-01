module Scenes.Level.Transition exposing (hallTransitionIn0, hallTransitionIn1, levelTransitionOut0, levelTransitionOut1)

{-| SceneInit

@docs hallTransitionIn0, hallTransitionIn1, levelTransitionOut0, levelTransitionOut1

-}

import Canvas exposing (Point, Renderable, rect, shapes)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Advanced exposing (filter)
import Color
import Lib.Coordinate.Coordinates exposing (lengthToReal, posToReal)
import Lib.Render.Sprite exposing (renderSprite)
import Lib.Scene.Transitions.Base exposing (SingleTrans)
import Scenes.Level.Frame.Functions exposing (addPoint, int2Point)


rawTransition : SingleTrans
rawTransition _ _ _ =
    Canvas.empty


{-| The transition setting for Story layer
-}
levelTransitionOut0 : SingleTrans
levelTransitionOut0 env rend f =
    let
        rend1 =
            if f < 0.4 then
                shapes
                    [ filter "opacity(68%)"
                    , fill Color.red
                    ]
                    [ rect (posToReal env ( 0, 0 )) (lengthToReal env 1920) (lengthToReal env 1080) ]

            else
                shapes
                    [ fill Color.black ]
                    [ rect (posToReal env ( 0, 0 )) (lengthToReal env 1920) (lengthToReal env 1080) ]

        pos =
            ( 200, 100 )

        rf1 =
            60 - round (f * 100)

        rf =
            if rf1 >= 0 then
                rf1

            else
                0

        ox =
            if modBy 3 rf1 == 1 then
                -1

            else
                1

        oy =
            if modBy 2 rf1 == 1 then
                -1

            else
                1

        offset =
            int2Point ( ox * rf, oy * rf )

        rpos =
            addPoint pos offset

        rend2 =
            if f >= 0.38 then
                renderSprite env [] rpos ( 1520, 800 ) "kill"

            else
                Canvas.empty
    in
    Canvas.group
        []
        [ rend
        , rend1
        , rend2
        ]


{-| The transition setting for Hall layer
-}
hallTransitionIn0 : SingleTrans
hallTransitionIn0 env rend f =
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
                , fill Color.black
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
levelTransitionOut1 : SingleTrans
levelTransitionOut1 env rend f =
    let
        op1 =
            round (f * 120)

        op =
            if op1 > 100 then
                100

            else
                op1

        str =
            "opacity(" ++ String.fromInt op ++ "%)"

        rend1 =
            shapes
                [ filter str
                , fill (Color.rgb255 255 240 245)
                ]
                [ rect (posToReal env ( 0, 0 )) (lengthToReal env 1920) (lengthToReal env 1080) ]
    in
    Canvas.group
        []
        [ rend
        , rend1
        ]


{-| The transition setting for Hall layer
-}
hallTransitionIn1 : SingleTrans
hallTransitionIn1 env rend f =
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
                , fill (Color.rgb255 255 240 245)
                ]
                [ rect (posToReal env ( 0, 0 )) (lengthToReal env 1920) (lengthToReal env 1080) ]
    in
    Canvas.group
        []
        [ rend1
        , rend2
        ]
