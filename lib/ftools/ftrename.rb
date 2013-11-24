#!/usr/bin/env ruby -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative 'runner'
require_relative '../mini_exiftool-2.3.0anb'

module FTools
  # Rename original files to ftools standard
  class FTrename < Runner
    private

    def validate_options
      @author = @options_cli['--author'].upcase || ''
      ok, msg = FTFile.validate_author(@author)
      fail FTools::Error, msg unless ok
    end

    def process_file(filename)
      ftf = FTFile.new(filename)
      begin
        tag = MiniExiftool.new(filename, timestamps: DateTime)
        dto = tag.date_time_original || tag.create_date || FTFile::ZERO_DATE
      rescue
        raise FTools::Error, 'EXIF tags reading'
      end

      new_basename = ftf.generate_basename(clean_name: ftf.basename_part[:clean],
                                           date_time: dto,
                                           author: @author)
      new_filename = File.join(ftf.dirname,
                               new_basename + ftf.extname)
      FileUtils.mv(filename, new_filename) unless filename == new_filename
      new_filename
    rescue
      raise FTools::Error, 'file renaming'
    end
  end
end
