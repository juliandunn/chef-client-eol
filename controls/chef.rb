# encoding: utf-8
# copyright: 2018, Chef Software Inc.

title 'Chef client installed and up to date'

control 'chef-client installed and a non-EOL version' do
  impact 1.0
  title 'Make sure Chef client is installed and a non-EOL version'
  if os.aix?
    describe command('lslpp -lcq chef') do
      its('stderr') { should be_empty }
      its('stdout') { should match /\:chef\:1[3-9]/ }
    end
  elsif os.darwin?
    describe command('pkgutil --pkg-info com.getchef.pkg.chef') do
      its('stderr') { should_not match /No receipt/ }
      its('stdout') { should match /version: 1[3-9]/ }
    end
  elsif os.suse?
    describe command('zypper product-info package:chef') do
      its('stdout') { should_not match /product.*not found/ }
      its('stdout') { should match /Version\s+:\s+1[3-9]/ }
    end
  elsif os.windows?
    describe powershell('Get-Package -Name "Chef Client*" | Select-Object Version | Format-List') do
      its('stderr') { should be_empty } # will be an error if not installed
      its('stdout') { should match /Version : 1[3-9]/ }
    end
  else
    # The default case checks the version directly from the package.
    # If your platform is not covered here and you need some other functionality,
    # you can add a conditional block above.
    describe package('chef') do
      it { should be_installed }
      its('version') { should match /^1[3-9]/ }
    end
  end
end
