set pythonJsonPath="\\***\quectel\研发部\测试部\软件测试\ST-4G\4G_QAT\QAT_9x07_GW_Excel\***"
set RemoteQATCasePath="\\***\quectel\研发部\测试部\软件测试\ST-4G\4G_QAT\QAT_9x07_GW_Excel\"
set FileName=****
set RemoteFilePath="\\***\quectel\Project\Module Project Files\LTE Project\MDM9x07\EC20-CEHB-GWWS\Release\"
set platform=9x07
set branch=GW
set CustomKey=WS

set LocalFilePath=F:\
::本地保存盘符，保存软件版本、QAT工具、QFLASH工具、自动化case等,统一放到F盘，不要改动
set FileNameSuf=.zip

set DMPORT1=-3
set DMPORT2=-4
set DMPORT3=-15
set DMPORT4=-18

set UART1=COM11
set UART2=COM28
set UART3=COM12
set UART4=COM13

set Burdrate=-9***
set QATBatPath=F:\9x07_GW_QAT\
set VBAT_Disusedcard_function01=QAT_9X07_GW_*_common_VBAT_废卡_20180823
set QFlashFilePath=F:\**\Release\

set VBATfunction01=QAT_9X07_GW_*_common_VBAT_工厂版本验证非数传_20180628
set VBATfunction02=QAT_9X07_GW_*_stand_WS_CQ_VBAT_20181008
set VBATfunction03=QAT_9X07_GW_*_common_VBAT_正常卡_20180823
set VBATfunction04=QAT_9x07_GW_*_common_VBAT_20180919

set AUTOfunction01=QAT_9x07_GW_**_common_Auto_工厂版本验证_20180810
set AUTOfunction02=QAT_9x07_GW_**_common_Auto_20180608
set AUTOfunction03=QAT_9X07_GW_**_common_Auto_数传_20180427
set AUTOfunction04=QAT_9x07_GW_**_common_Auto_20180426
set AUTOfunction05=QAT_9x07_GW_**_stand_WS_CQ_Auto_20180917
set AUTOfunction06=QAT_9X07_GW_**_common_Auto_20180426
set AUTOfunction07=QAT_9x07_GW_**_common_Auto_客户问题_20180928
set AUTOfunction08=QAT_9x07_GW_**_common_Auto_20180522
set AUTOfunction09=QAT_9x07_GW_**_common_Auto_20180302
set AUTOfunction10=QAT_9x07_GW_**_common_Auto_20180903




set hh=%time:~0,2%
if /i %hh% LSS 10 (set hh=0%time:~1,1%)


md %LocalFilePath%%platform%_deployment\%branch%\%FileName%\common_%date:~0,4%%date:~5,2%%date:~8,2%_%hh:~0,2%%time:~3,2%
md %LocalFilePath%%platform%_deployment\%branch%\%FileName%\custom_%date:~0,4%%date:~5,2%%date:~8,2%_%hh:~0,2%%time:~3,2%
::md %LocalFilePath%%platform%_workspace\%branch%\%FileName%\common_%date:~0,4%%date:~5,2%%date:~8,2%_%hh:~0,2%%time:~3,2%
::md %LocalFilePath%%platform%_workspace\%branch%\%FileName%\custom_%date:~0,4%%date:~5,2%%date:~8,2%_%hh:~0,2%%time:~3,2%

set DeploymentCommonPath=%LocalFilePath%%platform%_deployment\%branch%\%FileName%\common_%date:~0,4%%date:~5,2%%date:~8,2%_%hh:~0,2%%time:~3,2%
set DeploymentCustomPath=%LocalFilePath%%platform%_deployment\%branch%\%FileName%\custom_%date:~0,4%%date:~5,2%%date:~8,2%_%hh:~0,2%%time:~3,2%
::set WorkspaceCommonPath=%LocalFilePath%%platform%_workspace\%branch%\%FileName%\common_%date:~0,4%%date:~5,2%%date:~8,2%_%hh:~0,2%%time:~3,2%
::set WorkspaceCustomPath=%LocalFilePath%%platform%_workspace\%branch%\%FileName%\custom_%date:~0,4%%date:~5,2%%date:~8,2%_%hh:~0,2%%time:~3,2%

net use \\192.168.11.252\ipc$ "Admin@123456" /user:"test-public@quectel"
echo [%date%%time%]"Access share folder successfully.."

ping /n 60 127.0.0.1 >nul

for /r %RemoteQATCasePath% %%i in (*_common_*.xlsx) do copy %%i %DeploymentCommonPath%
for /r %RemoteQATCasePath% %%i in (*.txt) do copy %%i %DeploymentCommonPath%
for /r %RemoteQATCasePath% %%i in (*_%CustomKey%_*.xlsx) do copy %%i %DeploymentCustomPath%
::for /r %RemoteQATCasePath% %%i in (*.json) do copy %%i "F:\json\"

::ping /n 1200 127.0.0.1 >nul
::此处不需要copy到工作路径了，直接在部署路径执行即可
::copy %DeploymentCommonPath% %WorkspaceCommonPath%
::copy %DeploymentCustomPath% %WorkspaceCustomPath%


:main1
if NOT exist %RemoteFilePath%%FileName%%FileNameSuf% (goto do1) else goto do2

