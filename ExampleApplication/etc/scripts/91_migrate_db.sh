#!/usr/bin/env ruby
require 'open3'

if ENV['RUN_MIGRATE'] == "true"
  def clear_warnings(stderr)
    no_more_warnings = stderr.gsub(/mysqldump\: \[Warning\] Using a password on the command line interface can be insecure\./, '')
    no_more_warnings.strip
  end

  failed = true
  Dir.chdir('/home/app/myapp'){
    loop do
      stdout, stderr, status = Open3.capture3("SKIP_IMPLICIT=true setuser app bundle exec rake db:migrate")
      stderr = clear_warnings(stderr)
      puts stdout
      puts stderr
      puts status
      if stderr.empty? && status.exitstatus == 0
        failed = false
        break
      elsif !stderr.include?("Can't connect to MySQL server on")
        break
      end

      sleep(10)
    end
  }
  abort("Migrating Database FAILED...") if failed
end
