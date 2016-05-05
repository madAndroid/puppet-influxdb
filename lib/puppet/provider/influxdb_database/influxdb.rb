require File.expand_path(File.join(File.dirname(__FILE__), '..', 'influxdb'))
Puppet::Type.type(:influxdb_database).provide(:influxdb, :parent => Puppet::Provider::InfluxDB) do
  desc 'Manages InfluxDB databases.'

  commands :influx_cli => '/usr/bin/influx'

  def initialize(value={})
    super(value)
    @property_flush = {}
  end

  def self.instances
    begin
      output = influx_cli([command_args, '-execute', 'show databases'].compact)
    rescue Puppet::ExecutionFailure => e
      return nil
    end
    databases = output.split("\n")[3..-1]
    databases.collect do |name|
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
        influx_cli([command_args, '-execute', "drop database #{resource[:name]}"].compact)
        return
    end
    influx_cli([command_args, '-execute', "create database #{resource[:name]}"].compact)
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
