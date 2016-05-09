Puppet::Type.newtype(:influxdb_database) do
  @doc = 'Manage Influxdb databases.'

  ensurable

  autorequire(:class) { 'influxdb::service' }

  newparam(:name, :namevar => true) do
    desc 'The name of the Influxdb database to manage.'
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
