Puppet::Type.newtype(:influxdb_user) do
  @doc = 'Manage Influxdb users.'

  ensurable

  autorequire(:class) { 'influxdb::install' }

  newparam(:name, :namevar => true) do
    desc 'The name of the Influxdb user to manage.'
  end

  newproperty(:password) do
    desc 'The password of the user'
    newvalue(/\w*/)
  end

  newproperty(:admin) do
    desc 'Whether the user should be an admin user'
    newvalues(:true, :false)
  end

  newproperty(:admin_username) do
    desc 'The username of the admin user to manage Influxdb (optional)'
    newvalue(/\w+/)
  end

  newproperty(:admin_password) do
    desc 'The password of the admin user to manage Influxdb (optional)'
    newvalue(/\w*/)
  end

end
