require File.expand_path(File.join(File.dirname(__FILE__), '..', 'influxdb'))
Puppet::Type.type(:influxdb_user).provide(:influxdb, :parent => Puppet::Provider::InfluxDB) do
  desc 'Manages InfluxDB databases.'

  mk_resource_methods

  commands :influx_cli => '/usr/bin/influx'

  def initialize(value={})
    super(value)
    @property_flush = {}
  end

  def self.instances
    begin
      output = influx_cli([command_args, '-execute', 'show users'].compact)
    rescue Puppet::ExecutionFailure => e
      return nil
    end
    users = output.split("\n")[1..-1]
    puts users.inspect
    users.collect do |name|
      new(:name  => name,
        :ensure  => :present,
      )
    end
  end

  def self.prefetch(resources)
    instances.each do |prov|
      if resource = resources[prov.name]
        resource.provider = prov
      end
    end
  end

  def flush
    if @property_flush[:ensure] == :absent
      influx_cli([command_args, '-execute', "DROP USER #{resource[:name]}"].compact)
      return
    end
    if @property_flush[:admin]
      admin_privs = "WITH ALL PRIVILEGES"
    else
      admin_privs = nil
    end
    influx_cli([command_args, '-execute',
      "CREATE USER #{resource[:name]} WITH PASSWORD '#{@property_flush[:password]}'",
      admin_privs].compact)
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    @property_flush[:ensure] = :present
  end

  def destroy
    @property_flush[:ensure] = :absent
  end

end
