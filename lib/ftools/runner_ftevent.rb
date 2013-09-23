#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative 'runner.rb'

module FTools
  class Runner

    private

    def validate_options
      # TODO read event
      @event = FTools::Event.new(@options_cli['--event'])
      # raise FTools::Error.new("author is not defined") if @author.empty?
    end
    
    def process_before
      # TODO create event dir and copy event to it
      # raise FTools::Error.new("author is not defined") if @author.empty?
    end

    def process_file( filename )
      dirname = File.dirname( filename )
      extname = File.extname( filename )
      basename = File.basename( filename, extname )
      
      # TODO check if the file in proper YYYYmmdd* format

      # renaming file
      new_filename = File.join( dirname, basename + extname )
      #begin
      #  FileUtils.mv(filename, new_filename) if basename != new_basename
      #rescue => e
      #  raise FTools::Error.new("file renaming", e)
      #end

      return new_filename
    end

  end
end
