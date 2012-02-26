require 'mysql2psql/postgres_writer'

class Mysql2psql

class PostgresFileWriter < PostgresWriter
  def initialize(file)
    @f = File.open(file, "w+")
    @f << <<-EOF
-- MySQL 2 PostgreSQL dump\n
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;

EOF
  end

  def truncate(table)
    serial_key = nil
    maxval = nil

    table.columns.map do |column|
      if column[:auto_increment]
        serial_key = column[:name]
        maxval = column[:maxval].to_i < 1 ? 1 : column[:maxval] + 1
      end
    end

    @f << <<-EOF
-- TRUNCATE #{table.name};
TRUNCATE #{table.name} CASCADE;

EOF
    if serial_key
    @f << <<-EOF
SELECT pg_catalog.setval(pg_get_serial_sequence('#{table.name}', '#{serial_key}'), #{maxval}, true);
EOF
    end
  end

  def write_table(table)
    primary_keys = []
    serial_key = nil
    maxval = nil

    columns = table.columns.map do |column|
      if column[:auto_increment]
        serial_key = column[:name]
        maxval = column[:maxval].to_i < 1 ? 1 : column[:maxval] + 1
      end
      if column[:primary_key]
        primary_keys << column[:name]
      end
      "  " + column_description(column)
    end.join(",\n")

    if serial_key

      @f << <<-EOF
--
-- Name: #{table.name}_#{serial_key}_seq; Type: SEQUENCE; Schema: public
--

DROP SEQUENCE IF EXISTS #{table.name}_#{serial_key}_seq CASCADE;

CREATE SEQUENCE #{table.name}_#{serial_key}_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


SELECT pg_catalog.setval('#{table.name}_#{serial_key}_seq', #{maxval}, true);

      EOF
    end

    @f << <<-EOF
-- Table: #{table.name}

-- DROP TABLE #{table.name};
DROP TABLE IF EXISTS #{table.name} CASCADE;

CREATE TABLE #{table.name} (
EOF

    @f << columns

    if primary_index = table.indexes.find {|index| index[:primary]}
      @f << ",\n  CONSTRAINT #{table.name}_pkey PRIMARY KEY(#{primary_index[:columns].map {|col| col}.join(", ")})"
    end

    @f << <<-EOF
\n)
WITHOUT OIDS;
EOF

    table.indexes.each do |index|
      next if index[:primary]
      unique = index[:unique] ? "UNIQUE " : nil
      @f << <<-EOF
DROP INDEX IF EXISTS #{index[:name]} CASCADE;
CREATE #{unique}INDEX #{index[:name]} ON #{table.name} (#{index[:columns].map {|col| col}.join(", ")});
EOF
    end

  end

  def write_indexes(table)
  end

  def write_constraints(table)
    table.foreign_keys.each do |key|
      @f << "ALTER TABLE #{table.name} ADD FOREIGN KEY (#{key[:column].map{|c|c}.join(', ')}) REFERENCES #{key[:ref_table]}(#{key[:ref_column].map{|c|c}.join(', ')}) ON UPDATE #{key[:on_update]} ON DELETE #{key[:on_delete]};\n"
    end
  end


  def write_contents(table, reader)
    @f << <<-EOF
--
-- Data for Name: #{table.name}; Type: TABLE DATA; Schema: public
--

COPY "#{table.name}" (#{table.columns.map {|column| column[:name]}.join(", ")}) FROM stdin;
EOF

    reader.paginated_read(table, 1000) do |row, counter|
      line = []
      process_row(table, row)
      @f << row.join("\t") + "\n"
    end
    @f << "\\.\n\n"
    #@f << "VACUUM FULL ANALYZE #{table.name};\n\n"
  end

  def close
    @f.close
  end
end

end
