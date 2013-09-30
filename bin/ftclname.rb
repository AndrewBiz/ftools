#!/usr/bin/env ruby -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev
require_relative "../lib/ftools/runner_#{File.basename(__FILE__)}"

module FTools 
  VERSION = '0.1.0'
end

file_type = FTools::FILE_TYPE_IMAGE + FTools::FILE_TYPE_VIDEO
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

Optimized to be used with other *ftools* via pipes, e.g. ftls |#{tool_name}

Options:
  -D --debug    Turn on debugging (verbose) mode
  -h --help     Show this screen.
  --version     Show version.
DOCOPT

runner = FTools::Runner.new( usage, file_type )
runner.run
