module Scenes.Level.Avatar.Function exposing (..)

import Canvas exposing (Point)
import Scenes.Level.Avatar.Common exposing (EnvC, Model)
import Tuple exposing (..)


add : Point -> Point -> Point
add a b =
    ( first a + first b, second a + second b )



--the pos change will be the mouse pos
--


move : Model -> Point -> Model
move avatar mouse =
    { avatar | pos = add avatar.pos mouse }


changehp : Model -> Int -> Model
changehp avatar num =
    { avatar | health = avatar.health + num }
