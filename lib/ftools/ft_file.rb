#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require 'time'

# Foto tools
module FTools
  # media type constants
  FILE_TYPE_IMAGE = %w{jpg jpeg tif tiff orf arw png dng}
  FILE_TYPE_VIDEO = %w{avi mp4 mpg mts dv mov}

  # ftools file name operations
  class FTFile
    # filename constants
    NICKNAME_MIN_SIZE = 3
    NICKNAME_MAX_SIZE = 6
    # TODO: NICKNAME - check size, only word, no non-ascii symbols
    NICKNAME_SIZE = 3 # should be in range of MIN and MAX

    ZERO_DATE = DateTime.strptime('0000', '%Y')

    attr_reader :filename, :dirname, :extname, :basename, :basename_part,
                :date_time

    def initialize(filename)
      @filename = filename
      @dirname = File.dirname(@filename)
      @extname = File.extname(@filename)
      @basename = File.basename(@filename, @extname)
      parse_basename
      @date_time = reveal_date_time
    end

    def generate_basename(clean_name: 'NNN',
                          date_time: ZERO_DATE,
                          author: 'XXX')
      # Generating standard FT name
      %Q{#{date_time.strftime('%Y%m%d-%H%M%S')}_#{(author + "XXXXXX")[0, NICKNAME_SIZE]} #{clean_name}}
    end

    def date_time_ok?
      @date_time != ZERO_DATE
    end

    def basename_is_standard?
      @basename == generate_basename(clean_name: @basename_part[:clean],
                                     date_time: @date_time,
                                     author: @basename_part[:author])
    end

    private

    def reveal_date_time
      date = @basename_part[:date]
      time = @basename_part[:time]
      strptime_template = ''
      strptime_string = ''
      case date.size
      when 4 # expecting Year e.g.2001
        strptime_template += '%Y'
        strptime_string += date
      when 8 # expecting YYmmdd e.g.20010101
        strptime_template += '%Y%m%d'
        strptime_string += date
      end
      case time.size
      when 4 # expecting HHMM e.g. 1025
        strptime_template += '%H%M'
        strptime_string += time
      when 6 # expecting YHHMMSS e.g.102559
        strptime_template += '%H%M%S'
        strptime_string += time
      end

      DateTime.strptime(strptime_string, strptime_template)

    rescue ArgumentError
      return ZERO_DATE
    end

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
      # STANDARD template
      # check YYYYmmdd-HHMMSS_AUT cleanname
      when /^(?<prefix>(?<date>\d{8})-(?<time>\d{6})_(?<author>\w{#{NICKNAME_MIN_SIZE},#{NICKNAME_MAX_SIZE}})[-\s_])(?<clean>.*)/
        @basename_part = default.merge(prefix: Regexp.last_match(:prefix),
                                       clean: Regexp.last_match(:clean),
                                       date: Regexp.last_match(:date),
                                       time: Regexp.last_match(:time),
                                       author: Regexp.last_match(:author))
      # check if name = YYYYmmdd-HHMM_AAA_name
      when /^(?<prefix>(?<date>\d{8})-(?<time>\d{4})[-\s_](?<author>\w{#{NICKNAME_MIN_SIZE},#{NICKNAME_MAX_SIZE}})[-\s_])(?<clean>.*)/
        @basename_part = default.merge(prefix: Regexp.last_match(:prefix),
                                       clean: Regexp.last_match(:clean),
                                       date: Regexp.last_match(:date),
                                       time: Regexp.last_match(:time),
                                       author: Regexp.last_match(:author))
      # check if name = YYYYmmdd-HHMM_name
      when /^(?<prefix>(?<date>\d{8})-(?<time>\d{4})[-\s_])(?<clean>.*)/
        @basename_part = default.merge(prefix: Regexp.last_match(:prefix),
                                       clean: Regexp.last_match(:clean),
                                       date: Regexp.last_match(:date),
                                       time: Regexp.last_match(:time))
      # check if name = YYYYmmdd_name
      when /^(?<prefix>(?<date>\d{8})[-\s_])(?<clean>.*)/
        @basename_part = default.merge(prefix: Regexp.last_match(:prefix),
                                       clean: Regexp.last_match(:clean),
                                       date: Regexp.last_match(:date))
      # check if name = YYYY_name
      when /^(?<prefix>(?<date>\d{4})[-\s_])(?<clean>.*)/
        @basename_part = default.merge(prefix: Regexp.last_match(:prefix),
                                       clean: Regexp.last_match(:clean),
                                       date: Regexp.last_match(:date))
      else
        @basename_part = default.merge(clean: @basename)
      end
    end
  end

  # TODO: DEPRECATED TO DELETE!
  def self.new_basename( basename, date_time_original: DateTime.civil, author: "XXX" )
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
