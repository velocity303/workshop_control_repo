class profile::myapp {

      package {'unzip': 
        ensure => present, 
      }

      $doc_root = '/var/www/generic_website'
      class { 'apache':
        default_vhost => false,
      }

      file { $doc_root:
        ensure => directory,
        owner  => $::apache::user,
        group  => $::apache::group,
        mode   => '0755',
      }

      apache::vhost { $::fqdn:
        port    => '80',
        docroot => $doc_root,
        require => File[$doc_root],
      }

      staging::deploy { 'pl_generic_site.zip':
        source  => 'https://github.com/velocity303/demo-control-repo/blob/production/site/profile/files/pl_generic_site.zip?raw=true',
        target  => $doc_root,
        require => Apache::Vhost[$::fqdn],
        creates => "${doc_root}/index.html",
      }

      firewall { '100 allow http':
        proto  => 'tcp',
        dport  => '80',
        action => 'accept',
      }

 
}
