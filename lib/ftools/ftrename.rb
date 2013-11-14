#!/usr/bin/env ruby -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative 'runner'
require_relative '../mini_exiftool-2.0.0anb'

# TODO: to refactor!
module FTools
  class FTrename < Runner
    private

    def validate_options
      @author = @options_cli['--author'].upcase || ''
      raise FTools::Error.new('author is not defined, use --author option') if @author.empty?
      raise FTools::Error.new("author size should be #{FTools::FTFile::NICKNAME_SIZE} chars") if @author.size != FTools::FTFile::NICKNAME_SIZE
    end

    def process_file(filename)
      # checking file name
      dirname = File.dirname( filename )
      extname = File.extname( filename )
      # file_type = extname.downcase.slice(1..-1)
      basename = File.basename( filename, extname )

      # reading tags
      begin
        tag = MiniExiftool.new(filename, timestamps: DateTime)
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
        new_basename = FTools::new_basename( FTools::clean_name(basename), date_time_original: dto, author: @author)
        new_filename = File.join( dirname, new_basename + extname )
        FileUtils.mv(filename, new_filename) if basename != new_basename
      rescue => e
        raise FTools::Error.new("file renaming", e)
      end

      return new_filename
    end
  end
end
