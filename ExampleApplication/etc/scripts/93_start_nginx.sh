#!/usr/bin/env ruby
require 'open3'
if ENV['RUN_NGINX'] == "true"
  failed = true
  stdout, stderr, status = Open3.capture3("rm -f /etc/service/nginx/down")
  puts stdout
  puts stderr
  puts status
  failed = false if stderr.empty? && status.exitstatus == 0
  abort("Nginx won't start...") if failed
end
