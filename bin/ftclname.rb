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
#{tool_name}, version #{FTools::VERSION}, renames the input file to it's original name.
Useful when needed to clean up the name changed whith other ft* utils.
Input file should be one of the types: #{file_type*","}

Example: input file '20130108-124145_ANB DSC03455.JPG' will be renamed to 'DSC03455.JPG'

Usage:
  #{tool_name} [-D]
  #{tool_name} -h | --help
  #{tool_name} --version

Optimized to be used via pipes, e.g. ls *|#{tool_name}

Options:
  -D --debug    Turn on debugging (verbose) mode
  -h --help     Show this screen.
  --version     Show version.
DOCOPT

runner = FTools::Runner.new( usage, file_type )
runner.run
