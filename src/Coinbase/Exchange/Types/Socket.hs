{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE OverloadedStrings          #-}

module Coinbase.Exchange.Types.Socket where

import           Data.Aeson.Types
import           Data.Text                    (Text)
import           Data.Time
import           Data.Word
import           GHC.Generics

import           Coinbase.Exchange.Types.Core

newtype Sequence = Sequence { unSequence :: Word64 }
    deriving (Eq, Ord, Num, Show, Read, Generic, FromJSON, ToJSON)

data ExchangeMessage
    = Subscribe
        { msgProductId :: ProductId
        }
    | Received
        { msgTime      :: UTCTime
        , msgProductId :: ProductId
        , msgSequence  :: Sequence
        , msgOrderId   :: OrderId
        , msgSize      :: Size
        , msgPrice     :: Price
        , msgSide      :: Side
        , msgClientOid :: Maybe ClientOrderId
        }
    | Open
        { msgTime          :: UTCTime
        , msgProductId     :: ProductId
        , msgSequence      :: Sequence
        , msgOrderId       :: OrderId
        , msgPrice         :: Price
        , msgRemainingSize :: Size
        , msgSide          :: Side
        }
    | Done
        { msgTime      :: UTCTime
        , msgProductId :: ProductId
        , msgSequence  :: Sequence
        , msgPrice     :: Price
        , msgOrderId   :: OrderId
        , msgReason    :: Reason
        , msgSide      :: Side
        }
    | Match
        { msgTradeId      :: TradeId
        , msgSequence     :: Sequence
        , msgMakerOrderId :: OrderId
        , msgTakerOrderId :: OrderId
        , msgTime         :: UTCTime
        , msgProductId    :: ProductId
        , msgSize         :: Size
        , msgPrice        :: Price
        , msgSide         :: Side
        }
    | Change
        { msgTime      :: UTCTime
        , msgSequence  :: Sequence
        , msgOrderId   :: OrderId
        , msgProductId :: ProductId
        , msgNewSize   :: Size
        , msgOldSize   :: Size
        , msgPrice     :: Price
        , msgSide      :: Side
        }
    | Error
        { msgMessage :: Text
        }
    deriving (Eq, Show, Read, Generic)

instance ToJSON ExchangeMessage where
    toJSON = genericToJSON coinbaseAesonOptions

instance FromJSON ExchangeMessage where
    parseJSON = genericParseJSON coinbaseAesonOptions
