module Scenes.Story.MainLayer.Update exposing (updateModelItems, updateModelItemsScale, updateModelRoom)

{-| Update module


# Functions

@docs updateModelItems, updateModelItemsScale, updateModelRoom

-}

import Base exposing (GlobalData, Msg(..))
import Canvas exposing (Point)
import Lib.Audio.Base exposing (AudioOption(..))
import Lib.Coordinate.Coordinates exposing (judgeMouseRect)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Lib.Resources.Sprites exposing (getResourcePath)
import Scenes.Story.MainLayer.Common exposing (EnvC, Model, StoryItem, StoryStatus(..), nullStoryItem)


{-| Judge the mouse click position at Room status
-}
judgeClickItemC : Model -> Point -> StoryStatus
judgeClickItemC model m_pos =
    if judgeMouseRect m_pos model.family_painting.c_pos model.family_painting.c_size then
        StoryFamilyPainting

    else if judgeMouseRect m_pos model.sun.c_pos model.sun.c_size then
        StorySun

    else if judgeMouseRect m_pos model.diary.c_pos model.diary.c_size then
        StoryDiary

    else if judgeMouseRect m_pos model.button_hall.c_pos model.button_hall.c_size then
        StoryHall

    else
        StoryNull


{-| Judge the mouse click position at Item status
True -> click on the item
False -> click outside the item / Not in item viewing mode
-}
judgeClickItemV : Model -> Point -> Bool
judgeClickItemV model m_pos =
    let
        ( i, flag ) =
            case model.status of
                StoryFamilyPainting ->
                    ( model.family_painting, True )

                StoryHall ->
                    ( model.button_hall, True )

                StoryDiary ->
                    ( model.diary, True )

                StorySun ->
                    ( model.diary, True )

                _ ->
                    ( nullStoryItem, False )
    in
    if flag then
        if judgeMouseRect m_pos i.v_pos i.v_size then
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
        judge =
            judgeClickItemC model m_pos
    in
    case judge of
        StoryFamilyPainting ->
            ( { model | status = StoryFamilyPainting }
            , []
            , env
            )

        StorySun ->
            ( { model | status = StorySun }
            , []
            , env
            )

        StoryDiary ->
            ( { model | status = StoryDiary }
            , []
            , env
            )

        StoryHall ->
            ( { model | status = StoryHall }
            , [ ( LayerParentScene, LayerStringMsg "Hall" )
              , ( LayerParentScene, LayerSoundMsg "bgm" (getResourcePath "bgm/bgm.ogg") ALoop )
              ]
            , env
            )

        _ ->
            ( model, [], env )


{-| update model at status of StoryItems (only click events)
-}
updateModelItems : EnvC -> Model -> Point -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModelItems env model m_pos =
    let
        judge =
            judgeClickItemV model m_pos
    in
    if judge then
        ( model, [], env )

    else
        ( { model | status = StoryRoom }
        , []
        , env
        )


{-| increase the scale of a single item to 1.3
-}
increaseItemScale : StoryItem -> StoryItem
increaseItemScale i =
    { i | c_scale = 1.3 }


{-| decrease the scale of a single item to 1
-}
decreaseItemScale : StoryItem -> StoryItem
decreaseItemScale i =
    { i | c_scale = 1 }


{-| update the scale of items when the mouse is on them at clicking status
-}
updateModelItemsScale : EnvC -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModelItemsScale env model =
    let
        m_pos =
            env.globalData.mousePos

        judge =
            judgeClickItemC model m_pos
    in
    case judge of
        StoryFamilyPainting ->
            ( { model
                | family_painting = increaseItemScale model.family_painting
                , button_hall = decreaseItemScale model.button_hall
                , sun = decreaseItemScale model.sun
                , diary = decreaseItemScale model.diary
              }
            , []
            , env
            )

        StorySun ->
            ( { model
                | sun = increaseItemScale model.sun
                , button_hall = decreaseItemScale model.button_hall
                , family_painting = decreaseItemScale model.family_painting
                , diary = decreaseItemScale model.diary
              }
            , []
            , env
            )

        StoryDiary ->
            ( { model
                | diary = increaseItemScale model.diary
                , button_hall = decreaseItemScale model.button_hall
                , sun = decreaseItemScale model.sun
                , family_painting = decreaseItemScale model.family_painting
              }
            , []
            , env
            )

        StoryHall ->
            ( { model
                | family_painting = decreaseItemScale model.family_painting
                , button_hall = increaseItemScale model.button_hall
                , sun = decreaseItemScale model.sun
                , diary = decreaseItemScale model.diary
              }
            , []
            , env
            )

        _ ->
            ( { model
                | family_painting = decreaseItemScale model.family_painting
                , button_hall = decreaseItemScale model.button_hall
                , sun = decreaseItemScale model.sun
                , diary = decreaseItemScale model.diary
              }
            , []
            , env
            )
