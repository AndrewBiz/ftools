#!/usr/bin/env ruby -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev
require_relative 'os'

module FTools
  # Unix specific functions
  class OSUnix < FTools::OS
    private

    def prepare(message)
      message.to_s
    end
  end
end
