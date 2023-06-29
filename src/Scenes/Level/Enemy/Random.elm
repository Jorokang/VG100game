module Scenes.Level.Enemy.Random exposing (..)

import Random

{-| control the random seed in Enemy Layer-}
randomEnemy : Random.Seed -> (Int, Random.Seed)
randomEnemy seed =
    let
        number =
            Random.int 0 1000
    in
    Random.step number seed
