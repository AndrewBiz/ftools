#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative 'runner.rb'
require_relative 'event'

module FTools
  # collecting media files into EVENT folder
  class FTevent < Runner
    private

    def validate_options
      # TODO: parent_dir to event
      @event = Event.new(@options_cli['--event'])
    end

    def process_before
      @event.mkdir
      @event.copy_profile
    end

    def process_file(ftfile)
      ftfile_out = ftfile.clone
      # TODO: new_filename

      ftfile_out
    end
  end
end
