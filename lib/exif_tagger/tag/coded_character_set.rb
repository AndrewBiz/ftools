#!/usr/bin/env ruby
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative 'tag'

module ExifTagger
  module Tag
    # -IPTC:CodedCharacterSet, string[0,32]!
    class CodedCharacterSet < Tag
      MAX_BYTESIZE = 32
      EXIFTOOL_TAGS = %w(CodedCharacterSet)

      def initialize(value_raw = '')
        super(value_raw.to_s)
      end

      private

      def validate
        bsize = @value.bytesize
        if bsize > MAX_BYTESIZE
          @errors << %{#{tag_name}: '#{@value}' } +
                     %{is #{bsize - MAX_BYTESIZE} bytes longer than allowed #{MAX_BYTESIZE}}
          @value_invalid << @value
          @value = ''
        end
      end

      def generate_write_script_lines
        @write_script_lines = []
        unless @value.empty?
          @write_script_lines << %Q(-IPTC:CodedCharacterSet=#{@value})
        end
      end
    end
  end
end
