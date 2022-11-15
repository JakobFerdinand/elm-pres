module Pages.Records exposing (Model, Msg, layout, page)

import Component exposing (code, subHeading)
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
    = Record
    | ExtensibleRecord


init : () -> ( Model, Effect Msg )
init () =
    ( Record
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
        ( NavigatePrevious, Record ) ->
            ( model, navigate Path.NoRuntimeExceptions )

        ( NavigatePrevious, ExtensibleRecord ) ->
            ( Record, Effect.none )

        ( NavigateNext, Record ) ->
            ( ExtensibleRecord, Effect.none )

        ( NavigateNext, ExtensibleRecord ) ->
            ( model, navigate Path.Unions )

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
            { header = text "Records"
            , body =
                case model of
                    Record ->
                        viewRecord

                    ExtensibleRecord ->
                        viewExtensibleRecord
            }
    , previous = Just NavigatePrevious
    , next = Just NavigateNext
    }


viewRecord : Element msg
viewRecord =
    column [ width fill, spacing 20, Font.size 24 ]
        [ subHeading <| text "Type alias"
        , row
            [ width fill, spacing 20, alignTop ]
            [ code [] "viewUserNames :\n    List\n        { firstName : String\n        , lastName : String\n        , age : Int\n        }\nviewUserNames users =\n    users\n        |> List.map viewUser\n"
            , code [] "type alias User =\n    { firstName : String\n    , lastName : String\n    , age : Int\n    }\n\n\nviewUserNames : List User\nviewUserNames users =\n    users\n        |> List.map viewUser\n"
            ]
        ]


viewExtensibleRecord : Element msg
viewExtensibleRecord =
    column [ width fill, spacing 20, Font.size 24 ]
        [ subHeading <| text "Extensible records"
        , code [] "isOver18Years : { a | age : Int } -> Bool\nisOver18Years thing =\n    thing.age > 18\n\n\ngertraud : Person\ngertraud =\n    { firstName = \"Gertraud\"\n    , lastName = \"Steiner\"\n    , age = 58\n    }\n\n\ntableSaw : Tool\ntableSaw =\n    { power = 3.2\n    , manufacturer = \"Record Power\"\n    , age = 33\n    }\n\n\nbothOldEnough =\n    isOver18Years gertraud && isOver18Years tableSaw\n    "
        ]
