module Yuki.Reply where

import Data.Text

import Discord
import Discord.Types
import qualified Discord.Requests as R

import Control.Monad (void)

reply :: Message -> Text -> DiscordHandler ()
reply message content = do
  let opts :: R.MessageDetailedOpts
      opts = def 
          { R.messageDetailedContent = content
          , R.messageDetailedTTS = False
          , R.messageDetailedAllowedMentions = Just $
              def { R.mentionEveryone = False
                  , R.mentionRepliedUser = False
                  }
          , R.messageDetailedReference = Just $
              def { referenceMessageId = Just $ messageId message }
          }
  void $ restCall (R.CreateMessageDetailed (messageChannel message) opts)
