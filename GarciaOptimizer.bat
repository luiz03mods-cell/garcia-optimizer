@echo off
title GARCIA OPTIMIZER - SERVER EDITION
color 0A
cls

set "URL_KEYS=https://raw.githubusercontent.com/luiz03mods-cell/garcia-optimizer/main/keys.json"
set "ARQUIVO_KEYS=%temp%\garcia_keys.json"
set "ARQUIVO_SESSION=%temp%\garcia_session.txt"
set "TENTATIVAS=0"
set "MAX_TENTATIVAS=3"

net session >nul 2>&1
if %errorlevel% neq 0 (
    cls
    echo ======================================================
    echo    ⚠️  EXECUTE COMO ADMINISTRADOR!
    echo ======================================================
    echo.
    echo   Clique com o botao direito no arquivo e escolha
    echo   "Executar como administrador".
    echo.
    echo ======================================================
    echo.
    pause
    exit /b
)

:BAIXAR_KEYS
cls
echo ======================================================
echo    🚀 GARCIA OPTIMIZER - SERVER EDITION
echo    "Autenticacao online via GitHub" 🔐
echo ======================================================
echo.
echo   Conectando ao servidor de autenticacao...
echo.

powershell -Command "Invoke-WebRequest -Uri '%URL_KEYS%' -OutFile '%ARQUIVO_KEYS%'" >nul 2>nul

if not exist "%ARQUIVO_KEYS%" (
    echo ❌ Falha ao conectar ao servidor!
    echo.
    echo   Verifique sua conexão com a internet.
    echo.
    pause
    exit /b
)

echo ✅ Conectado ao servidor!
timeout /t 1 /nobreak >nul

if exist "%ARQUIVO_SESSION%" (
    for /f "tokens=1 delims=" %%a in ('type "%ARQUIVO_SESSION%"') do set "SESSION_KEY=%%a"
    goto VERIFICAR_SESSAO
)

:LOGIN
cls
echo ======================================================
echo    🚀 GARCIA OPTIMIZER - SERVER EDITION
echo    "Digite sua key para validar online" 🔑
echo ======================================================
echo.
echo   🔑 Key valida em servidor online.
echo   ⚠️ Apenas %MAX_TENTATIVAS% tentativas.
echo.
echo ------------------------------------------------------
echo.
set /p "CHAVE_DIGITADA=Digite sua key: "

if "%CHAVE_DIGITADA%"=="" (
    echo.
    echo ❌ Voce precisa digitar uma key!
    timeout /t 2 /nobreak >nul
    goto LOGIN
)

echo.
echo   Validando key no servidor...
echo.

powershell -Command "
$json = Get-Content '%ARQUIVO_KEYS%' | ConvertFrom-Json
$key = '%CHAVE_DIGITADA%'
$found = $false
foreach ($k in $json.keys) {
    if ($k.key -eq $key) {
        if ($k.ativada -eq $true) {
            if ($k.max_usos -eq 0 -or $k.usos -lt $k.max_usos) {
                echo 'VALIDO'
                echo $k.plano
                echo $k.usuario
                echo $k.validade
                echo $k.max_usos
                echo $k.usos
                $found = $true
                $k.usos = $k.usos + 1
                $json | ConvertTo-Json | Out-File '%ARQUIVO_KEYS%'
                break
            } else {
                echo 'LIMITE_EXCEDIDO'
                $found = $true
                break
            }
        } else {
            echo 'INATIVA'
            $found = $true
            break
        }
    }
}
if ($found -eq $false) { echo 'INVALIDA' }
" > "%temp%\key_result.txt"

set /p RESULTADO=<"%temp%\key_result.txt"

if "%RESULTADO%"=="VALIDO" goto CHAVE_OK
if "%RESULTADO%"=="INVALIDA" goto CHAVE_INVALIDA
if "%RESULTADO%"=="INATIVA" goto CHAVE_INATIVA
if "%RESULTADO%"=="LIMITE_EXCEDIDO" goto LIMITE_EXCEDIDO
goto CHAVE_INVALIDA

:CHAVE_OK
for /f "tokens=1-5 delims= " %%a in ('type "%temp%\key_result.txt"') do (
    set "PLANO=%%a"
    set "USUARIO=%%b"
    set "VALIDADE=%%c"
    set "MAX_USOS=%%d"
    set "USOS_ATUAIS=%%e"
)

echo %CHAVE_DIGITADA% > "%ARQUIVO_SESSION%"
echo %USUARIO% >> "%ARQUIVO_SESSION%"
echo %PLANO% >> "%ARQUIVO_SESSION%"

cls
echo ======================================================
echo    ✅ KEY VALIDADA COM SUCESSO!
echo ======================================================
echo.
echo    👋 Bem-vindo, %USUARIO%!
echo.
echo    🔑 Key: %CHAVE_DIGITADA%
echo    📋 Plano: %PLANO%
echo    ⏳ Validade: %VALIDADE%
echo    🔢 Usos: %USOS_ATUAIS%/%MAX_USOS%
echo.
echo ======================================================
echo.
echo Pressione qualquer tecla para continuar...
pause >nul

:LOOP_PRINCIPAL
cls
echo ======================================================
echo    🚀 GARCIA OPTIMIZER - EXECUTANDO PLANO %PLANO%
echo ======================================================
echo.
echo    👋 Bem-vindo, %USUARIO%!
echo    📋 Plano: %PLANO%
echo    ⏳ Validade: %VALIDADE%
echo.
echo    🔄 Verificando key a cada 30 segundos...
echo.
echo ======================================================
echo.
echo Iniciando otimizacao... Aguarde!
echo.

