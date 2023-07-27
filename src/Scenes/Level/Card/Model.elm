module Scenes.Level.Card.Model exposing
    ( initModel
    , updateModel, updateModelRec
    , viewModel
    )

{-| Model module

@docs initModel
@docs updateModel, updateModelRec
@docs viewModel

-}

import Base exposing (Msg(..))
import Canvas exposing (Renderable)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Scenes.Level.Card.CardCreate exposing (CardStatus(..), Model, giveErrorCard)
import Scenes.Level.Card.CardSystem exposing (drawCard, dropCardByCard)
import Scenes.Level.Card.CardUnique exposing (clickCard, costSpirit)
import Scenes.Level.Card.Common exposing (EnvC, nullModel)
import Scenes.Level.Card.Render exposing (renderCardInfo, renderDeckCards, renderDiscardCards, renderHandCards, renderTestMessage)
import Scenes.Level.SceneInit exposing (LevelInit)


{-| initModel
Add components here
-}
initModel : EnvC -> LevelInit -> Model
initModel _ _ =
    nullModel


{-| updateModel
Default update function

Add your logic to handle msg here

-}
updateModel env model =
    case model.status of
        Active ->
            let
                ( checked_model, msg ) =
                    if model.click_status then
                        clickCard model

                    else
                        ( model, [] )
            in
            case env.msg of
                MouseDown _ ( a, b ) ->
                    ( { checked_model | point = ( a, b ), click_status = True }, msg, env )

                MouseMove ( a, b ) ->
                    ( { checked_model | point = ( a, b ) }, msg, env )

                _ ->
                    ( checked_model, msg, env )

        _ ->
            ( model, [], env )


{-| updateModelRec
Default update function

Add your logic to handle LayerMsg here

-}
updateModelRec : EnvC -> LayerMsg -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModelRec env msg model =
    case msg of
        LayerMsgPlayerTurn ->
            ( drawCard { model | status = Active } 1, [], env )

        LayerMsgEnemyTurn ->
            ( { model | status = Inactive }, [], env )

        LayerMsgCardType id ->
            let
                nmodel =
                    { model | status = Active, selected_pos = -1, selected_card = giveErrorCard }
            in
            if id == model.selected_card.id && id /= -1 then
                ( dropCardByCard nmodel model.selected_card, costSpirit model, env )

            else
                ( nmodel, [], env )

        LayerMsgModifySpirit x ->
            ( { model | spirit = x }, [], env )

        _ ->
            ( model, [], env )


{-| viewModel
Default view function

If you don't have components, remove viewComponent.

If you have other elements than components, add them after viewComponent.

-}
viewModel : EnvC -> Model -> Renderable
viewModel env model =
    Canvas.group
        []
        [ renderHandCards env model
        , renderDeckCards env model
        , renderDiscardCards env model

        --, renderTestMessage env model
        --, renderCardInfo env model
        ]
