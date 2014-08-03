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

  context 'when the original value (read by mini_exiftool) exists -' do
    it 'generates warnings' do
      tag.validate_with_original(val_orig)
      expect(tag.warnings).not_to be_empty
      expect(tag.warnings.inspect).to include('has original value:')
    end
    it 'generates write_script with commented lines' do
      tag.validate_with_original(val_orig)
      expect(tag.to_write_script).to include('# -MWG:DateTimeOriginal=2014-07-31 21:01:01')
      expect(tag.to_write_script).to match(/# WARNING: ([\w]*) has original value:/)
    end
  end

  it 'accepts String value' do
    t = described_class.new('now')
    expect(t).to be_valid
    expect(t.value).to eq 'now'
    expect(t.value_invalid).to be_empty
    expect(t.to_write_script).to include('-MWG:DateTimeOriginal=now')
  end

  it 'accepts DateTime value' do
    t = described_class.new(DateTime.new(2014, 07, 31, 22, 53, 10))
    expect(t).to be_valid
    expect(t.value).to eq DateTime.new(2014, 07, 31, 22, 53, 10)
    expect(t.value_invalid).to be_empty
    expect(t.to_write_script).to include('-MWG:DateTimeOriginal=2014-07-31 22:53:10')
  end

  it 'accepts Time value' do
    t = described_class.new(Time.new(2014, 07, 31, 22, 57, 10))
    expect(t).to be_valid
    expect(t.value).to eq Time.new(2014, 07, 31, 22, 57, 10)
    expect(t.value_invalid).to be_empty
    expect(t.to_write_script).to include('-MWG:DateTimeOriginal=2014-07-31 22:57:10')
  end

  it 'does not accept values of wrong type' do
    t = described_class.new(Date.new(2014, 07, 31))
    expect(t).not_to be_valid
    expect(t.value).to be_empty
    expect(t.value_invalid).not_to be_empty
    expect(t.value_invalid).to match_array([Date.new(2014, 07, 31)])
    expect(t.to_write_script).to be_empty
    expect(t.errors.inspect).to include('wrong type (Date)')
  end
 
  it 'does not accept too long String value' do
    val_nok = '123456789012345678901234567890123' # bytesize=33
    t = described_class.new(val_nok)
    expect(t).not_to be_valid
    expect(t.value).to be_empty
    expect(t.value_invalid).not_to be_empty
    expect(t.value_invalid).to match_array([val_nok])
    expect(t.to_write_script).to be_empty
    expect(t.errors.inspect).to include('longer than allowed')
  end
 
  it 'does not accept zero DateTime value' do
    val_nok = DateTime.new(0)
    t = described_class.new(val_nok)
    expect(t).not_to be_valid
    expect(t.value).to be_empty
    expect(t.value_invalid).not_to be_empty
    expect(t.value_invalid).to match_array([val_nok])
    expect(t.to_write_script).to be_empty
    expect(t.errors.inspect).to include('zero Date')
  end
 
  it 'does not accept zero Time value' do
    val_nok = Time.new(0)
    t = described_class.new(val_nok)
    expect(t).not_to be_valid
    expect(t.value).to be_empty
    expect(t.value_invalid).not_to be_empty
    expect(t.value_invalid).to match_array([val_nok])
    expect(t.to_write_script).to be_empty
    expect(t.errors.inspect).to include('zero Date')
  end
end
