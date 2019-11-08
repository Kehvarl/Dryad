module Main exposing (..)

import Browser
import Html exposing (..)



--MAIN


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


init : () -> ( Model, Cmd Msg )
init () =
    ( { value = "" }, Cmd.none )



--UPDATE


type alias Model =
    { value : String }


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update _ _ =
    ( { value = "" }, Cmd.none )



--VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "", body = [ text model.value ] }
