#!/usr/bin/env ruby
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

      @tags_default = ExifTagger::TagCollection.new(
        keywords: @event.keywords,
        world_region: @place_created[:world_region],
        country: @place_created[:country],
        country_code: @place_created[:country_code],
        state: @place_created[:state],
        city: @place_created[:city],
        location: @place_created[:location],
        gps_created: @place_created[:gps_created],
        collections: { collection_name: @event.title,
                       collection_uri: @event.uri },
        image_unique_id: "#{DateTime.now.strftime('%Y%m%d-%H%M%S-')}",
        coded_character_set: 'UTF8',
        modify_date: 'now')
      fail FTools::Error, @tags_default.error_message unless @tags_default.valid?
    end

    def process_before
      @writer = ExifTagger::Writer.new(
        script_name: 'exif_tagger.txt',
        memo: "#{DateTime.now}: Script generated by #{@tool_name} (ftools bundle) version #{VERSION} (core #{VERSION_CORE})",
        output: STDERR)
    end

    def process_file(ftfile)
      # TODO: fail if file is not supported by exiftool
      fail FTools::Error, 'non-standard name, use ftrename to rename' unless ftfile.basename_is_standard?
      ftfile_out = ftfile.clone
      STDERR.puts ftfile_out
      begin
        tags_original = MiniExiftool.new(ftfile.filename,
                                         replace_invalid_chars: true,
                                         composite: true,
                                         timestamps: DateTime)
      rescue
        raise FTools::Error, "EXIF tags reading by mini_exiftool - #{e.message}"
      end
      tags_to_write = ExifTagger::TagCollection.new(@tags_default)
      author = ftfile_out.author
      fail "Author '#{author}' is not found in #{@creators.filename}" if @creators[author].empty?
      tags_to_write[:creator] = @creators[author][:creator]
      tags_to_write[:copyright] = "#{ftfile_out.date_time.year} #{@creators[author][:copyright]}"
      tags_to_write[:image_unique_id] = @tags_default[:image_unique_id] + format('%04d', @writer.added_files_count + 1)
      tags_to_write.item(:modify_date).force_write = true
      tags_to_write.validate_with_original(tags_original)
      STDERR.puts tags_to_write.warning_message if tags_to_write.with_warnings?
      fail FTools::Error, tags_to_write.error_message unless tags_to_write.valid?
      @writer.add_to_script(ftfile: ftfile_out, tags: tags_to_write)
      ''
    rescue  => e
      raise FTools::Error, e.message
    end

    def process_after
      @writer.run!
    end
  end
end
