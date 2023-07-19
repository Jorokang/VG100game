module Scenes.Story.MainLayer.Render exposing (..)

import Canvas exposing (Point, Renderable, empty, rect, shapes, text)
import Canvas.Settings exposing (Setting, fill)
import Canvas.Settings.Advanced exposing (filter)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Color exposing (Color, rgb255)
import Scenes.Story.MainLayer.Common exposing (Model, StoryStatus(..), StoryItem, EnvC)
import Lib.Coordinate.Coordinates exposing (posToReal, lengthToReal)
import Lib.Render.Sprite exposing (renderSprite)

{-| render the background of the Story Layer
    (Specifically the image of room)
-}
renderBackground : EnvC -> Model -> Renderable
renderBackground env model =
    shapes
        [fill (Color.rgb255 20 30 40)]
        [ rect (posToReal env.globalData (0,0)) (lengthToReal env.globalData 1920) (lengthToReal env.globalData 1080) ]

{-| render the masking of the room when viewing StoryItems
-}
renderMasking : EnvC -> Model -> Renderable
renderMasking env model =
    let
        masking = shapes
                    [ fill (Color.white)
                    , filter "opacity(50%)" ]
                    [ rect (posToReal env.globalData (0,0)) (lengthToReal env.globalData 1920) (lengthToReal env.globalData 1080) ]
    in
    case model.status of
        StoryRoom ->
            Canvas.empty
        StoryNull ->
            Canvas.empty
        _ ->
            masking

{-| render the StoryItem
-}
renderStoryItem : EnvC -> Model -> Renderable
renderStoryItem env model =
    case model.status of
        StoryFamilyPainting ->
            let
                i = model.family_painting
                rend_s = renderSprite env.globalData [] i.pos i.size i.sprite_name
                rend_t = text [ font { size = 24, family = "Arial", style = "" }, align Center ] (posToReal env.globalData ( 1800, 540 ) ) i.str
            in
            Canvas.group
            []
            [ rend_s
            , rend_t
            ]
        _ ->
            Canvas.empty