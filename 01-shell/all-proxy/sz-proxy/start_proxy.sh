#!/bin/bash
autossh -NfL *:10005:192.168.1.41:9003  -i /root/.ssh/sh_41 -p32201 httpproxy@101.231.200.238
autossh -NfL *:10006:192.168.1.41:9004  -i /root/.ssh/sh_41 -p32201 httpproxy@101.231.200.238

