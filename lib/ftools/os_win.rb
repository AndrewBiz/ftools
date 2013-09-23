#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev
require_relative 'os'

module FTools
  
  class OSWin < FTools::OS

    private

    def prepare(message)
      message.gsub(/#{"/"}/, "\\")
    end

  end
 
end
