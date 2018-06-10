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
    sudo apt -y install webmin || local ERROR=1
    echo "------------------------------------------------"
    echo "Webmin install complete. You can now login to https://webmin.linuxconfig.org:10000/"
    echo "as root with your root password, or as any user who can use sudo"
    echo "to run commands as root."
    return $ERROR
}

Install_Apache() {
    echo " -------------- Installing Apache -------------- "
    
    cd $DOWNDIR
    sudo apt-get -y install apache2 || local ERROR=1
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
    sudo apt-get install python-software-properties || local ERROR=1
    sudo add-apt-repository ppa:ondrej/php || local ERROR=1
    sudo apt-get update || local ERROR=1
    sudo aapt-get -y install php7.2 libapache2-mod-php7.2 || local ERROR=1
    sudo apt-get install php7.2-mysql php7.2-curl php7.2-json php7.2-cgi php7.2-xsl || local ERROR=1
    sudo apt-get -y install php7.2-mysql php7.2-curl php7.2-gd php7.2-intl php-pear php-imagick php7.2-imap php-memcache  php7.2-pspell php7.2-recode php7.2-sqlite3 php7.2-tidy php7.2-xmlrpc php7.2-xsl php7.2-mbstring php-gettext || local ERROR=1
    sudo systemctl restart apache2 || local ERROR=1
    sudo apt install php7.0-dev || local ERROR=1
    sudo systemctl restart apache2 || local ERROR=1
    sudo apt-get -y install php7.2-opcache php-apcu || local ERROR=1
    sudo systemctl restart apache2 || local ERROR=1
    sudo a2enmod ssl || local ERROR=1
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
}

 Install_Mysql() {
    echo " -------------- Installing Mysql -------------- "
    cd $DOWNDIR
    apt-get -y install mysql-server mysql-client || local ERROR=1
    sudo mysql_secure_installation
    sudo systemctl restart mysql.service || local ERROR=1
    return $ERROR
}
Install_mariaDB(){
    echo " -------------- Installing Maria Db -------------- "
    cd $DOWNDIR
    apt-get -y install mariadb-server mariadb-client
    mysql_secure_installation
}
Install_PhpMyAdmin() {
    echo " -------------- Installing PHP Myadmin -------------- "
    cd $DOWNDIR
    sudo apt-get install phpmyadmin php-gettext
    return $ERROR
}

install_samba() {
    echo " -------------- Installing samba -------------- "
    
    cd $DOWNDIR
    
    sudo tasksel install samba-server  || local ERROR=1
    sudo cp /etc/samba/smb.conf /etc/samba/smb.conf_backup  || local ERROR=1
    sudo bash -c 'grep -v -E "^#|^;" /etc/samba/smb.conf_backup | grep . > /etc/samba/smb.conf'  || local ERROR=1
    return $?
}

