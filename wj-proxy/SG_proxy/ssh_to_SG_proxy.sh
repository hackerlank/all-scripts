#!/bin/bash 

#SG-proxy-0
ssh -p58022 ec2-user@52.76.6.27 -i /root/.ssh/sg_proxy.pem
#SG-proxy-1
ssh -p58022 ec2-user@52.76.11.171 -i /root/.ssh/sg_proxy.pem
#SG-proxy-2
ssh -p58022 ec2-user@52.74.98.63 -i /root/.ssh/sg_proxy.pem
#SG-proxy-3
ssh -p58022 ec2-user@52.76.15.252 -i /root/.ssh/sg_proxy.pem
#SG-proxy-4
ssh -p58022 ec2-user@52.76.48.59 -i /root/.ssh/sg_proxy.pem
#SG-proxy-5
ssh -p58022 ec2-user@52.76.48.40 -i /root/.ssh/sg_proxy.pem
#SG-proxy-6
ssh -p58022 ec2-user@52.76.48.22 -i /root/.ssh/sg_proxy.pem
#SG-proxy-7
ssh -p58022 ec2-user@52.76.31.229 -i /root/.ssh/sg_proxy.pem
