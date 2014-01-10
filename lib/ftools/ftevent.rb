#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative 'runner.rb'
require_relative 'event'

module FTools
  # collecting media files into EVENT folder
  class Ftevent < Runner
    private

    def validate_options
      @event = Event.new(@options_cli['--event'], @options_cli['--parent_dir'])
    end

    def process_before
      @event.mkdir
      @event.copy_profile
    end

    def process_file(ftfile)
      fail FTools::Error, 'non-standard name, use ftrename to rename' unless
        ftfile.basename_is_standard?

      ftfile_out = ftfile.clone
      fail FTools::Error, 'out of event dates' unless
        (ftfile_out.date_time <= @event.date_end) &&
        (ftfile_out.date_time >= @event.date_start)
      ftfile_out.dirname = @event.dirname
      FileUtils.mv(ftfile.filename, ftfile_out.filename) unless
        ftfile == ftfile_out
      ftfile_out
    rescue SystemCallError => e
      raise FTools::Error, 'file moving - ' + e.message
    end
  end
end
