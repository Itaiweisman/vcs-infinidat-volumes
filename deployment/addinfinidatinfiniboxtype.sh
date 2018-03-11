#!/bin/sh

VCSHOME="${VCS_HOME:-/opt/VRTSvcs}"
ro=`${VCSHOME}/bin/haclus -value ReadOnly`
if [ $ro -eq 1 ];
then
	${VCSHOME}/bin/haconf -makerw
fi
${VCSHOME}/bin/hatype -add infinidat-infinibox
${VCSHOME}/bin/hatype -modify infinidat-infinibox ArgList localbox UserLocal PasswordLocal remotebox UserRemote PasswordRemote dataset_type LocalCG RemoteCG LocalVols RemoteVols
${VCSHOME}/bin/hatype -modify infinidat-infinibox OpenTimeout 180
${VCSHOME}/bin/hatype -modify infinidat-infinibox OnlineTimeout 700
${VCSHOME}/bin/hatype -modify infinidat-infinibox RestartLimit 1
${VCSHOME}/bin/haattr -add infinidat-infinibox localbox -string
${VCSHOME}/bin/haattr -add infinidat-infinibox UserLocal -string
${VCSHOME}/bin/haattr -add infinidat-infinibox PasswordLocal -string
${VCSHOME}/bin/haattr -add infinidat-infinibox remotebox -string
${VCSHOME}/bin/haattr -add infinidat-infinibox UserRemote -string
${VCSHOME}/bin/haattr -add infinidat-infinibox PasswordRemote -string
${VCSHOME}/bin/haattr -add infinidat-infinibox dataset_type -string
${VCSHOME}/bin/haattr -add infinidat-infinibox LocalCG -string 
${VCSHOME}/bin/haattr -add infinidat-infinibox RemoteCG -string 
${VCSHOME}/bin/haattr -add infinidat-infinibox LocalVols -vector 
${VCSHOME}/bin/haattr -add infinidat-infinibox RemoteVols -vector 
#${VCSHOME}/bin/hatype -modify infinidat-infinibox RegList ComputeDRSLA
mkdir -p $VCSHOME/bin/infinidat-infinibox
ln -s /opt/VRTSvcs/bin/Script50Agent /opt/VRTSvcs/bin/infinidat-infinibox/infinidat-infinibox
ln -s /opt/VRTSvcs/bin/Script50Agent /opt/VRTSvcs/bin/infinidat-infinibox/infinidat-infiniboxAgent
cp ../Linux/online $VCSHOME/bin/infinidat-infinibox
cp ../Linux/offline $VCSHOME/bin/infinidat-infinibox
cp ../Linux/monitor $VCSHOME/bin/infinidat-infinibox
cp ../Linux/clean $VCSHOME/bin/infinidat-infinibox
cp ../Linux/open $VCSHOME/bin/infinidat-infinibox
cp ../Linux/close $VCSHOME/bin/infinidat-infinibox
cp ../Linux/*.pm $VCSHOME/bin/infinidat-infinibox
cp *.xml $VCSHOME/bin/infinidat-infinibox
chmod 744 $VCSHOME/bin/infinidat-infinibox
cp ../Linux/*.cf  /etc/VRTSvcs/conf/


if [ $ro -eq 1 ];
then
	${VCSHOME}/bin/haconf -dump -makero
else
	${VCSHOME}/bin/haconf -dump
fi
PERL="/opt/VRTSperl/bin/perl"
MAKE="/usr/bin/make"
cp REST-Client-273.tar.gz /tmp/
cp Module-Install-1.18.tar.gz /tmp
cd /tmp
tar xvzf REST-Client-273.tar.gz
tar xvzf Module-Install-1.18.tar.gz 
cd Module-Install-1.18
$PERL Makefile.PL
$MAKE
$MAKE install
cd /tmp/REST-Client-273
cd REST-Client-273.tar.gz
$PERL Makefile.PL
$MAKE
$MAKE install
cd /tmp/
rm -rf REST-Client-273 
rm -rf Module-Install-1.18
