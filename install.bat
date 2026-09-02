@echo off
title GARCIA OPTIMIZER - INSTALADOR
color 0A
cls

echo ======================================================
echo    🚀 GARCIA OPTIMIZER - INSTALADOR OFICIAL
echo    "Baixando a versao mais recente..." 🔐
echo ======================================================
echo.

:: Substitua SEU-USUARIO pelo seu nome do GitHub
set "URL_SCRIPT=https://raw.githubusercontent.com/SEU-USUARIO/garcia-optimizer/main/GarciaOptimizer.bat"
set "ARQUIVO_DESTINO=%USERPROFILE%\Desktop\GarciaOptimizer.bat"

echo   📥 Baixando o Garcia Optimizer...
echo   📁 Salvando em: %ARQUIVO_DESTINO%
echo.

powershell -Command "Invoke-WebRequest -Uri '%URL_SCRIPT%' -OutFile '%ARQUIVO_DESTINO%'" >nul 2>nul

if not exist "%ARQUIVO_DESTINO%" (
    echo ❌ Falha ao baixar o arquivo!
    echo.
    echo   Verifique sua conexão com a internet.
    echo.
    pause
    exit /b
)

echo ✅ Download concluido com sucesso!
echo.
echo ======================================================
echo    ✅ INSTALACAO CONCLUIDA!
echo ======================================================
echo.
echo   📁 Arquivo salvo em: %ARQUIVO_DESTINO%
echo.
echo   Para executar, clique com o botao direito
echo   no arquivo e escolha "Executar como administrador".
echo.
echo ======================================================
echo.

echo Deseja executar o GarciaOptimizer agora?
choice /C SN /M "Executar agora"
if errorlevel 2 goto SAIR
if errorlevel 1 goto EXECUTAR

:EXECUTAR
echo.
echo Executando o Garcia Optimizer...
timeout /t 2 /nobreak >nul
call "%ARQUIVO_DESTINO%"
exit

:SAIR
echo.
echo Voce pode executar o GarciaOptimizer quando quiser.
echo Local: %ARQUIVO_DESTINO%
pause
exit
