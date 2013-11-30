#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative 'runner.rb'

# Foto processing tools
module FTools
  # Fixing file's date-time modification property
  class FTfixfmd < Runner
    private

    def process_file(ftfile)
      fail FTools::Error, 'wrong date-time in the name' unless
        ftfile.date_time_ok?
      begin
        File.utime(Time.now, ftfile.date_time_to_time, ftfile.filename)
      rescue
        raise FTools::Error.new, 'setting file modify time'
      end
      ftfile
    end
  end
end
