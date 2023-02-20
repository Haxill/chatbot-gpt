@echo off
setlocal enabledelayedexpansion
rem Filename : chatbot_gpt_v2.5.bat

rem Window title
title IA - ChatGPT 3 - by Haxill
rem Definition of the window background color and text color
rem In Matrix mode, for fun: color 0a
color 0a

rem OPENAI API key for the use of ChatGPT
set openai_api_key=YOUR-API-OPENAI

:greetings
rem Display of the welcome message chosen by the AI
chcp 65001 > nul
set reponse=

rem Definition and initialization of the variables of the request to ChatGPT
set max_tokens=1024
set n=1
set temperature=0.8
set url=https://api.openai.com/v1/completions
set model=text-davinci-003
set header01=Content-Type:application/json
set header02=Authorization:Bearer

for /f "tokens=2 delims={}" %%a in ('curl.exe -s -X POST -H "%header01%" -H "%header02% %openai_api_key%" -d "{\"model\": \"%model%\", \"prompt\": \"You are a highly evolved robot, tell me hello like a robot from the future:\",  \"temperature\": %temperature%,  \"max_tokens\": %max_tokens%,  \"n\": %n%}" %url% ^| findstr "text"') do (
  set "reponse=%%~a"
)

rem Cleaning up the junk when retrieving fields from JSON
set "reponse=%reponse:text":"=%"
set "reponse=%reponse:0,"logprobs":null,"finish_reason":"stop=%"
set "reponse=%reponse:\n=%"
set "reponse=%reponse:\"='%"
set "reponse=%reponse:","index=%"
set "reponse=%reponse:.=. %"
set "reponse=%reponse:":=%"

rem Display of the ChatGPT response
echo   IA: %reponse%
echo.
rem Switching encoding to ANSI
chcp 1252 > nul
If exist "chatgpt.vbs" (del chatgpt.vbs)
rem Creation of the speaking VBS
echo dire="%reponse%" > chatgpt.vbs
echo Dim msg, sapi >> chatgpt.vbs
echo msg=dire >> chatgpt.vbs
echo Set sapi=CreateObject("sapi.spvoice") >> chatgpt.vbs
echo sapi.Speak msg >> chatgpt.vbs
rem Playing the VBS
start "" chatgpt.vbs
ping localhost -n 2 > nul
If exist "chatgpt.vbs" (del chatgpt.vbs)
goto chat_loop


:chat_loop
rem Encoding in UTF-8
chcp 65001 > nul
rem Emptying variables
set user_input=
set reponse=

set /p user_input="Vous: "

rem If the input is empty, then no request is sent
If "%user_input%"=="" set user_input=%user_input:~0,1% & goto chat_loop
rem Quit the chatbot
echo %user_input%|findstr /i /l "bye quit goodbye exit ciao aurevoir" > nul
If %ERRORLEVEL% EQU 0 goto end

rem Gestion des accents
chcp 1252 > nul
set "user_input=%user_input:à=a%"
set "user_input=%user_input:â=a%"
set "user_input=%user_input:é=e%"
set "user_input=%user_input:è=e%"
set "user_input=%user_input:ê=e%"
set "user_input=%user_input:ë=e%"
set "user_input=%user_input:î=i%"
set "user_input=%user_input:ï=i%"
set "user_input=%user_input:ô=o%"
set "user_input=%user_input:ô=o%"
set "user_input=%user_input:ù=u%"
set "user_input=%user_input:û=u%"
set "user_input=%user_input:ü=u%"
set "user_input=%user_input:ç=c%"
set "user_input=%user_input:Ç=c%"
chcp 65001 > nul

rem Definition and initialization of variables for the request to ChatGPT
set prompt=%user_input%
set max_tokens=1024
set n=1
set temperature=0.8
set url=https://api.openai.com/v1/completions
set model=text-davinci-003
set header01=Content-Type:application/json
set header02=Authorization:Bearer

rem Sending the request
for /f "tokens=2 delims={}" %%a in ('curl.exe -s -X POST -H "%header01%" -H "%header02% %openai_api_key%" -d "{\"model\": \"%model%\", \"prompt\": \"%prompt%\",  \"temperature\": %temperature%,  \"max_tokens\": %max_tokens%,  \"n\": %n%}" %url% ^| findstr "text"') do (
  set "reponse=%%~a"
)

rem Deleting waste during JSON field retrieval
set "reponse=%reponse:text":"=%"
set "reponse=%reponse:0,"logprobs":null,"finish_reason":"stop=%"
set "reponse=%reponse:\n=%"
set "reponse=%reponse:\"='%"
set "reponse=%reponse:","index=%"
set "reponse=%reponse:.=. %"
set "reponse=%reponse:":=%"

rem Displaying ChatGPT response
echo   IA: %reponse%
echo.
rem Switching to ANSI encoding
chcp 1252 > nul
If exist "chatgpt.vbs" (del chatgpt.vbs)
rem Creating VBS
echo dire="%reponse%" > chatgpt.vbs
echo Dim msg, sapi >> chatgpt.vbs
echo msg=dire >> chatgpt.vbs
echo Set sapi=CreateObject("sapi.spvoice") >> chatgpt.vbs
echo sapi.Speak msg >> chatgpt.vbs
rem Playing VBS
start "" chatgpt.vbs
goto chat_loop

:end
rem Displaying farewell sentence, chosen by the AI
chcp 65001 > nul
set reponse=

rem Definition and initialization of variables for the request to ChatGPT
set max_tokens=1024
set n=1
set temperature=0.8
set url=https://api.openai.com/v1/completions
set model=text-davinci-003
set header01=Content-Type:application/json
set header02=Authorization:Bearer

for /f "tokens=2 delims={}" %%a in ('curl.exe -s -X POST -H "%header01%" -H "%header02% %openai_api_key%" -d "{\"model\": \"%model%\", \"prompt\": \"You are a highly evolved robot, tell me goodbye like a robot from the future:\",  \"temperature\": %temperature%,  \"max_tokens\": %max_tokens%,  \"n\": %n%}" %url% ^| findstr "text"') do (
  set "reponse=%%~a"
)

rem Deleting waste during JSON field retrieval
set "reponse=%reponse:text":"=%"
set "reponse=%reponse:0,"logprobs":null,"finish_reason":"stop=%"
set "reponse=%reponse:\n=%"
set "reponse=%reponse:\"='%"
set "reponse=%reponse:","index=%"
set "reponse=%reponse:.=. %"
set "reponse=%reponse:":=%"

rem Displaying ChatGPT response
echo   IA: %reponse%
echo.
rem Switching to ANSI encoding
chcp 1252 > nul
If exist "chatgpt.vbs" (del chatgpt.vbs)
rem Creating VBS
echo dire="%reponse%" > chatgpt.vbs
echo Dim msg, sapi >> chatgpt.vbs
echo msg=dire >> chatgpt.vbs
echo Set sapi=CreateObject("sapi.spvoice") >> chatgpt.vbs
echo sapi.Speak msg >> chatgpt.vbs
rem Playing VBS
start "" chatgpt.vbs
ping localhost -n 2 > nul
If exist "chatgpt.vbs" (del chatgpt.vbs)

Exit
