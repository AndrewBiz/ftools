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
      # raise FTools::Error.new("author is not defined") if  @author.empty?
      event_dir = '20130102-08 Круиз Балтика'
      if File.exist?(event_dir)
        fail FTools::Error, "#{event_dir} is not a directory" unless
          File.directory?(event_dir)
        fail FTools::Error, "#{event_dir} is not writable" unless
          File.writable?(event_dir)
      else
        begin
          Dir.mkdir event_dir
        rescue
          raise FTools::Error, "Unable to create event dir '#{event_dir}'"
        end
      end
    end

    def process_file(ftfile)
      ftfile_out = ftfile.clone
      # TODO: new_filename

      ftfile_out
    end
  end
end
