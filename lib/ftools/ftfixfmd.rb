#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative 'runner.rb'

# Foto processing tools
module FTools
  # Fixing file's date-time modification property
  class FTfixfmd < Runner
    private

    def process_file(filename)
      ftf = FTFile.new(filename)
      fail FTools::Error, 'no date-time in the name' unless ftf.date_time_ok?
      begin
        File.utime(Time.now, ftf.date_time_to_time, filename)
      rescue
        raise FTools::Error.new, 'setting file modify time'
      end
      filename
    end
  end
end
