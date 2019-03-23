if defined?(Mongoid)
  # GlobalID is used by ActiveJob (among other things)
  # https://github.com/rails/globalid

  Mongoid::Document.send(:include, GlobalID::Identification)
  if Mongoid::VERSION.split('.').first.to_i < 7
    Mongoid::Relations::Proxy.send(:include, GlobalID::Identification)
  else
    Mongoid::Association::Proxy.send(:include, GlobalID::Identification)
  end
end
