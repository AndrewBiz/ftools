#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative 'error'
require 'yaml'
require 'date'

# Foto tools
module FTools
  # ftools event operations
  class Event
    attr_reader :profile, :raw_data, :basename, :dirname,
                :title, :sort, :uri, :date_start, :date_end,
                :keywords, :alias_place_created

    def initialize(filename, parent_dirname = '.')
      fail FTools::Error, "event profile '#{filename}' does not exist" unless
        filename && File.exist?(filename)
      fail FTools::Error, "event profile '#{filename}' is not a file" if
        File.directory?(filename)
      fail FTools::Error, "event profile '#{filename}' should be yml type"\
        unless File.extname(filename).downcase == '.yml'

      begin
        @profile = filename
        @raw_data = YAML.load_file(filename)
        @title = @raw_data[:event][:title] || ''
        @sort = @raw_data[:event][:sort] || ''
        @uri = @raw_data[:event][:uri] || ''
        @date_start, @date_end =
          collect_dates(@raw_data[:event][:date_start] || '',
                        @raw_data[:event][:date_end] || '')
        @keywords = collect_keywords(@raw_data[:event][:keywords] || {})
        @alias_place_created = @raw_data[:event][:alias_place_created] || ''
      rescue => e
        raise FTools::Error,
              "reading event profile '#{filename}' - #{e.message}"
      end

      validate_event
      @basename = generate_basename
      @dirname = File.join(parent_dirname, @basename)
    end

    def mkdir
      if File.exist?(@dirname)
        fail FTools::Error, "#{@dirname} is not a directory" unless
          File.directory?(@dirname)
        fail FTools::Error, "#{@dirname} is not writable" unless
          File.writable?(@dirname)
      else
        Dir.mkdir @dirname
      end
    end

    def copy_profile
      target_profile = File.join(@dirname, 'event.yml')
      FileUtils.cp(@profile, target_profile)
    end

    private

    def collect_dates(date_start = '', date_end = '')
      fail FTools::Error, 'date_start is not set' if date_start.empty?
      ds = DateTime.strptime(date_start, '%Y-%m-%d %H:%M:%S')
      if date_end.empty?
        de = DateTime.new(ds.year, ds.mon, ds.mday, 23, 59, 59)
      else
        de = DateTime.strptime(date_end, '%Y-%m-%d %H:%M:%S')
      end
      [ds, de]
    rescue => e
      raise  FTools::Error, "parsing dates - #{e.message}"
    end

    def collect_keywords(keywords_hash = {})
      keywords = []
      keywords_hash.each_value { |v| keywords << v }
      keywords.flatten!.uniq!
      keywords.compact!
      keywords.delete_if { |v| v.empty? }
    end

    def generate_basename
      # Generate PREFIX in format:
      #     YYYYmmdd if date1 == date2
      #     YYYYmmdd-dd if day is different
      #     YYYYmmdd-mmdd if month is different
      #     YYYYmmdd-YYYYmmdd if year is different
      prefix = @date_start.strftime('%Y%m%d')
      case
      when @date_start.year != @date_end.year
        prefix += '-' + @date_end.strftime('%Y%m%d')
      when @date_start.mon != @date_end.mon
        prefix += '-' + @date_end.strftime('%m%d')
      when @date_start.mday != @date_end.mday
        prefix += '-' + @date_end.strftime('%d')
      end
      "#{prefix + @sort} #{@title}".strip
    end

    def validate_event
      @title.strip!
      fail FTools::Error, 'invalid event profile - title is not set' \
        if @title.empty?

      @uri.strip!
      fail FTools::Error, 'invalid event profile - date_end < date_start' \
        if @date_end < @date_start
      @keywords.map! { |v| v.strip }
      @alias_place_created.strip!
    end
  end
end
