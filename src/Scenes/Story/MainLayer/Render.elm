module Scenes.Story.MainLayer.Render exposing (renderBackground, renderMasking, renderStoryItem)

{-| Render module


# Functions

@docs renderBackground, renderMasking, renderStoryItem

-}

import Canvas exposing (Point, Renderable, empty, rect, shapes, text)
import Canvas.Settings exposing (Setting, fill)
import Canvas.Settings.Advanced exposing (filter)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Color exposing (Color, rgb255)
import Lib.Coordinate.Coordinates exposing (lengthToReal, posToReal)
import Lib.Render.Sprite exposing (renderSprite)
import Scenes.Level.Frame.Functions exposing (addPoint, coorChange, lengthChange, negPoint, nullCoorData, scalePoint)
import Scenes.Story.MainLayer.Common exposing (EnvC, Model, StoryItem, StoryStatus(..))


{-| render the background of the Story Layer
(Specifically the image of room)
-}
renderBackground : EnvC -> Model -> Renderable
renderBackground env _ =
    renderSprite env.globalData [] ( 0, 0 ) ( 1920, 1080 ) "room_background_1"


{-| render the masking of the room when viewing StoryItems
-}
renderMasking : EnvC -> Model -> Renderable
renderMasking env model =
    let
        masking =
            shapes
                [ fill Color.white
                , filter "opacity(66%)"
                ]
                [ rect (posToReal env.globalData ( 0, 0 )) (lengthToReal env.globalData 1920) (lengthToReal env.globalData 1080) ]
    in
    case model.status of
        StoryRoom ->
            Canvas.empty

        StoryNull ->
            Canvas.empty

        _ ->
            masking


{-| calculate the real position of the item (according to the scale) at clicking status
-}
realPosItemC : StoryItem -> ( Point, Point )
realPosItemC i =
    ( addPoint i.c_pos (negPoint (scalePoint i.c_size ((i.c_scale - 1) / 2))), scalePoint i.c_size i.c_scale )


{-| render the StoryItem
-}
renderStoryItem : EnvC -> Model -> Renderable
renderStoryItem env model =
    case model.status of
        StoryFamilyPainting ->
            let
                i =
                    model.family_painting

                rend_s =
                    renderSprite env.globalData [] i.v_pos i.v_size i.v_sprite_name

                rend_t =
                    --text [ font { size = 24, family = "Arial", style = "" }, align Center ] (posToReal env.globalData ( 500, 940 )) i.str
                    text [ font { size = round (lengthChange env 24 nullCoorData), family = "Comic Sans MS", style = "" }, align Left ] (coorChange env ( 500, 940 ) nullCoorData) i.str
            in
            Canvas.group
                []
                [ rend_s
                , rend_t
                ]

        StorySun ->
            let
                i =
                    model.sun

                rend_s =
                    renderSprite env.globalData [] i.v_pos i.v_size i.v_sprite_name

                rend_t =
                    text [ font { size = round (lengthChange env 24 nullCoorData), family = "Comic Sans MS", style = "" }, align Left ] (coorChange env ( 500, 940 ) nullCoorData) i.str
            in
            Canvas.group
                []
                [ rend_s
                , rend_t
                ]

        StoryDiary ->
            let
                i =
                    model.diary

                rend_s =
                    renderSprite env.globalData [] i.v_pos i.v_size i.v_sprite_name

                rend_t =
                    text [ font { size = round (lengthChange env 24 nullCoorData), family = "Comic Sans MS", style = "" }, align Left ] (coorChange env ( 500, 940 ) nullCoorData) i.str
            in
            Canvas.group
                []
                [ rend_s
                , rend_t
                ]

        StoryRoom ->
            let
                i1 =
                    model.family_painting

                i2 =
                    model.button_hall

                i3 =
                    model.diary

                i4 =
                    model.sun

                i5 =
                    model.t

                ( pos1, size1 ) =
                    realPosItemC i1

                ( pos2, size2 ) =
                    realPosItemC i2

                ( pos3, size3 ) =
                    realPosItemC i3

                ( pos4, size4 ) =
                    realPosItemC i4

                ( pos5, size5 ) =
                    realPosItemC i5

                rend1 =
                    renderSprite env.globalData [] pos1 size1 i1.c_sprite_name

                rend2 =
                    renderSprite env.globalData [] pos2 size2 i2.c_sprite_name

                rend3 =
                    renderSprite env.globalData [] pos3 size3 i3.c_sprite_name

                rend4 =
                    renderSprite env.globalData [] pos4 size4 i4.c_sprite_name

                rend5 =
                    renderSprite env.globalData [] pos5 size5 i5.c_sprite_name
            in
            Canvas.group
                []
                [ rend1
                , rend2
                , rend3
                , rend4
                , rend5
                ]

        StoryHall ->
            Canvas.empty

        StoryT ->
            Canvas.empty

        StoryNull ->
            Canvas.empty
