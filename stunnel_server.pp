# Ensure stunnel RPM installed
package { 'stunnel' :
    ensure => 'installed',
    before => File['/etc/stunnel/stunnel.conf','/etc/init.d/stunnel']
}
# Copy the stunnel config file
file { '/etc/stunnel/stunnel.conf':
    ensure => 'present',
    content => template('/etc/puppet/templates/stunnel.server.erb')
}
# Create the stunnel startup script
file { '/etc/init.d/stunnel':
    ensure => 'present',
    source => template('/etc/puppet/templates/stunnel-startup.erb'),
    mode   => 755,
}
# Create the Group
group { "stunnel" :
    ensure => "present"
}

# Create the User
user { "stunnel":
    ensure => present,
    comment => "Stunnel daemon",
    gid => "stunnel",
    shell => "/sbin/nologin",
    home => "/var/run/stunnel",
    require => Group["stunnel"],
  }
# Set the Permissions
file { "/var/run/stunnel":
  ensure => "directory",
  owner  => "stunnel",
  group  => "stunnel",
}
file { "/var/log/stunnel":
  ensure => "directory",
  owner  => "stunnel",
  group  => "stunnel",
}
file { "/etc/stunnel":
  ensure => "directory",
  owner  => "stunnel",
  group  => "stunnel",
}

# Create the Cert
$directory = '/etc/stunnel'
$keyname = "stunnel"
$pem_file = "$keyname.pem"

exec {  "create_key":
        command => "/usr/bin/openssl req -new -x509 -days 365 -nodes -out stunnel.pem -keyout stunnel.pem -subj  '/CN=$keyname'",
        cwd     => $directory,
}

# Set the Permission
file { '/etc/stunnel/stunnel.pem':
    ensure => 'present',
    owner => 'stunnel',
    group => 'stunnel',
}

# Set stunnel to start at startup
service { 'stunnel':
  enable => true,
}

# Start the Service
exec { "start_service":
    command => "/etc/init.d/stunnel start",
}
