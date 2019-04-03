# # encoding: utf-8

# Inspec test for recipe nginx_test::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

unless os.windows?
  # This is an example test, replace with your own test.
  describe user('root') do
    it { should exist }
  end
end

describe port(80) do
  it { should be_listening }
end

describe package('nginx') do
  it { should be_installed } # the package should be installed
end

describe file('/etc/nginx/sites-available/default') do
  it { should exist } # the configuration file should exist
end

describe command('curl localhost') do
  its('stdout') { should match 'Welcome' }
  # nginx must send back 404 at our request
end
