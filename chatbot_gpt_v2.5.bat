@echo off
setlocal enabledelayedexpansion
rem Nom du fichier : chatbot_gpt_v2.5.bat
rem Créé par Haxill le 20/02/2023

rem Titre de la fenêtre
title IA - ChatGPT 3 - by Haxill
rem Définition de la couleur de fond de la fenêtre et du texte
rem En mode Matrix, pour le style : color 0a
color 0a

rem Clé API d'OPENAI pour l'utilisation de ChatGPT
set openai_api_key=VOTRE-CLE-API

rem Déclaration et initialisation des variables de la requête vers ChatGPT
set max_tokens=1024
set n=1
set temperature=0.8
set url=https://api.openai.com/v1/chat/completions
set model=gpt-3.5-turbo
set header01=Content-Type:application/json
set header02=Authorization:Bearer
set monnom=

rem Si le nom de l'utilisateur est déjà connu, ouverture du message d'accueil
If exist "nommage.txt" (
	FOR /F %%i in ('type nommage.txt') do set monnom=%%i
	goto :greetings
) else (
  rem Sinon, demande le nom de l'utilisateur et passe dans loop de chat
	goto :asknom
)

===============================================================================================

:greetings
rem Affichage de la phrase d'aurevoir, choisit par l'IA
chcp 65001 > nul
set reponse=

for /f "tokens=2 delims={}" %%a in ('curl.exe -s -X POST -H "%header01%" -H "%header02% %openai_api_key%" -d "{\"model\": \"%model%\", \"prompt\": \"Tu es un robot très évolué, dis moi bonjour comme un robot du futur :\",  \"temperature\": %temperature%,  \"max_tokens\": %max_tokens%,  \"n\": %n%}" %url% ^| findstr "text"') do (
  set "reponse=%%~a"
)

rem Suppression des déchets lors de la récupération des champs du JSON
set "reponse=%reponse:text":"=%"
set "reponse=%reponse:0,"logprobs":null,"finish_reason":"stop=%"
set "reponse=%reponse:0,"logprobsnull,"finish_reasonnull=%"
set "reponse=%reponse:\n=%"
set "reponse=%reponse:\"='%"
set "reponse=%reponse:","index=%"
set "reponse=%reponse:.=. %"
set "reponse=%reponse:":=%"

rem Affichage de la réponse de ChatGPT
echo   IA:
echo.
echo %reponse%
echo.
rem Bascule de l'encodage en ANSI
chcp 1252 > nul
If exist "chatgpt.vbs" (del chatgpt.vbs)
rem Création du VBS
echo dire="%reponse%" > chatgpt.vbs
echo Dim msg, sapi >> chatgpt.vbs
echo msg=dire >> chatgpt.vbs
echo Set sapi=CreateObject("sapi.spvoice") >> chatgpt.vbs
echo sapi.Speak msg >> chatgpt.vbs
rem Lecture du VBS
start "" chatgpt.vbs
ping localhost -n 2 > nul
If exist "chatgpt.vbs" (del chatgpt.vbs)
goto chat_loop

===============================================================================================

:chat_loop
rem Encodage en UTF-8
chcp 65001 > nul
rem Vidage des variables
set user_input=
set reponse=

set /p user_input="Vous: "

rem L'input est vide alors pas d'envoi de la demande
If "%user_input%"=="" set user_input=%user_input:~0,1% & goto chat_loop
rem Quitter le script
echo %user_input%|findstr /i /l "bye quit quitter exit ciao aurevoir" >nul
If %ERRORLEVEL% EQU 0 goto end
echo %user_input%|findstr /i /l "à a au"|findstr /i /l "revoir bientôt bientot" >nul
If %ERRORLEVEL% EQU 0 goto end

rem Réponse à la demande de son nom
echo %user_input%|findstr /i /l "quel comment"|findstr /i /l "appelle mon nom">nul
If %ERRORLEVEL% EQU 0 goto nommage2
echo %user_input%|findstr /i /l "qui"|findstr /i /l "je suis">nul
If %ERRORLEVEL% EQU 0 goto nommage2


rem Gestion des accents
chcp 1252 > nul
set "user_input=%user_input:à=a%"
set "user_input=%user_input:â=a%"
set "user_input=%user_input:À=A%"
set "user_input=%user_input:é=e%"
set "user_input=%user_input:è=e%"
set "user_input=%user_input:ê=e%"
set "user_input=%user_input:ë=e%"
set "user_input=%user_input:É=E%"
set "user_input=%user_input:î=i%"
set "user_input=%user_input:ï=i%"
set "user_input=%user_input:ô=o%"
set "user_input=%user_input:ô=o%"
set "user_input=%user_input:ù=u%"
set "user_input=%user_input:û=u%"
set "user_input=%user_input:ü=u%"
set "user_input=%user_input:œ=oe%"
set "user_input=%user_input:ç=c%"
set "user_input=%user_input:Ç=C%"
set "user_input=%user_input:"='%"
set "user_input=%user_input:(=%"
set "user_input=%user_input:)=%"
chcp 65001 > nul

set prompt=%user_input%

rem Envoie de la requête
for /f "tokens=2 delims={}" %%a in ('curl.exe -s -X POST -H "%header01%" -H "%header02% %openai_api_key%" -d "{\"model\": \"%model%\", \"prompt\": \"%prompt%\",  \"temperature\": %temperature%,  \"max_tokens\": %max_tokens%,  \"n\": %n%}" %url% ^| findstr "text"') do (
  set "reponse=%%~a"
)

rem Suppression des déchets lors de la récupération des champs du JSON
set "reponse=%reponse:text":"=%"
set "reponse=%reponse:0,"logprobs":null,"finish_reason":"stop=%"
set "reponse=%reponse:\"='%"
set "reponse=%reponse:","index=%"
set "reponse=%reponse:.=. %"
set "reponse=%reponse:":=%"
rem Prise en charge de l'affichage des retours à la ligne
set reponse=%reponse:\n=^&echo.%

