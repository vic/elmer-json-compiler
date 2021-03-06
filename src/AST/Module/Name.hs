{-# LANGUAGE DeriveGeneric, DeriveAnyClass #-}

module AST.Module.Name where

import Data.Binary
import qualified Data.List as List

import qualified Elm.Package as Package

import GHC.Generics (Generic)
import qualified Data.Aeson as Json


type Raw = [String] -- must be non-empty


data Canonical = Canonical
    { _package :: Package.Name
    , _module :: Raw
    }
    deriving (Eq, Ord, Show, Generic, Json.ToJSON)


inCore :: Raw -> Canonical
inCore raw =
  Canonical Package.core raw


inHtml :: Raw -> Canonical
inHtml raw =
  Canonical Package.html raw


toString :: Raw -> String
toString rawName =
  List.intercalate "." rawName


canonicalToString :: Canonical -> String
canonicalToString (Canonical _ rawName) =
  toString rawName


isNative :: Raw -> Bool
isNative name =
  case name of
    "Native" : _ ->
        True

    _ ->
        False


instance Binary Canonical where
    put (Canonical home name) =
        put home >> put name

    get =
        Canonical <$> get <*> get
