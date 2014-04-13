#!/usr/bin/env ruby
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative 'tag'

module ExifTagger
  module Tag
    # Collections (struct+)
    #   CollectionName
    #   CollectionURI
    class Collections < Tag
      VALID_KEYS = [:collection_name, :collection_uri]
      EXIFTOOL_TAGS = %w(CollectionName CollectionURI)
      def initialize(value_raw = {})
        super
      end

      def to_write_script
        str = ''
        unless @value.empty?
          str << print_warnings
          str << print_line(%Q{-XMP-mwg-coll:Collections-={CollectionName=#{@value[:collection_name]}, CollectionURI=#{@value[:collection_uri]}}\n})
          str << print_line(%Q{-XMP-mwg-coll:Collections+={CollectionName=#{@value[:collection_name]}, CollectionURI=#{@value[:collection_uri]}}\n})
        end
        str
      end

      private

      def validate
        unknown_keys = @value.keys - VALID_KEYS
        unknown_keys.each do |k|
          @errors << %{#{tag_name}: KEY '#{k}' is unknown}
        end
        missed_keys = VALID_KEYS - @value.keys
        missed_keys.each do |k|
          @errors << %{#{tag_name}: KEY '#{k}' is missed}
        end
        unless @errors.empty?
          @value_invalid << @value
          @value = {}
        end
      end
    end
  end
end
