#!/usr/bin/env ruby
require 'yaml'
require 'open3'
require 'fileutils'
if ENV['ENABLE_LOGRAGE'] == "true"
  stdout, stderr, status = Open3.capture3(%q{sed -i -e 's/<%=ENV\["RAILS_ENV"\]%>/} + ENV["RAILS_ENV"] + %q{/g' /var/awslogs/etc/awslogs.conf})
  stdout, stderr, status = Open3.capture3("/etc/init.d/awslogs start")
  puts stdout
  puts stderr
  puts status
  unless stderr.empty? && status.exitstatus == 0
    abort("Enabling Logging FAILED...")
  end
end
