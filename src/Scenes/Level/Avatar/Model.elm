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
import Canvas exposing (Renderable, empty)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Scenes.Level.Avatar.Common exposing (AvatarStatus(..), EnvC, GridLoc, Model, initAvatar1)
import Scenes.Level.Avatar.Render exposing (renderAvailLocs, renderAvatar, renderMovingHint, renderStr)
import Scenes.Level.Avatar.Update exposing (erodeAvailGrids, loc2Pos, moveAvatar, retrieveAvailGrids, setAvatarPos, setAvatarStill, updateClickEvent)
import Scenes.Level.Frame.Functions exposing (addPoint, negPoint, scalePointLength)
import Scenes.Level.SceneInit exposing (LevelInit)


{-| initModel
Add components here
-}
initModel : EnvC -> LevelInit -> Model
initModel _ _ =
    initAvatar1 ( 3, 4 )


{-| updateModel
Default update function

Add your logic to handle msg here

-}
updateModel : EnvC -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModel env model =
    let
        n_model =
            setAvatarPos model
    in
    case env.msg of
        Tick new_time ->
            ( moveAvatar n_model
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
            ( { model | status = AvatarActive }
            , []
            , env
            )

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
            ( erodeAvailGrids model loc, [], env )

        LayerMsgClearCell loc ->
            ( retrieveAvailGrids model loc, [], env )

        LayerMsgClickLoc loc ->
            updateClickEvent env model loc

        _ ->
            ( model, [], env )


viewModel : EnvC -> Model -> Renderable
viewModel env model =
    let
        str =
            case model.status of
                AvatarActive ->
                    "Active"

                AvatarInactive ->
                    "Inactive"

                AvatarMoving ->
                    "Moving"

                AvatarSelected ->
                    "Selevted"

                AvatarStopped ->
                    "Stopped"

        rend =
            [ renderAvatar env model
            , renderMovingHint env model deltaLocsDis1
            , renderStr env ("Avatar status : " ++ str) ( 500, 400 )
            , renderAvailLocs env model
            ]
    in
    case model.status of
        AvatarInactive ->
            Canvas.empty

        _ ->
            Canvas.group
                []
                rend


{-| a list of delta\_locs with the Manhattan Distance of 1 (used for renderMovingHint)
-}
deltaLocsDis1 : List GridLoc
deltaLocsDis1 =
    [ ( -1, 0 )
    , ( 0, -1 )
    , ( 1, 0 )
    , ( 0, 1 )
    ]