echo [1/5] Liberando memoria RAM...
powershell -Command "Clear-RecycleBin -Force" >nul 2>nul
powershell -Command "[System.GC]::Collect()" >nul 2>nul
del /f /s /q "%TEMP%\*.*" >nul 2>nul
del /f /s /q "%WINDIR%\Temp\*.*" >nul 2>nul
rd /s /q "%TEMP%" >nul 2>nul
rd /s /q "%WINDIR%\Temp" >nul 2>nul
mkdir "%TEMP%" 2>nul
mkdir "%WINDIR%\Temp" 2>nul
echo      OK!

if not "%PLANO%"=="FREE" (
    echo [2/5] Fechando programas pesados...
    taskkill /f /im chrome.exe >nul 2>nul
    taskkill /f /im discord.exe >nul 2>nul
    taskkill /f /im spotify.exe >nul 2>nul
    taskkill /f /im steam.exe >nul 2>nul
    echo      OK!
)

if not "%PLANO%"=="FREE" (
    echo [3/5] Otimizando rede...
    ipconfig /flushdns >nul 2>nul
    echo      OK!
)

if "%PLANO%"=="VIP" (
    echo [4/5] Desativando servicos inuteis...
    sc stop SysMain >nul 2>nul
    sc config SysMain start= disabled >nul 2>nul
    sc stop DiagTrack >nul 2>nul
    sc config DiagTrack start= disabled >nul 2>nul
    echo      OK!
)

if "%PLANO%"=="VIP" (
    echo [5/5] Priorizando jogos...
    for %%i in (FiveM.exe fivem.exe RobloxPlayerBeta.exe BloodStrike.exe) do (
        wmic process where name="%%i" CALL setpriority "HIGH" >nul 2>nul
    )
    echo      OK!
) else (
    echo [5/5] Limpando lixeira...
    powershell -Command "Clear-RecycleBin -Force" >nul 2>nul
    echo      OK!
)

:VERIFICAR_SESSAO
cls
echo ======================================================
echo    🔄 VERIFICANDO KEY NO SERVIDOR...
echo ======================================================
echo.
echo   Verificando se a key ainda e valida...
echo.

powershell -Command "Invoke-WebRequest -Uri '%URL_KEYS%' -OutFile '%ARQUIVO_KEYS%'" >nul 2>nul

powershell -Command "
$json = Get-Content '%ARQUIVO_KEYS%' | ConvertFrom-Json
$key = '%SESSION_KEY%'
$found = $false
foreach ($k in $json.keys) {
    if ($k.key -eq $key) {
        if ($k.ativada -eq $true) {
            echo 'VALIDO'
            $found = $true
            break
        } else {
            echo 'INATIVA'
            $found = $true
            break
        }
    }
}
if ($found -eq $false) { echo 'REMOVIDA' }
" > "%temp%\verificacao.txt"

set /p STATUS=<"%temp%\verificacao.txt"

if "%STATUS%"=="VALIDO" (
    echo ✅ Key ainda valida!
    echo.
    echo Continuando o programa...
    timeout /t 3 /nobreak >nul
    goto LOOP_PRINCIPAL
)

if "%STATUS%"=="INATIVA" goto KEY_DESATIVADA
if "%STATUS%"=="REMOVIDA" goto KEY_REMOVIDA

echo ⚠️ Nao foi possivel verificar a key.
echo    Tentando novamente em 30 segundos...
timeout /t 30 /nobreak >nul
goto VERIFICAR_SESSAO

:KEY_DESATIVADA
cls
echo ======================================================
echo    ⛔ KEY DESATIVADA PELO ADMIN!
echo ======================================================
echo.
echo   Sua key foi desativada remotamente.
echo.
echo   Entre em contato com o suporte.
echo.
echo   O programa sera encerrado em 5 segundos...
echo.
timeout /t 5 /nobreak >nul
del "%ARQUIVO_SESSION%" >nul 2>nul
exit /b

:KEY_REMOVIDA
cls
echo ======================================================
echo    ⛔ KEY REMOVIDA DO SISTEMA!
echo ======================================================
echo.
echo   Sua key foi removida da whitelist.
echo.
echo   Entre em contato com o suporte.
echo.
echo   O programa sera encerrado em 5 segundos...
echo.
timeout /t 5 /nobreak >nul
del "%ARQUIVO_SESSION%" >nul 2>nul
exit /b

:CHAVE_INVALIDA
cls
echo ======================================================
echo    ❌ CHAVE INVALIDA!
echo ======================================================
echo.
echo   A key digitada nao existe no sistema.
echo.
echo ======================================================
echo.
set /a TENTATIVAS+=1
set "RESTANTE=%MAX_TENTATIVAS%-%TENTATIVAS%"

if %TENTATIVAS% LSS %MAX_TENTATIVAS% (
    echo Tentativas restantes: %RESTANTE%
    timeout /t 2 /nobreak >nul
    goto LOGIN
) else (
    echo Acesso bloqueado por %MAX_TENTATIVAS% tentativas.
    pause
    exit /b
)

:CHAVE_INATIVA
cls
echo ======================================================
echo    ⛔ CHAVE INATIVA!
echo ======================================================
echo.
echo   Esta key foi desativada pelo administrador.
echo.
echo ======================================================
echo.
pause
exit /b

:LIMITE_EXCEDIDO
cls
echo ======================================================
echo    ⛔ LIMITE DE USOS EXCEDIDO!
echo ======================================================
echo.
echo   Esta key ja atingiu o limite de usos.
echo.
echo ======================================================
echo.
pause
exit /b
