#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative 'error'
require 'active_support/core_ext'

# loading exif tag classes
lib_dir = File.join(__dir__, 'tag', '*.rb')
Dir.glob(lib_dir).each { |file| require_relative file }

module ExifTagger
  # EXIF tags collection
  class TagCollection
    include Enumerable

    def initialize
      @collection = []
    end

    def each(&block)
      @collection.each(&block)
    end

    def to_s
      str = ''
      @collection.each { |i| str << i.to_s }
      str
    end

    def []=(tag, value)
      delete(tag)
      @collection << produce_tag(tag, value)
    end

    def [](tag)
      ind = @collection.find_index(tag)
      ind.nil? ? nil : @collection[ind].value
    end

    def item(tag)
      ind = @collection.find_index(tag)
      ind.nil? ? nil : @collection[ind]
    end

    def delete(tag)
      @collection.delete(tag)
    end

    private

    def produce_tag(tag, value)
      tag_class = ExifTagger::Tag.const_get(tag.to_s.camelize)
      tag_class.new(value)
    rescue => e
      raise ExifTagger::UnknownTag, "Tag #{tag} - #{e.message}"
    end
  end
end
