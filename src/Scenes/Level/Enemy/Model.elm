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
import Scenes.Level.Enemy.Common exposing (EnemyState(..), EnvC, Model, initEnemy1)
import Scenes.Level.Enemy.Random exposing (randomEnemy)
import Scenes.Level.Enemy.Render exposing (renderEnemyBody, renderEnemyCore, renderEnemyEye, renderNum)
import Scenes.Level.Enemy.Update exposing (clickFreeCell, erodeTarget, moveEnemyEye, targetNearestCell, targetRandomCell)
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
        Alive ->
            case env.msg of
                Tick newTime ->
                    ( --{ model | time = Time.posixToMillis newTime }
                      { model | time = Time.posixToMillis newTime }
                        |> updateRandNum
                        |> moveEnemyEye
                    , []
                    , env
                    )

                KeyDown x ->
                    case x of
                        32 ->
                            --space->erode target
                            ( erodeTarget model
                            , []
                            , env
                            )

                        38 ->
                            --arrowup->set random target
                            ( targetRandomCell model
                            , []
                            , env
                            )

                        40 ->
                            --arrowdown->set nearest target
                            ( targetNearestCell model
                            , []
                            , env
                            )

                        _ ->
                            --do nothing
                            ( model, [], env )

                MouseDown _ ( a, b ) ->
                    ( clickFreeCell model ( a, b )
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


{-| updateModelRec
Default update function

Add your logic to handle LayerMsg here

-}
updateModelRec : EnvC -> LayerMsg -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModelRec env _ model =
    ( model, [], env )


{-| viewModel
Default view function

If you don't have components, remove viewComponent.

If you have other elements than components, add them after viewComponent.

-}
viewModel : EnvC -> Model -> Renderable
viewModel env model =
    let
        rend =
            case model.status of
                Dead ->
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
