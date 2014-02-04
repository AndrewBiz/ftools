#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative 'tag'

module ExifTagger
  module Tag
    # MWG:Keywords = IPTC:Keywords, XMP-dc:Subject
    class Keywords < Tag
      def initialize(value = [])
        @value = Array(value)
        validate
      end

      def to_write_script
        str = ''
        @value.each do |o|
          str << %Q{-MWG:Keywords-=#{o}\n}
          str << %Q{-MWG:Keywords+=#{o}\n}
        end
        str
      end

      private

      def validate
        # Keywords: string[0,64]+
        @errors = ''
        max_bytesize = 64
        @value.each do |v|
          val_bytesize = v.bytesize
          @errors << "keyword '#{v}' is #{val_bytesize - max_bytesize} bytes longer than allowed #{max_bytesize}\n" if val_bytesize > max_bytesize
        end
      end
    end
  end
end
