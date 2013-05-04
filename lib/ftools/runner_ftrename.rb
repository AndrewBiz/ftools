#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (с) ANB Andrew Bizyaev Андрей Бизяев 

require_relative 'runner.rb'
require_relative '../mini_exiftool-1.6.0'

module FTools
  class Runner

    private
    def validate_options
      @author = @options_cli['--author']||""
      @author.upcase!
      raise FTools::Error.new("author is not defined") if @author.empty?
      raise FTools::Error.new("author nickname is too long, max is #{FTools::NicknameMaxSize}") if @author.size > FTools::NicknameMaxSize
    end

    def process_file( filename )
      # checking file name
      dirname = File.dirname( filename )
      extname = File.extname( filename )
      #file_type = extname.downcase.slice(1..-1)
      basename = File.basename( filename, extname )
      # check if name = YYYYMMDD-hhmmss_AAA[ID]name
      if (/^(\d{8}-\d{4})(.*)/ =~ basename)
        raise FTools::Error.new("already renamed")
      end

      # reading tags
      begin
        tag = MiniExiftool.new( filename, :timestamps => DateTime)
      rescue => e
        raise FTools::Error.new("exif tags reading")
      end

      # reading DateTimeOriginal tag
      begin
        dto = tag.date_time_original||tag.create_date||DateTime.new(0)
        #puts "#{tag.date_time_original}, #{tag.create_date}"
      rescue => e
        raise FTools::Error.new("reading tag of creation date", e)
      end

      # renaming file
      begin
        new_filename = File.join( dirname, FTools::new_basename(basename, date_time_original: dto, author: @author) + extname )      
        FileUtils.mv(filename, new_filename)
      rescue => e
        raise FTools::Error.new("file renaming", e)
      end

      return new_filename
    end

  end
end
