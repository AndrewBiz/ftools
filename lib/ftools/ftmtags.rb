#!/usr/bin/env ruby
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative 'runner.rb'
require_relative '../mini_exiftool-2.3.0anb'

module FTools
  # backup files
  class Ftmtags < Runner
    FT_TAGS = %w(
      DateTimeOriginal
      CreateDate
      ModifyDate
      GPSDateTime

      Artist
      Creator
      Byline

      Copyright
      Rights
      CopyrightNotice

      Subject
      Keywords

      GPSPosition
      GPSLatitude
      GPSLatitudeRef
      GPSLongitude
      GPSLongitudeRef
      GPSAltitude
      GPSAltitudeRef

      LocationShownWorldRegion

      LocationShownCountryName
      CountryPrimaryLocationName
      Country

      LocationShownCountryCode

      LocationShownProvinceState
      State
      ProvinceState

      LocationShownCity
      City

      Location
      LocationShownSublocation
      Sublocation

      CollectionName
      CollectionURI

      ImageUniqueID
      CodedCharacterSet
    )
    private

    def process_file(ftfile)
      begin
        tags = MiniExiftool.new(ftfile.filename,
                                replace_invalid_chars: true,
                                composite: true,
                                timestamps: DateTime)
        # tags_original.values.each { |k, v| puts "#{k}=#{v}" }
      rescue
        raise FTools::Error, "EXIF tags reading - #{e.message}"
      end

      puts "#{ftfile}"
      FT_TAGS.each do |t|
        v = tags[t]
        if v.respond_to?(:empty?)
          empty = v.empty? ? ' EMPTY' : ''
        end
        if v.nil?
          puts "#{t}\tNIL"
        else  
          puts "#{t}\t#{v} (#{v.class}#{empty})"
        end
      end

      ''
    rescue => e
      raise FTools::Error, "exif tags operating: #{e.message}"
    end
  end
end
