module Scenes.Level.Avatar.Render exposing (..)

import Canvas exposing (Point, Renderable, circle, empty, group, rect, shapes)
import Canvas.Settings exposing (fill)
import Color exposing (Color)
import Scenes.Level.Avatar.Common exposing (EnvC, Model, nullModel)
import Scenes.Level.Frame.Functions exposing (cellLength, coorChange, grid2real, lengthChange, lowerCell, nullCoorData)


avatarRadius : Float
avatarRadius =
    cellLength * 0.35


renderAvatar : EnvC -> Model -> Renderable
renderAvatar env model =
    shapes
        [ fill Color.yellow ]
        [ circle (coorChange env model.pos nullCoorData) (lengthChange env avatarRadius nullCoorData) ]
