module Scenes.Level.Frame.Functions exposing (..)
import Canvas exposing (Point)
import Lib.Env.Env as Env

type alias EnvC =
    Env.EnvC CommonData

coorChange : EnvC -> Point -> Point
coorChange _ pos =
    pos