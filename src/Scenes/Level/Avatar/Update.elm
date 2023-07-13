module Scenes.Level.Avatar.Update exposing (..)

import Canvas exposing (Point)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Scenes.Level.Avatar.Common exposing (AvatarStatus(..), CardSelectionStatus(..), EnvC, GridLoc, Model, avatarRadius, cardClickPos0, cardClickPos1, maxSpirit)
import Scenes.Level.Frame.Functions exposing (addLoc, addPoint, allGrids, cellLength, negPoint, pointDistance, scalePointLength)


{-| judge selection of the Avatar
-}
judgeAvatarSelection : EnvC -> Point -> Model -> Bool
judgeAvatarSelection env click_pos model =
    let
        dis =
            pointDistance click_pos model.pos
    in
    dis <= avatarRadius


{-| get the center of the GridLoc
-}
loc2Pos : GridLoc -> Point
loc2Pos ( lx, ly ) =
    ( (toFloat lx + 0.5) * cellLength, (toFloat ly + 0.5) * cellLength )


updateModifySpirit : EnvC -> Model -> Int -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModifySpirit env model x =
    let
        n_model =
            modifySpirit model x
    in
    case n_model.status of
        AvatarDead ->
            ( n_model
            , [ ( LayerParentScene, LayerMsgLevelComplete 0 ) ]
            , env
            )

        _ ->
            ( n_model, [], env )


{-| simply increase or decrease the spirit by an int
-}
modifySpirit : Model -> Int -> Model
modifySpirit model delta =
    let
        n_spirit0 =
            model.spirit + delta

        n_spirit1 =
            if n_spirit0 < 0 then
                0

            else if n_spirit0 > maxSpirit then
                maxSpirit

            else
                n_spirit0
    in
    if n_spirit1 > 0 then
        { model | spirit = n_spirit1 }

    else
        { model | status = AvatarDead }


{-| ensure that the pos is synchronized with loc
-}
setAvatarPos : Model -> Model
setAvatarPos model =
    let
        new_pos =
            if model.cur_loc == model.target_loc then
                loc2Pos model.cur_loc

            else
                model.pos
    in
    { model | pos = new_pos }


{-| set the moving target for the model
-}
setAvatarTarget : Model -> GridLoc -> Model
setAvatarTarget model loc =
    { model
        | target_loc = loc
        , status = AvatarMoving
    }


{-| set target to current pos
-}
setAvatarStill : Model -> Model
setAvatarStill model =
    { model | target_loc = model.cur_loc }
        |> setAvatarPos


maxAvatarV : Float
maxAvatarV =
    5


{-| Decide the motion of the Avatar
-}
moveAvatar : Model -> Model
moveAvatar model =
    let
        target_pos =
            loc2Pos model.target_loc

        dis =
            pointDistance model.pos target_pos

        vec =
            addPoint target_pos (negPoint model.pos)

        v =
            scalePointLength vec maxAvatarV
    in
    case model.status of
        AvatarMoving ->
            if dis <= maxAvatarV then
                { model
                    | pos = target_pos
                    , cur_loc = model.target_loc
                    , status = AvatarActive
                }

            else
                { model | pos = addPoint model.pos v }

        _ ->
            model


{-| The spirit decreasing value when the Avatar is eroded by the enemy
-}
spiritLossAtErosion : Int
spiritLossAtErosion =
    -10


{-| remove a cell from avail\_grids ( most likely it is eroded by the enemy )
-}
updateErodeMsg : EnvC -> Model -> GridLoc -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateErodeMsg env model loc =
    let
        ( nx, ny ) =
            loc

        new_model1 =
            { model | avail_grids = List.filter (\x -> x /= loc) model.avail_grids }
    in
    if loc == model.cur_loc then
        ( setAvatarTarget new_model1 model.core_loc
        , [ ( LayerName "Avatar", LayerMsgModifySpirit spiritLossAtErosion ) ]
        , env
        )

    else
        ( new_model1, [], env )


{-| add a cell to avail\_grids ( most likely the cell is retrieved from the enemy )
-}
retrieveAvailGrids : Model -> GridLoc -> Model
retrieveAvailGrids model loc =
    { model | avail_grids = loc :: model.avail_grids }


{-| add a cell to avail\_grids ( most likely the cell is retrieved from the enemy )
-}
retrieveAvailGrids2 : GridLoc -> Model -> Model
retrieveAvailGrids2 loc model =
    { model | avail_grids = loc :: model.avail_grids }


{-| return an loc representing the relative position
-}
relativeLoc : GridLoc -> GridLoc -> GridLoc
relativeLoc ( cx, cy ) ( locx, locy ) =
    ( locx - cx, locy - cy )


{-| Judge whther a loc is able to move to (whether this loc is in the avail\_loc)
-}
judgeLocAvail : Model -> GridLoc -> Bool
judgeLocAvail model loc =
    List.any (\x -> x == loc) model.avail_grids


{-| Update click event
-}
updateClickEvent : EnvC -> Model -> GridLoc -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateClickEvent env model loc =
    let
        delta_loc =
            relativeLoc model.cur_loc loc

        ( dx, dy ) =
            delta_loc
    in
    case model.status of
        AvatarActive ->
            if delta_loc == ( 0, 0 ) then
                ( { model | status = AvatarSelected }
                , []
                , env
                )

            else
                ( model, [], env )

        AvatarSelected ->
            if judgeLocAvail model loc then
                if abs (dx + dy) == 1 then
                    ( setAvatarTarget model loc
                    , [ ( LayerName "Frame", LayerIntMsg 1 )
                      , ( LayerName "Avatar", LayerMsgModifySpirit -3 )
                      ]
                    , env
                    )

                else
                    ( { model | status = AvatarActive }
                    , []
                    , env
                    )

            else
                ( { model | status = AvatarActive }
                , []
                , env
                )

        AvatarCard ->
            updateCardClickEvent env model loc

        _ ->
            ( model, [], env )


