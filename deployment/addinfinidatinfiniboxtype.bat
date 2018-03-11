@echo on
"%VCS_HOME%"\bin\haconf -makerw
"%VCS_HOME%"\bin\hatype -add infinidat-infinibox0
"%VCS_HOME%"\bin\hatype -modify infinidat-infinibox0 ArgList localbox UserLocal PasswordLocal remotebox UserRemote PasswordRemote LocalCG RemoteCG
"%VCS_HOME%"\bin\hatype -modify infinidat-infinibox0 OpenTimeout 180
"%VCS_HOME%"\bin\hatype -modify infinidat-infinibox0 OnlineTimeout 700
"%VCS_HOME%"\bin\hatype -modify infinidat-infinibox0 RestartLimit 1
"%VCS_HOME%"\bin\haattr -add infinidat-infinibox0 localbox -string
"%VCS_HOME%"\bin\haattr -add infinidat-infinibox0 UserLocal -string
"%VCS_HOME%"\bin\haattr -add infinidat-infinibox0 PasswordLocal -string
"%VCS_HOME%"\bin\haattr -add infinidat-infinibox0 remotebox -string
"%VCS_HOME%"\bin\haattr -add infinidat-infinibox0 UserRemote -string
"%VCS_HOME%"\bin\haattr -add infinidat-infinibox0 PasswordRemote -string
"%VCS_HOME%"\bin\haattr -add infinidat-infinibox0 dataset_type -string
"%VCS_HOME%"\bin\haattr -add infinidat-infinibox0 LocalCG -string 
"%VCS_HOME%"\bin\haattr -add infinidat-infinibox0 RemoteCG -string 

"%VCS_HOME%"\bin\haattr -add infinidat-infinibox0 LocalVols -vector
"%VCS_HOME%"\bin\haattr -add infinidat-infinibox0 RemoteVols -vector

"%VCS_HOME%"\bin\haconf -dump -makero
mkdir "%VCS_HOME%"\bin\infinidat-infinibox0
mkdir "%VCS_HOME%"\conf\sample_infinidat-infinibox0
copy ..\Windows-1\*.pl "%VCS_HOME%"\bin\infinidat-infinibox0
copy ..\Windows-1\*.pm "C:\program files\Verias\VRTSperl\lib"
copy infinidat-infinibox0.xml "%VCS_HOME%"\bin\infinidat-infinibox0
copy infinidat-infinibox0.dll "%VCS_HOME%"\bin\infinidat-infinibox0
copy infinidat-infinibox0Typess.cf "%VCS_HOME%"\conf\sample_infinidat-infinibox0



