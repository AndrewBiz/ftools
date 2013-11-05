#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require 'date'

# Foto tools
module FTools
  # filename constants
  NICKNAME_MIN_SIZE = 3
  NICKNAME_MAX_SIZE = 6
  # TODO: use NICKNAME_SIZE in code
  # TODO: NICKNAME - check size, only word, no non-ascii symbols
  NICKNAME_SIZE = 3 # should be in range of MIN and MAX

  # ftools file name operations
  class FileName

    attr_reader :dirname, :extname, :basename, :basename_part

    def initialize(filename)
      @dirname = File.dirname(filename)
      @extname = File.extname(filename)
      @basename = File.basename(filename, @extname)
      parse_basename
    end

    private

    def parse_basename
      default = { prefix: '', clean: '', date: '',
                  time: '', author: '', id: '', flags: '' }

      case @basename
      # check YYYYmmdd-HHMMSS_AUT[ID]{FLAGS}cleanname
      when /^(?<prefix>(?<date>\d{8})-(?<time>\d{6})_(?<author>\w{#{NICKNAME_MIN_SIZE},#{NICKNAME_MAX_SIZE}})\[(?<id>.*)\]\{(?<flags>.*)\})(?<clean>.*)/
        @basename_part = default.merge(prefix: Regexp.last_match(:prefix),
                                       clean: Regexp.last_match(:clean),
                                       date: Regexp.last_match(:date),
                                       time: Regexp.last_match(:time),
                                       author: Regexp.last_match(:author),
                                       id: Regexp.last_match(:id),
                                       flags: Regexp.last_match(:flags))

      # check YYYYmmdd-HHMMSS_AUT[ID]cleanname
      when /^(?<prefix>(?<date>\d{8})-(?<time>\d{6})_(?<author>\w{#{NICKNAME_MIN_SIZE},#{NICKNAME_MAX_SIZE}})\[(?<id>.*)\])(?<clean>.*)/
        @basename_part = default.merge(prefix: Regexp.last_match(:prefix),
                                       clean: Regexp.last_match(:clean),
                                       date: Regexp.last_match(:date),
                                       time: Regexp.last_match(:time),
                                       author: Regexp.last_match(:author),
                                       id: Regexp.last_match(:id))

      # check YYYYmmdd-HHMMSS_AUT_cleanname
      when /^(?<prefix>(?<date>\d{8})-(?<time>\d{6})_(?<author>\w{#{NICKNAME_MIN_SIZE},#{NICKNAME_MAX_SIZE}})_)(?<clean>.*)/
        @basename_part = default.merge(prefix: Regexp.last_match(:prefix),
                                       clean: Regexp.last_match(:clean),
                                       date: Regexp.last_match(:date),
                                       time: Regexp.last_match(:time),
                                       author: Regexp.last_match(:author))

      # STANDARD template
      # check YYYYmmdd-HHMMSS_AUT cleanname
      when /^(?<prefix>(?<date>\d{8})-(?<time>\d{6})_(?<author>\w{#{NICKNAME_MIN_SIZE},#{NICKNAME_MAX_SIZE}}) )(?<clean>.*)/
        @basename_part = default.merge(prefix: Regexp.last_match(:prefix),
                                       clean: Regexp.last_match(:clean),
                                       date: Regexp.last_match(:date),
                                       time: Regexp.last_match(:time),
                                       author: Regexp.last_match(:author))

      # TODO: remaining regexps

      else
        @basename_part = default.merge(clean: @basename)
      end
    end

  end

  # TODO: DEPRECATED TO DELETE!
  def self.new_basename( basename, date_time_original: DateTime.civil, author: "N_A" )
    %Q{#{date_time_original.strftime('%Y%m%d-%H%M%S')}_#{author} #{basename}}    
  end

  def self.clean_name( name )
    # + check if name = YYYYmmdd-HHMMSS_AAA[ID]{bla}name
    if (/^(\d{8}-\d{6}_\w{3}\[.*\]\{.*\})(.*)/ =~ name)
      return $2
    end
    # + check if name = YYYYmmdd-HHMMSS_AAA[ID]name
    if (/^(\d{8}-\d{6}_\w{3}\[.*\])(.*)/ =~ name)
      return $2
    end
    # + check if name = YYYYmmdd-HHMMSS_AAA name
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
