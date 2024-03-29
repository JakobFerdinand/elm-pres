module Pages.NoRuntimeExceptions exposing (Model, Msg, layout, page)

import Colors exposing (blue)
import Effect exposing (Effect)
import Element exposing (..)
import Element.Font as Font
import KeyListener
import Layout exposing (Layout)
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
            ( model, navigate Path.Compiler )

        NavigateNext ->
            ( model, navigate Path.Records )

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
            { header = text "No runtime exceptions"
            , body =
                column
                    [ width shrink
                    , height fill
                    , spacing 20
                    ]
                    [ row
                        [ width fill
                        , height shrink
                        , spacing 20
                        ]
                        [ image [ width (fill |> maximum 800) ]
                            { src = "/production-runtime-exeptions-2015-2020.png"
                            , description = "Diagram of runtime exceptions in JavaScript and Elm from 2015 to 2020 at company NoRedInk."
                            }
                        , column [ alignBottom, spacing 10 ]
                            [ text "Not zero\nbut negligible"
                            , text "2015-2020"
                            ]
                        ]
                    , newTabLink
                        [ centerX
                        , Font.color blue
                        ]
                        { url = "https://youtu.be/ukVqQGbxM9A?t=1031"
                        , label = text "Next-Generation Programming: Rust & Elm - Richard Feldman"
                        }
                    ]
            }
    , info = Nothing
    , previous = Just NavigatePrevious
    , next = Just NavigateNext
    }
