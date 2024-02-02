Name: ppes-rtsp
Summary: rtsp docker for ppes
Version: %(git rev-parse --short HEAD)
Release: 1
License: MIT

%description 
rtsp docker for ppes

%define _pwd %(echo $PWD)/
%define _rpmdir %(echo $PWD)/rpm

%install
mkdir -p %{buildroot}
cp %{_pwd}/ppes-rtsp.tar %{buildroot}

%post 
docker load --input ppes-rtsp.tar
rm -f /ppes-rtsp.tar

%files
/ppes-rtsp.tar