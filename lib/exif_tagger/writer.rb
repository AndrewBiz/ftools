#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative 'error'
require 'date'
require_relative 'tag_collection'

# Exif tagger
module ExifTagger
  # batch EXIF tags setter
  class Writer
    DEFAULT_OPTIONS = %w(-v0 -P -overwrite_original -ignoreMinorErrors)
    attr_reader :script_name

    def initialize(script_name: 'exif_tagger.txt', memo: 'Generated by ftools')
      @script_name = script_name
      create_script(memo)
    end

    def add_to_script(ftfile: '', tags: {}, options: DEFAULT_OPTIONS)
      @script.puts "# ***** Processing file: #{ftfile} *****"
      # tags
      tags.each do |k|
        @script.puts tags.item(k).to_write_script
      end
      # file to be altered
      @script.puts %Q{#{ftfile}}
      # General options
      options.each { |o| @script.puts "#{o}" }
      @script.puts %Q{-execute}
      @script.puts

    rescue => e
      raise WriteTag, "adding item to exiftool script - #{e.message}"
    end

    def close_script
      @script.close
    rescue => e
      raise WriteTag, "closing exiftool script - #{e.message}"
    end

    def command
      "exiftool -@ #{@script_name}"
    end

    def run!
      close_script
      ok = system(command)
      fail if ok.nil?
    rescue => e
      raise WriteTag, "running #{command}"
    end

    private

    def create_script(memo)
      @script = File.open(@script_name, 'w+:utf-8')
      @script.puts '# exiftool script for batch tag operations'
      @script.puts "# #{memo}"
      @script.puts "# usage: exiftool -@ #{@script_name}"
      @script.puts '-execute'
    rescue => e
      raise ExifTagger::WriteTag, "creating exiftool script - #{e.message}"
    end
  end
end
