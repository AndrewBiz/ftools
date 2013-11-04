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
  # TODO: make test of NICKNAME_SIZE - should be in a range
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

      # TODO: bn =~ %r{^(?<author>\w{#{min},#{max}})}
      # TODO: m = Regexp.new(srt_regexp).match(file_name)

      case

      # check YYYYmmdd-HHMMSS_AUT[ID]{FLAGS}cleanname
      when %r{^(?<prefix>(?<date>\d{8})-(?<time>\d{6})_(?<author>\w{3})\[(?<id>.*)\]\{(?<flags>.*)\})(?<clean>.*)} =~ @basename
        @basename_part = default.merge(prefix: prefix, clean: clean,
                                       date: date, time: time,
                                       author: author, id: id, flags: flags)
      # check YYYYmmdd-HHMMSS_AUT[ID]cleanname
      when %r{^(?<prefix>(?<date>\d{8})-(?<time>\d{6})_(?<author>\w{3})\[(?<id>.*)\])(?<clean>.*)} =~ @basename
        @basename_part = default.merge(prefix: prefix, clean: clean,
                                       date: date, time: time,
                                       author: author, id: id)
      # check YYYYmmdd-HHMMSS_AUT_cleanname
      when %r{^(?<prefix>(?<date>\d{8})-(?<time>\d{6})_(?<author>\w{3})_)(?<clean>.*)} =~ @basename
        @basename_part = default.merge(prefix: prefix, clean: clean,
                                       date: date, time: time,
                                       author: author)
      # STANDARD template
      # check YYYYmmdd-HHMMSS_AUT cleanname
      when %r{^(?<prefix>(?<date>\d{8})-(?<time>\d{6})_(?<author>\w{3,6}) )(?<clean>.*)} =~ @basename
        @basename_part = default.merge(prefix: prefix, clean: clean,
                                       date: date, time: time,
                                       author: author)

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
