#!/usr/bin/env ruby
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative 'runner'
require_relative '../mini_exiftool-2.3.0anb'

module FTools
  # Rename original files to ftools standard
  class Ftrename < Runner
    private

    def validate_options
      @author = @options_cli['--author'].upcase || ''
      ok, msg = FTFile.validate_author(@author)
      fail FTools::Error, msg unless ok
    end

    def process_file(ftfile)
      ftfile_out = ftfile.clone
      begin
        tag = MiniExiftool.new(ftfile.filename, timestamps: DateTime)
        dto = tag.date_time_original || tag.create_date || FTFile::ZERO_DATE
      rescue
        raise FTools::Error, 'EXIF tags reading'
      end
      begin
        user_tag_date = @options_cli['--tag_date'] || ''
        if user_tag_date.empty?
          dto = tag.date_time_original || tag.create_date || FTFile::ZERO_DATE
        else
          dto = tag[user_tag_date] || FTFile::ZERO_DATE
        end
      rescue
        #raise FTools::Error, 'EXIF tags reading'
      end
      ftfile_out.standardize!(date_time: dto, author: @author)
      FileUtils.mv(ftfile.filename, ftfile_out.filename) unless
        ftfile == ftfile_out
      ftfile_out
    rescue
      raise FTools::Error, 'file renaming'
    end
  end
end
