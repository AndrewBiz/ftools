#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative 'runner'

module FTools
  # list generation
  class Runner

    def run
      @options_cli['DIR_OR_FILE'] = ['.'] if @options_cli['DIR_OR_FILE'].empty?
      @options_cli['DIR_OR_FILE'].each { |item| output_dir_or_file(item) }

    rescue SignalException
      FTools.puts_error 'EXIT on user interrupt Ctrl-C'
      exit 1
    rescue => e
      FTools.puts_error "FATAL: #{e.message}", e
      exit 1
    end

    private

    def output_dir_or_file(item)
      if File.exist?(item)
        if File.directory?(item)
          fmask = File.join(item, @options_cli['--recursive'] ? '**' : '',
                            "{#{@file_type.map { |i| "*.#{i}" } * ','}}")
          files_to_process = Dir.glob(fmask, File::FNM_CASEFOLD |
                                      File::FNM_DOTMATCH)
          files_to_process.each { |f| output_file(f) }
        else
          output_file(item)
        end
      end
    end

    def output_file(file)
      @os.output(file) if @file_type.include?(File.extname(file).slice(1..-1))
    end

  end
end
