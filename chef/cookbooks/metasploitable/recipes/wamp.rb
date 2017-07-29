#
# Cookbook:: metasploitable
# Recipe:: wamp
#
# Copyright:: 2017, The Authors, All Rights Reserved.

powershell_script 'Download WAMP server' do
  code '(New-Object System.Net.WebClient).DownloadFile(\'https://sourceforge.net/projects/wampserver/files/WampServer 2/WampServer 2.2/wampserver2.2d-x64.exe\', \'C:\Windows\Temp\wampserver2.2.d-x64.exe\')'
end

execute 'Install WAMP Server' do
  command "C:\\Windows\\Temp\\wampserver2.2.d-x64.exe /verysilent"
end

batch 'Copy configuration' do
  code <<-EOH
    copy /Y "C:\\vagrant\\resources\\wamp\\httpd.conf" "C:\\wamp\\bin\\apache\\Apache2.2.21\\conf\\httpd.conf"
    copy /Y "C:\\vagrant\\resources\\wamp\\phpmyadmin.conf" "C:\\wamp\\alias\\phpmyadmin.conf"
    EOH
end

batch 'Configure permissions' do
  code <<-EOH
    icacls "C:\\wamp" /grant "NT Authority\\LOCAL SERVICE:(OI)(CI)F" /T
    sc config wampapache obj= "NT Authority\\LOCAL SERVICE"
  EOH
end

windows_service 'wampapache' do
  action [:start, :enable]
  startup_type :automatic
end

windows_service 'wampmysqld' do
  action [:start, :enable]
  startup_type :automatic
end

