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

f.puts "}"
end
