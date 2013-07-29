#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require 'rbconfig'

# foto tools
module FTools

  # determine OS
  def self.os (os_string = RbConfig::CONFIG['host_os'])
    case os_string
    when /darwin/ then :macosx
    when /linux/ then :linux
    when /w32/ then :windows
    else :unknown
    end
  end

  # OS specific output implementation
  class OS
    def output(message)
      STDOUT.puts prepare(message)
    end
  end
end