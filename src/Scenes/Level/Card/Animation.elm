module Animation exposing (MoveData)

import Canvas exposing (Point)
import Scenes.Level.Card.CardCreate exposing (CardObject, CardStatus(..), Model, MoveStatus(..), giveHandSize)
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
    let
        size =
            giveHandSize
    in
    addPoint size.startPoint (scalePoint ( size.interval, 0 ) (toFloat (List.length model.hand)))



--( 0, 0 )


minusPoint : Point -> Point -> Point
minusPoint p1 p2 =
    ( Tuple.first p1 - Tuple.first p2, Tuple.second p1 - Tuple.second p2 )


checkHelper : CardObject -> Bool
checkHelper obj =
    case obj.status of
        Moving _ _ ->
            True

        Rest ->
            False


checkMoveStatus : List CardObject -> CardStatus
checkMoveStatus objs =
    if List.any checkHelper objs then
        CardMoving

    else
        Active


moveCards : Model -> Model
moveCards model =
    --{ model | deck = moveCard model.deck, hand = moveCard model.hand, discard = moveCard model.discard }
    model


moveCard : List CardObject -> List CardObject
moveCard objs =
    List.map moveOneCard objs


moveOneCard : CardObject -> CardObject
moveOneCard obj =
    case obj.status of
        Rest ->
            obj

        Moving target stage ->
            if stage == 0 then
                { obj | status = Rest }

            else
                let
                    npos =
                        addPoint obj.pos <|
                            scalePoint (minusPoint target obj.pos) (1 / toFloat stage)
                in
                { obj | pos = npos, status = Moving target (stage - 1) }
