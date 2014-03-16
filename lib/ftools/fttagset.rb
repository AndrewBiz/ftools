#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require 'date'
require_relative 'runner.rb'
require_relative 'event'
require_relative '../mini_exiftool-2.3.0anb'
require_relative '../exif_tagger/exif_tagger'

module FTools
  # setting EXIF etc tags in media file
  class Fttagset < Runner
    private

    def validate_options
      @event = Event.new(@options_cli['--event'])

      @creators = ExifTagger::CreatorsDir.new(@options_cli['--creators'])
      fail FTools::Error, @creators.error_message unless @creators.valid?
      @places = ExifTagger::PlacesDir.new(@options_cli['--places'])
      fail FTools::Error, @places.error_message unless @places.valid?

      @place_created = @places[@event.alias_place_created]
      fail FTools::Error, "Place '#{@event.alias_place_created}' is not found in #{@places.filename}" if @place_created.empty?
      # TODO: generate default tag_collection
      # TODO: fail if default tags have errors
    end

    def process_before
      @writer = ExifTagger::Writer.new(
        script_name: 'exif_tagger.txt',
        memo: "#{DateTime.now}: Script generated by #{@tool_name} (ftools bundle) version #{VERSION} (core #{VERSION_CORE})")
      puts "*** Preparing exiftool script '#{@writer.script_name}' ..."
    end

    def process_file(ftfile)
      # TODO: fail if file is not supported by exiftool

      fail FTools::Error, 'non-standard name, use ftrename to rename' unless ftfile.basename_is_standard?
      ftfile_out = ftfile.clone

      begin
        tags_original = MiniExiftool.new(ftfile.filename, replace_invalid_chars: true,
                                       composite: true,
                                       timestamps: DateTime)
      rescue
        raise FTools::Error, "EXIF tags reading - #{e.message}"
      end

      # TODO: add places tags
      # TODO: check to not owerwrite existing tags e.g. gps

      # initializing tags for the given file
      tags_to_write = ExifTagger::TagCollection.new

      author = ftfile_out.author
      fail "Author '#{author}' is not found in #{@creators.filename}" if @creators[author].empty?
      tags_to_write[:creator] = @creators[author][:creator]
      tags_to_write[:copyright] = "#{ftfile_out.date_time.year} #{@creators[author][:copyright]}"

      tags_to_write[:keywords] = @event.keywords
      tags_to_write[:world_region] = @place_created[:world_region]
      tags_to_write[:country] = @place_created[:country]
      tags_to_write[:country_code] = @place_created[:country_code]
      tags_to_write[:state] = @place_created[:state]
      tags_to_write[:city] = @place_created[:city]
      tags_to_write[:location] = @place_created[:location]
      tags_to_write[:gps_created] = @place_created[:gps_created]
      tags_to_write[:collections] = { collection_name: @event.title,
                                      collection_uri: @event.uri }
      # tags_to_write[:image_unique_id] = '20140223-003748-0123'
      tags_to_write[:coded_character_set] = 'UTF8'
      tags_to_write[:modify_date] = 'now'

      @writer.add_to_script(ftfile: ftfile_out, tags: tags_to_write)

      ftfile_out
    rescue  => e
      raise FTools::Error, e.message
    end

    def process_after
      puts '*** Finished preparation of the script'
      puts "*** Running #{@writer.command} ..."
      @writer.run!
      puts '*** Finished'
    end
  end
end
