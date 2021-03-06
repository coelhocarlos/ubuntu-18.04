#!/bin/bash
##### Install Libraries #####

ERROR=0

install_Webmin() {
    echo " -------------- Installing Webmin -------------- "
    cd $DOWNDIR
    sudo apt install tasksel wget || local ERROR=1
    #sudo tasksel install lamp-server || local ERROR=1
    sudo add-apt-repository "deb http://download.webmin.com/download/repository sarge contrib" || local ERROR=1
    sudo wget -qO- http://www.webmin.com/jcameron-key.asc | sudo apt-key add || local ERROR=1
    sudo apt update || local ERROR=1
    sudo apt install webmin  wget|| local ERROR=1
    echo "------------------------------------------------"
    echo "Webmin install complete. You can now login to https://webmin.linuxconfig.org:10000/"
    echo "as root with your root password, or as any user who can use sudo"
    echo "to run commands as root."
    return $ERROR
}

Install_Apache() {
    echo " -------------- Installing Apache -------------- "
    
    cd $DOWNDIR
    sudo apt install apache2 wget|| local ERROR=1
    #sudo ufw app list 
    sudo ufw allow 'Apache' || local ERROR=1
    sudo mkdir -p /var/www/server || local ERROR=1
    sudo mkdir -p /var/www/public || local ERROR=1
    sudo chown -R $zombie:$zombie /var/www || local ERROR=1
    sudo chown -R $zombie:$zombie /var/www/html || local ERROR=1
    sudo chown -R $zombie:$zombie /var/www/server || local ERROR=1
    sudo chown -R $zombie:$zombie /var/www/public || local ERROR=1
    sudo chmod -R 755 /var/www/
    sudo chmod -R 755 /var/www/html
    sudo chmod -R 755 /var/www/public
    sudo chmod -R 755 /var/www/server
    sudo systemctl restart apache2
    #sudo ufw status
    #sudo systemctl status apache2
    return $ERROR
}

