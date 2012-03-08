#!/usr/bin/env ruby
require 'rubygems'
require 'sequel'
require 'yaml'
require 'awesome_print'
require File.join(File.expand_path(File.dirname(__FILE__)), 'migrate_utils')
MU = MigrateUtils

config_file = ARGV.shift.to_s
raise "Please provide a valid config file!" if !File.exist?(config_file)
config = YAML.load(File.read(config_file))

pg_db = config["pg_db"] || raise("no pg_db specified in config")
system "createdb #{ pg_db }"

MU.reset(config)

config["sites"].each do |site_name, info|
  puts
  puts
  puts " *** We are dropping the local mysql db for #{ site_name }, "
  puts " *** recreating it from #{ info["dump_file"] }, and "
  puts " *** converting it to postgres!"
  puts " *** Then, we will merge that postgresql database into "
  puts " *** the main postgres database '#{ config["pg_db"] }'"
  puts
  puts
  MU.drop_db site_name
  MU.create_db site_name, info["dump_file"]
  MU.convert_mysql_to_pg site_name, config["local_db_settings"]
  MU.merge_pg_dbs(site_name,
                  config,
                  info)
end

MU.reset_sequences config

exit
