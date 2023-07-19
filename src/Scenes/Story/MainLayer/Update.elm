module Scenes.Story.MainLayer.Update exposing (..)

import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Scenes.Story.MainLayer.Common exposing (EnvC, Model, StoryStatus(..), StoryItem, nullStoryItem)
import Base exposing (Msg(..))
import Canvas exposing (Point)
import Lib.Coordinate.Coordinates exposing (posToReal, lengthToReal)
import Lib.Coordinate.Coordinates exposing (judgeMouseRect)

{-| Judge the mouse click position at Room status
-}
judgeClickItemC : Model -> Point -> StoryStatus
judgeClickItemC model m_pos =
    if (judgeMouseRect m_pos model.family_painting.c_pos model.family_painting.c_size) then
        StoryFamilyPainting
    else
        StoryNull

{-| Judge the mouse click position at Item status
True -> click on the item
False -> click outside the item / Not in item viewing mode
-}
judgeClickItemV : Model-> Point -> Bool
judgeClickItemV model m_pos =
    let
        (i, flag) = case model.status of
                        StoryFamilyPainting ->
                            (model.family_painting, True)
                        _ ->
                            (nullStoryItem, False)
    in
    if (flag) then
        if (judgeMouseRect m_pos i.v_pos i.v_size) then
            True
        else
            False
    else
        False

{-| update model at status StoryRoom (only click events)
-}
updateModelRoom : EnvC -> Model -> Point -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModelRoom env model m_pos =
    let
        judge = judgeClickItemC model m_pos
    in
    case judge of
        StoryFamilyPainting ->
            ( { model | status = StoryFamilyPainting }
            , []
            , env
            )
        _ ->
            ( model, [], env )

{-| update model at status of StoryItems (only click events)
-}
updateModelItems : EnvC -> Model -> Point -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModelItems env model m_pos =
    let
        judge = judgeClickItemV model m_pos
    in
    if judge then
        ( model, [], env )
    else
        ( { model | status = StoryRoom }
        , []
        , env
        )
