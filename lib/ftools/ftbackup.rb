#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative 'runner.rb'

module FTools
  # backup files
  class FTbackup < Runner
    private

    def validate_options
      @backup_dir = @options_cli['--backup'] || ''
      fail FTools::Error, 'backup dir is not defined' if @backup_dir.empty?
    end

    def process_before
      if File.exist?(@backup_dir)
        fail FTools::Error, "#{@backup_dir} is not a directory" unless
          File.directory?(@backup_dir)
        fail FTools::Error, "#{@backup_dir} is not writable" unless
          File.writable?(@backup_dir)
      else
        begin
          Dir.mkdir @backup_dir
        rescue
          raise FTools::Error, "Unable to make dir '#{@backup_dir}'"
        end
      end
    end

    def process_file(ftfile)
      backup_path = File.join(@backup_dir,
                              ftfile.basename + ftfile.extname)
      FileUtils.cp(ftfile.filename, backup_path, verbose: FTools.debug)
      ftfile
    rescue
      raise FTools::Error, "file copying to #{@backup_dir}"
    end
  end
end
