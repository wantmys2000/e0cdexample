#!/usr/bin/env ruby
require 'open3'
if ENV['RUN_WAIT'] == "true"
  Dir.chdir('/home/app/myapp'){
    loop do
      stdout, stderr, status = Open3.capture3('setuser app bundle exec rails runner script/am_i_migrated.rb')
      puts stdout
      puts stderr
      break if stdout.include?('We are UP!')
      sleep(10)
    end
  }
end
