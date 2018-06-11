

## Includes
source ./req.sh
source ./lib.sh
#source ./bin.sh
source ./functions.sh


export global binonly=false

#Parse Args
opts $@

#PreInstall

tabs 16
export global cpu=`cat "/proc/cpuinfo" | grep "processor"|wc -l`
export global TMPDIR=$HOME/tmp
mkdir -p $HOME/tmp
mkdir -p ~/Downloads
export global DOWNDIR=/root/Downloads
mkdir -p $DOWNDIR
export global DESTDIR=""
export global ARCH=$(arch)
export global LOG=$DOWNDIR/log
traps >$LOG 2>1

##################################################################################

## Header
echo -e "\n Ubuntu 18.04 pos Installer Script \n"
echo -e "\n Log File: $LOG\n"

## Presetup 
echo -e "\n#### Running PreSetup WEB #### \n"

dots "Update Distro"
apt_update >>$LOG 2>1
dots "" $?

#dots "Mysql-Server"
#Install_Mysql >>$LOG 2>1
#dots "" $?

dots "Apache"
Install_Apache >>$LOG 2>1
dots "" $?

dots "Php 7"
Install_php >>$LOG 2>1
dots "" $?

#dots "Maria DB"
#Install_MariaDB >>$LOG 2>1
#dots "" $?

dots "SSL CERT"
Install_SSL >>$LOG 2>1
dots "" $?

dots "PhpMyAdmin"
Install_PhpMyAdmin >>$LOG 2>1
dots "" $?

dots "Webmin"
install_Webmin >>$LOG 2>1
dots "" $?
# on port error /etc/init.d/webmin restart
# editing /etc/webmin/miniserv.conf port 10000 to 10222

dots "Samba"
Install_Samba >>$LOG 2>1
dots "" $?

dots "FireWallRules"
Install_Firewall >>$LOG 2>1
dots "" $?

dots "Git"
install_git >>$LOG 2>1
dots "" $?

dots "Cron Scripts"
Install_cron >>$LOG 2>1
dots "" $?

## FinishWebSetup 
echo -e "\n#### Finish PreSetup WEB #### \n"

## Init MediaSetup
echo -e "\n#### Init Install Media #### \n"

dots "Install Utorrent"
Install_utorrent >>$LOG 2>1
dots "" $?

dots "Emby"
Install_Emby >>$LOG 2>1
dots "" $?

dots "NTFS 3g"
Install_ntfs >>$LOG 2>1
dots "" $?

dots "Drivers Impressora"
Install_Impressora >>$LOG 2>1
dots "" $?

dots "Pxe Libs"
Install_pxe_lib >>$LOG 2>1
dots "" $?

dots "Mega Tools Backup"
Install_mega >>$LOG 2>1
dots "" $?

dots "TestDisc"
Install_TestDisc >>$LOG 2>1
dots "" $?

#finish MediaSetup
echo -e "\n#### Finish Install MEDIA #### \n"

#Init Install Tools NetWork
echo -e "\n#### Install Tools NetWork #### \n"

dots "Glances"
Install_glances >>$LOG 2>1
dots "" $?



############################################################
##                         CLEAN                          ##
############################################################
dots "Checking Threads"
check_threads >>$LOG 2>1
dots "" $?

dots "Removing Files"
remove_stuff >>$LOG 2>1
dots "" $?
