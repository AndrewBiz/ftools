#!/usr/bin/env ruby -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative '../../../spec/spec_helper'
require 'exif_tagger'

describe ExifTagger::TagCollection do

  it 'saves the tag value' do
    mytags = ExifTagger::TagCollection.new
    val_array = %w{aaa bbb ааа ббб}
    mytags[:keywords] = val_array

    expect(mytags[:keywords]).to match_array(val_array)
  end

  it 'could stringify the tags' do
    mytags = ExifTagger::TagCollection.new
    val_array = %w{aaa bbb ааа ббб}
    mytags[:keywords] = val_array

    expect(mytags.to_s).to include(val_array.to_s)
  end

  it 'does not dublicate tags' do
    mytags = ExifTagger::TagCollection.new
    val1 = %w{aaa bbb}
    val2 = %w{ccc ddd}
    mytags[:keywords] = val1
    mytags[:keywords] = val2

    expect(mytags[:keywords] == val1).to be_false
    expect(mytags[:keywords]).to match_array(val2)
  end

  it 'deletes tag from collection' do
    mytags = ExifTagger::TagCollection.new
    val = %w{aaa bbb}
    mytags[:keywords] = val

    expect(mytags[:keywords]).to match_array(val)
    mytags.delete(:keywords)

    expect(mytags[:keywords]).to be_nil
    expect(mytags.item(:keywords)).to be_nil
  end

  it 'fails in unknown tag is used' do
    mytags = ExifTagger::TagCollection.new
    val = 'hahaha'
    expect { mytags[:unknown_tag] = val }.to raise_error(ExifTagger::UnknownTag)
  end

  it 'works with basic exif tags' do
    mytags = ExifTagger::TagCollection.new
    mytags[:creator] = %w{Andrey\ Bizyaev Matz}
    mytags[:copyright] = %{2014 (c) Andrey Bizyaev. All Rights Reserved.}

    mytags[:keywords] = %w{keyword1 keyword2}

    expect(mytags[:creator]).to match_array(%w{Andrey\ Bizyaev Matz})
    expect(mytags[:copyright]).to include(%{2014 (c) Andrey Bizyaev. All Rights Reserved.})

    expect(mytags[:keywords]).to match_array(%w{keyword1 keyword2})
  end
end

# WorldRegion = -XMP:LocationCreatedWorldRegion=Europe
#    -XMP-iptcExt:LocationShownWorldRegion
# -MWG:Country=Russia
# CountryCode = -XMP-iptcCore:CountryCode=RU
#    -XMP-iptcExt:LocationShownCountryCode
# -MWG:State=Москва
# -MWG:City=Москва
# -MWG:Location=Вавилова 23
# -GPSLatitude=" 55 41 49.51"
# -GPSLatitudeRef=N
# -GPSLongitude=" 37°34 23.61"
# -GPSLongitudeRef=E
# -GPSAltitude=131.0
# -GPSAltitudeRef=Above Sea Level
# -XMP-mwg-coll:Collections-={CollectionName=имя коллекции, CollectionURI=www.rbc.ru}
# -XMP-mwg-coll:Collections+={CollectionName=имя коллекции, CollectionURI=www.rbc.ru}
# -ImageUniqueID=23232342434
# -IPTC:CodedCharacterSet=UTF8
# -EXIF:ModifyDate=now

# DateTimeOriginal                : 2013-03-07 10:51:07
# CreateDate                      : 2013-03-07 10:51:07
# ModifyDate                      : 2013-03-20 23:17:06
# Creator                         : Andrey Bizyaev (photographer), Andrey Bizyaev (camera owner)
# Copyright                       : 2013 (c) Andrey Bizyaev. All Rights Reserved.
# Keywords                        : работа, корпоратив, 8 марта,
# LocationCreatedWorldRegion      : Europe
# Country                         : Russia
# CountryCode                     : RU
# State                           : Москва
# City                            : Москва
# Location                        : Вавилова 23
# GPSLatitude                     : 55 41 49.51000000 N
# GPSLatitudeRef                  : North
# GPSLongitude                    : 37 34 23.61000000 E
# GPSLongitudeRef                 : East
# GPSAltitude                     : 131 m Above Sea Level
# GPSAltitudeRef                  : Above Sea Level
# CollectionName                  : Сбербанк 8-марта, 111, 444, 4441
# CollectionURI                   : anblab.net/, www3, 222, 555, 5551
# ImageUniqueID                   : 20130308-SRLLL
# CodedCharacterSet               : UTF8