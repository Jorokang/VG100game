module Scenes.Level.Enemy.Random exposing (..)

import Random
import Scenes.Level.Frame.Functions exposing (cellLength)
import Canvas exposing (Point)
import List
import Tuple

{-| control the random seed in Enemy Layer-}
randomEnemy : Random.Seed -> (Int, Random.Seed)
randomEnemy seed =
    let
        number =
            Random.int 0 1000
    in
    Random.step number seed


{- The following five functions are coefficients for curUniqueSin -}
partialCoefficient : Float
partialCoefficient = 
    0.45

period1 : Float
period1 =
    20

period2 : Float 
period2 =
    30

period3 : Float
period3 =
    36

xNum : Int
xNum =
    6

{-| Get a function which change continuously for main branch of a tentacle -}
{-
Explicit Function:
y = Asin(kx+d),
in which
    A = 0.5+0.5C1,
    d = 2/3*2*PI/B*C2,
    k = (1/3 + 2/3*C3) * 2*PI/B,
        B = partialC * cellLength,
        Ci = (q % pi) / pi (i = 1,2,3),
        p1,2,3 are determined coefficients for A,d,k,
        q = (pos + id + t).
-}
curUniqueSin : Int -> Point -> Int -> List Point
curUniqueSin time pos id =
    let
        b = partialCoefficient * cellLength
        q = Tuple.first pos + Tuple.second pos + toFloat (id + time)
        c1 = ( toFloat ( modBy (round q) (round period1) ) ) / period1
        c2 = ( toFloat ( modBy (round q) (round period2) ) ) / period2
        c3 = ( toFloat ( modBy (round q) (round period3) ) ) / period3
        a = 5+5*c1
        d = 2/3*2*pi/b*c2
        k = (1/3 + 2/3*c3) * 2*pi/b
        x = List.map (listModifyNum (b/ (toFloat xNum))) (List.range 1 xNum)
    in
    List.map (generatePairSin a d k) x

{- The following two functions are used for map -}
generatePairSin : Float -> Float -> Float -> Float -> Point
generatePairSin a d k x =
    (x, a*sin ( radians (k*x + d)))

listModifyNum : Float -> Int -> Float
listModifyNum div x =
    (toFloat x) * div