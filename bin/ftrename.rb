#!/usr/bin/env ruby -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev
require_relative "../lib/ftools/runner_#{File.basename(__FILE__)}"

module FTools 
  VERSION = '0.1.0'
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

! Make sure you have exiftool installed (for more details see http://www.sno.phy.queensu.ca/~phil/exiftool/install.html)

Usage:
  #{tool_name} -a NICKNAME [-D]
  #{tool_name} -h | --help
  #{tool_name} --version

Optimized to be used with other *ftools* via pipes, e.g. ftls |#{tool_name}

Options:
  -a NICKNAME --author=NICKNAME  Author nickname should be max #{FTools::NicknameMaxSize} chars long (e.g. ANB)
  -D --debug    Turn on debugging (verbose) mode
  -h --help     Show this screen.
  --version     Show version.
DOCOPT

runner = FTools::Runner.new( usage, file_type )
runner.run
