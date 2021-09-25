module Yuki (login) where

import Control.Monad (when, void)
import qualified Data.Text as T
import qualified Data.Text.IO as TextIO

import Discord
import Discord.Types
import qualified Discord.Requests as R

import Yuki.Commands (ping, weather, verifyCommand, Commands(..))

login :: T.Text -> IO ()
login token = do
  t <- runDiscord $ def { discordToken = token
                        , discordOnEvent = eventHandler
                        , discordOnStart = startHandler
                        , discordOnLog = \_ -> TextIO.putStrLn "Connected to Discord!"
                        }
  TextIO.putStrLn t

startHandler :: DiscordHandler ()
startHandler = do
  let activity = Activity { activityName = "$"
                          , activityType = ActivityTypeListening
                          , activityUrl = Nothing
                          }

  let opts = UpdateStatusOpts { updateStatusOptsSince = Nothing
                              , updateStatusOptsGame = Just activity
                              , updateStatusOptsNewStatus = UpdateStatusOnline
                              , updateStatusOptsAFK = False
                              }
  sendCommand (UpdateStatus opts)

eventHandler :: Event -> DiscordHandler ()
eventHandler event = case event of
  MessageCreate m -> when (not (fromBot m) && forBot m) $ do
    case verifyCommand (T.tail (messageText m)) of
      Just Ping -> ping m
      Just Weather -> weather m
      Nothing -> return ()
  _ -> return ()

forBot :: Message -> Bool
forBot = ("$" `T.isPrefixOf`) . T.toLower . messageText

fromBot :: Message -> Bool
fromBot m = userIsBot (messageAuthor m)
