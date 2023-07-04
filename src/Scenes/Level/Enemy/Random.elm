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
    0.75

period1 : Int
period1 =
    6

period2 : Int 
period2 =
    4

period3 : Int
period3 =
    9

xNum : Int
xNum =
    12

{-| Get a function which change continuously for main branch of a tentacle -}
{-
Explicit Function:
y = Asin(kx+d),
in which
    A = 0.5+0.5C1,
    d = 2/3*2*PI/B*C2,
    k = (1/3 + 2/3*C3) * 2*PI/B,
        B = partialC * cellLength,
        [Ci = (q % pi) / pi (i = 1,2,3),] (ERROR: modBy doesn't work for time, and a substitutional plan is applied.)
        p1,2,3 are determined coefficients for A,d,k,
        q = (pos + id + t).
-}
curUniqueSin : Int -> (Int, Int) -> Int -> List Point
curUniqueSin time loc id =
    let
        b = partialCoefficient * cellLength
        q = toFloat (Tuple.first loc) + toFloat (Tuple.second loc) + toFloat (id*100 + time)
        c1 = sin (2*degrees (toFloat ((round q)//period1) ))
        c2 = sin (2*degrees (toFloat ((round q)//period2) ))
        c3 = sin (2*degrees (toFloat ((round q)//period3) ))
        a = 10+10*c1
        d = 2/3*2*pi/b*c2
        k = (1/3 + 2/3*c3) * 2*pi/b
        x = List.map (listModifyNum (b/ (toFloat xNum))) (List.range 1 xNum)
    in
    List.map (generatePairSin a d k) x

{- The following two functions are used for map -}
generatePairSin : Float -> Float -> Float -> Float -> Point
generatePairSin a d k x =
    (x, a * (sin ( radians (k*x + d)) ) )

listModifyNum : Float -> Int -> Float
listModifyNum div x =
    (toFloat x) * div