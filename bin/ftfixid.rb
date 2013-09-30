#!/usr/bin/env ruby -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev
require_relative '../lib/ftools/runner_ftfixid.rb'

module FTools 
  VERSION = '0.1.0'
end

file_type = FTools::FILE_TYPE_IMAGE
tool_name = File.basename(__FILE__, ".rb")
usage = <<DOCOPT
*ftools* - *keep your fotos in order* Andrew Bizyaev (c).
#{tool_name}, version #{FTools::VERSION}.
#{tool_name} fixes EXIF ImageUniqueID tag and renames the input file. The name of the input file
should be in format: YYYYmmdd-HHMMSS_AAA[ID]name.ext. The ID string will be put into the EXIF
tag, while the [ID] part will be replaced with single space.
Input file should be one of the types: #{file_type*","}

Example: input file '20130108-124145_ANB[20130112-Z685C]IMG_0390.JPG' will be renamed to
'20130108-124145_ANB IMG_0390.JPG' and EXIF ImageUniqueID tag will be set = '20130112-Z685C'

Usage:
  #{tool_name}
  #{tool_name} -h | --help
  #{tool_name} --version

Optimized to be used with other *ftools* via pipes, e.g. ftls |#{tool_name}

Options:
  -h --help     Show this screen.
  --version     Show version.
DOCOPT

runner = FTools::Runner_ftfixid.new( usage, file_type )
runner.run
