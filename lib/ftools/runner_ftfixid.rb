#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (с) ANB Andrew Bizyaev Андрей Бизяев 

require_relative 'runner.rb'
require_relative '../mini_exiftool-1.6.0'

module FTools
  class Runner_ftfixid < FTools::Runner

    private
    def process_file( filename )
      # checking file name
      dirname = File.dirname( filename )
      extname = File.extname( filename )
      basename = File.basename( filename, extname )
      # check if name = YYYYMMDD-hhmmss_AAA[ID]name
      if (/^(\d{8}-\d{6}_\w{3})\[(.*)\](.*)/ =~ basename)
        name_id = $2        
        new_basename = "#{$1} #{$3}"
      else
        raise FTools::Error.new("has wrong name")
      end

      # changing tag
      begin
        tag = MiniExiftool.new( filename, :timestamps => DateTime)
      rescue => e
        raise FTools::Error.new("exif tags reading")
      end  
      unless (/^\d{8}-.*/ =~ tag.image_unique_id)
        tag.image_unique_id = name_id
        raise FTools::Error.new("exif tag is not saved") unless tag.save 
      end

      # renaming file
      begin
        new_filename = File.join( dirname, new_basename+extname )      
        FileUtils.mv(filename, new_filename)
      rescue => e
        raise FTools::Error.new("file renaming")
      end

      return new_filename
    end

  end
end
