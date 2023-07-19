module Scenes.Story.MainLayer.Render exposing (..)

import Canvas exposing (Point, Renderable, empty, rect, shapes, text)
import Canvas.Settings exposing (Setting, fill)
import Canvas.Settings.Advanced exposing (filter)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Color exposing (Color, rgb255)
import Scenes.Story.MainLayer.Common exposing (Model, StoryStatus(..), StoryItem, EnvC)
import Lib.Coordinate.Coordinates exposing (posToReal, lengthToReal)
import Lib.Render.Sprite exposing (renderSprite)
import Scenes.Level.Frame.Functions exposing (scalePoint, addPoint, negPoint)

{-| render the background of the Story Layer
    (Specifically the image of room)
-}
renderBackground : EnvC -> Model -> Renderable
renderBackground env _ =
    renderSprite env.globalData [] (0,0) (1920, 1080) "room_background_1"

{-| render the masking of the room when viewing StoryItems
-}
renderMasking : EnvC -> Model -> Renderable
renderMasking env model =
    let
        masking = shapes
                    [ fill (Color.white)
                    , filter "opacity(66%)" ]
                    [ rect (posToReal env.globalData (0,0)) (lengthToReal env.globalData 1920) (lengthToReal env.globalData 1080) ]
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
realPosItemC : StoryItem -> ( Point , Point )
realPosItemC i =
    ( addPoint i.c_pos ( negPoint (scalePoint i.c_size ((i.c_scale-1)/2) ) ), scalePoint i.c_size i.c_scale )

{-| render the StoryItem
-}
renderStoryItem : EnvC -> Model -> Renderable
renderStoryItem env model =
    case model.status of
        StoryFamilyPainting ->
            let
                i = model.family_painting
                rend_s = renderSprite env.globalData [] i.v_pos i.v_size i.v_sprite_name
                rend_t = text [ font { size = 24, family = "Arial", style = "" }, align Center ] (posToReal env.globalData ( 1800, 540 ) ) i.str
            in
            Canvas.group
            []
            [ rend_s
            , rend_t
            ]
        StoryRoom ->
            let
                i1 = model.family_painting
                i2 = model.button_hall
                ( pos1, size1 ) = realPosItemC i1
                ( pos2, size2 ) = realPosItemC i2
                rend1 = renderSprite env.globalData [] pos1 size1 i1.c_sprite_name
                rend2 = renderSprite env.globalData [] pos2 size2 i2.c_sprite_name
            in
            Canvas.group
            []
            [ rend1
            , rend2
            ]
        StoryHall ->
            Canvas.empty
        StoryNull ->
            Canvas.empty