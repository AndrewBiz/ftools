#!/usr/bin/env ruby
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require 'active_support/core_ext/string/inflections'
require_relative 'error'
Dir.glob(File.join(__dir__, 'tag', '*.rb')).each { |f| require_relative f }
require_relative 'creators_dir'
require_relative 'places_dir'
require_relative 'tag_collection'
require_relative 'writer'

# ExifTagger helper methods
module ExifTagger
  TAGS_SUPPORTED = (Tag.constants - [:Tag]).map { |i| i.to_s.underscore.to_sym }
end
