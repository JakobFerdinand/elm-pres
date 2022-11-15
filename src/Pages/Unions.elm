module Pages.Unions exposing (Model, Msg, layout, page)

import Component exposing (code)
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
    = DescribeUnionTypes
    | NoNull
    | MaybeExample


init : () -> ( Model, Effect Msg )
init () =
    ( DescribeUnionTypes
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
        ( NavigatePrevious, DescribeUnionTypes ) ->
            ( model, navigate Path.Records )

        ( NavigatePrevious, NoNull ) ->
            ( DescribeUnionTypes, Effect.none )

        ( NavigatePrevious, MaybeExample ) ->
            ( NoNull, Effect.none )

        ( NavigateNext, DescribeUnionTypes ) ->
            ( NoNull, Effect.none )

        ( NavigateNext, NoNull ) ->
            ( MaybeExample, Effect.none )

        ( NavigateNext, MaybeExample ) ->
            ( model, navigate Path.Architecture )

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
            { header =
                text <|
                    case model of
                        DescribeUnionTypes ->
                            "Union Types"

                        NoNull ->
                            "Union Types: Null"

                        MaybeExample ->
                            "Union Types: Maybe"
            , body =
                case model of
                    DescribeUnionTypes ->
                        viewUnionTypes

                    NoNull ->
                        viewBillionDollarMistake

                    MaybeExample ->
                        viewMaybe
            }
    , previous = Just NavigatePrevious
    , next = Just NavigateNext
    }


viewUnionTypes : Element msg
viewUnionTypes =
    column [ spacing 20 ]
        [ text "Definded collection of possible states."
        , code [] "type Msg\n    = WindowResized Int Int\n    | TextEntered String\n    | SubmitButtonClicked"
        ]


viewBillionDollarMistake : Element msg
viewBillionDollarMistake =
    column [ spacing 30 ]
        [ paragraph []
            [ text "Elm has no concept of "
            , code [ Font.size 28 ] "null"
            , text " !"
            ]
        , paragraph []
            [ text "Instead there is "
            , code [ Font.size 28 ] "Maybe"
            , text " and "
            , code [ Font.size 28 ] "Result"
            ]
        , code [ Font.size 28 ] "type Maybe a \n    = Just a\n    | Nothing"
        , code [ Font.size 28 ] "type Result error value\n    = Ok value\n    | Err error"
        ]


viewMaybe : Element msg
viewMaybe =
    code [] "type Age\n    = Age Int\n\n\ntoValidAge : Int -> Maybe Age\ntoValidAge input =\n    if input >= 18 then\n        Just (Age input)\n\n    else\n        Nothing\n\n\nparseAge : String -> Maybe Age\nparseAge input =\n    input\n        |> String.toInt\n        |> Maybe.andThen toValidAge"
