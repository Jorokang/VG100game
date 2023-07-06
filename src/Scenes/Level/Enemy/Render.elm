module Scenes.Level.Enemy.Render exposing (..)

import Canvas exposing (Point, Renderable, circle, empty, group, rect, shapes, text)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Advanced exposing (rotate, transform, translate)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Color exposing (Color)
import Json.Decode exposing (null)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import List
import Scenes.Level.Enemy.Common exposing (Cell, EnemyBlock, EnemyCore, EnemyState(..), EnvC, GridLoc, Model, initEnemy1, nullModel)
import Scenes.Level.Enemy.Random exposing (curUniqueSin)
import Scenes.Level.Enemy.Update exposing (checkCellLoc)
import Scenes.Level.Frame.Functions exposing (addPoint, cellLength, coorChange, grid2real, int2Point, leftCell, lengthChange, lowerCell, nullCoorData, point2Int, rightCell, scalePointLength, upperCell)
import Scenes.Level.SceneInit exposing (LevelInit)
import Tuple


{-| render the whole enemy body(explicitly the body field in model)
-}
renderEnemyBody : EnvC -> Model -> Renderable
renderEnemyBody env model =
    let
        rend =
            List.map (renderEnemyBlock env model) model.body
    in
    Canvas.group
        []
        rend


{-| render a single enemy block
-}
renderEnemyBlock : EnvC -> Model -> Cell EnemyBlock -> Renderable
renderEnemyBlock env model x =
    let
        loc =
            x.loc

        tmp_enemyblock =
            x.val

        tentacle_render =
            Canvas.group [] (List.map (renderSingleTentacle env model x) (tentacleDir model loc))
    in
    Canvas.group
        []
        [ renderEnemyBlockCentral env model x
        , tentacle_render
        ]


{-| generate a list representing the available tentacles direction (0 to 11)
-}
tentacleDir : Model -> GridLoc -> List Int
tentacleDir model loc =
    let
        ( x, y ) =
            loc

        right =
            case List.any (checkCellLoc ( x + 1, y )) model.body of
                True ->
                    []

                False ->
                    [ 0, 1, 2 ]

        up =
            case List.any (checkCellLoc ( x, y - 1 )) model.body of
                True ->
                    []

                False ->
                    [ 3, 4, 5 ]

        left =
            case List.any (checkCellLoc ( x - 1, y )) model.body of
                True ->
                    []

                False ->
                    [ 6, 7, 8 ]

        down =
            case List.any (checkCellLoc ( x, y + 1 )) model.body of
                True ->
                    []

                False ->
                    [ 9, 10, 11 ]
    in
    List.concat [ right, up, left, down ]


{-| Render the central part of an enemy block,
which is a circle exists as long as there is a block.
-}
renderEnemyBlockCentral : EnvC -> Model -> Cell EnemyBlock -> Renderable
renderEnemyBlockCentral env model x =
    let
        color =
            x.val.color

        loc =
            x.loc
    in
    Canvas.group
        []
        [ shapes [ fill color ] [ rect (coorChange env (grid2real loc) nullCoorData) (lengthChange env cellLength nullCoorData) (lengthChange env cellLength nullCoorData) ]
        ]


{-| rendering a single tentacle
tentacle id | direction
0 | right 1
1 | right 2
2 | right 3
3 | up 1
4 | up 2
5 | up 3
6 | left 1
7 | left 2
8 | left 3
9 | down 1
10 | down 2
11 | down 3
-}
renderSingleTentacle : EnvC -> Model -> Cell EnemyBlock -> Int -> Renderable
renderSingleTentacle env model x id =
    let
        color =
            x.val.color

        ( locx, locy ) =
            x.loc

        sinPair =
            curUniqueSin model.time x.loc id

        ( rotate, offset ) =
            case id of
                0 ->
                    ( 0, ( (toFloat locx + 0.7) * cellLength, (toFloat locy + (toFloat id / 10) * 3 + 0.2) * cellLength ) )

                1 ->
                    ( 0, ( (toFloat locx + 0.7) * cellLength, (toFloat locy + (toFloat id / 10) * 3 + 0.2) * cellLength ) )

                2 ->
                    ( 0, ( (toFloat locx + 0.7) * cellLength, (toFloat locy + (toFloat id / 10) * 3 + 0.2) * cellLength ) )

                3 ->
                    ( 1, ( (toFloat locx + (toFloat (id - 3) / 10) * 3 + 0.2) * cellLength, (toFloat locy + 0.2) * cellLength ) )

                4 ->
                    ( 1, ( (toFloat locx + (toFloat (id - 3) / 10) * 3 + 0.2) * cellLength, (toFloat locy + 0.2) * cellLength ) )

                5 ->
                    ( 1, ( (toFloat locx + (toFloat (id - 3) / 10) * 3 + 0.2) * cellLength, (toFloat locy + 0.2) * cellLength ) )

                6 ->
                    ( 2, ( (toFloat locx + 0.3) * cellLength, (toFloat locy + (toFloat (id - 6) / 10) * 3 + 0.2) * cellLength ) )

                7 ->
                    ( 2, ( (toFloat locx + 0.3) * cellLength, (toFloat locy + (toFloat (id - 6) / 10) * 3 + 0.2) * cellLength ) )

                8 ->
                    ( 2, ( (toFloat locx + 0.3) * cellLength, (toFloat locy + (toFloat (id - 6) / 10) * 3 + 0.2) * cellLength ) )

                9 ->
                    ( 3, ( (toFloat locx + (toFloat (id - 9) / 10) * 3 + 0.2) * cellLength, (toFloat locy + 0.8) * cellLength ) )

                10 ->
                    ( 3, ( (toFloat locx + (toFloat (id - 9) / 10) * 3 + 0.2) * cellLength, (toFloat locy + 0.8) * cellLength ) )

                11 ->
                    ( 3, ( (toFloat locx + (toFloat (id - 9) / 10) * 3 + 0.2) * cellLength, (toFloat locy + 0.8) * cellLength ) )

                _ ->
                    ( 0, ( (toFloat locx + 0.7) * cellLength, (toFloat locy + (toFloat id / 10) * 3) * cellLength ) )

        rend =
            List.map (renderTentaclePixels env model color ( rotate, offset )) sinPair
    in
    Canvas.group
        []
        rend


