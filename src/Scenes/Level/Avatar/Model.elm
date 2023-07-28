module Scenes.Level.Avatar.Model exposing
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
import Scenes.Level.Avatar.Common exposing (AvatarStatus(..), EnvC, GridLoc, Model, initAvatarLevel1, initAvatarLevel2, initAvatarLevel3, initAvatarLevel4, nullModel)
import Scenes.Level.Avatar.Render exposing (renderAvatar, renderCardHint, renderMovingHint, renderShadow, renderSpirit, renderStr, renderTrappedEffect)
import Scenes.Level.Avatar.Update exposing (judgeErosionDamage, moveAvatar, retrieveAvailGrids, setAvatarPos, setAvatarStill, updateAnima, updateCardType, updateClickEvent, updateErodeMsg, updateModifyLight, updateModifySpirit, updateSpirit)
import Scenes.Level.SceneInit exposing (LevelInit)


{-| initModel
Add components here
-}
initModel : EnvC -> LevelInit -> Model
initModel _ i =
    case i.level_id of
        1 ->
            initAvatarLevel1

        2 ->
            initAvatarLevel2

        3 ->
            initAvatarLevel3

        4 ->
            initAvatarLevel4 i.rand_num

        _ ->
            nullModel


updateModel : EnvC -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModel env model =
    let
        n_model =
            setAvatarPos model
    in
    case env.msg of
        Tick new_time ->
            ( n_model
                |> moveAvatar
                |> updateAnima
                |> updateSpirit
            , []
            , env
            )

        _ ->
            ( n_model, [], env )


{-| updateModelRec
Default update function

Add your logic to handle LayerMsg here

-}
updateModelRec : EnvC -> LayerMsg -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModelRec env lmsg model =
    case lmsg of
        LayerMsgEnemyTurn ->
            ( { model | status = AvatarStopped }
                |> setAvatarStill
            , []
            , env
            )

        LayerMsgPlayerTurn ->
            { model
                | status = AvatarActive
                , stamina = 3
            }
                |> judgeErosionDamage env

        LayerIntMsg x ->
            case x of
                1 ->
                    ( { model | status = AvatarActive }
                    , []
                    , env
                    )

                0 ->
                    ( { model | status = AvatarStopped }
                        |> setAvatarStill
                    , []
                    , env
                    )

                _ ->
                    ( model, [], env )

        LayerMsgErodeCell loc ->
            updateErodeMsg env model loc

        LayerMsgClearCell loc ->
            ( retrieveAvailGrids model loc, [], env )

        LayerMsgClickLoc loc ->
            updateClickEvent env model loc

        LayerMsgCardType card_type ->
            updateCardType env model card_type

        LayerMsgModifySpirit x ->
            updateModifySpirit env model x

        LayerMsgAvatarModifyLight r ->
            updateModifyLight env model r

        _ ->
            ( model, [], env )


viewModel : EnvC -> Model -> Renderable
viewModel env model =
    let
        str =
            case model.status of
                AvatarActive ->
                    "Active"

                AvatarDead ->
                    "Dead"

                AvatarMoving ->
                    "Moving"

                AvatarCard ->
                    "Using Card"

                AvatarSelected ->
                    "Selevted"

                AvatarStopped ->
                    "Stopped"

        rend =
            [ renderAvatar env model
            , renderTrappedEffect env model
            , renderMovingHint env model
            , renderShadow env model
            , renderCardHint env model
            , renderSpirit env model
            ]
    in
    case model.status of
        AvatarDead ->
            renderStr env ("Avatar status : " ++ str) ( 500, 400 )

        _ ->
            Canvas.group
                []
                rend
