#!/bin/bash -e


if [ "$UID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

if [ -x /usr/bin/yum ]; then
  rpm -Uvh http://repo.zabbix.com/zabbix/3.0/rhel/6/x86_64/zabbix-release-3.0-1.el6.noarch.rpm
  yum -y install zabbix-agent

  sed -i 's/Server=127.0.0.1/Server=172.16.11.51/' /etc/zabbix/zabbix_agentd.conf
  sed -i 's/ServerActive=127.0.0.1/ServerActive=172.16.11.51/' /etc/zabbix/zabbix_agentd.conf
  sed -i "s/Hostname=Zabbix/#Hostname=/" /etc/zabbix/zabbix_agentd.conf
  sed -i "s/# HostnameItem=system.hostname/HostnameItem=system.hostname/" /etc/zabbix/zabbix_agentd.conf
  sed -i "s/# HostMetadataItem=/HostMetadataItem=system.uname/" /etc/zabbix/zabbix_agentd.conf
  chkconfig zabbix-agent on
  service zabbix-agent restart
fi

if [ -x /usr/bin/apt-get ]; then
  wget http://repo.zabbix.com/zabbix/3.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_3.0-2+xenial_all.deb
  dpkg -i zabbix-release_3.0-2+xenial_all.deb
  
  apt-get update
  apt-get -y install zabbix-agent 
  sed -i 's/Server=127.0.0.1/Server=172.16.11.51/' /etc/zabbix/zabbix_agentd.conf
  sed -i 's/ServerActive=127.0.0.1/ServerActive=172.16.11.51/' /etc/zabbix/zabbix_agentd.conf
  sed -i "s/Hostname=Zabbix/#Hostname=/" /etc/zabbix/zabbix_agentd.conf
  sed -i "s/# HostnameItem=system.hostname/HostnameItem=system.hostname/" /etc/zabbix/zabbix_agentd.conf
  sed -i "s/# HostMetadataItem=/HostMetadataItem=system.uname/" /etc/zabbix/zabbix_agentd.conf

  service zabbix-agent restart
fi

