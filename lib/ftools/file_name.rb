#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require 'date'

# Foto tools
module FTools
  # filename constants
  NICKNAME_MAX_SIZE = 3

  # ftools file name operations
  class FileName

    attr_reader :dirname, :extname, :basename, :basename_prefix
    attr_reader :basename_clean

    def initialize(filename)
      @dirname = File.dirname(filename)
      @extname = File.extname(filename)
      @basename = File.basename(filename, @extname)
      @basename_prefix, @basename_clean = parse_basename
    end

    private

    def parse_basename
      # TODO: bn =~ %r{^(?<prefix>\d{8}-\d{6}_(?<author>\w{#{min},#{max}})\[.*\])(?<clean>.*)}
      case
      # check YYYYmmdd-HHMMSS_AAA[ID]{blabla}cleanname
      when /^(?<prefix>\d{8}-\d{6}_\w{3}\[.*\]\{.*\})(?<clean>.*)/ =~ @basename
        return [prefix, clean]

      # check YYYYmmdd-HHMMSS_AAA[ID]cleanname
      when /^(?<prefix>\d{8}-\d{6}_\w{3}\[.*\])(?<clean>.*)/ =~ @basename
        return [prefix, clean]

      else
        return ['', @basename]
      end
    end

  end

  # DEPRECATED TO DELETE!
  def self.new_basename( basename, date_time_original: DateTime.civil, author: "N_A" )
    %Q{#{date_time_original.strftime('%Y%m%d-%H%M%S')}_#{author} #{basename}}    
  end

  def self.clean_name( name )
    # check if name = YYYYmmdd-HHMMSS_AAA[ID]{bla}name
    if (/^(\d{8}-\d{6}_\w{3}\[.*\]\{.*\})(.*)/ =~ name)
      return $2
    end
    # check if name = YYYYmmdd-HHMMSS_AAA[ID]name
    if (/^(\d{8}-\d{6}_\w{3}\[.*\])(.*)/ =~ name)
      return $2
    end
    # check if name = YYYYmmdd-HHMMSS_AAA name
    if (/^(\d{8}-\d{6}_\w{3} )(.*)/ =~ name)
      return $2
    end
    # check if name = YYYYmmdd-HHMM_AAA_name
    if (/^(\d{8}-\d{4}[-_\s]\w{3}[-\s_])(.*)/ =~ name)
      return $2
    end
    # check if name = YYYYmmdd-HHMM_name
    if (/^(\d{8}-\d{4}[-\s_])(.*)/ =~ name)
      return $2
    end
    # check if name = YYYYmmdd_name
    if (/^(\d{8}[-\s_])(.*)/ =~ name)
      return $2
    end
    # check if name = YYYY_name
    if (/^(\d{4}[-\s_])(.*)/ =~ name)
      return $2
    end
    name
  end

end
