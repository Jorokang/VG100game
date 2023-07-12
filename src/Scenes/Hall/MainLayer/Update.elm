module Scenes.Hall.MainLayer.Update exposing (..)

import Lib.Coordinate.Coordinates exposing (judgeMouseRect, posToReal)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Scenes.Hall.MainLayer.Common exposing (Button, ButtonStatus(..), EnvC, HallStatus(..), Model)
import Scenes.Level.Frame.Functions exposing (coorChange, nullCoorData)
import Html exposing (button)



--check one button, if clicked, will give out the level's string

clickcheck : ( Float, Float ) -> Button -> Bool
clickcheck ( a, b ) btn =
    if judgeMouseRect ( a, b ) btn.pos btn.size then
        case btn.status of
            ButtonActive -> True
            _ -> False
    else
        False

checkall : Model -> ( Float, Float) -> String
checkall model (a, b) =
    if clickcheck (a, b) model.levels.level1 then
        model.levels.level1.text
    else if clickcheck (a, b) model.levels.level2 then
        model.levels.level2.text
    else if clickcheck (a, b) model.levels.level3 then
        model.levels.level3.text
    else
        ""
