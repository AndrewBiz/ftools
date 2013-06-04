#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (с) ANB Andrew Bizyaev Андрей Бизяев 

require_relative 'runner.rb'

module FTools
  class Runner

    def run
      @options_cli['DIR_OR_FILE'] = ['.'] if @options_cli['DIR_OR_FILE'].empty?
      @options_cli['DIR_OR_FILE'].each { |item| output item }

    rescue SignalException => e
      FTools::puts_error "EXIT on user interrupt Ctrl-C"
      exit 1
    rescue Exception => e
      FTools::puts_error "FATAL: #{e.message}", e
      exit 1
    end

    private
    def output item
      if File.exist?(item)
        if File.directory?(item)
          fmask = File.join(item, @options_cli['--recursive'] ? "**":"",  "{#{@file_type.map {|i| "*.#{i}" } * ","}}")
          #xmask = File.join(dir_event, "{#{@options.exclude_files * ","}}")
          files_to_process = Dir.glob(fmask, File::FNM_CASEFOLD | File::FNM_DOTMATCH)
          #taboo_files = Dir.glob(xmask, File::FNM_CASEFOLD | File::FNM_DOTMATCH)
          #files_found += files_to_copy.size
          #files_excluded += (files_to_copy - (files_to_copy - taboo_files)).size
          files_to_process.each { |f| output_file(f) }
        else
          output_file(item)
        end
      end
    end

    def output_file file
      STDOUT.puts file
    end

  end
end
