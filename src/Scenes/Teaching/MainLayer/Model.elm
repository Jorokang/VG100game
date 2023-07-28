module Scenes.Teaching.MainLayer.Model exposing
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
import Scenes.Teaching.MainLayer.Common exposing (EnvC, Model, TeachingStatus(..), nullModel)
import Scenes.Teaching.MainLayer.Render
    exposing
        ( renderAvatar
        , renderBackgroud
        , renderCard1
        , renderCard2
        , renderClick
        , renderEnd
        , renderEnemy1
        , renderEnemy2
        , renderHurt
        , renderInit
        , renderMoveAvatar
        , renderMuttering1
        , renderMuttering2
        , renderMuttering3
        , renderRevealScroll
        , renderSelectAvatar
        , renderShadow
        , renderSpirit
        )
import Scenes.Teaching.MainLayer.Update exposing (judgeClickEnvet, updateAnima, updateMoveAvatar, updateRevealScroll, updateScrollOpacity, updateSpirit)
import Scenes.Teaching.SceneInit exposing (TeachingInit)
import Time exposing (posixToMillis)


{-| initModel
Add components here
-}
initModel : EnvC -> TeachingInit -> Model
initModel _ _ =
    nullModel


{-| updateModel
Default update function

Add your logic to handle msg here

-}
updateModel : EnvC -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModel env model =
    case env.msg of
        Tick new_time ->
            ( { model | time = posixToMillis new_time }
                |> updateAnima
                |> updateSpirit
                |> updateMoveAvatar
                |> updateRevealScroll
                |> updateScrollOpacity
            , []
            , env
            )

        MouseDown x pos ->
            judgeClickEnvet env model pos

        _ ->
            ( model, [], env )


{-| updateModelRec
Default update function

Add your logic to handle LayerMsg here

-}
updateModelRec : EnvC -> LayerMsg -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModelRec env lmsg model =
    ( model, [], env )


{-| viewModel
Default view function

If you don't have components, remove viewComponent.

If you have other elements than components, add them after viewComponent.

-}
viewModel : EnvC -> Model -> Renderable
viewModel env model =
    let
        rend_status =
            case model.status of
                Init ->
                    renderInit env model

                Muttering1 ->
                    renderMuttering1 env model

                Muttering2 ->
                    renderMuttering2 env model

                Enemy1 ->
                    renderEnemy1 env model

                Enemy2 ->
                    renderEnemy2 env model

                Hurt ->
                    renderHurt env model

                SelectAvatar ->
                    renderSelectAvatar env model

                MoveAvatar ->
                    renderMoveAvatar env model

                Muttering3 ->
                    renderMuttering3 env model

                RevealScroll ->
                    renderRevealScroll env model

                Card1 ->
                    renderCard1 env model

                Card2 ->
                    renderCard2 env model

                End ->
                    renderEnd env model

        rend =
            [ renderBackgroud env model
            , renderShadow env model
            , renderAvatar env model
            , renderSpirit env model
            , rend_status
            , renderClick env model
            ]
    in
    Canvas.group
        []
        rend
