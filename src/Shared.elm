module Shared exposing
    ( Flags, decoder
    , Model, Msg
    , init, update, subscriptions
    )

{-|

@docs Flags, decoder
@docs Model, Msg
@docs init, update, subscriptions

-}

import Browser
import Browser.Events
import Effect exposing (Effect)
import Json.Decode
import Route exposing (Route)
import Route.Path



-- FLAGS


type alias Flags =
    {}


decoder : Json.Decode.Decoder Flags
decoder =
    Json.Decode.succeed {}



-- INIT


type alias Model =
    {}


init : Result Json.Decode.Error Flags -> Route () -> ( Model, Effect Msg )
init flagsResult route =
    ( {}
    , Effect.none
    )



-- UPDATE


type Key
    = Character Char
    | Control String


type Msg
    = KeyPressed Key


update : Route () -> Msg -> Model -> ( Model, Effect Msg )
update route msg model =
    case msg of
        KeyPressed key ->
            ( Debug.log (Debug.toString key) model
            , Effect.none
            )



-- SUBSCRIPTIONS


subscriptions : Route () -> Model -> Sub Msg
subscriptions route model =
    Browser.Events.onKeyDown keyDecoder


keyDecoder : Json.Decode.Decoder Msg
keyDecoder =
    Json.Decode.map toKey (Json.Decode.field "key" Json.Decode.string)


toKey : String -> Msg
toKey string =
    KeyPressed <|
        case String.uncons string of
            Just ( char, "" ) ->
                Character char

            _ ->
                Control string
