#!/usr/bin/env ruby -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev
require_relative "../lib/ftools/runner_#{File.basename(__FILE__)}"

module FTools
  VERSION = '0.1.0'
end

file_type = FTools::FILE_TYPE_IMAGE + FTools::FILE_TYPE_VIDEO
tool_name = File.basename(__FILE__, '.rb')
usage = <<DOCOPT

ftools - *Keep Your Photos Clean And Tidy* ANB (c).
#{tool_name}, version #{FTools::VERSION}, scans given directories and
generates list of files to standart output.
In short it acts like a smart 'ls' command (or 'dir' in Windows).
It is a good starting point for all other ftools to be used with pipes.

Example: #{tool_name} -r abc |ftclname => recursively scans 'abc' dir and
sends all found ftools friendly files to ftclname program.

Usage:
  #{tool_name} [-D] [-r] [DIR_OR_FILE...]
  #{tool_name} -h | --help
  #{tool_name} --version

Options:
  -D --debug      Turn on debugging (verbose) mode
  -r --recursive  Recursively scan directories
  -h --help       Show this screen.
  --version       Show version.
DOCOPT

runner = FTools::Runner.new(usage, file_type)
runner.run
