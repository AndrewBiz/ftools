#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative 'os'

module FTools
  # OS platfor related logic
  class OSWin < FTools::OS

    private

    def prepare(message)
      message.to_s.gsub(/#{"/"}/, '\\')
    end
  end
end
