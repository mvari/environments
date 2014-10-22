node 'puppet-agent-r10k'{
    class{'monitoring::zabbix::server':
		zabbix_server => '192.168.150.56',
		listen_port   => '8080',
		db_password   => 'zabbix@pass#*'
}
}

node 'puppet-r10k'{
    class{'monitoring::zabbix::server':
                zabbix_server => '192.168.150.56',
                listen_port   => '8080',
                db_password   => 'zabbix@pass#*'
}
}

