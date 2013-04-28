#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (с) ANB Andrew Bizyaev Андрей Бизяев 

require 'nesty'

module FTools
  def self.puts_error msg
    STDERR.puts "#{File.basename($PROGRAM_NAME)}: #{msg}"
  end

  class FTools::Error < Nesty::NestedStandardError; end
  
end
