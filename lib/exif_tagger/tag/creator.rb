#!/usr/bin/env ruby
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative 'tag'

module ExifTagger
  module Tag
    # MWG:Creator, string[0,32]+, List of strings
    #   = EXIF:Artist, IPTC:By-line, XMP-dc:Creator
    class Creator < Tag
      MAX_BYTESIZE = 32
      EXIFTOOL_TAGS = %w(Artist By-line Creator)

      def initialize(value_raw = [])
        super(Array(value_raw).flatten.map { |i| i.to_s })
      end

      def to_write_script
        str = ''
        unless @value.empty?
          str << print_warnings
          @value.each do |o|
            str << print_line(%Q(-MWG:Creator-=#{o}\n))
            str << print_line(%Q(-MWG:Creator+=#{o}\n))
          end
        end
        str
      end

      private

      def validate
        @value.each do |v|
          bsize = v.bytesize
          if bsize > MAX_BYTESIZE
            @errors << %(#{tag_name}: '#{v}' ) +
                       %(is #{bsize - MAX_BYTESIZE} bytes longer than allowed #{MAX_BYTESIZE})
            @value_invalid << v
          end
        end
        @value = @value - @value_invalid
      end
    end
  end
end
