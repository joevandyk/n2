#!/usr/bin/env ruby

Dir["config/\*.yml.sample"].each do |file|
  command = "cp #{ file } #{ file.sub('.sample', '')}"
  puts command
  `#{ command }`
end
