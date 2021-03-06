#!/usr/bin/env ruby
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require 'date'
require_relative 'runner.rb'
require_relative '../mini_exiftool-2.3.0anb'
require_relative '../exif_tagger/exif_tagger'

module FTools
  # setting EXIF DateTimeOriginal nad CreateDate tags
  class Ftfixdate < Runner
    private

    def validate_options
      @shift_seconds = @options_cli['--shift-seconds'].to_i
      fail FTools::Error, '--shift-seconds is not correct' if @shift_seconds.zero?
      @name_only = @options_cli['--name-only'] || false
    end

    def process_before
      unless @name_only
        @writer = ExifTagger::Writer.new(
          script_name: 'exif_tagger_dto.txt',
          memo: "#{DateTime.now}: Script generated by #{@tool_name} (ftools bundle) version #{VERSION} (core #{VERSION_CORE})\n# shift-seconds = #{@shift_seconds}",
          output: STDERR)
      end
    end

    def process_file(ftfile)
      # TODO: fail if file is not supported by exiftool
      ftfile_out = ftfile.clone
      if @name_only
        fail FTools::Error, 'incorrect file name' unless ftfile_out.basename_is_standard?
        date_new = ftfile_out.date_time + @shift_seconds*(1.0/86400)
        ftfile_out.standardize!(date_time: ftfile_out.date_time + @shift_seconds*(1.0/86400))
        FileUtils.mv(ftfile.filename, ftfile_out.filename) unless ftfile == ftfile_out
        return ftfile_out
      else #changing exif tags
        STDERR.puts ftfile_out
        begin
          tags_original = MiniExiftool.new(ftfile.filename,
                                           replace_invalid_chars: true,
                                           composite: true,
                                           timestamps: DateTime)
        rescue
          raise FTools::Error, "EXIF tags reading by mini_exiftool - #{e.message}"
        end
        fail FTools::Error, 'DateTimeOriginal is not set' if tags_original[:date_time_original].nil?
        tags_to_write = ExifTagger::TagCollection.new()
        tags_to_write[:date_time_original] = tags_original[:date_time_original] + @shift_seconds*(1.0/86400)
        unless tags_original[:create_date].nil?
          tags_to_write[:create_date] = tags_original[:create_date] + @shift_seconds*(1.0/86400)
          tags_to_write.item(:create_date).force_write = true
        end
        tags_to_write.item(:date_time_original).force_write = true
        tags_to_write.check_for_warnings(original_values: tags_original)
        fail FTools::Error, tags_to_write.error_message unless tags_to_write.valid?
        @writer.add_to_script(ftfile: ftfile_out, tags: tags_to_write)
        return ''
      end
    rescue => e
      raise FTools::Error, e.message
    end

    def process_after
      @writer.run! unless @name_only
    end
  end
end
