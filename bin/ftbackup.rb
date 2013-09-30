#!/usr/bin/env ruby -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev
require_relative "../lib/ftools/runner_#{File.basename(__FILE__)}"

# Foto Tools
module FTools
  VERSION = '0.1.0'
end

file_type = FTools::FILE_TYPE_IMAGE + FTools::FILE_TYPE_VIDEO
tool_name = File.basename(__FILE__, '.rb')
usage = <<DOCOPT
*ftools* - *keep your fotos in order* Andrew Bizyaev (c).
#{tool_name}, version #{FTools::VERSION}, copies the input file into backup
directory.
Input file should be one of the types: #{file_type * ","}

Usage:
  #{tool_name} [--backup DIR] [-D]
  #{tool_name} -h | --help
  #{tool_name} --version

Optimized to be used with other *ftools* via pipes, e.g. ftls |#{tool_name}

Options:
  -b DIR --backup=DIR  Sets the backup directory [Default: ./backup]
  -D --debug           Turn on debugging (verbose) mode
  -h --help            Show this screen.
  --version            Show version.
DOCOPT

runner = FTools::Runner.new(usage, file_type)
runner.run
