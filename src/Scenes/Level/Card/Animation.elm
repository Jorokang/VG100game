module Scenes.Level.Card.Animation exposing (..)

import Canvas exposing (Point)
import Scenes.Level.Card.CardCreate exposing (CardObject, Model)
import Scenes.Level.Frame.Functions exposing (addPoint, scalePoint)


type alias MoveData =
    { target : Point
    , stage : Float
    , max_stage : Float
    }


nullMoveData =
    { target = ( -1, -1 )
    , stage = 1
    , max_stage = 1
    }


getMoveTarget : Model -> Point
getMoveTarget model =
    ( 0, 0 )


moveCard : CardObject -> MoveData -> CardObject
moveCard obj data =
    let
        npos =
            addPoint obj.pos <|
                scalePoint (addPoint obj.pos data.target) (1 / data.max_stage)
    in
    { obj | pos = npos }
