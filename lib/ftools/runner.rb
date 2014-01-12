#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative 'ruby_version.rb'
require 'docopt'
require_relative 'os_win.rb'
require_relative 'os_unix.rb'
require_relative 'error.rb'
require_relative 'ft_file.rb'

# Foto Tools
module FTools
  VERSION_CORE = '0.3.1'

  # Main class processing input stream
  class Runner
    def initialize(usage, file_type = [])
      case FTools.os
      when :windows
        # workaround for win32
        ARGV.map! { |a| a.encode('internal', 'filesystem') }
        @os = OSWin.new
      else
        @os = OSUnix.new
      end
      @tool_name = File.basename($PROGRAM_NAME)
      @options_cli = Docopt.docopt(usage, version:
                   "#{VERSION} (core #{VERSION_CORE})")
      @file_type = file_type
      FTools.debug = true if @options_cli['--debug']
      FTools.puts_error "OPTIONS = #{@options_cli.to_s}" if FTools.debug

      validate_options

    rescue Docopt::Exit => e
      STDERR.puts e.message
      exit 0
    rescue => e
      FTools.puts_error "FATAL: #{e.message}", e
      exit 1
    end

    def run!
      return if STDIN.tty?
      ARGV.clear
      process_before

      ARGF.each_line do |line|
        filename = line.chomp
        begin
          FTFile.validate_file!(filename, @file_type)
          ftfile = FTFile.new(filename)
          @os.output process_file(ftfile)
        rescue FTools::Error => e
          FTools.puts_error "ERROR: '#{filename}' - #{e.message}", e
        end
      end

      process_after

    rescue SignalException
      FTools.puts_error 'EXIT on user interrupt Ctrl-C'
      exit 1
    rescue => e
      FTools.puts_error "FATAL: #{e.message}", e
      exit 1
    end

    private

    def validate_options
    end

    def process_before
    end

    def process_file(file)
      file
    end

    def process_after
    end
  end
end
