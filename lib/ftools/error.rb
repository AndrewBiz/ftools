#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (с) ANB Andrew Bizyaev Андрей Бизяев 

require 'nesty'

module FTools

  @@debug = false
  def self.debug= val
    @@debug = val
  end

  def self.debug
    @@debug
  end

  def self.puts_error msg, e=nil
    STDERR.puts "#{File.basename($PROGRAM_NAME, ".rb")}: #{msg}"
    if debug and not e.nil?
      STDERR.puts e.backtrace
    end
  end

  class FTools::Error < Nesty::NestedStandardError; end
end
