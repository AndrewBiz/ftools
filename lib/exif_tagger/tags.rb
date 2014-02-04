#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative 'error'
# loading *Tag classes
lib_dir = File.join(__dir__, 'tag', '*.rb')
Dir.glob(lib_dir).each { |file| require_relative file }

module ExifTagger
  # EXIF tags collection
  class Tags
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

    def to_write_script
      str = ''
      @collection.each { |i| str << i.to_write_script }
      str
    end

    def []=(tag, value)
      delete(tag)
      @collection << produce_tag(tag, value)
    end

    def [](tag)
      @collection[@collection.find_index(tag)].value
    end

    def item(tag)
      @collection[@collection.find_index(tag)]
    end

    def delete(tag)
      @collection.delete(tag)
    end

    private

    def produce_tag(tag, value)
      tag_class = ExifTagger::Tag.const_get(tag.to_s.camelize)
      tag_class.new(value)
    rescue => e
      raise ExiftoolTagger, "unknown tag #{tag} - #{e.message}"
    end
  end
end
