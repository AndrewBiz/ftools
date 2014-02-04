#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require 'nesty'

# Foto tools
module ExifTagger
  class Error < Nesty::NestedStandardError; end
  class ExiftoolTagger < Error; end
end
