#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative 'tag'

module ExifTagger
  # Tag
  module Tag
    # Collections (struct+)
    #   CollectionName
    #   CollectionURI
    VALID_KEYS = [:collection_name, :collection_uri]

    # Collections tag
    class Collections < Tag
      def initialize(value_raw = {})
        super
        # super(value_raw.each { |k, v| value_raw[k] = v.to_s })
      end

      def to_write_script
        str = ''
        unless @value.empty?
          str << %Q{-XMP-mwg-coll:Collections-={CollectionName=#{@value[:collection_name]}, CollectionURI=#{@value[:collection_uri]}}\n}
          str << %Q{-XMP-mwg-coll:Collections+={CollectionName=#{@value[:collection_name]}, CollectionURI=#{@value[:collection_uri]}}\n}
        end
        str
      end

      private

      def validate
        @value.each do |k, v|
          unless VALID_KEYS.include? k
            @errors << %{#{tag_name}: KEY '#{k}' is wrong}
          end
        end
        unless @errors.empty?
          @value_invalid << @value
          @value = {}
        end
      end
    end
  end
end