Install_php() {
    echo " -------------- Installing PHP -------------- " 
    cd $DOWNDIR
    sudo apt install php7.2 libapache2-mod-php7.2 wget|| local ERROR=1
    sudo apt-get install php7.2-mysql php7.2-curl php7.2-json php7.2-cgi php7.2-xsl || local ERROR=1
    sudo apt-get -y install php7.2-mysql php7.2-curl php7.2-gd php7.2-intl php-pear php-imagick php7.2-imap php-memcache  php7.2-pspell php7.2-recode php7.2-sqlite3 php7.2-tidy php7.2-xmlrpc php7.2-xsl php7.2-mbstring php-gettext || local ERROR=1
    sudo systemctl restart apache2 || local ERROR=1
    sudo apt install php7.0-dev wget|| local ERROR=1
    sudo systemctl restart apache2 || local ERROR=1
    sudo apt-get -y install php7.2-opcache php-apcu || local ERROR=1
    sudo systemctl restart apache2 || local ERROR=1
    sudo a2enmod ssl || local ERROR=1
    sudo systemctl restart apache2 || local ERROR=1
    sudo a2ensite default-ssl || local ERROR=1
    sudo systemctl restart apache2 || local ERROR=1
    return $ERROR
}
Install_SSL(){
    echo " -------------- Installing SSL -------------- " 
    cd $DOWNDIR
    sudo apt-get -y install python3-certbot-apache
    #nano /etc/apache2/sites-available/000-default.conf
    #ServerName example.com
    #certbot --apache -d example.com
    # Let's encrypt Auto Renewal
    #/etc/cron.d/certbot
    #0 */12 * * * root test -x /usr/bin/certbot -a \! -d /run/systemd/system && perl -e 'sleep int(rand(43200))' && certbot -q renew
#}

 Install_Mysql() {
    echo " -------------- Installing Mysql -------------- "
    cd $DOWNDIR
    apt install -y mysql-server wget || local ERROR=1
    apt install -y mysql-client wget || local ERROR=1
    #sudo mysql_secure_installation
    sudo systemctl restart mysql.service || local ERROR=1
    return $ERROR
}
#Install_mariaDB(){
   # echo " -------------- Installing Maria Db -------------- "
   # cd $DOWNDIR
   # sudo apt install -y mariadb-server-10.0 mariadb-client-10.0 wget
    #mysql_secure_installation
#}

Install_PhpMyAdmin() {
    echo " -------------- Installing PHP Myadmin -------------- "
    cd $DOWNDIR
    sudo apt install -y phpmyadmin php-gettext wget
    return $ERROR
}

install_samba() {
    echo " -------------- Installing samba -------------- "
    
    cd $DOWNDIR
    
    sudo apt install samba wget || local ERROR=1
    sudo cp /etc/samba/smb.conf /etc/samba/smb.conf_backup  || local ERROR=1
    sudo bash -c 'grep -v -E "^#|^;" /etc/samba/smb.conf_backup | grep . > /etc/samba/smb.conf'  || local ERROR=1
    return $?
}

Install_Firewall() {
    echo " -------------- Adding Firewall Rules -------------- "
    
    cd $DOWNDIR
    sudo ufw allow ssh || local ERROR=1
    sudo ufw allow http || local ERROR=1
    sudo ufw allow https || local ERROR=1
    sudo ufw allow webmin || local ERROR=1
    sudo ufw allow 8443 || local ERROR=1
    sudo ufw allow 8096 || local ERROR=1
    sudo ufw allow 8080 || local ERROR=1
    sudo ufw allow samba || local ERROR=1
    sudo ufw allow ftp || local ERROR=1
    sudo ufw allow 2121 || local ERROR=1
    sudo ufw enable -y || local ERROR=1
    #-----Allow Established and Related Incoming Connections
    
return $ERROR
}

#Git client
install_git() {
    echo " -------------- Installing Git (If Necessary) -------------- "
    cd $DOWNDIR
    if ! hash git 2>/dev/null
    then
        if [ -f /usr/local/cpanel/3rdparty/bin/git ]
        then
            alias git=/usr/local/cpanel/3rdparty/bin/git
        else 
            cd $DOWNDIR
            rm -vrf git-master
            yum -y install expat-devel gettext-devel openssl-devel zlib-devel
            wget -N https://github.com/git/git/archive/master.tar.gz
            tar -xzvf master
            cd git-master
            make prefix=/usr/local all
            make prefix=/usr/local install
        fi
    fi
    return $?
}

Install_cron() {
    echo " -------------- Adding  Cron Scripts -------------- "
    cd $DOWNDIR
     sudo mkdir ~/.scripts || local ERROR=1
     cd ~/.scripts || local ERROR=1
     sudo wget https://raw.githubusercontent.com/coelhocarlos/meganz/master/megasend.sh || local ERROR=1
     sudo wget https://raw.githubusercontent.com/coelhocarlos/sqldump/master/MysqlDump.sh || local ERROR=1
     sudo wget https://raw.githubusercontent.com/coelhocarlos/DebianScripts/master/duck.sh || local ERROR=1
     sudo chmod +x megasend.sh || local ERROR=1
     sudo chmod +x MysqlDump.sh || local ERROR=1
     sudo chmod +x duck.sh || local ERROR=1
    return $ERROR
}

Install_utorrent () {
    echo " -------------- Installing Utorrent -------------- "
    cd $DOWNDIR
    
    sudo apt install libssl1.0.0 libssl-dev wget || local ERROR=1
    sudo wget http://download-new.utorrent.com/endpoint/utserver/os/linux-x64-ubuntu-13-04/track/beta/ -O utserver.tar.gz || local ERROR=1
    sudo tar -zxvf utserver.tar.gz -C /opt/ || local ERROR=1
    sudo chmod 777 /opt/utorrent-server-alpha-v3_3/ || local ERROR=1
    sudo ln -s /opt/utorrent-server-alpha-v3_3/utserver /usr/bin/utserver || local ERROR=1
    sudo wget https://raw.githubusercontent.com/coelhocarlos/debian9-install/master/utorrent || local ERROR=1
    sudo chmod 755 utorrent || local ERROR=1
    sudo cp utorrent /etc/init.d/  || local ERROR=1
    cd /etc/init.d/ || local ERROR=1
    sudo update-rc.d utorrent defaults || local ERROR=1
    sudo service utorrent start || local ERROR=1
    #systemctl status utorrent.service
    sudo service utorrent restart || local ERROR=1
    return $ERROR
}

Install_Emby() {
    echo " -------------- Installing Emby Media Server -------------- "
    cd $DOWNDIR
    sudo wget https://github.com/MediaBrowser/Emby.Releases/releases/download/3.4.1.0/emby-server-deb_3.4.1.0_amd64.deb  || local ERROR=1
    sudo dpkg -i emby-server-deb_3.4.1.0_amd64.deb || local ERROR=1
    return $ERROR
}

Install_ntfs() {
    echo " -------------- Installing NTFS 3G -------------- "
    cd $DOWNDIR
    sudo apt install ntfs-3g wget|| local ERROR=1
    #mkdir /media/hd160
    sudo mkdir /media/hd2000 || local ERROR=1
    #mount -t ntfs-3g /dev/sdb1 /media/hd160
    sudo mount -t ntfs-3g /dev/sdb1 /media/hd2000 || local ERROR=1
    return $ERROR
}

Install_Impressora(){
    cd $DOWNDIR
    sudo apt-get install hplip || local ERROR=1
    return $ERROR
}

Install_pxe_lib(){
    cd $DOWNDIR
    sudo apt-get install tftpd-hpa || local ERROR=1
    sudo echo "TFTP_DIRECTORY= /media/hd2000/wds_share" /etc/default/tftpd-hpa
    sudo echo "RUN_DAEMON="no" /etc/default/tftpd-hpa
    sudo echo "OPTIONS="-l -s /media/hd2000/wds_share" /etc/default/tftpd-hpa
    sudo apt=get install isc-dhcp-server || local ERROR=1
    sudo echo "option domain-name "coreserver.duckdns.org";" /etc/dhcp/dhcpd.conf
    sudo echo "option domain-name-servers ns1.coreserver.duckdns.org, ns2.coreser.duckdns.org;" /etc/dhcp/dhcpd.conf
    sudo echo " ddns-update-style interim;
                authoritative;
                allow booting;
                allow bootp; " /etc/dhcp/dhcpd.conf
    sudo echo "
         subnet 192.168.0.0 netmask 255.255.255.0
        {
        range 192.168.0.100 192.168.0.254;
        filename "pxelinux.0";
        default-lease-time 86400;
        max-lease-time 604800;
        option subnet-mask 255.255.255.0;
        option broadcast-address 192.168.0.255;
        option domain-name-servers 192.168.0.1;
        option routers 192.168.0.1;
        }
     " /etc/dhcp/dhcpd.conf
    sudo service isc-dhcp-server restart || local ERROR=1
    sudo /etc/init.d/tftpd-hpa restart || local ERROR=1
    return $ERROR
}
Install_mega(){
    cd $DOWNDIR
    sudo apt install megatools wget || local ERROR=1
    sudo touch ~/.megarc
    echo "[Login]" >> ~/.megarc
    echo "Username = carloscoelho_@live.com " >> ~/.megarc
    echo "Password = " >> ~/.megarc
    return $ERROR
}

Install_TestDisc(){
   cd $DOWNDIR
   sudo apt install testdisk  wget
   return $ERROR
}

Install_glances(){
  cd $DOWNDIR
  sudo apt install glances wget
  return $ERROR
}

}
