#搭建azazie完整环境的说明

## 操作前请先看一遍这段说明
#### * vpc.sh 脚本主要用来做 ` https://g.pupugao.com/hwang/infrastructure/wikis/aws `这里的一些初始化工作，生成security group、sns 等等。
#### * init_deployer.sh 脚本主要是初始化第一个 deployer
#### * 下面都是在ubuntu14.04（全新安装的虚拟机）上操作；测试浏览是在实体机上（需修改hosts文件）
#### * 脚本都是在README.MD同级目录下执行，因为需要用到同级目录和子目录的一些文件
#### * 下文提及的 jenkins.pupugao.com 在实际操作中应该改为操作者新安装的jenkins的实际地址。
#### * 下文提及的region和deployer依据实际操作的region和deployer做调整
#### * 下文新起的aws的机器的端口都是 38022
#### * 其他机器只能从deployer上登录；从deployer上连接其他机器需要使用ec2-user身份，在/home/ec2-user目下执行 `. ssh-agent.sh`


---

# 初始化完整实战步骤
1、准备以下几个文件：

|文件|用途|放置位置|
|---|---|---|
|azazie.sql.tar.gz	|初始数据库	|此README.md的同级目录|
|test_rsa	|测试环境的deployer的key	|此README.md的同级目录下的keys目录里|
|id_rsa	|	备份到杭州用的key|此README.md的同级目录下的 config_repo_tmpl/cms/config/zzcms-prod/ 目录里|
|aws.cms	|	网站内部之间访问用的key|此README.md的同级目录下的 config_repo_tmpl/lestore-vm/config/common/ 目录里|
|rsync.pwd	|	同步wiki账号用|此README.md的同级目录下的 config_repo_tmpl/cms/config/zzcms-prod/ 目录里|
|rsync.pwd	|	同步wiki账号用|config_repo_tmpl/editor/config/zzeditor-prod/|
|rsync.pwd	|	同步wiki账号用|config_repo_tmpl/osticket/config/zzticket-prod/|

登录ubuntu14.04虚拟机，做以下几个操作：

	sudo dpkg-reconfigure tzdata # 设置时区，选择亚洲/上海
	sudo apt-get update --fix-missing && sudo apt-get install git python-pip build-essential subversion jq vim -y
	sudo pip install awscli
	
输入 whereis aws 如果找出的aws路径不是 /usr/local/bin/aws 则需执行下面一行命令：

	PATH=/usr/local/bin/:$PATH

接着操作：

	cd ~
	git config --global http.sslverify false
	git config --global http.postBuffer 524288000
	git clone https://g.pupugao.com/devops/lestore_devops.git
	cd ~/lestore_devops/modules/lestore-stack/stages/initaws/aws # 后续操作都以此目录为基础
	mkdir -p keys
	
将azazie.sql.tar.gz放到~/lestore_devops/modules/lestore-stack/stages/initaws/aws目录下
将test_rsa放到 ~/lestore_devops/modules/lestore-stack/stages/initaws/aws/keys目录下

2、修改aws_credential文件里的配置，如下：

	region=eu-west-1
	#设置 access key 和 secret key （使用有aws管理员权限的账号下生成的Access Credentials；此配置可以在此文件里修改，也可以export到当前环境变量里）
	export AWS_ACCESS_KEY_ID=xxx
	export AWS_SECRET_ACCESS_KEY=yyy

然后运行 `time bash vpc.sh | tee vpc.log`；完成之后，待rds master启动好后，手动创建rds slave，取名azazieslave（rds master生成需要一定时间，可以先操作后面步骤，在要操作后面的第7步的时候再来创建rds slave）；手动建ses(`由于新区开通发邮件需要发case给aws开通需要一段时间，此处可以省略ses设置`)；对于脚本里创建的iam user，还需手动去生成Access Credentials，后面配置config_repo_tmpl/config.manual.conf会用到(__AWS_S3_ACCESS_KEY__和__AWS_S3_SECRET_KEY__使用jjshouse_vm_cms-a账号下生成的，__AWS_ACCESS_KEY__和__AWS_SECRET_KEY__使用jjshouse_vm_normal-a账号下生成的)

3、将deployer机器ip添加到aws test环境(另一个aws账号)的us-east-1区下名称为lestore-devops-deployer的security group里, 端口号为38022和39000-39010

