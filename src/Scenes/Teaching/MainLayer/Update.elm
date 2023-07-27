module Scenes.Teaching.MainLayer.Update exposing (..)

import Scenes.Teaching.MainLayer.Common exposing (EnvC, Model, nullModel, AvatarAnima, AvatarSpirit)
import Scenes.Level.Frame.Functions exposing (addLoc, addPoint, allGrids, cellLength, coorChange, coorChangeS, grid2real, lengthChange, lengthChangeS, mapCoorData, nullCoorData, shadowCoorData, sizeChangeS)

{-| update model anima
-}
updateAnima : Model -> Model
updateAnima model =
    let
        anima =
            model.anima

        ( nav, naa ) =
            if abs anima.a_v >= anima.lim then
                ( anima.a_v - anima.a_a, -anima.a_a )

            else
                ( anima.a_v + anima.a_a, anima.a_a )

        ( npv, npa ) =
            if abs anima.p_v >= anima.lim then
                ( anima.p_v - anima.p_a, -anima.p_a )

            else
                ( anima.p_v + anima.p_a, anima.p_a )

        napos =
            addPoint anima.a_pos ( 0, anima.a_v )

        nppos =
            addPoint anima.p_pos ( 0, anima.p_v )

        nanima =
            { anima
                | a_pos = napos
                , a_v = nav
                , a_a = naa
                , p_pos = nppos
                , p_v = npv
                , p_a = npa
            }
    in
    { model | anima = nanima }


updateSpirit : Model -> Model
updateSpirit model =
    let
        s =
            model.spirit

        d =
            s.spirit - s.cur_spirit

        ns =
            if abs d <= s.spirit_v then
                { s | cur_spirit = s.spirit }

            else if d < 0 then
                { s | cur_spirit = s.cur_spirit - s.spirit_v }

            else
                { s | cur_spirit = s.cur_spirit + s.spirit_v }
    in
    { model | spirit = ns }