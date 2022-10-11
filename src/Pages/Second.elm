module Pages.Second exposing (layout, page)

import Element exposing (..)
import Element.Font as Font
import Layout exposing (Layout)
import View exposing (View)


layout : Layout
layout =
    Layout.Navigation


page : View msg
page =
    { title = "Second"
    , body =
        column
            [ centerX
            , centerY
            , spacing 30
            ]
            [ el [ Font.size 36, centerX ] <| text "Second"
            ]
    , next = Nothing
    , previous = Just "/"
    }
