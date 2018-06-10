#!/bin/bash
##### Control Script for instaslling prerequisites #####

####PRE SETUP####
apt_update(){
    apt-get update && apt-get -y upgrade &&  apt-get -y dist-upgrade
}
install_ruby() {
    echo " -------------- Installing Ruby -------------- "
    if [ ! -f /usr/bin/ruby ]; then
      /scripts/installruby
    fi
    return $?
}
remove_stuff() {
    cd $DOWNDIR
    rm  tar*
    rm  tar.gz*
    rm  deb*
    rm -rf $HOME/tmp
    mkdir -p $HOME/tmp
    return $?
}




check_threads() {
    echo " -------------- Checking For Perl Compatibility -------------- "
    if ! /usr/bin/perl -e "use threads;"
    then
        if [ -f /usr/bin/perl5.10.1 ]
        then
            mv /usr/bin/perl /usr/bin/perl.old
            ln -s /usr/bin/perl5.10.1 /usr/bin/perl
        else
            cd /usr/local/src
            rm -rf ActivePerl*
            wget http://downloads.activestate.com/ActivePerl/releases/5.18.1.1800/ActivePerl-5.18.1.1800-x86_64-linux-glibc-2.5-297570.tar.gz
            tar xzf ActivePerl*
            cd ActivePerl*
            sh install.sh --license-accepted --prefix /opt/wt-perl/ --no-install-html
            mv /usr/bin/perl /usr/bin/perl.old
            ln -s /opt/wt-perl/bin/perl-static /usr/bin/perl
        fi
    fi
    
    return $?
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
