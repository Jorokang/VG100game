module Scenes.Level.Frame.Random exposing (randomFrame)

{-| Random module


# Functions

@docs randomFrame

-}

import Random


{-| control the random seed in Enemy Layer
-}
randomFrame : Random.Seed -> ( Int, Random.Seed )
randomFrame seed =
    let
        number =
            Random.int 0 1000
    in
    Random.step number seed
