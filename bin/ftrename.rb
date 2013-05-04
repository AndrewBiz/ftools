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
#{tool_name}, version #{FTools::VERSION}, renames the input file based on EXIF DateTimeOriginal tag and 
author nickname provided. The target file name format: YYYYmmdd-HHMMSS_AAA name.ext, 
where YYYYmmdd-HHMMSS is equal to DateTimeOriginal, AAA is the author nickname.
Input file should be one of the types: #{file_type*","}

Example: input file 'DSC03455.JPG' will be renamed to '20130108-124145_ANB DSC03455.JPG'

Usage:
  #{tool_name} -a NICKNAME [-D]
  #{tool_name} -h | --help
  #{tool_name} --version

Optimized to be used via pipes, e.g. ls *|#{tool_name}

Options:
  -a NICKNAME --author=NICKNAME  Author nickname should be max #{FTools::NicknameMaxSize} chars long (e.g. ANB)
  -D --debug    Turn on debugging (verbose) mode
  -h --help     Show this screen.
  --version     Show version.
DOCOPT

runner = FTools::Runner.new( usage, file_type )
runner.run
