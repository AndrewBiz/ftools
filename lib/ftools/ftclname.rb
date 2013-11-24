#!/usr/bin/env ruby -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative 'runner.rb'

# Foto processing tools
module  FTools
  # Rename file
  class FTclname < Runner
    private

    def process_file(filename)
      ftf = FTFile.new(filename)
      new_filename = File.join(ftf.dirname,
                               ftf.basename_part[:clean] + ftf.extname)
      FileUtils.mv(filename, new_filename) unless filename == new_filename
      new_filename
    rescue
      raise FTools::Error, 'file renaming'
    end
  end
end