:do1
echo [%date%%time%]"wait for remote file.." 
ping /n 50 127.0.0.1 >nul
goto main1

:do2
echo [%date%%time%]"Start to copy remote file.."
copy %RemoteFilePath%%FileName%%FileNameSuf% %LocalFilePath%

:main2
if NOT exist %LocalFilePath%%FileName%%FileNameSuf% (goto do3) else goto do4

:do3
echo [%date%%time%]"Copying remote file.." 
ping /n 30 127.0.0.1 >nul 
goto main2

:do4
echo [%date%%time%]"Start to unzip local file.."
"C:\Program Files\WinRAR\WinRAR.exe" -o+ x %LocalFilePath%%FileName%%FileNameSuf% %LocalFilePath%
echo [%date%%time%]"Unzip local file completed.."

ping /n 30 127.0.0.1 >nul

echo [%date%%time%]"Prepare to download firmware.."
cd %QFlashFilePath%

::执行run.bat，运行case
@echo on
cd\
F:
cd %QATBatPath%QAT_AUTO\
start QAT.exe "-s %QATBatPath%QAT_9x07_GW_Power.xlsx$ALL" "-uart %UART3% 115200 NO"
ping /n 10 127.0.0.1 >nul
cd %QFlashFilePath%
for /r %LocalFilePath%%FileName% %%i in (ENPRG9x0?.mbn) do if exist %%i QFlash_V4.8.exe %DMPORT3% %Burdrate% -%%i
echo [%date%%time%]"Start to download firmware..DMPORT3 UARTPORT-%UART3%"
ping /n 10 127.0.0.1 >nul
::taskkill /f /im QAT.exe

cd %QATBatPath%QAT_AUTO\
start QAT.exe "-s %QATBatPath%QAT_9x07_GW_Power.xlsx$ALL" "-uart %UART4% 115200 NO"
ping /n 10 127.0.0.1 >nul
cd %QFlashFilePath%
for /r %LocalFilePath%%FileName% %%i in (ENPRG9x0?.mbn) do if exist %%i QFlash_V4.8.exe %DMPORT4% %Burdrate% -%%i
echo [%date%%time%]"Start to download firmware..DMPORT4 UARTPORT-%UART4%"
ping /n 10 127.0.0.1 >nul
::taskkill /f /im QAT.exe

cd %QFlashFilePath%
for /r %LocalFilePath%%FileName% %%i in (ENPRG9x0?.mbn) do if exist %%i QFlash_V4.8.exe %DMPORT1% %Burdrate% -%%i
echo [%date%%time%]"Start to download firmware..DMPORT1 UARTPORT-%UART1%"
ping /n 10 127.0.0.1 >nul
echo [%date%%time%]"End of download firmware..DMPORT1 UARTPORT-%UART1%"

for /r %LocalFilePath%%FileName% %%i in (ENPRG9x0?.mbn) do if exist %%i QFlash_V4.8.exe %DMPORT2% %Burdrate% -%%i
echo [%date%%time%]"Start to download firmware..DMPORT2 UARTPORT-%UART2%"
ping /n 60 127.0.0.1 >nul

::升级完成后，配置Setting

cd "F:\dist\AllFileAutoSetting"
AllFileAutoSetting.exe "%DeploymentCommonPath%" "%DeploymentCustomPath%" %pythonJsonPath%

cd\
F:
ping /n 20 127.0.0.1 >nul
::cd %QATBatPath%
::start AUTO_disused_card.bat
::cd %QATBatPath%
::start AUTO_VBAT.bat
::cd %AutoPath%
::start QAT_Auto.bat

::AUTO_disused_card.bat
cd %QATBatPath%QAT_VBAT_disused_card\
start QAT.exe "-s %DeploymentCommonPath%\%VBAT_Disusedcard_function01%.xlsx$ALL" "-uart %UART3% 115200 NO"

::AUTO_VBAT.bat
cd %QATBatPath%QAT_VBAT\
start QAT.exe "-s %DeploymentCommonPath%\%VBATfunction01%.xlsx$ALL>%DeploymentCustomPath%\%VBATfunction02%.xlsx$ALL>%DeploymentCommonPath%\%VBATfunction03%.xlsx$ALL>%DeploymentCommonPath%\%VBATfunction04%.xlsx$ALL" "-uart %UART4% 115200 NO"

::QAT_Auto.bat
cd %QATBatPath%QAT_AUTO\
start QAT.exe "-s %DeploymentCommonPath%\%AUTOfunction01%.xlsx$ALL>%DeploymentCommonPath%\%AUTOfunction02%.xlsx$ALL>%DeploymentCommonPath%\%AUTOfunction03%.xlsx$ALL>%DeploymentCommonPath%\%AUTOfunction04%.xlsx$ALL>%DeploymentCustomPath%\%AUTOfunction05%.xlsx$ALL>%DeploymentCommonPath%\%AUTOfunction06%.xlsx$ALL>%DeploymentCommonPath%\%AUTOfunction07%.xlsx$ALL>%DeploymentCommonPath%\%AUTOfunction08%.xlsx$ALL>%DeploymentCommonPath%\%AUTOfunction09%.xlsx$ALL>%DeploymentCommonPath%\%AUTOfunction10%.xlsx$ALL" "-usb COM3 115200" "-uart %UART2% 115200 NO"

pause >nul
