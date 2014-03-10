#!/usr/bin/env ruby -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative '../../../spec/spec_helper'
require 'writer'

describe ExifTagger::Writer do
  before :each do
    # mocking
    @mfile = StringIO.new('script.txt', 'w+:utf-8')
    allow(File).to receive(:open).and_return(@mfile)
  end

  it 'creates script file to be used by exiftool' do
    ExifTagger::Writer.new(memo: 'automatically generated')
    expect(@mfile.string).to include('exiftool script')
    expect(@mfile.string).to include('usage: exiftool -@')
    expect(@mfile.string).to include('automatically generated')
  end

  it 'adds instructions into script' do
    tags2write = ExifTagger::TagCollection.new(
      creator: %w{Andrey\ Bizyaev Matz},
      copyright: %{2014 (c) Andrey Bizyaev},
      keywords: %w{keyword1 keyword2},
      world_region: %{Europe},
      country: %{Russia},
      state: %{State},
      city: %{Moscow},
      location: %{Pushkin street 1},
      gps_created: { gps_latitude: '55 36 31.49',
                     gps_latitude_ref: 'N',
                     gps_longitude: '37 43 28.27',
                     gps_longitude_ref: 'E',
                     gps_altitude: '170.0',
                     gps_altitude_ref: 'Above Sea Level' },
      collections: { collection_name: 'Collection Name',
                     collection_uri: 'www.site.com' },
      image_unique_id: '20140223-003748-0123',
      coded_character_set: 'UTF8',
      modify_date: 'now')
    options2write = %w{-v0 -P -overwrite_original -ignoreMinorErrors}

    writer = ExifTagger::Writer.new(memo: 'automatically generated')
    writer.add_to_script(ftfile: 'test.jpg',
                         tags: tags2write,
                         options: options2write)

    expect(@mfile.string).to include('-MWG:Creator-=Andrey Bizyaev')
    expect(@mfile.string).to include('-MWG:Creator+=Andrey Bizyaev')
    expect(@mfile.string).to include('-MWG:Creator-=Matz')
    expect(@mfile.string).to include('-MWG:Creator+=Matz')
    expect(@mfile.string).to include('-MWG:Copyright=2014 (c) Andrey Bizyaev')
    expect(@mfile.string).to include('-MWG:Keywords-=keyword1')
    expect(@mfile.string).to include('-MWG:Keywords+=keyword1')
    expect(@mfile.string).to include('-MWG:Keywords-=keyword2')
    expect(@mfile.string).to include('-MWG:Keywords+=keyword2')
    expect(@mfile.string).to include('-XMP-iptcExt:LocationShownWorldRegion=Europe')
    expect(@mfile.string).to include('-MWG:Country=Russia')
    expect(@mfile.string).to include('-MWG:State=State')
    expect(@mfile.string).to include('-MWG:City=Moscow')
    expect(@mfile.string).to include('-MWG:Location=Pushkin street 1')
    expect(@mfile.string).to include('-GPSLatitude="55 36 31.49"')
    expect(@mfile.string).to include('-GPSLatitudeRef=N')
    expect(@mfile.string).to include('-GPSLongitude="37 43 28.27"')
    expect(@mfile.string).to include('-GPSLongitudeRef=E')
    expect(@mfile.string).to include('-GPSAltitude=170.0')
    expect(@mfile.string).to include('-GPSAltitudeRef=Above Sea Level')
    expect(@mfile.string).to include('-XMP-mwg-coll:Collections-={CollectionName=Collection Name, CollectionURI=www.site.com}')
    expect(@mfile.string).to include('-XMP-mwg-coll:Collections+={CollectionName=Collection Name, CollectionURI=www.site.com}')
    expect(@mfile.string).to include('-ImageUniqueID=20140223-003748-0123')
    expect(@mfile.string).to include('-IPTC:CodedCharacterSet=UTF8')
    expect(@mfile.string).to include('-EXIF:ModifyDate=now')
    expect(@mfile.string).to include('test.jpg')
    expect(@mfile.string).to include('-v0')
    expect(@mfile.string).to include('-P')
    expect(@mfile.string).to include('-overwrite_original')
    expect(@mfile.string).to include('-overwrite_original')
    expect(@mfile.string).to include('-execute')
  end
end
