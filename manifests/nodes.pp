node default {
}

node /^cmgmt01p(1|2)/ {
  #class{ 'mrepo': }
  #class{ 'puppetdb::database::postgresql':
  #  listen_addresses       => 'localhost',
  #  manage_firewall => false,
  #}
  #class{ 'puppetdb::server':
  #  database_host          => 'localhost',
  #  listen_address         => '0.0.0.0',
  #  ssl_listen_address     => '0.0.0.0',
  #  manage_firewall => false,
  #}
  #class{ 'puppet':
  #  mode            => 'server',
  #  db              => 'puppetdb',
  #  db_port         => '8081',
  #  db_server       => 'cpuppetdb01.corp.sharpcast.com',
  #  db_user         => 'puppetdb',
  #  db_password     => 'md53cbf124486f5dca866b9eb0d6a3bb314',
  #  ca_authority    => true,
  #  ca_server       => 'puppet.corp.sharpcast.com',
  #  server_certname => 'puppet.corp.sharpcast.com',
  #  autosign        => true,
  #  passenger       => true,
  #  require         => Class['yum'],
  #  my_class        => 'puppet::server::data',
  #}
  #Class['puppetdb::database::postgresql'] -> Class['puppetdb::server'] -> Class['puppet']
  class { 'r10k':
    sources       => {
      'puppet'    => {
        'remote'  => 'https://stash.corp.sharpcast.com:8443/scm/ops/environments.git',
        'basedir' => "${::settings::confdir}/environments",
        'prefix'  => false,
      },
      'hiera'     => {
        'remote'  => 'https://bob.com',
        'basedir' => "${::settings::confdir}/hieradata",
        'prefix'  => false,
      }
    },
    purgedirs         => "${::settings::confdir}/environments",
    manage_modulepath => true,
    modulepath        => "${::settings::confdir}/environments/\$environment/modules",
  }
}
node /^cpuppetdb01/ {
  class{ 'postgresql::globals': version => '9.2', manage_firewall => false, }
  class{ 'puppetdb::database::postgresql':
    listen_addresses       => 'localhost',
    manage_firewall => false,
  }
  class{ 'puppetdb::server':
    database_host          => 'localhost',
    ssl_listen_address     => '0.0.0.0',
    listen_address         => '0.0.0.0',
    manage_firewall => false,
  }
}
