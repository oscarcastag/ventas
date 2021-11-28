Installing and configuring the OpenEdge Adapter for Sonic ESB

Since the release of OpenEdge 10.1C, there is no longer any need to manually configure 
the OpenEdge Adapter for Sonic ESB (Adapter). The OpenEdge installation program can 
be used to configure all your components in a distributed ESB system. The installation 
program automatically selects one of 3 different profiles depending on the situation.

Development Install

This mode is selected when installing an OpenEdge development product such as 
OpenEdge Architect. The installation program will install the adapter libraries, service 
types, and other artifacts to the specified Sonic Domain Manager that are required to run 
the adapter. It will also install a development container and default service for use in 
Sonic Workbench, and create a runtime container that you are free to use or not. Finally, 
it will configure the Sonic Management Console on the system you are performing the 
install on if you properly specified your Sonic ESB home directory (I.E. 
C:\Progress\Sonic\ESB7.6).

Deployment Install

This mode is selected when installing the OpenEdge Enterprise AppServer. It will do 
most of the development install except for the development container and default service. 
If you have Sonic ESB installed on a system where you are doing a deployment install 
and properly specify your Sonic ESB Home directory, it will configure the Sonic 
Management Console.

Domain Install

This mode is selected when you install the Adapter product on a system with Sonic ESB 
installed, but no other OpenEdge products installed. Its primary purpose is to configure 
the Sonic Management Console on the system running your Sonic Domain Manager. It is 
important to correctly specify your Sonic ESB home directory. If you need a 
downloadable install and control codes for the Adapter product, you can find them at the 
Progress Software ESD website, http://www.progress.com/openedge/support/index.ssp.

Offline Install

If your Sonic Domain Manager wasn't running when you installed OpenEdge, and you 
correctly specified your Adapter installation properties, an Offline script will be created 
that can be run to complete the installation process. Start you Sonic Domain Manager and 
run $DLC/sonic/ESB7.5/config/offline.bat or offline.sh.

Installing Sonic after installing OpenEdge

If you install Sonic after installing OpenEdge, the easiest way for configuring the adapter 
is to do a Domain Install as outlined above. If OpenEdge Architect and Sonic Workbench 
are already installed, this will configure your development environment for you.

Installation problems

If you encounter any issues with installing and configuring the adapter, you can find 
detailed information on the configuration in $DLC/install/tlr/esbadaptertlr.log.
