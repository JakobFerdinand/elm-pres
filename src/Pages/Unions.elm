module Pages.Unions exposing (Model, Msg, layout, page)

import Browser.Navigation as Nav
import Effect exposing (Effect)
import Element exposing (..)
import KeyListener
import Layout exposing (Layout)
import Page exposing (Page)
import Route exposing (Route)
import Route.Path as Path
import Shared
import View exposing (View)


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
    let
        navigate to =
            to
                |> Path.toString
                |> Nav.load
                |> Effect.fromCmd
    in
    case msg of
        NavigatePrevious ->
            ( model, navigate Path.Records )

        NavigateNext ->
            ( model, navigate Path.Architecture )

        DoNothing ->
            ( model, Effect.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    KeyListener.subscription NavigatePrevious NavigateNext DoNothing



-- VIEW


view : Model -> View Msg
view model =
    { title = "ELM"
    , body =
        column
            [ centerX
            , centerY
            , spacing 30
            ]
            [ text "Union Types"
            ]
    , previous = Just NavigatePrevious
    , next = Just NavigateNext
    }
