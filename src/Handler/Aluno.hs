{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Aluno where

import Import
import Text.Lucius
import Text.Julius
import Database.Persist.Postgresql

-- renderDivs
formAluno :: Form Aluno 
formAluno = renderBootstrap $ Aluno 
    <$> areq integerField   "Serie: " Nothing
    <*> areq integerField   "Numero: " Nothing
    <*> areq textField      "Nome: " Nothing 
    <*> areq textField      "RA: "   Nothing 
    <*> areq integerField   "Digito: " Nothing
    <*> areq dateField      "Nascimento: " Nothing 
    <*> areq textField      "Classe: "  Nothing
 
getAlunoR :: Handler Html 
getAlunoR = do 
    (widget, enctype) <- generateFormPost formAluno 
    msg <- getMessage
    defaultLayout $ do 
        addStylesheet (StaticR css_bootstrap_css)
        [whamlet|
            $maybe mensa <- msg
                <div>
                    ^{mensa}
            
            <h1>
                CADASTRO DE ALUNO
            
            <form method=post action=@{AlunoR}>
                ^{widget}
                <button>
                    Cadastrar
        |]

postAlunoR :: Handler Html 
postAlunoR = do 
    ((result,_),_) <- runFormPost formAluno 
    case result of 
        FormSuccess aluno -> do 
            runDB $ insert aluno 
            setMessage [shamlet|
                <h2>
                    REGISTRO INCLUIDO
            |]
            redirect AlunoR
        _ -> redirect HomeR

getListAlunoR :: Handler Html 
getListAlunoR = do 
    -- select * from aluno order by aluno.nome
    alunos <- runDB $ selectList [] [Asc AlunoNome]
    defaultLayout $ do 
        $(whamletFile "templates/alunos.hamlet")

postApagarAlunoR :: AlunoId -> Handler Html 
postApagarAlunoR aid = do 
    _ <- runDB $ get404 aid
    runDB $ delete aid 
    redirect ListAlunoR