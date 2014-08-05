#!/usr/bin/env ruby
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative 'tag'
require 'date'

module ExifTagger
  module Tag
    # -MWG:DateTimeOriginal:
    #    EXIF:DateTimeOriginal
    #    EXIF:SubSecTimeOriginal
    #    IPTC:DateCreated
    #    IPTC:TimeCreated
    #    XMP-photoshop:DateCreated
    # creation date of the intellectual content being shown
    class DateTimeOriginal < Tag
      MAX_BYTESIZE = 32 # no limit set in EXIF spec
      EXIFTOOL_TAGS = %w(DateTimeOriginal SubSecTimeOriginal DateCreated TimeCreated)

      private

      def validate
        case
        when @value.kind_of?(String)
          bsize = @value.bytesize  
          if bsize > MAX_BYTESIZE
            @errors << %(#{tag_name}: '#{@value}' ) +
              %(is #{bsize - MAX_BYTESIZE} bytes longer than allowed #{MAX_BYTESIZE})
            @value_invalid << @value
            @value = ''
          end
        when @value.kind_of?(DateTime)
          if @value == DateTime.new(0)
            @errors << %(#{tag_name}: '#{@value}' zero Date)
            @value_invalid << @value
            @value = ''
          end
        when @value.kind_of?(Time)
          if @value == Time.new(0)
            @errors << %(#{tag_name}: '#{@value}' zero Date)
            @value_invalid << @value
            @value = ''
          end
        else
          @errors << %(#{tag_name}: '#{@value}' is of wrong type (#{@value.class}))
          @value_invalid << @value
          @value = ''
        end
      end

      def generate_write_script_lines
        @write_script_lines = []
        case
        when @value.kind_of?(String) && !@value.empty?
          @write_script_lines << %Q(-MWG:DateTimeOriginal=#{@value})
        when @value.kind_of?(DateTime) || @value.kind_of?(Time)
          @write_script_lines << %Q(-MWG:DateTimeOriginal=#{@value.strftime('%F %T')})
        end
      end
    end
  end
end
