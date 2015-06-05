$icinga_server = 1.1.1.1
package { 'nrpe':
    ensure => latest,
}

package { 'nagios-plugins-all':
    ensure => latest,
}

augeas { "nrpe":
    context => "/files/etc/nagios/nrpe.conf",
    changes => [
        "set allowed_hosts = $icinga_server",
        ],
    require => Package['nrpe'],
} 


