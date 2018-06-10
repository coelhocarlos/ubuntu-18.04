

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

## Header
echo -e "\n Ubuntu 18.04 pos Installer Script \n"
echo -e "\n Log File: $LOG\n"

## Presetup 
echo -e "\n#### Running PreSetup WEB #### \n"

dots "Update Distro"
apt_update >>$LOG 2>1
dots "" $?

dots "Mysql-Server"
Install_Mysql >>$LOG 2>1
dots "" $?

dots "Apache"
Install_Apache >>$LOG 2>1
dots "" $?

dots "Php 7"
Install_php >>$LOG 2>1
dots "" $?

dots "Maria DB"
Install_MariaDB >>$LOG 2>1
dots "" $?

dots "Mysql-Server"
Install_Mysql >>$LOG 2>1
dots "" $?

dots "SL CERT"
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
############################################################
##                       Libraries                        ##
############################################################
echo -e "\n#### Installing Libraries #### \n"

if ! $binonly
then
    dots "Installing libpng"
    install_libpng >>$LOG 2>1
    dots "Installing libpng" $?
        
    dots "Installing Freetype"
    install_freetype >>$LOG 2>1
    dots "Installing Freetype" $?

    dots "Installing libwmf"
    install_libwmf >>$LOG 2>1
    dots "Installing libwmf" $?

    dots "Installing FLVTool"
    install_flvtoo >>$LOG 2>1
    dots "Installing FLVTool" $?

    dots "Installing Lame"
    install_lame >>$LOG 2>1
    dots "Installing Lame" $?

    dots "Installing Codecs"
    install_codecs >>$LOG 2>1
    dots "Installing Codecs" $?

    dots "Installing libogg"
    install_libogg >>$LOG 2>1
    dots "Installing libogg" $?

    dots "Installing libvorbis"
    install_libvorbis >>$LOG 2>1
    dots "Installing libvorbis" $?

    dots "Installing VorbisTools"
    install_vorbistools >>$LOG 2>1
    dots "Installing VorbisTools" $?

    dots "Installing libtheora"
    install_libtheora >>$LOG 2>1
    dots "Installing libtheora" $?

    dots "Installing openamr"
    install_openamr >>$LOG 2>1
    dots "Installing openamr" $?

    dots "Installing liba52" 
    install_liba52 >>$LOG 2>1
    dots "Installing liba52" $?

    dots "Installing FACC"
    install_facc >>$LOG 2>1
    dots "Installing FACC" $? 

    dots "Installing FAAD2"
    install_faad2 >>$LOG 2>1
    dots "Installing FAAD2" $?

    dots "Installing YASM"
    install_yasm >>$LOG 2>1
    dots "Installing YASM" $?

    dots "Installing NASM"
    install_nasm >>$LOG 2>1
    dots "Installing NASM" $?

    dots "Installing XVID"
    install_xvid >>$LOG 2>1
    dots "Installing XVID" $?

    dots "Installing x264"
    install_x264 >>$LOG 2>1
    dots "Installing x264" $?

    dots "Installing Live555"
    install_live555 >>$LOG 2>1
    dots "Installing Live555" $?

    dots "Installing re2c"
    install_re2c >>$LOG 2>1
    dots "Installing re2c" $?

    dots "Installing amrnb"
    install_amrnb >>$LOG 2>1
    dots "Installing amrnb" $?

    dots "Installing amrwb" 
    install_amrwb >>$LOG 2>1
    dots "Installing amrwb" $?

    dots "Installing libvpx"
    install_libvpx >>$LOG 2>1
    dots "Installing libvpx" $?
    
    dots "Installing libasound"
    install_libasound >>$LOG 2>1
    dots "Installing libasound" $?

    ldconfig 
else
    echo "--- Skipping ---"
fi

### FFMPEG Programs

echo -e "\n#### Installing FFMPEG Binaries #### \n"

dots "Installing FFMPEG"
install_ffmpeg >>$LOG 2>1
dots "Installing FFMPEG" $?

dots "Installing MPlayer"
install_mplayer >>$LOG 2>1
dots "Installing MPlayer" $?

dots "Installing MP4Box"
install_mp4box >>$LOG 2>1
dots "Installing MP4Box" $?

dots "Installing FFMPEG-PHP"
install_ffmpegphp >>$LOG 2>1
dots "Installing FFMPEG-PHP" $?
