#!/usr/bin/env ruby -U
# encoding: UTF-8
# (с) ANB Andrew Bizyaev Андрей Бизяев
require_relative '../lib/ftools/runner_ftfixfmd.rb'

module FTools 
  VERSION = "0.0.1"
end

file_type = FTools::FileTypeImage + FTools::FileTypeVideo
tool_name = File.basename(__FILE__, ".rb")
usage = <<DOCOPT
*ftools* - *keep your fotos in order* Andrew Bizyaev (c).
#{tool_name}, version #{FTools::VERSION}.
#{tool_name} changes an input file modify-date according to the date in the filename. 
The name of the input file should be in format: YYYYmmdd-HHMMSS*.* 
Input file should be one of the types: #{file_type*","}

Usage:
  #{tool_name}
  #{tool_name} -h | --help
  #{tool_name} --version

Optimized to be used via pipes, e.g. ls *|#{tool_name}

Options:
  -h --help     Show this screen.
  --version     Show version.
DOCOPT

runner = FTools::Runner_ftfixfmd.new( usage, file_type )
runner.run