4、在当前目录运行 `time bash init_deployer.sh | tee init_deployer.log` 部署第一台deployer，根据脚本提示操作（一般只需提供第二步里生成的deployer机器的域名或ip即可）；

5、在ubuntu14.04虚拟机上安装jenkins,可以先运行脚本install_jenkins.sh安装jenkins，然后参照（  https://g.pupugao.com/hwang/infrastructure/wikis/jenkins ）；

访问安装的jenkins，添加slave node：
  * 先在jenkins上添加credentials，地址：https://jenkins.pupugao.com/jenkins/credential-store/domain/_/ 
  * `Kind` 选择 `SSH Username with private key`
  * `Username` 输入 `ec2-user`
  * `Private Key` 输入`devops_rsa`的内容【可登录deployer(`ssh -p38022 -i keys/devops_rsa ec2-user@DEPLOYER_DOMAIN`)，复制deployer上/home/ec2-user/.awstools/keys/devops_rsa里的内容】；
  * 这里可以直接修改deployer-zy这个node，修改的参数见下面：

	启动方法->Host: 新deployer的域名
	启动方法->Credentials: 选择前面设置的Credentials
	键值对列表->config_repo_addr: 新的存放正式环境配置文件的服务器地址，这里跟“启动方法->Host”里的一致
	config_repo_key: 登陆存放正式环境配置文件的服务器的ssh key(/home/ec2-user/.awstools/keys/devops_rsa)
	ssh_agent_pid: 在配置deployer服务器中执行cat ~/ssh-agent.sh时SSH_AGENT_PID值
	ssh_auth_sock: 在配置deployer服务器中执行cat ~/ssh-agent.sh时SSH_AUTH_SOCK值
	
发布项目svn deployer（发布选择的参数见第9步表格`# 发布操作参数列表`的`project`为`svn deployer`行），操作参考地址： https://jenkins.pupugao.com/jenkins/view/DevOps/job/devops.deployer.zz.deploy/build?delay=0sec 

6、起机器，操作参数见下面表格`# 起机器操作参数列表`（ssd，sr，logman，eseditor，search2组，cms，ticket，prod2组）

\# 起机器操作参数列表 ↓

|project|jenkins job|stack_id|deployer|region|deployer_action|stage_name|stack_params|zones|
|---|---|---|---|---|---|---|---|---|
|ssd|stack.zz-ssd-prod.deploy|0|deployer-zy|eu-west-1|deploy|ssd-prod|FrontEnd:ssdp|b|
|sr|stack.zz-sr-prod.deploy|0|deployer-zy|eu-west-1|deploy|sr-prod|FrontEnd:srp|b|
|logman|stack.zz-logman-prod.deploy|0|deployer-zy|eu-west-1|deploy|logman-prod|FrontEnd:lmp|b|
|eseditor( 含v5-eseditor, v5-eseditor-cache_updater, v5-eseditor-api )|stack.zz-eseditor-prod.deploy|0|deployer-zy|eu-west-1|deploy|eseditor-prod|FrontEnd:esep|b|
|searcher-0|stack.zz-all.deploy|0|deployer-zy|eu-west-1|deploy|azazie-search-prod|-|-|
|searcher-2|stack.zz-all.deploy|2|deployer-zy|eu-west-1|deploy|azazie-search-prod|-|-|
|osticket|stack.zz-all.deploy|0|deployer-zy|eu-west-1|deploy|osticket-prod|FrontEnd:otp|b|
|cms,editor,newsletter|stack.zz-all.deploy|0|deployer-zy|eu-west-1|deploy|cms-prod|FrontEnd:cmsp|b|
|front-0(含v5-prod-0)|stack.zz-all.deploy|0|deployer-zy|eu-west-1|deploy|zz-prod|FrontEnd:zzp|b|
|front-2(含v5-prod-2)|stack.zz-all.deploy|2|deployer-zy|eu-west-1|deploy|zz-prod|FrontEnd:zzp|b|


7、继续在虚拟机上修改`config_repo_tmpl/config.manual.conf`配置文件，然后执行`bash config_repo_tmpl/auto_config.sh`，成功之后执行 `bash upconf.sh`将配置文件推送到deployer并在deployer生成好 config_repo；将 cms和ticket机器的公网ip加入到杭州192.168.2.1的iptables的白名单里（修改/var/job/ip_port文件，在873端口后面加ip，然后运行 /var/job/iptables）