isOdd : Int -> Int
isOdd x =
    let
        str =
            String.fromInt x

        strr =
            String.right 1 str
    in
    case strr of
        "1" ->
            1

        "3" ->
            3

        "5" ->
            5

        "7" ->
            7

        "9" ->
            9

        _ ->
            0


renderTentaclePixels : EnvC -> Model -> Color -> ( Int, Point ) -> Point -> Renderable
renderTentaclePixels env model color ( rotate, offset ) pos =
    let
        x =
            Tuple.first pos

        y =
            Tuple.second pos

        flag0 =
            model.randNum + round y

        delta =
            0

        flag1 =
            isOdd flag0

        flag2 =
            isOdd (flag0 // 2)

        flag3 =
            isOdd (flag0 // 4)

        flag4 =
            isOdd (flag0 // 8)

        l1 =
            isOdd ((model.randNum + round y) // 2) + 1

        l2 =
            isOdd ((model.randNum + round y) // 3) + 1

        l3 =
            isOdd ((model.randNum + round y) // 4) + 1

        l4 =
            isOdd ((model.randNum + round y) // 5) + 1

        l5 =
            isOdd ((model.randNum + round y) // 6) + 1

        l6 =
            isOdd ((model.randNum + round y) // 7) + 1

        l7 =
            isOdd ((model.randNum + round y) // 8) + 1

        l8 =
            isOdd ((model.randNum + round y) // 9) + 1

        offset1 =
            int2Point ( -l5, l8 )

        offset2 =
            int2Point ( l6, -l7 )

        offset3 =
            int2Point ( -l7, l6 )

        offset4 =
            int2Point ( l8, -l5 )
    in
    Canvas.group []
        [ renderTentaclePixel env color ( x, y + delta ) l1 ( rotate, addPoint offset offset1 ) flag1
        , renderTentaclePixel env color ( x, y + 2 * delta ) l2 ( rotate, addPoint offset offset2 ) flag2
        , renderTentaclePixel env color ( x, y - delta ) l3 ( rotate, addPoint offset offset3 ) flag3
        , renderTentaclePixel env color ( x, y - 2 * delta ) l4 ( rotate, addPoint offset offset4 ) flag4
        , renderNum env rotate
        ]


renderTentaclePixel : EnvC -> Color -> Point -> Int -> ( Int, Point ) -> Int -> Renderable
renderTentaclePixel env color pos l ( rotate, offset ) flag =
    --if (flag==1) then
    shapes [ fill color ] [ rect (coorChange env (offsetPoint rotate offset pos) nullCoorData) (lengthChange env (toFloat l) nullCoorData) (lengthChange env (toFloat l) nullCoorData) ]



--else
--  Canvas.group [] []


{-| applying offset & rotation to List Point for map function
rotate direction (clock-wise degrees)
0 0
1 90
2 180
3 270
-}
offsetPoint : Int -> Point -> Point -> Point
offsetPoint rotate offset pos =
    let
        ( px, py ) =
            offset

        ( x, y ) =
            pos

        ( nx, ny ) =
            case rotate of
                0 ->
                    ( x, y )

                1 ->
                    ( y, -x )

                2 ->
                    ( -x, -y )

                3 ->
                    ( -y, x )

                _ ->
                    ( x, y )
    in
    ( nx + px, ny + py )


{-| generic function of rendering number(Int) for testing
-}
renderNum : EnvC -> Int -> Renderable
renderNum env num =
    text [ font { size = 24, family = "Arial", style = "" }, align Center ] (coorChange env ( 50, 50 ) nullCoorData) ("rotate:" ++ String.fromInt num)


{-| generic function of rendering circle
-}
renderCircle : EnvC -> Point -> Int -> Color -> Renderable
renderCircle env pos radius color =
    shapes [ fill color ] [ circle (coorChange env pos nullCoorData) (lengthChange env (toFloat radius) nullCoorData) ]


{-| render the enemy's core
-}
renderEnemyCore : EnvC -> Model -> Renderable
renderEnemyCore env model =
    let
        ( locx, locy ) =
            int2Point model.core.loc

        ( x, y ) =
            coorChange env ( (locx + 0.5) * cellLength, (locy + 0.16) * cellLength ) nullCoorData
    in
    shapes
        [ transform
            [ translate x y
            , rotate (degrees 45)
            , translate -x -y
            ]
        , fill Color.red
        ]
        [ rect ( x, y ) (lengthChange env (cellLength / 2) nullCoorData) (lengthChange env (cellLength / 2) nullCoorData) ]


{-| render the enmy's eye
-}
renderEnemyEye : EnvC -> Model -> Renderable
renderEnemyEye env model =
    let
        eye =
            model.eye

        pupil_offset =
            scalePointLength eye.v 8

        pupil_pos =
            addPoint eye.pos pupil_offset
    in
    Canvas.group
        []
        [ shapes [ fill Color.yellow ] [ circle (coorChange env eye.pos nullCoorData) (lengthChange env 20 nullCoorData) ]
        , shapes [ fill Color.red ] [ circle (coorChange env pupil_pos nullCoorData) (lengthChange env 15 nullCoorData) ]
        ]
