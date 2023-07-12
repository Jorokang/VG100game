module Scenes.Hall.MainLayer.Model exposing
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
import Lib.Render.Sprite exposing (renderSprite)
import Scenes.Hall.MainLayer.Common exposing (ButtonStatus(..), EnvC, HallStatus(..), Model, l1, l2, l3, nullModel)
import Scenes.Hall.MainLayer.Render exposing (renderButtons, renderStr, renderTime)
import Scenes.Hall.MainLayer.Update exposing (checkall)
import Scenes.Hall.SceneInit exposing (HallInit)
import Scenes.Level.Frame.Functions exposing (coorChange, nullCoorData)
import Time exposing (posixToMillis)


{-| initModel
Add components here
-}
initModel : EnvC -> HallInit -> Model
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
            , []
            , env
            )

        KeyDown x ->
            ( model, [ ( LayerParentScene, LayerStringMsg "Level" ) ], env )

        MouseDown x ( a, b ) ->
            let
                n_model =
                    { model | click_pos = ( a, b ) }

                s =
                    checkall n_model ( a, b )

                --change the btn status      
            in
            case s of
                "Level1" ->
                    ( { n_model
                        | status = Inactive
                        , levels =
                            { level1 = { l1 | status = ButtonPressed}
                            , level2 = l2
                            , level3 = l3
                            }
                      }
                    , [ ( LayerParentScene, LayerStringMsg "Level" ) ]
                    , env
                    )

                "Level2" ->
                    ( { n_model
                        | status = Inactive
                        , levels =
                            { level1 = l1
                            , level2 = { l2 | status = ButtonPressed}
                            , level3 = l3
                            }
                      }
                    , [ ( LayerParentScene, LayerStringMsg "Level" ) ]
                    , env
                    )

                "Level3" ->
                    ( { n_model
                        | status = Inactive
                        , levels =
                            { level1 = l1
                            , level2 = l2
                            , level3 = { l3 | status = ButtonPressed}
                            }
                      }
                    , [ ( LayerParentScene, LayerStringMsg "Level" ) ]
                    , env
                    )

                _ ->
                    ( n_model, [], env )

        _ ->
            ( model, [], env )


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
            [ renderStr env (coorChange env ( 200, 50 ) nullCoorData) "HALL"
            , renderButtons env model
            , renderStr env (coorChange env ( 200, 700 ) nullCoorData) ("click" ++ String.fromFloat (Tuple.first model.click_pos) ++ ", " ++ String.fromFloat (Tuple.second model.click_pos))
            ]
    in
    Canvas.group
        []
        rend
