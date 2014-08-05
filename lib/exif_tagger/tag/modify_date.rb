#!/usr/bin/env ruby
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative 'tag_date'

module ExifTagger
  module Tag
    # -EXIF:ModifyDate=now
    class ModifyDate < TagDate
      EXIFTOOL_TAGS = %w(ModifyDate)

      # TODO: like DTO + write_ignoring_warnings
      def validate_with_original(values)
        @warnings = []
        @warnings.freeze
      end

      private

      def generate_write_script_lines
        @write_script_lines = []
        case
        when @value.kind_of?(String) && !@value.empty?
          @write_script_lines << %Q(-EXIF:ModifyDate=#{@value})
        when @value.kind_of?(DateTime) || @value.kind_of?(Time)
          @write_script_lines << %Q(-EXIF:ModifyDate=#{@value.strftime('%F %T')})
        end
      end
    end
  end
end
