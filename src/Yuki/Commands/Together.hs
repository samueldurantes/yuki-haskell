module Yuki.Commands.Together (together) where

import RIO ((>>>))
import GHC.Generics (Generic)
import Control.Monad (void)
import Control.Monad.IO.Class (MonadIO(liftIO))
import System.Environment (getEnv)

import Configuration.Dotenv (loadFile, defaultConfig)

import Data.Aeson
import Data.Text (Text)
import Data.ByteString.UTF8 (fromString)

import Network.HTTP.Client
import Network.HTTP.Client.TLS

import Discord
import Discord.Types

import Yuki.Reply (reply)

data APIResponse = APIResponse
    { code :: Text
    } deriving (Generic, Show)

instance FromJSON APIResponse where

togetherRequest :: IO (Either String APIResponse)
togetherRequest = do
  void $ loadFile defaultConfig
  manager <- newManager tlsManagerSettings
  token <- getEnv "DISCORD_TOKEN"

  let requestBodyObject = object [ "max_age" .= (86400 :: Int)
                             , "max_uses"  .= (0 :: Int)
                             , "target_application_id"  .= ("880218394199220334" :: Text)
                             , "target_type"  .= (2 :: Int)
                             , "temporary"  .= (False :: Bool)
                             ]

  initialRequest <- parseRequest "https://discord.com/api/v8/channels/817519297366065224/invites"
  let request = initialRequest { method = "POST"
                               , requestHeaders =
                                   [ ("Authorization", "Bot " <> fromString token)
                                   , ("Content-Type", "application/json")
                                   ]
                               , requestBody = RequestBodyLBS $ encode requestBodyObject
                               }

  response <- httpLbs request manager
  (responseBody >>> eitherDecode) <$> httpLbs request manager

together :: Message -> DiscordHandler ()
together m = do
  response <- liftIO togetherRequest
  case response of
    Right res -> do
      let invite = "https://discord.com/invite/" <> code res
      reply m invite
    Left _-> reply m "⚠️ An unexpected error has occurred..." 
