#!/usr/bin/env ruby -U
# encoding: UTF-8
# (с) ANB Andrew Bizyaev Андрей Бизяев
require_relative "../lib/ftools/runner_#{File.basename(__FILE__)}"

module FTools 
  VERSION = "0.0.1"
end

file_type = FTools::FileTypeImage + FTools::FileTypeVideo
tool_name = File.basename(__FILE__, ".rb")
usage = <<DOCOPT
*ftools* - *keep your fotos in order* Andrew Bizyaev (c).
#{tool_name}, version #{FTools::VERSION}, copies the input file into backup directory.
Input file should be one of the types: #{file_type*","}

Usage:
  #{tool_name} [--backup DIR] [-D]
  #{tool_name} -h | --help
  #{tool_name} --version

Optimized to be used via pipes, e.g. ls *|#{tool_name}|ftrename

Options:
  -b DIR --backup=DIR  Sets the backup directory [Default: ./backup]
  -D --debug           Turn on debugging (verbose) mode
  -h --help            Show this screen.
  --version            Show version.
DOCOPT

runner = FTools::Runner.new( usage, file_type )
runner.run
