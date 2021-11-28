export TERM=xterm
export DLC=/opt/app-root/src/ventas/dlc102b
export PATH=%DLC:$DLC/bin:$DLC/oebpm/server/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/dlc/dba/procomdb
rm /opt/app-root/src/sports.lk
/opt/app-root/src/ventas/dlc102b/bin/_mprosrv /opt/app-root/src/sports.db 
	
