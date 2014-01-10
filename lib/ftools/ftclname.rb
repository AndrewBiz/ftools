#!/usr/bin/env ruby -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative 'runner.rb'

# Foto processing tools
module  FTools
  # Rename file
  class Ftclname < Runner
    private

    def process_file(ftfile)
      ftfile_out = ftfile.clone
      ftfile_out.cleanse!
      FileUtils.mv(ftfile.filename, ftfile_out.filename) unless
        ftfile == ftfile_out
      ftfile_out
    rescue
      raise FTools::Error, 'file renaming'
    end
  end
end
