define proxy::os::user(
    $ensure = "present",
    $shell = "/bin/bash",
    $sudoer = false
){
    user { "$name" :
        ensure     => $ensure,
	shell	   => $shell,
        managehome => true,
    }

    file { "$name.ssh" :
        path       => "/home/$name/.ssh",
        ensure     => directory,
        owner      => $name,
        group      => $name,
        mode       => 700,
        require    => User[$name],
    }

    file { "$name.keys" :
        path       => "/home/$name/.ssh/authorized_keys",
        ensure     => present,
        owner      => $name,
        group      => $name,
        mode       => 600,
        require    => File["$name.ssh"],
        source     => "puppet:///modules/proxy/os/user/$name/authorized_keys",
    }

    if($sudoer){
        augeas { "$name.sudo":
            context => "/files/etc/sudoers",
            changes => [
                "set spec[user = '$name']/user $name",
                "set spec[user = '$name']/host_group/host ALL",
                "set spec[user = '$name']/host_group/command ALL",
                "set spec[user = '$name']/host_group/command/runas_user root",
                "set spec[user = '$name']/host_group/command/tag NOPASSWD",
                ],
        }
    }
}
