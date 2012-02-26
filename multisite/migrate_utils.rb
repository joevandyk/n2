require 'tempfile'
require 'uri'

module MigrateUtils
  def self.mysql_creds
    ENV['MYSQL_CREDS'] || " -u root "
  end

  def self.reset config
    system "dropdb #{ config['pg_db'] }"
    system "createdb #{ config['pg_db'] }"
    system "psql -f #{ config['pg_schema_file'] } #{ config['pg_db'] } "
  end

  def self.drop_db site_name
    print  "Removing #{ site_name } mysql db if exists... "
    system "yes | mysqladmin drop #{ site_name } #{ mysql_creds }"
    system "dropdb #{ site_name }"
    puts "Done"
    puts
  end

  def self.create_db site_name, mysql_file
    print "Populating #{ site_name } mysql db from the given sql file... "
    system "yes | mysqladmin create #{ site_name } #{ mysql_creds }"
    system "createdb #{ site_name }"
    status = execute_mysql "#{ site_name } < #{ mysql_file }"
    if !status
      raise "Couldn't populate mysql db"
    end
    puts "Done"
    puts
  end

  def self.execute_mysql command
    system "mysql #{ command } #{ mysql_creds }"
  end

  def self.convert_mysql_to_pg site_name, local_db_settings
    # Create temp db
    # Run mysql2psql
    # Merge
    system "dropdb #{ site_name }"
    system "createdb #{ site_name }"
    config = {
      "mysql"       => local_db_settings["mysql"],
      "destination" => { "postgres" => local_db_settings["postgres"] }
    }
    config["mysql"]["database"] = site_name
    config["destination"]["postgres"]["database"] = site_name
    mysql2psql_config = Tempfile.new('mysql2psql')
    mysql2psql_config << YAML.dump(config)
    mysql2psql_config.flush
    `./multisite/mysql2postgres/bin/mysql2psql #{ mysql2psql_config.path }`
  end

  def self.merge_pg_dbs site_name, config, site_info
    ENV['NAME'] = site_name
    ENV['DOMAIN'] = URI.parse(site_info["url"]).host

    ENV['DB'] = postgres_connect_string(config["local_db_settings"], site_name)
    ENV['LIVE_DB'] = postgres_connect_string(config["local_db_settings"], config["pg_db"])

    puts "Running multisite migrations..."
    system "ruby ./multisite/migrate_sql.rb"

    puts "Dumping temp postgres db to file"
    system "pg_dump -a -T schema_migrations -T external_auth_sites #{site_name} > /tmp/db.sql"

    puts "Loading temp postgres dump into #{ config["pg_db"] }"
    system "psql #{ config["pg_db"] } < /tmp/db.sql"


    # Restore pg dump file to pg_db
    #
    # Profit?
    #
    # Review site-specific configuration, maybe add some more
    # tables for it. Then populate site-specific config
    # from the yaml config file

  end

  def self.postgres_connect_string settings, db_name
    db_connection_string = "postgres://"
    db_connection_string << settings["postgres"]["username"].to_s
    db_connection_string << ":"
    db_connection_string << settings["postgres"]["password"].to_s
    db_connection_string << "@"
    db_connection_string << settings["postgres"]["hostname"].to_s
    db_connection_string << "/"
    db_connection_string << db_name
  end

end
