#!/usr/bin/env ruby
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require 'spec_helper'
require 'tag/date_time_original'
require 'date'

describe ExifTagger::Tag::DateTimeOriginal do
  let(:val_ok) { DateTime.new(2014, 07, 31, 21, 1, 1) }
  let(:val_orig) { { 'DateTimeOriginal' => DateTime.new(2014, 01, 21, 11, 5, 5) } }
  let(:tag) { described_class.new(val_ok) }

  it_behaves_like 'any tag'

  it 'knows it\'s ID' do
    expect(tag.tag_id).to be :date_time_original
    expect(tag.tag_name).to eq 'DateTimeOriginal'
  end

  it 'generates write_script for exiftool' do
    expect(tag.to_write_script).to include('-MWG:DateTimeOriginal=2014-07-31 21:01:01')
  end

  it_behaves_like 'any paranoid tag'

  it_behaves_like 'any date-tag'
end
