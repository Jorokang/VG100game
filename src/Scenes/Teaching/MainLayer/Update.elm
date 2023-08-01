module Scenes.Teaching.MainLayer.Update exposing (judgeClickEnvet, updateAnima, updateMoveAvatar, updateRevealScroll, updateScrollOpacity, updateSpirit)

{-| Update module


# Functions

@docs judgeClickEnvet, updateAnima, updateMoveAvatar, updateRevealScroll, updateScrollOpacity, updateSpirit

-}

import Canvas exposing (Point)
import Lib.Coordinate.Coordinates exposing (judgeMouseRect)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Scenes.Level.Frame.Functions exposing (addPoint)
import Scenes.Teaching.MainLayer.Common exposing (AvatarAnima, AvatarSpirit, EnvC, Model, TeachingStatus(..), textBoxPos)


{-| update model anima
-}
updateAnima : Model -> Model
updateAnima model =
    let
        anima =
            model.anima

        ( nav, naa ) =
            if abs anima.a_v >= anima.lim then
                ( anima.a_v - anima.a_a, -anima.a_a )

            else
                ( anima.a_v + anima.a_a, anima.a_a )

        ( npv, npa ) =
            if abs anima.p_v >= anima.lim then
                ( anima.p_v - anima.p_a, -anima.p_a )

            else
                ( anima.p_v + anima.p_a, anima.p_a )

        napos =
            addPoint anima.a_pos ( 0, anima.a_v )

        nppos =
            addPoint anima.p_pos ( 0, anima.p_v )

        nanima =
            { anima
                | a_pos = napos
                , a_v = nav
                , a_a = naa
                , p_pos = nppos
                , p_v = npv
                , p_a = npa
            }
    in
    { model | anima = nanima }


{-| Modify spirit
-}
updateSpirit : Model -> Model
updateSpirit model =
    let
        s =
            model.spirit

        d =
            s.spirit - s.cur_spirit

        ns =
            if abs d <= s.spirit_v then
                { s | cur_spirit = s.spirit }

            else if d < 0 then
                { s | cur_spirit = s.cur_spirit - s.spirit_v }

            else
                { s | cur_spirit = s.cur_spirit + s.spirit_v }
    in
    { model | spirit = ns }


{-| Update moving avatar
-}
updateMoveAvatar : Model -> Model
updateMoveAvatar model =
    if model.status == MoveAvatar then
        if Tuple.first model.pos < 600 then
            { model | pos = addPoint model.pos ( 5, 0 ) }

        else
            { model | status = Muttering3 }

    else
        model


{-| Update scroll
-}
updateRevealScroll : Model -> Model
updateRevealScroll model =
    if (model.scroll_opacity >= 100) && (model.status == RevealScroll) then
        { model
            | status = Card1
            , click_pos = ( 200, 750 )
        }

    else
        model


{-| Update scroll opacity
-}
updateScrollOpacity : Model -> Model
updateScrollOpacity model =
    if (model.scroll_opacity < 100) && (model.status == RevealScroll) then
        { model | scroll_opacity = model.scroll_opacity + 0.8 }

    else
        model


{-| Click event
-}
judgeClickEnvet : EnvC -> Model -> Point -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
judgeClickEnvet env model pos =
    case model.status of
        Init ->
            judgeInit env model pos

        Muttering1 ->
            judgeMuttering1 env model pos

        Muttering2 ->
            judgeMuttering2 env model pos

        Enemy1 ->
            judgeEnemy1 env model pos

        Enemy2 ->
            judgeEnemy2 env model pos

        SelectAvatar ->
            judgeSelectAvatar env model pos

        MoveAvatar ->
            ( model, [], env )

        RevealScroll ->
            ( model, [], env )

        Hurt ->
            judgeHurt env model pos

        Muttering3 ->
            judgeMuttering3 env model pos

        Card1 ->
            judgeCard1 env model pos

        Card2 ->
            judgeCard2 env model pos

        End ->
            judgeEnd env model pos


clickSize : Point
clickSize =
    ( 50, 50 )


judgeInit : EnvC -> Model -> Point -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
judgeInit env model pos =
    if judgeMouseRect pos model.click_pos clickSize then
        ( { model | status = Muttering1 }
        , []
        , env
        )

    else
        ( model
        , []
        , env
        )


judgeMuttering1 : EnvC -> Model -> Point -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
judgeMuttering1 env model pos =
    if judgeMouseRect pos model.click_pos clickSize then
        ( { model | status = Muttering2 }
        , []
        , env
        )

    else
        ( model
        , []
        , env
        )


judgeMuttering2 : EnvC -> Model -> Point -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
judgeMuttering2 env model pos =
    if judgeMouseRect pos model.click_pos clickSize then
        ( { model | status = Enemy1 }
        , []
        , env
        )

    else
        ( model
        , []
        , env
        )


judgeEnemy1 : EnvC -> Model -> Point -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
judgeEnemy1 env model pos =
    if judgeMouseRect pos model.click_pos clickSize then
        ( { model
            | status = Enemy2
          }
        , []
        , env
        )

    else
        ( model
        , []
        , env
        )


judgeEnemy2 : EnvC -> Model -> Point -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
judgeEnemy2 env model pos =
    if judgeMouseRect pos model.click_pos clickSize then
        let
            s =
                model.spirit

            ns =
                { s | spirit = 15 }
        in
        ( { model
            | status = Hurt
            , click_pos = addPoint model.pos ( -20, -20 )
            , spirit = ns
          }
        , []
        , env
        )

    else
        ( model
        , []
        , env
        )


judgeHurt : EnvC -> Model -> Point -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
judgeHurt env model pos =
    if judgeMouseRect pos model.click_pos clickSize then
        ( { model
            | status = SelectAvatar
            , click_pos = addPoint model.pos ( 80, -20 )
          }
        , []
        , env
        )

    else
        ( model
        , []
        , env
        )


judgeSelectAvatar : EnvC -> Model -> Point -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
judgeSelectAvatar env model pos =
    if judgeMouseRect pos model.click_pos clickSize then
        ( { model
            | status = MoveAvatar
            , click_pos = textBoxPos
          }
        , []
        , env
        )

    else
        ( model
        , []
        , env
        )


judgeMuttering3 : EnvC -> Model -> Point -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
judgeMuttering3 env model pos =
    if judgeMouseRect pos model.click_pos clickSize then
        ( { model | status = RevealScroll }
        , []
        , env
        )

    else
        ( model
        , []
        , env
        )


judgeCard1 : EnvC -> Model -> Point -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
judgeCard1 env model pos =
    if judgeMouseRect pos model.click_pos clickSize then
        ( { model
            | status = Card2
            , click_pos = addPoint model.pos ( -100, 0 )
          }
        , []
        , env
        )

    else
        ( model
        , []
        , env
        )


judgeCard2 : EnvC -> Model -> Point -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
judgeCard2 env model pos =
    if judgeMouseRect pos model.click_pos clickSize then
        let
            s =
                model.spirit

            ns =
                { s | spirit = 5 }
        in
        ( { model
            | status = End
            , click_pos = textBoxPos
            , spirit = ns
          }
        , []
        , env
        )

    else
        ( model
        , []
        , env
        )


judgeEnd : EnvC -> Model -> Point -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
judgeEnd env model pos =
    if judgeMouseRect pos model.click_pos clickSize then
        ( model
        , [ ( LayerParentScene, LayerIntMsg 0 ) ]
        , env
        )

    else
        ( model
        , []
        , env
        )