rem Affichage de la réponse de ChatGPT
echo   IA: %reponse%
echo.

rem Suppression des retours à la ligne avant envoie pour Sapi
set "reponse=%reponse:&echo=%"

rem Bascule de l'encodage en ANSI
chcp 1252 > nul
If exist "chatgpt.vbs" (del chatgpt.vbs)
rem Création du VBS
echo dire="%reponse%" > chatgpt.vbs
echo Dim msg, sapi >> chatgpt.vbs
echo msg=dire >> chatgpt.vbs
echo Set sapi=CreateObject("sapi.spvoice") >> chatgpt.vbs
echo sapi.Speak msg >> chatgpt.vbs
rem Lecture du VBS
start "" chatgpt.vbs
goto chat_loop

===============================================================================================

:end
rem Affichage de la phrase d'aurevoir, choisit par l'IA
chcp 65001 > nul
set reponse=

for /f "tokens=2 delims={}" %%a in ('curl.exe -s -X POST -H "%header01%" -H "%header02% %openai_api_key%" -d "{\"model\": \"%model%\", \"prompt\": \"Tu es un robot très évolué, dis moi aurevoir comme un robot du futur :\",  \"temperature\": %temperature%,  \"max_tokens\": %max_tokens%,  \"n\": %n%}" %url% ^| findstr "text"') do (
  set "reponse=%%~a"
)

rem Suppression des déchets lors de la récupération des champs du JSON
set "reponse=%reponse:text":"=%"
set "reponse=%reponse:0,"logprobs":null,"finish_reason":"stop=%"
set "reponse=%reponse:\n=%"
set "reponse=%reponse:\"='%"
set "reponse=%reponse:","index=%"
set "reponse=%reponse:.=. %"
set "reponse=%reponse:":=%"

rem Affichage de la réponse de ChatGPT
echo   IA:
echo.
echo %reponse%
echo.
rem Bascule de l'encodage en ANSI
chcp 65001 > nul
If exist "chatgpt.vbs" (del chatgpt.vbs)
rem Création du VBS
echo dire="%reponse%" > chatgpt.vbs
echo Dim msg, sapi >> chatgpt.vbs
echo msg=dire >> chatgpt.vbs
echo Set sapi=CreateObject("sapi.spvoice") >> chatgpt.vbs
echo sapi.Speak msg >> chatgpt.vbs
rem Lecture du VBS
start "" chatgpt.vbs
ping localhost -n 2 > nul
If exist "chatgpt.vbs" (del chatgpt.vbs)

Exit

===============================================================================================

chcp 65001 > nul
:asknom
set "reponse=Bonjour. Je suis ton IA et toi ? Comment dois-je t'appeler ?"
rem Création du nom de l'interlocuteur
echo   IA:
echo.
echo %reponse%
echo.
echo "" > nommage.txt
echo dire="%reponse%" > chatgpt.vbs
echo Dim msg, sapi >> chatgpt.vbs
echo msg=dire >> chatgpt.vbs
echo Set sapi=CreateObject("sapi.spvoice") >> chatgpt.vbs
echo sapi.Speak msg >> chatgpt.vbs
start "" chatgpt.vbs
ping localhost -n 2 >nul
del chatgpt.vbs >nul
goto :nommage1

:nommage1
chcp 28591 > nul
set monnom=
set /p monnom="Vous: "
echo %monnom% > nommage.txt
set "reponse=Enchantée de faire ta connaissance %monnom%."
echo   IA:
echo.
echo %reponse%
echo.
echo dire="%reponse%" > chatgpt.vbs
echo Dim msg, sapi >> chatgpt.vbs
echo msg=dire >> chatgpt.vbs
echo Set sapi=CreateObject("sapi.spvoice") >> chatgpt.vbs
echo sapi.Speak msg >> chatgpt.vbs
start "" chatgpt.vbs
ping localhost -n 2 >nul
del chatgpt.vbs >nul
goto :chat_loop

:nommage2
chcp 28591 > nul
rem Randomisation des réponses
set /a num=(%random%*4/32768)+1
rem Interdiction de faire la même réponse 2 fois de suite
If "%num%"=="%num1%" (
	goto :nommage2
)

If %num%==1 goto nommage3
If %num%==2 goto nommage4
If %num%==3 goto nommage5
If %num%==4 goto nommage6

:nommage3
set "reponse=Tu t'appelles %monnom%."
echo   IA:
echo.
echo %reponse%
echo.
echo dire="%reponse%" > chatgpt.vbs
goto nommagefinal
:nommage4
set "reponse=Ton nom est %monnom%."
echo   IA:
echo.
echo %reponse%
echo.
echo dire="%reponse%" > chatgpt.vbs
goto nommagefinal
:nommage5
set "reponse=Une question facile, tu es %monnom%."
echo   IA:
echo.
echo %reponse%
echo.
echo dire="%reponse%" > chatgpt.vbs
goto nommagefinal
:nommage6
set "reponse=%monnom%."
echo   IA:
echo.
echo %reponse%
echo.
echo dire="%reponse%" > chatgpt.vbs
goto nommagefinal

:nommagefinal
echo Dim msg, sapi >> chatgpt.vbs
echo msg=dire >> chatgpt.vbs
echo Set sapi=CreateObject("sapi.spvoice") >> chatgpt.vbs
echo sapi.Speak msg >> chatgpt.vbs
start "" chatgpt.vbs
ping localhost -n 2 >nul
del chatgpt.vbs >nul
set /a num1=%num%
goto chat_loop

==============================================================================================
