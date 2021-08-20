module Yuki (login) where

import Data.Text
import qualified Data.Text.IO as TextIO

import Discord
import Discord.Types
-- import qualified Discord.Requests as R

login :: Text -> IO ()
login token = do
  t <- runDiscord $ def { discordToken = token
                        , discordOnStart = startHandler
                        , discordOnLog = \_ -> TextIO.putStrLn "Connected to Discord!"
                        }
  TextIO.putStrLn t

startHandler :: DiscordHandler ()
startHandler = do
  let activity = Activity { activityName = "Hi there!"
                          , activityType = ActivityTypeListening
                          , activityUrl = Nothing
                          }

  let opts = UpdateStatusOpts { updateStatusOptsSince = Nothing
                              , updateStatusOptsGame = Just activity
                              , updateStatusOptsNewStatus = UpdateStatusOnline
                              , updateStatusOptsAFK = False
                              }
  sendCommand (UpdateStatus opts)
