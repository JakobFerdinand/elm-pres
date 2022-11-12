module View exposing
    ( View, map
    , none, fromString
    , toBrowserDocument
    , Slide(..)
    )

{-|

@docs View, map
@docs none, fromString
@docs toBrowserDocument

-}

import Browser
import Colors exposing (darkgray, lightgray)
import Component exposing (heading)
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font


type alias View msg =
    { title : String
    , body : Slide msg
    , previous : Maybe msg
    , next : Maybe msg
    }


type Slide msg
    = Header (Element msg)
    | Slide
        { header : Element msg
        , body : Element msg
        }


{-| Used internally by Elm Land to create your application
so it works with Elm's expected `Browser.Document msg` type.
-}
toBrowserDocument : View msg -> Browser.Document msg
toBrowserDocument view =
    { title = view.title
    , body =
        [ layout
            [ width fill
            , height fill
            , padding 80
            , Background.color darkgray
            , Font.color lightgray
            , Font.family
                [ Font.external
                    { name = "Source Sans 3"
                    , url = "https://fonts.googleapis.com/css2?family=Source+Sans+3&display=swap"
                    }
                ]
            ]
          <|
            case view.body of
                Header header ->
                    header

                Slide { header, body } ->
                    column
                        [ spacing 50
                        , width fill
                        , height fill
                        ]
                        [ heading header
                        , body
                        ]
        ]
    }


{-| Used internally by Elm Land to wire up your pages together.
-}
map : (msg1 -> msg2) -> View msg1 -> View msg2
map fn view =
    { title = view.title
    , body =
        case view.body of
            Header header ->
                Header (Element.map fn header)

            Slide { header, body } ->
                Slide
                    { header = Element.map fn header
                    , body = Element.map fn body
                    }
    , previous = view.previous |> Maybe.map fn
    , next = view.next |> Maybe.map fn
    }


{-| Used internally by Elm Land whenever transitioning between
authenticated pages.
-}
none : View msg
none =
    { title = ""
    , body = Header <| Element.none
    , next = Nothing
    , previous = Nothing
    }


{-| If you customize the `View` module, anytime you run `elm-land add page`,
the generated page will use this when adding your `view` function.

That way your app will compile after adding new pages, and you can see
the new page working in the web browser!

-}
fromString : String -> View msg
fromString moduleName =
    { title = moduleName
    , body = Header <| Element.text moduleName
    , next = Nothing
    , previous = Nothing
    }
