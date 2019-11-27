{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Home where

import Import
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql
import Text.Lucius
import Text.Julius

getHomeR :: Handler Html
getHomeR = do
    defaultLayout $ do 
--        addStylesheet (StaticR css_bootstrap_css)
        $(whamletFile "templates/homepage.hamlet")
--        toWidgetHead $(luciusFile "templates/homepage.lucius")
--        toWidgetHead $(juliusFile "templates/homepage.julius")

