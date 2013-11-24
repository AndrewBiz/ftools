#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require 'nesty'

# Foto tools
module FTools
  @debug = false
  def self.debug=(val)
    @debug = val
  end

  def self.debug
    @debug
  end

  def self.puts_error(msg, e = nil)
    STDERR.puts "#{File.basename($PROGRAM_NAME, ".rb")}: #{msg}"
    STDERR.puts e.backtrace if @debug && !e.nil?
  end

  class FTools::Error < Nesty::NestedStandardError; end
end
