module Scenes.Level.Grids.Random exposing (randomGrids)

{-| Random module


# Functions

@docs randomGrids

-}

import Random


{-| control the random seed in Enemy Layer
-}
randomGrids : Random.Seed -> ( Int, Random.Seed )
randomGrids seed =
    let
        number =
            Random.int 0 1000
    in
    Random.step number seed
