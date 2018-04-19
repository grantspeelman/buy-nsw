if !defined?(APP_VERSION) && File.exists?("BUILD")
  APP_VERSION = File.read("BUILD").strip
  APP_VERSION_TIME = File.mtime("BUILD")
end
