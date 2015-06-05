# 使用时必须require lebbay::os::cronjob, 保证crontab和cronjob不会穿插执行
define lebbay::os::crontab(
    $ensure = present,
    $user = 'root',
    $content,
){
    $identifier = "crontab-${name}"

    file { "/tmp/$identifier" :
        ensure => $ensure,
        owner  => $user,
        mode   => 0644,
        content => inline_template("#begin-<%=identifier%>
$content
#end-<%=identifier%>
"),
    }

    if $ensure == present {
        exec { "create-$identifier":
            path => '/bin:/usr/bin:/usr/local/bin',
            unless => "crontab -u $user -l | sed -n '/begin-$identifier/,/end-$identifier/p' | diff /tmp/$identifier -",
            command => "crontab -u $user -l | sed '/begin-$identifier/,/end-$identifier/d' | cat - /tmp/$identifier | crontab -u $user -",
            require => File["/tmp/$identifier"],
        }
    }elsif $ensure == absent {
        exec { "rm-$identifier":
            path => '/bin:/usr/bin:/usr/local/bin',
            onlyif => "test -n \"$(crontab -u $user -l | sed -n '/begin-$identifier/,/end-$identifier/p')\"",
            command => "crontab -u $user -l | sed '/begin-$identifier/,/end-$identifier/d' | crontab -u $user -",
        }
    }
}
