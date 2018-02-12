# encoding: utf-8
# copyright: 2018, Chef Software Inc.

title 'chef client installed and up to date'

control 'chef-client installed and a non-EOL version' do
  impact 1.0
  title 'Make sure Chef Client is installed and a non-EOL version'
  if os[:family] == :linux # TODO: package resource doesn't work on SuSE
    describe package('chef') do
      it { should be_installed }
      its('version') { should match /^1[3-9]/ }
    end
  elsif os[:family] == :darwin
    describe command('pkgutil --pkg-info com.getchef.pkg.chef') do
      its('stderr') { should_not match /No receipt/ }
      its('stdout') { should_not match /version: [0-1]/ }
    end
  elsif os[:family] == :windows
    describe powershell('Get-Package -Name "Chef Client*" | Select-Object Version | Format-List') do
      its('stderr') { should be_empty } # will be an error if not installed
      its('stdout') { should match /Version : 1[3-9]/ }
    end
  end
