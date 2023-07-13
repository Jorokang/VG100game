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
import Canvas exposing (Point, Renderable, empty, group)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Scenes.Level.Enemy.Common exposing (EnemyState(..), EnvC, ErodePriority(..), Model, initEnemy1)
import Scenes.Level.Enemy.Random exposing (randomEnemy)
import Scenes.Level.Enemy.Render exposing (renderEnemyBody, renderEnemyCore, renderEnemyEye, renderNum)
import Scenes.Level.Enemy.Update exposing (clickFreeCell, erodeTarget, freeCell, handlePermissionMsg, handleProtectMsg, moveEnemyEye, targetNearestCell, targetRandomCell, updateEnemySettingTarget)
import Scenes.Level.SceneInit exposing (LevelInit)
import Time exposing (posixToMillis)


{-| initModel
Add components here
-}
initModel : EnvC -> LevelInit -> Model
initModel _ _ =
    initEnemy1


{-| updateModel
-}
updateModel : EnvC -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModel env model =
    case model.status of
        EnemyAlive ->
            case env.msg of
                Tick newTime ->
                    ( --{ model | time = Time.posixToMillis newTime }
                      { model | time = Time.posixToMillis newTime }
                        |> updateRandNum
                        |> moveEnemyEye
                    , []
                    , env
                    )

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
            updateEnemySettingTarget env model ErodeNearest

        LayerMsgEnemyTurn ->
            --erode the target
            ( erodeTarget model
            , [ ( LayerName "Frame", LayerMsgEnemyErodeCell model.target ) ]
            , env
            )

        LayerMsgClearCell loc ->
            ( freeCell model loc
            , []
            , env
            )

        LayerMsgErodePermission loc x ->
            handlePermissionMsg env model loc x

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