Install_Firewall() {
    echo " -------------- Adding Firewall Rules -------------- "
    
    cd $DOWNDIR
    
    #-----Allow Established and Related Incoming Connections
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A OUTPUT -o lo -j ACCEPT
sudo iptables -A INPUT -i ens130 -j ACCEPT
sudo iptables -A OUTPUT -o ens130 -j ACCEPT
#-----Allow Established Outgoing Connections
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
#-----Internal to External
sudo iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED -j ACCEPT 
#-----Drop Invalid Packets
#sudo iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT
#----Block an IP Address
#sudo iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
#----Block a invalid Packets
#sudo iptables -A INPUT -s 15.15.15.51 -j DROP
#----Reject Network Ip
#sudo iptables -A INPUT -s 15.15.15.51 -j REJECT
#----Reject Network Interfaces
#sudo iptables -A INPUT -i eth0 -s 15.15.15.51 -j DROP
#----Allow All Incoming SSH 
sudo iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 22 -m conntrack --ctstate ESTABLISHED -j ACCEPT
sudo iptables -A INPUT -p tcp -s 15.15.15.0/24 --dport 22 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 22 -m conntrack --ctstate ESTABLISHED -j ACCEPT
#----Allow Outgoing SSH
sudo iptables -A OUTPUT -p tcp --dport 22 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A INPUT -p tcp --sport 22 -m conntrack --ctstate ESTABLISHED -j ACCEPT
#----Allow All Incoming HTTP
sudo iptables -A INPUT -p tcp --dport 80 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 80 -m conntrack --ctstate ESTABLISHED -j ACCEPT
#----Allow All Incoming HTTPS
sudo iptables -A INPUT -p tcp --dport 443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 443 -m conntrack --ctstate ESTABLISHED -j ACCEPT
#----Allow All Incoming HTTP and HTTPS
sudo iptables -A INPUT -p tcp -m multiport --dports 80,443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp -m multiport --dports 80,443 -m conntrack --ctstate ESTABLISHED -j ACCEPT
#----Allow All Incoming FTP
sudo iptables -A INPUT -p tcp --dport 21-m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 21-m conntrack --ctstate ESTABLISHED -j ACCEPT
#----Allow MySQL from Specific IP Address or Subnet
sudo iptables -A INPUT -p tcp -s 15.15.15.0/24 --dport 3306 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 3306 -m conntrack --ctstate ESTABLISHED -j ACCEPT
#----Allow Email  
sudo iptables -A INPUT -p tcp --dport 25 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 25 -m conntrack --ctstate ESTABLISHED -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 143 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 143 -m conntrack --ctstate ESTABLISHED -j ACCEPT
#---Allow Eamail SMTP 
sudo iptables -A INPUT -p tcp --dport 143 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 143 -m conntrack --ctstate ESTABLISHED -j ACCEPT
#---Allow Eamail IMAP
sudo iptables -A INPUT -p tcp --dport 993 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 993 -m conntrack --ctstate ESTABLISHED -j ACCEPT
#---Allow All Incoming POP3
sudo iptables -A INPUT -p tcp --dport 110 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 110 -m conntrack --ctstate ESTABLISHED -j ACCEPT
#---Allow All Incoming POP3S
sudo iptables -A INPUT -p tcp --dport 995 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 995 -m conntrack --ctstate ESTABLISHED -j ACCEPT
#---Allow All TEAMSPEAK3
sudo iptables -A INPUT -p tcp --dport 10011 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 10011 -m conntrack --ctstate ESTABLISHED -j ACCEPT

sudo iptables -A INPUT -p tcp -m tcp --dport 10000 -j ACCEPT
sudo iptables -A INPUT -p tcp -m tcp --dport 11100 -j ACCEPT

sudo iptables -A INPUT -p tcp --dport 30033 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 30033 -m conntrack --ctstate ESTABLISHED -j ACCEPT
sudo iptables -A INPUT -p udp --dport  9987 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p udp --sport  9987 -m conntrack --ctstate ESTABLISHED -j ACCEPT
#---Allow All MINECRAFT
sudo iptables -A INPUT -p tcp --dport 25565 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 25565 -m conntrack --ctstate ESTABLISHED -j ACCEPT
#--Allow All PXE
sudo iptables -A INPUT -p ALL -i $INET_IFACE -s 192.168.0.0/24 -j ACCEPT
sudo iptables -A INPUT -p ALL -i $INET_IFACE -d 192.168.0.255 -j ACCEPT
sudo iptables -A udp_inbound -p UDP -s 0/0 --destination-port 69 -j ACCEPT
#--Allow All QUAKE
sudo iptables -A INPUT -p udp -m udp --dport 27910:27912 -j ACCEPT
#--Allow All CSTRIKE
sudo iptables -A INPUT -p udp -m udp --dport 27915:27917 -j ACCEPT
#----SAVE
sudo iptables-save > /etc/ iptables.up.rules
#----RESTORE
sudo iptables-restore < /etc/ iptables.up.rules
#---FLUSH
sudo iptables -F
#---FINISH sudo iptables
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
     sudo cd ~/.scripts || local ERROR=1
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
    
    sudo apt-get install libssl1.0.0 libssl-dev || local ERROR=1
    sudo wget http://download-new.utorrent.com/endpoint/utserver/os/linux-x64-ubuntu-13-04/track/beta/ -O utserver.tar.gz || local ERROR=1
    sudo tar -zxvf utserver.tar.gz -C /opt/ || local ERROR=1
    sudo chmod 777 /opt/utorrent-server-alpha-v3_3/ || local ERROR=1
    sudo ln -s /opt/utorrent-server-alpha-v3_3/utserver /usr/bin/utserver || local ERROR=1
    sudo wget https://raw.githubusercontent.com/coelhocarlos/debian9-install/master/utorrent || local ERROR=1
    sudo chmod 755 utorrent || local ERROR=1
    sudo cp utorrent /etc/init.d/  || local ERROR=1
    sudo cd /etc/init.d/ || local ERROR=1
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
    sudo apt-get install ntfs-3g || local ERROR=1
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
    sudo apt=get install isc-dhcp-server || local ERROR=1
    sudo service isc-dhcp-server restart || local ERROR=1
    sudo /etc/init.d/tftpd-hpa restart || local ERROR=1
    return $ERROR
}
Install_mega(){
    cd $DOWNDIR
    sudo apt-get install megatools || local ERROR=1
    sudo apt-get install -f
    sudo cp ~/.megarc
    return $ERROR
}

Install_TestDisc(){
   cd $DOWNDIR
   sudo apt-get install testdisk   
   return $ERROR
}

Install_glances(){
  cd $DOWNDIR
  sudo apt-get install glances
  return $ERROR
}
