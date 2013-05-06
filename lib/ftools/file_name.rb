#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (с) ANB Andrew Bizyaev Андрей Бизяев 

require 'date'

module FTools
  # filename constants
  NicknameMaxSize = 3

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
