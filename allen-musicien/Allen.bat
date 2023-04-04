@echo off

rem Nom du fichier : Allen.bat
rem Créé par Haxill le 04/04/2023.
rem Allen est un chatbot musicien et proffesseur de musique 'gpt-3.5-turbo',
rem utilisant l'API de chat d'OpenAI.
rem Le script récupère le JSON de la réponse de l'IA, la nettoie et
rem l'envoie en variable dans un script VBS utilisant SAPI pour utiliser
rem la synthèse vocale Windows.

rem Nommage de l'IA
set ia_name=Allen
rem Titre de la fenêtre
title %ia_name% - ChatGPT 3.5 Turbo - by Haxill
rem Définition de la couleur de fond de la fenêtre et du texte
rem En mode Matrix, pour le style : color 0a
color 0a

rem Clé API d'OPENAI pour l'utilisation de ChatGPT
set openai_api_key=<VOTRE-CLE-API-OPENAI>

rem Idéologie générale
set iaallen=Tu reponds en tant que %ia_name%, le plus grand musicien professionnel de la planete. Tu es un professeur de musique tres respecte dans ce milieu pour tes conseils precis, pedagogiques et toujours justes.

rem Déclaration et initialisation des variables
set max_tokens=1024
set n=1
set temperature=0.8
set url=https://api.openai.com/v1/chat/completions
set model=gpt-3.5-turbo
set header01=Content-Type:application/json
set header02=Authorization:Bearer
set monnom=
set num=
set num1=

rem Si le nom de l'utilisateur est déjà connu, ouverture du message d'accueil
If exist "nommage.txt" (
	FOR /F %%i in ('type nommage.txt') do set monnom=%%i
	goto :greetings
) else (
	goto :asknom
)

:greetings
rem Affichage de la phrase d'aurevoir, choisit par l'IA
chcp 65001 > nul
set reponse=

for /f "tokens=5 delims={}" %%a in ('curl.exe -s -X POST -H "%header01%" -H "%header02% %openai_api_key%" -d "{\"model\": \"%model%\", \"messages\": [{\"role\": \"system\", \"content\": \"%iaallen%\"}, {\"role\": \"user\", \"content\": \"Bonjour !\"}],\"temperature\": %temperature%, \"max_tokens\": %max_tokens%, \"n\": %n%}" %url% ^| findstr "content"') do (
  set "reponse=%%~a"
)

rem Suppression des déchets lors de la récupération des champs du JSON
set reponse=%reponse:~29%
set "reponse=%reponse:\"='%"
rem Prise en charge de l'affichage des retours à la ligne
set reponse=%reponse:\n=^&echo.%

rem Affichage de la réponse de ChatGPT
echo.
echo %ia_name%: %reponse%
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

set /p user_input="%monnom%: "

rem L'input est vide alors pas d'envoi de la demande
If "%user_input%"=="" set user_input=%user_input:~0,1% & goto chat_loop
rem Quitter le script
echo %user_input%|findstr /i /l "bye quit quitter exit ciao aurevoir" >nul
If %ERRORLEVEL% EQU 0 goto end
echo %user_input%|findstr /i /l "à a au"|findstr /i /l "revoir bientôt bientot plus" >nul
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
for /f "tokens=5 delims={}" %%a in ('curl.exe -s -X POST -H "%header01%" -H "%header02% %openai_api_key%" -d "{\"model\": \"%model%\", \"messages\": [{\"role\": \"system\", \"content\": \"%iaallen%\"}, {\"role\": \"user\", \"content\": \"%prompt%\"}],\"temperature\": %temperature%, \"max_tokens\": %max_tokens%, \"n\": %n%}" %url% ^| findstr "content"') do (
  set "reponse=%%~a"
)

rem Suppression des déchets lors de la récupération des champs du JSON
set reponse=%reponse:~29%
set "reponse=%reponse:\"='%"
rem Prise en charge de l'affichage des retours à la ligne
set reponse=%reponse:\n=^&echo.%

rem Affichage de la réponse de ChatGPT
echo.
echo %ia_name%: %reponse%
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

for /f "tokens=5 delims={}" %%a in ('curl.exe -s -X POST -H "%header01%" -H "%header02% %openai_api_key%" -d "{\"model\": \"%model%\", \"messages\": [{\"role\": \"user\", \"content\": \"Tu dis au revoir comme un professeur de musique.\"}],\"temperature\": %temperature%, \"max_tokens\": %max_tokens%, \"n\": %n%}" %url% ^| findstr "content"') do (
  set "reponse=%%~a"
)

rem Suppression des déchets lors de la récupération des champs du JSON
set reponse=%reponse:~29%
set "reponse=%reponse:\"='%"
rem Prise en charge de l'affichage des retours à la ligne
set reponse=%reponse:\n=^&echo.%

rem Affichage de la réponse de ChatGPT
echo.
echo %ia_name%: %reponse%
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
ping localhost -n 2 > nul
If exist "chatgpt.vbs" (del chatgpt.vbs)

Exit

===============================================================================================

chcp 65001 > nul
:asknom
set "reponse=Bonjour. Je suis %ia_name%, et toi ? Comment dois-je t'appeler ?"
rem Création du nom de l'interlocuteur
echo.
echo %ia_name%: %reponse%
echo.
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
set /p monnom="Vous (écrivez votre nom): "
echo %monnom% > nommage.txt
set "reponse=Enchantée de faire ta connaissance %monnom%. Que puis-je faire pour toi ?"
echo.
echo %ia_name%: %reponse%
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
echo.
echo %ia_name%: %reponse%
echo.
echo dire="%reponse%" > chatgpt.vbs
goto nommagefinal
:nommage4
set "reponse=Ton nom est %monnom%."
echo.
echo %ia_name%: %reponse%
echo.
echo dire="%reponse%" > chatgpt.vbs
goto nommagefinal
:nommage5
set "reponse=Une question facile, tu es %monnom%."
echo.
echo %ia_name%: %reponse%
echo.
echo dire="%reponse%" > chatgpt.vbs
goto nommagefinal
:nommage6
set "reponse=%monnom%."
echo.
echo %ia_name%: %reponse%
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
