#!/usr/bin/env ruby -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative '../../../spec/spec_helper'
require 'exif_tagger'

describe ExifTagger::Tags do

  it 'saves :keywords value' do
    mytags = ExifTagger::Tags.new
    val_array = %w{aaa bbb ааа ббб}
    mytags[:keywords] = val_array
    expect(mytags[:keywords]).to match_array(val_array)
    expect(mytags.to_s).to include(val_array.to_s)
    expect(mytags.item(:keywords).tag_id).to be(:keywords)
    expect(mytags.item(:keywords)).to be_valid
    expect(mytags.item(:keywords).errors).to be_empty

    script = mytags.to_write_script
    expect(script).to include('-MWG:Keywords-=aaa')
    expect(script).to include('-MWG:Keywords+=aaa')
    expect(script).to include('-MWG:Keywords-=bbb')
    expect(script).to include('-MWG:Keywords+=bbb')
    expect(script).to include('-MWG:Keywords-=ааа')
    expect(script).to include('-MWG:Keywords+=ааа')
    expect(script).to include('-MWG:Keywords-=ббб')
    expect(script).to include('-MWG:Keywords+=ббб')
  end
 
  # it 'adds exiftool instructions into script file' do
  #                  collection_name: 'Test Event',
  #                  collection_uri: 'www.leningrad.spb.ru',
  #                  coded_character_set: 'UTF8',
  #                  modify_date: 'now'}
  #   options2write = %w{-v0 -P -overwrite_original -ignoreMinorErrors}

  #   t = FTools::Tagger.new(memo: 'automatically generated')
  #   t.add_to_script(ftfile: 'TEST.JPG',
  #                   tags: tags2write,
  #                   options: options2write)

  #   expect(@mfile.string).to include('-XMP:CollectionName-=Test Event')
  #   expect(@mfile.string).to include('-XMP:CollectionName+=Test Event')
  #   expect(@mfile.string).to include('-XMP:CollectionURI-=www.leningrad.spb.ru')
  #   expect(@mfile.string).to include('-XMP:CollectionURI+=www.leningrad.spb.ru')
  #   expect(@mfile.string).to include('-IPTC:CodedCharacterSet=UTF8')
  #   expect(@mfile.string).to include('-EXIF:ModifyDate=now')
  #   expect(@mfile.string).to include('TEST.JPG')
  #   expect(@mfile.string).to include('-v0')
  #   expect(@mfile.string).to include('-P')
  #   expect(@mfile.string).to include('-overwrite_original')
  #   expect(@mfile.string).to include('-overwrite_original')
  #   expect(@mfile.string).to include('-execute')
  # end
end
