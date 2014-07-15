#!/usr/bin/env ruby
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative 'tag'

module ExifTagger
  module Tag
    # MWG:Keywords, string[0,64]+, List of Strings
    #   = IPTC:Keywords, XMP-dc:Subject
    class Keywords < Tag
      MAX_BYTESIZE = 64
      EXIFTOOL_TAGS = %w(Keywords Subject)

      def initialize(value_raw = [])
        super(Array(value_raw).flatten.map { |i| i.to_s })
      end

      def to_write_script
        str = ''
        unless @value.empty?
          str << print_warnings
          @value.each do |o|
            str << print_line(%Q(-MWG:Keywords-=#{o}\n))
            str << print_line(%Q(-MWG:Keywords+=#{o}\n))
          end
        end
        str
      end

      def validate_with_original(values)
        @warnings = []
        @warnings.freeze
      end

      private

      def validate
        @value.each do |v|
          bsize = v.bytesize
          if bsize > MAX_BYTESIZE
            @errors << %{#{tag_name}: '#{v}' } +
                       %{is #{bsize - MAX_BYTESIZE} bytes longer than allowed #{MAX_BYTESIZE}}
            @value_invalid << v
          end
        end
        @value = @value - @value_invalid
      end
    end
  end
end
