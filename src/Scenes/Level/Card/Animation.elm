module Scenes.Level.Card.Animation exposing (..)

import Canvas exposing (Point)
import Scenes.Level.Card.CardCreate exposing (CardObject, Model, giveHandSize)
import Scenes.Level.Frame.Functions exposing (addPoint, scalePoint)


type MoveStatus
    = Moving Point Int
    | Null


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
    let
        size =
            giveHandSize
    in
    addPoint size.startPoint (scalePoint ( size.interval, 0 ) (toFloat (List.length model.hand)))



--( 0, 0 )


moveCard : CardObject -> MoveData -> CardObject
moveCard obj data =
    let
        npos =
            addPoint obj.pos <|
                scalePoint (addPoint obj.pos data.target) (1 / data.max_stage)
    in
    { obj | pos = npos }
