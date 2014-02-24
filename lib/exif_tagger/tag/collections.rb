#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative 'tag'

module ExifTagger
  module Tag
    # Collections (struct+)
    #   CollectionName
    #   CollectionURI
    class Collections < Tag
      def initialize(value_raw = {})
        super(value_raw.each { |k, v| value_raw[k] = v.to_s })
      end

      def to_write_script
        str = ''
        @value.each do |o|
          # -XMP-mwg-coll:Collections-={CollectionName=имя коллекции, CollectionURI=www.rbc.ru}
          # -XMP-mwg-coll:Collections+={CollectionName=имя коллекции, CollectionURI=www.rbc.ru}
          # str << %Q{-MWG:Keywords-=#{o}\n}
          # str << %Q{-MWG:Keywords+=#{o}\n}
        end
        str
      end

      private

      def validate
        @value.each do |k, v|
          # @errors << %{#{tag_name}: '#{v}' } +
          #           %{is #{bsize - MAX_BYTESIZE} bytes longer than allowed #{MAX_BYTESIZE}}
          # @value_invalid << v
          # @value = {}
        end
      end
    end
  end
end
