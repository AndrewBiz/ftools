#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (с) ANB Andrew Bizyaev Андрей Бизяев 

require_relative 'runner.rb'

module FTools
  class Runner_ftfixfmd < FTools::Runner

    private
    def process_file( filename )
      # checking file name
      #dirname = File.dirname( filename )
      extname = File.extname( filename )
      basename = File.basename( filename, extname )
      # check if name = YYYYMMDD-hhmmss_AAA[ID]name
      if (/^(\d{8}-\d{6})(.*)/ =~ basename)
        fmd = Time.strptime($1, "%Y%m%d-%H%M%S")
      else
        raise FTools::Error.new("wrong name format")
      end

      # processing file
      begin
        File.utime(Time.now, fmd, filename)
      rescue => e
        raise FTools::Error.new("setting file modify time", e)
      end

      return filename
    end

  end
end
