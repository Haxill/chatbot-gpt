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

:greetings
rem Affichage de la phrase de bienvenue, choisit par l'IA
chcp 65001 > nul
set reponse=

rem Définition et initialisation des variables de la requête vers ChatGPT
set max_tokens=1024
set n=1
set temperature=0.8
set url=https://api.openai.com/v1/completions
set model=text-davinci-003
set header01=Content-Type:application/json
set header02=Authorization:Bearer

for /f "tokens=2 delims={}" %%a in ('curl.exe -s -X POST -H "%header01%" -H "%header02% %openai_api_key%" -d "{\"model\": \"%model%\", \"prompt\": \"Tu es un robot très évolué, dis moi bonjour comme un robot du futur :\",  \"temperature\": %temperature%,  \"max_tokens\": %max_tokens%,  \"n\": %n%}" %url% ^| findstr "text"') do (
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
echo   IA: %reponse%
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


:chat_loop
rem Encodage en UTF-8
chcp 65001 > nul
rem Vidage des variables
set user_input=
set reponse=

set /p user_input="Vous: "

rem Si l'input est vide alors pas d'envoi de la demande
If "%user_input%"=="" set user_input=%user_input:~0,1% & goto chat_loop
rem Quitter le script
echo %user_input%|findstr /i /l "bye quit exit ciao" > nul
If %ERRORLEVEL% EQU 0 goto end

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
set "user_input=%user_input:ç=c%"
set "user_input=%user_input:Ç=c%"
set "user_input=%user_input:"='%"
set "user_input=%user_input:(=%"
set "user_input=%user_input:)=%"
chcp 65001 > nul

rem Définition et initialisation des variables de la requête vers ChatGPT
set prompt=%user_input%
set max_tokens=1024
set n=1
set temperature=0.8
set url=https://api.openai.com/v1/completions
set model=text-davinci-003
set header01=Content-Type:application/json
set header02=Authorization:Bearer

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

:end
rem Affichage de la phrase d'aurevoir, choisit par l'IA
chcp 65001 > nul
set reponse=

rem Définition et initialisation des variables de la requête vers ChatGPT
set max_tokens=1024
set n=1
set temperature=0.8
set url=https://api.openai.com/v1/completions
set model=text-davinci-003
set header01=Content-Type:application/json
set header02=Authorization:Bearer

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
echo   IA: %reponse%
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

Exit
