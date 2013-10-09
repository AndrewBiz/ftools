#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative 'ruby_version.rb'
require 'docopt'
require 'fileutils'
require_relative 'os_win.rb'
require_relative 'os_unix.rb'
require_relative 'error.rb'
require_relative 'file_type.rb'
require_relative 'file_name.rb'

# Foto Tools
module FTools

  VERSION_CORE = '0.1.3'

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
      @options_cli = Docopt.docopt(usage, version:
                   "#{FTools::VERSION} (core #{FTools::VERSION_CORE})")
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

    def run
      return if STDIN.tty?

      ARGV.clear

      process_before

      ARGF.each_line do |line|
        result = nil
        filename = line.chomp!
        begin
          # checking file
          unless filename && File.exist?(filename)
            fail FTools::Error.new('does not exist')
          end
          fail FTools::Error.new('not a file') if File.directory?(filename)
          fail FTool::Error.new('no permission to write') unless File
            .writable?(filename)
          fail FTools::Error.new('wrong type') unless @file_type.include?(File
            .extname(filename).downcase.slice(1..-1))

          result = process_file(filename)

        rescue FTools::Error => e
          FTools.puts_error "ERROR: '#{line}' - #{e.message}", e
        else
          @os.output result unless result.nil?
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

    def process_file(filename)
      filename
    end

    def process_after
    end
  end
end
