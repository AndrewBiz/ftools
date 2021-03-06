#!/usr/bin/env ruby
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require 'nesty'

# Foto tools
module ExifTagger
  class Error < Nesty::NestedStandardError; end
  class UnknownTag < Error; end
  class WriteTag < Error; end
  class CreatorsDirectory < Error; end
  class PlacesDirectory < Error; end
end
