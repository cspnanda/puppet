case $::osfamily {
  /^(?i:Redhat|Centos)$/: { 
      notify {"Installing package for Centos":}
      package { 'vim' :
          ensure => 'installed'
      }
  }
  /^(?i:Debian|Ubuntu)$/: {
      notify {"Installing package for debian":}
      package { 'vim' :
          ensure => 'installed'
      }
  }
}
