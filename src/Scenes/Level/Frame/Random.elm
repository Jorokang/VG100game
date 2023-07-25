module Scenes.Level.Frame.Random exposing (..)

import Canvas exposing (Point)
import List
import Random
import Tuple


{-| control the random seed in Enemy Layer
-}
randomFrame : Random.Seed -> ( Int, Random.Seed )
randomFrame seed =
    let
        number =
            Random.int 0 1000
    in
    Random.step number seed
