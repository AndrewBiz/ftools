#!/usr/bin/env ruby
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative 'tag'

module ExifTagger
  module Tag
    # -MWG:CreateDate:
    #    EXIF:CreateDate
    #    EXIF:SubSecTimeDigitized
    #    IPTC:DigitalCreationDate
    #    IPTC:DigitalCreationTime
    #    XMP-xmp:CreateDate
    # creation date of the digital representation
    class CreateDate < Tag
      MAX_BYTESIZE = 32 # no limit set in EXIF spec
      EXIFTOOL_TAGS = %w(CreateDate SubSecTimeDigitized DigitalCreationDate DigitalCreationTime)

      def initialize(value_raw = '')
        super(value_raw.to_s)
      end

      def to_write_script
        str = ''
        unless @value.empty?
          str << print_warnings
          str << print_line(%Q(-EXIF:ModifyDate=#{@value}\n))
        end
        str
      end

      def validate_with_original(values)
        @warnings = []
        @warnings.freeze
      end

      private

      def validate
        bsize = @value.bytesize
        if bsize > MAX_BYTESIZE
          @errors << %(#{tag_name}: '#{@value}' ) +
                     %(is #{bsize - MAX_BYTESIZE} bytes longer than allowed #{MAX_BYTESIZE})
          @value_invalid << @value
          @value = ''
        end
      end
    end
  end
end