if !defined?(APP_VERSION) && File.exists?("BUILD")
  APP_VERSION = File.read("BUILD")
end