8、发布应用ssd( https://jenkins.pupugao.com/jenkins/job/zz-ssd.prod.deploy/build?delay=0sec 操作相关的参数见第9步表格 project 为 ssd 一行)；登录deployer，从deployer推azazie.sql.tar.gz grant.sql到ssd机器;可以运行 push_sql.sh脚本用于推送相关内容并在ssd机器上导入sql；相关命令例子：
`$ . ssh-agent.sh
$ scp -P38022 azazie.sql.tar.gz $SSD_DOMAIN:~/
$ scp -P38022 grant.sql $SSD_DOMAIN:~/`
然后从deployer登录ssd，在ssd上解压azazie.sql.tar.gz后导入数据库数据，在ssd上导入grant.sql到数据库，导入操作的命令例子（数据库主机地址在aws的rds里查看，数据库账号密码使用vpc.sh脚本里的配置）：
`mysql -hazazie.ckkpbpfxpmj7.eu-west-1.rds.amazonaws.com -P3306 -uzydbroot -p < azazie.sql
mysql -hazazie.ckkpbpfxpmj7.eu-west-1.rds.amazonaws.com -P3306 -uzydbroot -p < grant.sql`

9、访问jenkins，发布项目；详细操作参数见下表，请按下面表格顺序发布。

\# 发布操作参数列表 ↓

|project|jenkins job|vm_action|stack|stack_id|region|deployer|stage_name|
|---|---|---|---|---|---|---|---|
|svn deployer|devops.deployer.zz.deploy|-|default|0|eu-west-1|deployer-zy|-|
|git deployer|devops.deployer.git.zz.deploy|-|default|0|eu-west-1|deployer-zy|-|
|ssd|zz-ssd.prod.deploy|-|default|0|eu-west-1|deployer-zy|ssd-prod|
|sr|zz-sr.prod.deploy|-|default|0|eu-west-1|deployer-zy|sr-prod|
|logman|zz-logman.prod.deploy|-|default|0|eu-west-1|deployer-zy|logman-prod|
|searcher-0|lestore-search.zz.deploy|install_and_index|default|0|eu-west-1|deployer-zy|-|
|searcher-2|lestore-search.zz.deploy|install_and_index|default|2|eu-west-1|deployer-zy|-|
|osticket|zz-osticket-prod.deploy|-|-|0|eu-west-1|deployer-zy|-|
|cms|zzcms-prod.deploy|-|-|0|eu-west-1|deployer-zy|-|
|editor|zz-editor.prod.deploy|-|-|0|eu-west-1|deployer-zy|-|
|v5-prod-0|zz-v5-prod.deploy|install|default|0|eu-west-1|deployer-zy|zz-prod|
|v5-prod-2|zz-v5-prod.deploy|install|default|2|eu-west-1|deployer-zy|zz-prod|
|prod-0|zz-prod.git.deploy|install|default|0|eu-west-1|deployer-zy|-|
|prod-2|zz-prod.git.deploy|install|default|2|eu-west-1|deployer-zy|-|
|v5-eseditor|zz-v5-prod.deploy|install|default|0|eu-west-1|deployer-zy|eseditor-prod|
|v5-eseditor-cache_updater|zz-v5-prod.deploy|install_cache-updater|default|0|eu-west-1|deployer-zy|eseditor-prod|
|v5-eseditor-api|zz-v5-prod.deploy|install_api|default|0|eu-west-1|deployer-zy|eseditor-prod|
|eseditor|zz-esmeralda-editor-prod.deploy|install|default|0|eu-west-1|deployer-zy|eseditor-prod|
|newsletter|zznl-prod.git.deploy|-|-|0|eu-west-1|deployer-zy|-|

###### 发布完 prod 之后，去掉 http basic 验证（地址：https://jenkins.pupugao.com/jenkins/job/lestore-ops.zz.deploy/build?delay=0sec ），操作参数如下：

|Project|stage_name|stack_id|vm_action|stack|force|region|deployer|
|---|---|---|---|---|---|---|---|
|lestore-ops.zz.deploy|zz-prod|0|prod_env|default|√|eu-west-1|deployer-zy|
|lestore-ops.zz.deploy|zz-prod|2|prod_env|default|√|eu-west-1|deployer-zy|


10、下面还有一些与访问有关的操作；检查最终结果： https://g.pupugao.com/hwang/infrastructure/wikis/checklist

下面①②③可使用当前目录的脚本 `set_ssh_agent_and_know_hosts.sh` 在deployer上执行一起自动完成

\# ① 在sr机器上设置know_hosts

	sudo su
	killall ssh-agent
	ssh-agent > /var/job/ssh-agent.sh
	. /var/job/ssh-agent.sh
	chmod 700 /var/job/ssh-agent.sh
	ssh-add /root/.ssh/aws.cms
	ssh -p38022 syncer@$CMS_DOMAIN

\# ② 在cms机器上设置know_hosts
	
	sudo su
	killall ssh-agent
	ssh-agent > /var/job/ssh-agent.sh
	chmod 700 /var/job/ssh-agent.sh
	. /var/job/ssh-agent.sh
	ssh-add /root/.ssh/aws.cms
	ssh-add /var/www/http/zzcms-prod/stages/zzcms-prod/id_rsa
	ssh -p38022 syncer@$SR_DOMAIN
	## 继续在cms机器设置know_hosts
	ssh -p32200 syncer@115.236.98.66
	ssh -p32200 product@115.236.98.67

\# ③ 在logman机器上设置ssh-agent
	
	sudo su
	killall ssh-agent
	ssh-agent > /var/job/ssh-agent.sh
	chmod 700 /var/job/ssh-agent.sh
	. /var/job/ssh-agent.sh
	ssh-add /home/ec2-user/.awstools/keys/prod_rsa

\# ④ HZ -> SSD

\# ⑤ 设置 hosts;可以运行set_hosts.sh脚本一键设置；

	## 在prod机器设置（仅修改下面ip，此处ip为内部ip）
	172.31.35.173	t.azazie.com  # ticket机器内部ip
	172.31.42.21	up.azazie.com img.azazie.com  # 目前 ip 同cms
	## 在ticket机器设置（仅修改下面ip，此处ip为内部ip）
	172.31.42.21	up.azazie.com img.azazie.com  # 目前 ip 同cms
	## 在cms设置（下面不用修改）
	127.0.0.1       up.azazie.com img.azazie.com  # 目前 ip 同cms

\# ⑥ 最后设置本地实体机 hosts 以测试前面发布的应用(仅修改下面ip，这里ip是外部ip；可以自动生成，见最后面的`使用脚本获取应用外部ip与域名对应关系`部分说明）

	54.76.176.141   p.azazie.com
	54.76.131.147   www.azazie.com 
	54.76.146.27    t.azazie.com
	54.72.206.119   cms.azazie.com
	54.72.206.119   editor.azazie.com
	54.72.206.119   img.azazie.com 
	54.72.206.119   up.azazie.com
	54.72.206.119   newsletter.azazie.com
	54.76.149.150  eseditor.azazie.com


---
## 注意：
  * `脚本运行完后，会创建sns的topic，它会发一封邮件到vpc.sh里设置的邮箱，需要去点击激活一下。`
  * `成功运行完脚本后还需手动操作的有：ip, ses, route53, rds slave, elb的需要手动添加https listener和证书`
  * `此处省略route53的设置，对主机的访问全部采用绑定hosts的方式`
  * `此处省略elb https(需要证书)的操作`

---
## 获取机器的内外网ip
  * 在deployer上执行 `make -C ~/deployer/stages/ _gender region=eu-west-1`，获取机器的内网ip，会自动写入到deployer的 /etc/hosts 文件，方便直接通过机器名登录其他机器
  * 在deployer上执行 `make -C ~/deployer/stages/ _getip region=eu-west-1` ，获取机器的外网ip

---
## 使用脚本获取应用外部ip与域名对应关系
  * 在deployer上执行 `make _gethostip region=eu-west-1 -C lestore-deployer/stages` ，获取各个应用的外部ip与域名的对应关系，方便添加到本地实体机hosts文件以测试发布的应用；
  * 上面一条命令也可以在本地ubuntu14.04虚拟机上此README.md同级目录下执行 `make _gethostip region=eu-west-1 -C ../../../../lestore-deployer/stages` ，获取各个应用的外部ip与域名的对应关系，方便添加到本地实体机hosts文件以测试发布的应用；

---
## 添加新商品上架之后如果在列表页没有显示也不能搜索到，则使用下面方法刷缓存

	# 从 deployer 登录上 eseditor 机器执行下面命令：
	cd /var/www/http/cache-updater_v5-prod/zz
	./flush_cache.sh -m -p -l=en
	# 执行完再去检查是否列表页是否有新添加的商品了，是否可以搜索到


