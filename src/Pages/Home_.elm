module Pages.Home_ exposing (page)

import Element exposing (..)
import Element.Font as Font
import Layout exposing (Layout)
import View exposing (View)


layout : Layout
layout =
    Layout.Navigation


page : View msg
page =
    { title = "Homepage"
    , body =
        column
            [ centerX
            , centerY
            , spacing 30
            ]
            [ el [ Font.size 36, centerX ] <| text "ELM"
            , paragraph []
                [ text "If it compiles it works!"
                ]
            ]
    , next = Nothing
    , previous = Just ""
    }
