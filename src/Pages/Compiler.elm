module Pages.Compiler exposing (Model, Msg, layout, page)

import Component exposing (codeBlock)
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


type Model
    = Sample1
    | Sample2


init : () -> ( Model, Effect Msg )
init () =
    ( Sample1
    , Effect.none
    )



-- UPDATE


type Msg
    = NavigatePrevious
    | NavigateNext
    | DoNothing


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case ( msg, model ) of
        ( NavigatePrevious, Sample1 ) ->
            ( model, navigate (Path.Language__Direction_ { direction = "backward" }) )

        ( NavigatePrevious, Sample2 ) ->
            ( Sample1, Effect.none )

        ( NavigateNext, Sample1 ) ->
            ( Sample2, Effect.none )

        ( NavigateNext, Sample2 ) ->
            ( model, navigate Path.NoRuntimeExceptions )

        ( DoNothing, _ ) ->
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
        Slide
            { header = text "Elm Compiler"
            , body =
                column [ height fill, width fill ]
                    [ case model of
                        Sample1 ->
                            viewSample1

                        Sample2 ->
                            viewSample2
                    ]
            }
    , previous = Just NavigatePrevious
    , next = Just NavigateNext
    }


viewSample1 : Element msg
viewSample1 =
    row [ spacing 20 ]
        [ codeBlock [ Font.size 28, centerY ]
            "\nviewUsersName users =\n    users\n        |> List.nap viewUser\n\n\nviewUser user =\n    row\n        [ spacing 5 ]\n        [ viewSmallUserIcon user\n        , text user.name\n        ]\n"
        , image [ width fill ]
            { src = "/list-map-error.png"
            , description = ""
            }
        ]


viewSample2 : Element msg
viewSample2 =
    row [ spacing 20 ]
        [ codeBlock [ Font.size 28, centerY ]
            "gertraud =\n    { firstName = \"Gertraud\"\n    , lastName = \"Steiner\"\n    , age = 58\n    }\n\n\nisOver18years person =\n    person.aeg >= 18\n\n\ncheckAge =\n    isOver18years gertraud"
        , image [ width fill ]
            { src = "/missing-field-error.png"
            , description = ""
            }
        ]
