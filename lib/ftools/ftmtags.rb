#!/usr/bin/env ruby
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative 'runner.rb'
require_relative '../mini_exiftool-2.3.0anb'
require_relative '../exif_tagger/exif_tagger'

module FTools
  # output exiftool tags
  class Ftmtags < Runner

    private

    def process_file(ftfile)
      begin
        tags = MiniExiftool.new(ftfile.filename,
                                numerical: false,
                                coord_format: '%d %d %.4f',
                                replace_invalid_chars: true,
                                composite: true,
                                timestamps: DateTime)
      rescue
        raise FTools::Error, "EXIF tags reading - #{e.message}"
      end
      puts "#{ftfile}"
      if @options_cli['--full_dump']
        all_tags = tags.to_hash
        #puts all_tags
        #all_tags.delete nil
        all_tags.each do |t,v|
          puts format('  %-27s %-10s %s', t, "(#{v.class})", v)
        end
      else
        puts "******** FILE #{ftfile} ********"
        puts format('  %-27s %s', "FileModifyDate", "#{File.mtime(ftfile.filename)}")
        ExifTagger::TAGS_SUPPORTED.each do |tag|
          puts "#{tag.to_s.camelize}"
          ExifTagger::Tag.const_get(tag.to_s.camelize).const_get('EXIFTOOL_TAGS').each do |t|
            v = tags[t]
            v = 'EMPTY' if v.respond_to?(:empty?) && v.empty?
            if v.nil?
              puts format('  %-27s %s', t, 'NIL')
            else
              puts format('  %-27s %-10s %s', t, "(#{v.class})", v)
            end
          end
        end
      end
      ''
    rescue => e
      raise FTools::Error, "exif tags operating: #{e.message}"
    end
  end
end
