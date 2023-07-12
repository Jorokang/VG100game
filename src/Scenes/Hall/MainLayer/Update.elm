module Scenes.Hall.MainLayer.Update exposing (..)

import Html exposing (button)
import Lib.Coordinate.Coordinates exposing (judgeMouseRect, posToReal)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Scenes.Hall.MainLayer.Common exposing (Button, ButtonStatus(..), EnvC, HallStatus(..), Model)
import Scenes.Level.Frame.Functions exposing (coorChange, nullCoorData)



--check one button if clicked


clickcheck : ( Float, Float ) -> Button -> Bool
clickcheck ( a, b ) btn =
    if judgeMouseRect ( a, b ) btn.pos btn.size then
        case btn.status of
            ButtonActive ->
                True

            _ ->
                False

    else
        False



--can improve: change String to type
--


checkall : Model -> ( Float, Float ) -> ( String, Button )
checkall model ( a, b ) =
    if clickcheck ( a, b ) model.levels.level1 then
        ( model.levels.level1.text, model.levels.level1 )

    else if clickcheck ( a, b ) model.levels.level2 then
        ( model.levels.level2.text, model.levels.level2 )

    else if clickcheck ( a, b ) model.levels.level3 then
        ( model.levels.level3.text, model.levels.level3 )

    else
        ( "", model.levels.level1 )
