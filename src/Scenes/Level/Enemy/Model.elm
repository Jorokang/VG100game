module Scenes.Level.Enemy.Model exposing
    ( initModel
    , updateModel, updateModelRec
    , viewModel
    )

{-| Model module

@docs initModel
@docs updateModel, updateModelRec
@docs viewModel

-}

import Base exposing (GlobalData, Msg(..))
import Canvas exposing (Point, Renderable, group)
import Lib.Env.Env exposing (Env)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import List
import Scenes.Level.Enemy.Common exposing (EnemyState(..), EnvC, ErodePriority(..), Model, initEnemyLevel1, initEnemyLevel2, initEnemyLevel3, nullModel, initEnemyLevel4)
import Scenes.Level.Enemy.Random exposing (randomEnemy)
import Scenes.Level.Enemy.Render exposing (renderEnemyBody, renderEnemyCore, renderEnemyEye)
import Scenes.Level.Enemy.Update exposing (curPriority, erodeTarget, freeCell, handlePermissionMsg, handleProtectMsg, moveEnemyEye, resetRecursionTimes, updateEndRound, updateEnemyRound, updateEnemySettingTarget, updatePlayerRound)
import Scenes.Level.SceneInit exposing (LevelInit)
import Time


{-| initModel
Add components here
-}
initModel : EnvC -> LevelInit -> Model
initModel _ i =
    case i.level_id of
        1 ->
            initEnemyLevel1

        2 ->
            initEnemyLevel2

        3 ->
            initEnemyLevel3

        4 ->
            initEnemyLevel4 i.rand_num

        _ ->
            nullModel


{-| updateModel
-}
updateModel : EnvC -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModel env model =
    case model.status of
        EnemyDead ->
            case env.msg of
                Tick _ ->
                    ( model
                    , [ ( LayerParentScene, LayerMsgLevelComplete 1 model.level_id ) ]
                    , env
                    )

                _ ->
                    ( model, [], env )

        EnemyAlive ->
            case env.msg of
                Tick newTime ->
                    let
                        nmodel =
                            { model | time = Time.posixToMillis newTime }
                                |> updateRandNum
                    in
                    ( --{ model | time = Time.posixToMillis newTime }
                      nmodel
                    , []
                    , env
                    )

                _ ->
                    ( model, [], env )

        EnemyMoving ->
            case env.msg of
                Tick newTime ->
                    let
                        nmodel =
                            { model | time = Time.posixToMillis newTime }
                                |> updateRandNum
                    in
                    moveEnemyEye env nmodel

                _ ->
                    ( model, [], env )

        _ ->
            ( model, [], env )


{-| update the random number in model
-}
updateRandNum : Model -> Model
updateRandNum model =
    let
        ( randNum, seed ) =
            randomEnemy model.seed
    in
    { model
        | randNum = randNum
        , seed = seed
    }


updateModelRec : EnvC -> LayerMsg -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModelRec env lmsg model =
    case lmsg of
        LayerMsgPlayerTurn ->
            --set the target
            --updateEnemySettingTarget env (updatePlayerRound model) ErodeRandom--(curPriority model)
            ( updatePlayerRound model
            , []
            , env
            )

        LayerMsgEnemyErodeTarget ->
            --erode the target
            ( model
                |> erodeTarget
                |> resetRecursionTimes
            , [ ( LayerName "Frame", LayerMsgEnemyErodeCell model.target ) ]
            , env
            )

        LayerMsgEnemyTurn ->
            updateEnemySettingTarget env (updateEnemyRound model) (curPriority model)

        LayerMsgEnemySetTarget ->
            if List.isEmpty model.target_priority then
                updateEndRound env model

            else
                updateEnemySettingTarget env model (curPriority model)

        LayerMsgClearCell loc ->
            let
                msg =
                    if loc == model.core.loc then
                        [ ( LayerParentScene, LayerMsgLevelComplete 1 model.level_id ) ]

                    else
                        []
            in
            ( freeCell model loc
            , msg
            , env
            )

        LayerMsgErodePermission _ x ->
            handlePermissionMsg env model x

        LayerMsgProtectCell loc x ->
            handleProtectMsg env model loc

        _ ->
            ( model, [], env )


viewModel : EnvC -> Model -> Renderable
viewModel env model =
    let
        rend =
            case model.status of
                EnemyDead ->
                    []

                _ ->
                    [ renderEnemyBody env model
                    , renderEnemyCore env model
                    , renderEnemyEye env model
                    ]
    in
    group
        []
        rend
