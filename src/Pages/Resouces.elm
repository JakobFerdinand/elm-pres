module Pages.Resouces exposing (Model, Msg, layout, page)

import Browser.Navigation as Nav
import Component exposing (imageLink)
import Effect exposing (Effect)
import Element exposing (..)
import KeyListener
import Layout exposing (Layout)
import Logo
import Navigation exposing (navigate)
import Page exposing (Page)
import Route exposing (Route)
import Route.Path as Path
import Shared
import View exposing (Slide(..), View)


page : Shared.Model -> Route () -> Page Model Msg
page shared route =
    Page.new
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


layout : Layout
layout =
    Layout.Navigation



-- INIT


type alias Model =
    {}


init : () -> ( Model, Effect Msg )
init () =
    ( {}
    , Effect.none
    )



-- UPDATE


type Msg
    = NavigatePrevious
    | NavigateNext
    | DoNothing


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        NavigatePrevious ->
            ( model, navigate Path.Architecture )

        NavigateNext ->
            ( model, navigate Path.Packages )

        DoNothing ->
            ( model, Effect.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    KeyListener.subscription NavigatePrevious NavigateNext DoNothing



-- VIEW


view : Model -> View Msg
view model =
    { title = "ELM"
    , body =
        Slide
            { header = text "Resources"
            , body = viewLinks
            }
    , info = Nothing
    , previous = Just NavigatePrevious
    , next = Just NavigateNext
    }


viewLinks : Element msg
viewLinks =
    column [ width fill, height fill, spacing 50 ]
        [ row [ width fill, spaceEvenly ]
            [ newTabLink []
                { url = "https://elm-lang.org/"
                , label =
                    column [ width fill, spacing 5 ]
                        [ Logo.static []
                        , el [ centerX ] <| text "Elm Lang"
                        ]
                }
            , imageLink
                { url = "https://elm-lang.org/community"
                , images =
                    [ { imageUrl = "slack-logo.svg"
                      , imageDescription = "slack logo"
                      }
                    , { imageUrl = "discord-logo.svg"
                      , imageDescription = "discord logo"
                      }
                    ]
                , description = "Community"
                }
            , imageLink
                { url = "https://elm-radio.com/"
                , images =
                    [ { imageUrl = "/elm-radio-logo.svg"
                      , imageDescription = "elm-radio logo"
                      }
                    ]
                , description = "Podcast: elm-radio"
                }
            ]
        , row [ width fill, spaceEvenly ]
            [ imageLink
                { url = "https://elmprogramming.com/"
                , images =
                    [ { imageUrl = "elmprogramming-logo.png"
                      , imageDescription = "elmprogramming logo"
                      }
                    ]
                , description = "Tutorial: elmprogramming.com"
                }
            , imageLink
                { url = "https://orasund.gitbook.io/elm-cookbook/"
                , images =
                    [ { imageUrl = "/elm-cookbook-logo.png"
                      , imageDescription = "elm-cookbook logo"
                      }
                    ]
                , description = "elm-cookbook"
                }
            , imageLink
                { url = "https://elmcraft.org/"
                , images =
                    [ { imageUrl = "/elmcraft-logo.png"
                      , imageDescription = "elmcraft logo"
                      }
                    ]
                , description = "Things built with elm"
                }
            , imageLink
                { url = "https://exercism.org/tracks/elm"
                , images =
                    [ { imageUrl = "/exercism-logo.svg"
                      , imageDescription = "exercism logo"
                      }
                    ]
                , description = "Exercism"
                }
            ]
        ]
