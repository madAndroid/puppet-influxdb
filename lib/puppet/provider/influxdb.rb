class Puppet::Provider::InfluxDB < Puppet::Provider

  # Without initvars commands won't work.
  initvars

  commands :influx_cli => '/usr/bin/influx'

  def self.auth_enabled?
    unless @property_hash.nil?
      @property_hash[:admin_username].nil? false || true
    end
  end

  def self.command_args
    if auth_enabled?
      "-username #{@property_hash[:admin_username]} -password #{@property_hash[:admin_password]}"
    else
      nil
    end
  end

  def command_args
    self.class.command_args
  end

  def auth_enabled?
    self.class.auth_enabled?
  end

end
