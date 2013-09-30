#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative 'runner.rb'

module FTools
  class Runner

    private
    def validate_options
      @backup_dir = @options_cli['--backup'] || ''
      raise FTools::Error.new('backup dir is not defined') if @backup_dir.empty?
    end

    def process_before
      if File.exist?(@backup_dir)
        raise FTools::Error.new("#{@backup_dir} is not a directory") unless File.directory?(@backup_dir)
        raise FTools::Error.new("#{@backup_dir} is not writable") unless File.writable?(@backup_dir)
      else
        begin
          Dir.mkdir @backup_dir
        rescue => e
          raise FTools::Error.new("Unable to make dir '#{@backup_dir}'", e)
        end
      end
    end

    def process_file(filename)
      extname = File.extname(filename)
      basename = File.basename(filename, extname)
      # copy file
      begin
        new_filename = File.join(@backup_dir, basename + extname)
        FileUtils.cp(filename, new_filename, verbose: FTools.debug)
      rescue => e
        raise FTools::Error.new("file copying to #{@backup_dir}", e)
      end
      filename
    end
  end
end
