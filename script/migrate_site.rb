#!/usr/bin/env ruby
require 'rubygems'
require 'sequel'
require 'yaml'

mysql_file = ARGV.shift.to_s
raise "Please provide a valid mysql dump file!" if !File.exist?(mysql_file)

main_pg_db_name = ARGV.shift.to_s
system "createdb #{ main_pg_db_name }"

def mysql_creds
  ENV['MYSQL_CREDS'] || " -u root "
end

def drop_dbs db_name
  system "yes | mysqladmin drop #{ db_name } #{ mysql_creds }"
  system "dropdb #{ db_name }"
end

def create_dbs db_name
  system "yes | mysqladmin create #{ db_name } #{ mysql_creds }"
  system "createdb #{ db_name }"
end

def execute_mysql command
  system "mysql #{ command } #{ mysql_creds }"
end

site_name = File.basename(mysql_file)

print  "Removing #{ site_name } mysql dump if exists... "
drop_dbs site_name
puts "Done"
puts

print "Creating #{ site_name } mysql db from the given sql file... "
create_dbs site_name
puts "Done"
puts

print "Populating #{ site_name } mysql db from the given sql file... "
execute_mysql "#{ site_name } < #{ mysql_file }"
puts "Done"
puts


print "Converting mysql database to postgresql... "
