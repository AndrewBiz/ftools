#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (с) ANB Andrew Bizyaev Андрей Бизяев 

require 'docopt'
require_relative 'error.rb'
require_relative 'file_type.rb'

module FTools
  class Runner

    def initialize( usage, file_type=[] )
      ARGV.map!{|a| a.encode("internal", "filesystem")}   #workaround for win32
      @options_cli = Docopt::docopt( usage, version: FTools::VERSION ) 
      @file_type = file_type
      #puts_error @options_cli.to_s if DEBUG 
    rescue Docopt::Exit => e
      STDERR.puts e.message
      exit 1
    end

    def run
      ARGV.clear

      ARGF.each_line do |line|
        result = nil
        filename = line.chomp!
        begin
          # checking file
          unless filename && File.exist?(filename)
            raise FTools::Error.new("does not exist")
          end
          if File.directory?(filename)
            raise FTools::Error.new("not a file")
          end        
          raise FTools::Error.new("wrong type") unless @file_type.include?(File.extname(filename).downcase.slice(1..-1))
          
          result = process_file( filename )
      
        rescue FTools::Error => e
          FTools::puts_error "ERROR: '#{line}' - #{e.message}"
        else  
          STDOUT.puts result unless result.nil?
        end  
      end

    rescue SignalException => e
      STDERR.puts "Exit on user interrupt Ctrl-C"
      exit 1
    rescue Exception => e
      STDERR.puts e.message, e.backtrace
      exit 1
    end

  end
end
