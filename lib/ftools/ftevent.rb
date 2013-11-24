#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative 'runner.rb'

module FTools
  # collecting media files into EVENT folder
  class FTevent < Runner
    private

    def validate_options
      # TODO: read event
      # @event = Event.new(@options_cli['--event'])
      # raise FTools::Error.new("author is not defined") if @author.empty?
    end

    def process_before
      # TODO: create event dir and copy event to it
      # raise FTools::Error.new("author is not defined") if @author.empty?
    end

    def process_file(filename)
      ftf = FTFile.new(filename)
      # TODO: new_filename
      new_filename = ftf.filename # !
      new_filename
    end
  end
end
