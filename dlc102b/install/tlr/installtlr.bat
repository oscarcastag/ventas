echo OFF

set DLC=[[install-dir-short]]
set tlrdir=%DLC%\install\tlr
set antfile=%tlrdir%\LaunchTailoringClasses.xml
set tempfileA=%tlrdir%\tempfileA
set sonicesbpath=[[archive-dir]]3party\sonicmq\lib\jmxri.jar;[[archive-dir]]3party\sonicmq\lib\mgmt_client.jar;[[archive-dir]]3party\sonicmq\lib\mgmt_config.jar;[[archive-dir]]3party\sonicesb\lib\xq_config.jar;[[archive-dir]]3party\sonicmq\lib\sonic_Client.jar;[[archive-dir]]3party\sonicmq\lib\sonic_Crypto.jar;[[archive-dir]]3party\sonicmq\lib\xercesImpl.jar;[[archive-dir]]3party\sonicmq\lib\xmlParserAPIs.jar

echo ^<project name="TailoringExtension" default="launch" basedir="%tlrdir%"^>  > %antfile%
echo ^<target name="launch"^> >> %antfile%

cd %tlrdir%
FOR %%x in (*tlr.class) DO ( 
	echo %%x > %tempfileA%
	
	FOR /F "delims=. tokens=1" %%z in (%tempfileA%) DO (
		echo ^<java classname="%%z" classpath=".\;%DLC%\java;%sonicesbpath%"^>^</java^> >> %antfile%)
	)
)	

echo ^</target^>   >> %antfile%
echo ^</project^>  >> %antfile%

IF exist %tempfileA% DEL /F/Q %tempfileA%

