#
# Cookbook:: sensu-client-install
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.
#
#bash 'Install client package' do
#  cwd ::File.dirname(src_filepath)	
#  code <<-EOH
#    mkdir -p /home/centos/sensu
#    cd /home/centos/sensu
#    wget https://repositories.sensuapp.org/yum/6/x86_64/sensu-1.8.0-1.el6.x86_64.rpm
#    rpm -i sensu-1.8.0-1.el6.x86_64.rpm
#    EOH
#end
package 'wget'
script "install_sensu" do
  interpreter "bash"
  user "root"
  cwd "/tmp"
  code <<-EOH
    mkdir -p /home/centos/sensu
    cd /home/centos/sensu
    wget https://repositories.sensuapp.org/yum/6/x86_64/sensu-1.8.0-1.el6.x86_64.rpm
    rpm -i sensu-1.8.0-1.el6.x86_64.rpm
  EOH
not_if "rpm -qa | grep 'sensu'"
end
template '/etc/sensu/conf.d/client.json' do
  source 'client.json.erb'
end
template '/etc/sensu/conf.d/transport.json' do
  source 'transport.json.erb'
end
template '/etc/sensu/conf.d/rabbitmq.json' do
  source 'rabbitmq.json.erb'
end
#bash 'Install plugins' do
#  cwd ::File.dirname(src_filepath)
#  code <<-EOH
#    	/opt/sensu/embedded/bin/gem install sensu-plugins-disk-checks
#	/opt/sensu/embedded/bin/gem install sensu-plugins-memory-checks
#	/opt/sensu/embedded/bin/gem install sensu-plugins-process-checks
#	/opt/sensu/embedded/bin/gem install sensu-plugins-cpu-checks
#    	EOH
#end
script "install_plugins" do
  interpreter "bash"
  user "root"
  cwd "/tmp"
  code <<-EOH
    	/opt/sensu/embedded/bin/gem install sensu-plugins-disk-checks
	/opt/sensu/embedded/bin/gem install sensu-plugins-memory-checks
	/opt/sensu/embedded/bin/gem install sensu-plugins-process-checks
  	/opt/sensu/embedded/bin/gem install sensu-plugins-cpu-checks
  EOH
end
service "sensu-client" do
  action :restart
end
