#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (с) ANB Andrew Bizyaev Андрей Бизяев 

require_relative 'runner.rb'

module FTools
  class Runner

    private
    def process_file( filename )
      # checking file name
      dirname = File.dirname( filename )
      extname = File.extname( filename )
      basename = File.basename( filename, extname )

      # renaming file
      new_basename = FTools::clean_name( basename ) 
      new_filename = File.join( dirname, new_basename + extname )
      begin
        FileUtils.mv(filename, new_filename) if basename != new_basename
      rescue => e
        raise FTools::Error.new("file renaming", e)
      end

      return new_filename
    end

  end
end
