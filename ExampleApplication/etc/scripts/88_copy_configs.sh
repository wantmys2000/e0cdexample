#!/usr/bin/env ruby
# NOTE: Encryption has been removed from this example as to not expose security procedures publicly.
# NOTE: S3 VPC endpoint has been removed for this example for simplicity


require 'yaml'
require 'open3'
require 'fileutils'
if ENV['RUN_COPYCONFIG'] == "true"
  FileUtils::mkdir_p './app_configs'

  stdout, stderr, status = Open3.capture3("aws s3 sync s3://#{ENV['S3_CONFIG_BUCKET']}/ ./app_configs")
  puts stdout
  puts stderr
  puts status
  unless stderr.empty? && status.exitstatus == 0
    abort("Copying config FAILED...")
  end

  YAML.load_file('./app_configs/common.yml').each do |key, value|
    File.write("/etc/container_environment/#{key}", value)
  end
  YAML.load_file("./app_configs/#{ENV['S3_CONFIG_FILE']}").each do |key, value|
    File.write("/etc/container_environment/#{key}", value)
  end
  if ENV['VW_DOCSTORE_ENABLED'] == "true"
    FileUtils::cp("./app_configs/#{ENV['VW_DOCSTORE_PEM_FILE']}", "/home/app/myapp/config")
  end

  FileUtils::rm_rf("./app_configs")
end
