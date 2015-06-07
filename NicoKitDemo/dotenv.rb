#!/usr/bin/env ruby

require 'bundler/setup'
require 'dotenv'

Dotenv.load

File.open("dotenv.swift", "w") do |f|

f.puts "public struct ENV {"

ENV.each {|k, v|
    vv = v.gsub('"', '\"')
    if k != "_"
    f.puts "    static let #{k} = \"#{vv}\""
    end
}

unless ENV["DEMO_NICO_MAILADDRESS"] then
  f.puts "    static let DEMO_NICO_MAILADDRESS = \"\""
end
unless ENV["DEMO_NICO_PASSWORD"] then
  f.puts "    static let DEMO_NICO_PASSWORD = \"\""
end

f.puts "}"
end