{-| deal with click event of card
-}
updateCardClickEvent : EnvC -> Model -> GridLoc -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateCardClickEvent env model loc =
    let
        relative_loc =
            relativeLoc model.cur_loc loc
    in
    case model.card_status of
        CardType_1 ->
            let
                avail_card_loc =
                    filterMapCardLoc model (offsetRelativePos model.cur_loc cardClickPos1)
            in
            if List.any (\x -> x == loc) avail_card_loc then
                cardActiveType1 env model relative_loc

            else
                ( { model
                    | status = AvatarActive
                    , card_status = CardType_None
                  }
                , []
                , env
                )

        CardType_2 ->
            let
                avail_card_loc =
                    filterAvailCardLoc model (offsetRelativePos model.cur_loc cardClickPos0)
            in
            if List.any (\x -> x == loc) avail_card_loc then
                cardActiveType2 env model relative_loc

            else
                ( { model
                    | status = AvatarActive
                    , card_status = CardType_None
                  }
                , []
                , env
                )

        CardType_None ->
            ( model, [], env )


{-| Card 1 active
-}
cardActiveType1 : EnvC -> Model -> GridLoc -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
cardActiveType1 env model loc =
    let
        dir =
            if loc == ( -1, 0 ) || loc == ( -2, 0 ) then
                1

            else if loc == ( 1, 0 ) || loc == ( 2, 0 ) then
                2

            else if loc == ( 0, 1 ) || loc == ( 0, 2 ) then
                3

            else if loc == ( 0, -1 ) || loc == ( 0, -2 ) then
                4

            else
                0
    in
    case dir of
        1 ->
            ( { model
                | status = AvatarActive
                , card_status = CardType_None
              }
            , [ ( LayerName "Frame", LayerMsgClearCell (addLoc model.cur_loc ( -1, 0 )) )
              , ( LayerName "Frame", LayerMsgClearCell (addLoc model.cur_loc ( -2, 0 )) )
              , ( LayerName "Card", LayerMsgCardType 1)
              ]
            , env
            )

        2 ->
            ( { model
                | status = AvatarActive
                , card_status = CardType_None
              }
            , [ ( LayerName "Frame", LayerMsgClearCell (addLoc model.cur_loc ( 1, 0 )) )
              , ( LayerName "Frame", LayerMsgClearCell (addLoc model.cur_loc ( 2, 0 )) )
              , ( LayerName "Card", LayerMsgCardType 1)
              ]
            , env
            )

        3 ->
            ( { model
                | status = AvatarActive
                , card_status = CardType_None
              }
            , [ ( LayerName "Frame", LayerMsgClearCell (addLoc model.cur_loc ( 0, 1 )) )
              , ( LayerName "Frame", LayerMsgClearCell (addLoc model.cur_loc ( 0, 2 )) )
              , ( LayerName "Card", LayerMsgCardType 1)
              ]
            , env
            )

        4 ->
            ( { model
                | status = AvatarActive
                , card_status = CardType_None
              }
            , [ ( LayerName "Frame", LayerMsgClearCell (addLoc model.cur_loc ( 0, -1 )) )
              , ( LayerName "Frame", LayerMsgClearCell (addLoc model.cur_loc ( 0, -2 )) )
              , ( LayerName "Card", LayerMsgCardType 1)
              ]
            , env
            )

        _ ->
            ( { model
                | status = AvatarActive
                , card_status = CardType_None
              }
            , []
            , env
            )


{-| Card 2 active
-}
cardActiveType2 : EnvC -> Model -> GridLoc -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
cardActiveType2 env model loc =
    if List.any (\x -> x == loc) cardClickPos0 then
        ( { model
            | status = AvatarActive
            , card_status = CardType_None
          }
        , ( LayerName "Card", LayerMsgCardType 1) :: (List.map (\x -> ( LayerName "Grids", LayerMsgProtectCell (addLoc model.cur_loc x) 2 )) cardClickPos0)
        , env
        )

    else
        ( { model
            | status = AvatarActive
            , card_status = CardType_None
          }
        , []
        , env
        )


{-| filter for click pos (move available grids)
-}
filterAvailCardLoc : Model -> List GridLoc -> List GridLoc
filterAvailCardLoc model list_loc =
    List.filter (\x1 -> List.any (\x2 -> x2 == x1) model.avail_grids) list_loc


{-| filter for click pos (purify available grids, as long as it is in the map)
-}
filterMapCardLoc : Model -> List GridLoc -> List GridLoc
filterMapCardLoc model list_loc =
    List.filter (\x1 -> List.any (\x2 -> x2 == x1) (allGrids model.map_size)) list_loc


{-| add the relative location list to a COM
-}
offsetRelativePos : GridLoc -> List GridLoc -> List GridLoc
offsetRelativePos com list_loc =
    List.map (addLoc com) list_loc


{-| deal with specific card msg
-}
updateCardType : EnvC -> Model -> Int -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateCardType env model card_type =
    case card_type of
        1 ->
            ( { model | status = AvatarCard, card_status = CardType_1 }
            , []
            , env
            )

        2 ->
            ( { model | status = AvatarCard, card_status = CardType_2 }
            , []
            , env
            )

        _ ->
            ( model, [], env )
