#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (с) ANB Andrew Bizyaev Андрей Бизяев 
require_relative 'os'

module FTools
  
  class OSUnix < FTools::OS
    private

    def prepare(message)
      message.to_s
    end
  end
end
