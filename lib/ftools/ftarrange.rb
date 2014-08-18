#!/usr/bin/env ruby
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative 'runner.rb'

module FTools
  # collecting media files into WORKING_FOLDER folder
  class Ftarrange < Runner
    private

    def validate_options
      @working_folder = @options_cli['--working_folder'] || ''
      @raw_folder = File.join(@working_folder, 'RAW')
      @video_folder = File.join(@working_folder, 'VIDEO')
    end

    def process_before
      fail FTools::Error, "#{@working_folder} does not exist" unless File.exist?(@working_folder)
      fail FTools::Error, "#{@working_folder} is not a directory" unless File.directory?(@working_folder)
      begin
        Dir.mkdir @raw_folder unless Dir.exist?(@raw_folder)
        Dir.mkdir @video_folder unless Dir.exist?(@video_folder)
      rescue
        raise FTools::Error, "Unable to make dir inside '#{@working_folder}'"
      end
    end

    def process_file(ftfile)
      ftfile_out = ftfile.clone
      file_type = ftfile.extname.slice(1..-1).downcase
      case
      when FILE_TYPE_IMAGE_NORMAL.include?(file_type)
        ftfile_out.dirname = @working_folder
      when FILE_TYPE_IMAGE_RAW.include?(file_type)
        ftfile_out.dirname = @raw_folder
      when FILE_TYPE_VIDEO.include?(file_type)
        ftfile_out.dirname = @video_folder
      when FILE_TYPE_AUDIO.include?(file_type)
        ftfile_out.dirname = @working_folder
      end

      FileUtils.mv(ftfile.filename, ftfile_out.filename) unless ftfile == ftfile_out
      ftfile_out
    rescue SystemCallError => e
      raise FTools::Error, 'file moving - ' + e.message
    end
  end
end
