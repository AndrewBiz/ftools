#!/usr/bin/env ruby -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative '../../../spec/spec_helper'
require 'tagger'

describe FTools::Tagger do
  before :each do
    # mocking
    @mfile = StringIO.new('script.txt', 'w+:utf-8')
    allow(File).to receive(:open).and_return(@mfile)
  end

  it 'creates script file to be used by exiftool' do
    FTools::Tagger.new(memo: 'automatically generated')
    expect(@mfile.string).to include('exiftool script')
    expect(@mfile.string).to include('usage: exiftool -@')
    expect(@mfile.string).to include('automatically generated')
  end
  
  it 'adds exiftool instructions into script file' do
    tags2write = { keywords: %w{aaa bbb ааа ббб},
                   collection_name: 'Test Event',
                   collection_uri: 'www.leningrad.spb.ru',
                   coded_character_set: 'UTF8',
                   modify_date: 'now'}
    options2write = %w{-v0 -P -overwrite_original -ignoreMinorErrors}

    t = FTools::Tagger.new(memo: 'automatically generated')
    t.add_to_script(ftfile: 'TEST.JPG',
                    tags: tags2write,
                    options: options2write)

    expect(@mfile.string).to include('-MWG:Keywords-=aaa')
    expect(@mfile.string).to include('-MWG:Keywords+=aaa')
    expect(@mfile.string).to include('-MWG:Keywords-=bbb')
    expect(@mfile.string).to include('-MWG:Keywords+=bbb')
    expect(@mfile.string).to include('-MWG:Keywords-=ааа')
    expect(@mfile.string).to include('-MWG:Keywords+=ааа')
    expect(@mfile.string).to include('-MWG:Keywords-=ббб')
    expect(@mfile.string).to include('-MWG:Keywords+=ббб')

    expect(@mfile.string).to include('-XMP:CollectionName-=Test Event')
    expect(@mfile.string).to include('-XMP:CollectionName+=Test Event')
    expect(@mfile.string).to include('-XMP:CollectionURI-=www.leningrad.spb.ru')
    expect(@mfile.string).to include('-XMP:CollectionURI+=www.leningrad.spb.ru')
    expect(@mfile.string).to include('-IPTC:CodedCharacterSet=UTF8')
    expect(@mfile.string).to include('-EXIF:ModifyDate=now')
    expect(@mfile.string).to include('TEST.JPG')
    expect(@mfile.string).to include('-v0')
    expect(@mfile.string).to include('-P')
    expect(@mfile.string).to include('-overwrite_original')
    expect(@mfile.string).to include('-overwrite_original')
    expect(@mfile.string).to include('-execute')
  end
end
