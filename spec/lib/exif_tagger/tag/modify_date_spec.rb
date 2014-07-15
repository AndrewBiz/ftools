#!/usr/bin/env ruby
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require 'spec_helper'
require 'tag/modify_date'
require 'date'

describe ExifTagger::Tag::ModifyDate do
  let(:val_ok) { 'now' }
  let(:val_orig) { { 'ModifyDate' => DateTime.now } }
  let(:tag) { described_class.new(val_ok) }

  it_behaves_like 'any tag'

  it 'knows it\'s ID' do
    expect(tag.tag_id).to be :modify_date
    expect(tag.tag_name).to eq 'ModifyDate'
  end

  it 'generates write_script for exiftool' do
    expect(tag.to_write_script).to include('-EXIF:ModifyDate=now')
  end

  context 'when the original value (read by mini_exiftool) exists -' do
    it 'generates NO warnings' do
      tag.validate_with_original(val_orig)
      expect(tag.warnings).to be_empty
    end
    it 'generates write_script for exiftool' do
      tag.validate_with_original(val_orig)
      expect(tag.to_write_script).to include('-EXIF:ModifyDate=now')
      expect(tag.to_write_script).not_to include('# -EXIF:ModifyDate=now')
      expect(tag.to_write_script).not_to match(/# WARNING: ([\w]*) has original value:/)
    end
  end

  context 'when gets invalid value' do
    val_nok = '123456789012345678901234567890123' # bytesize=33
    subject { described_class.new(val_nok) }
    its(:value) { should be_empty }
    it { should_not be_valid }
    its(:value_invalid) { should_not be_empty }
    its(:value_invalid) { should match_array([val_nok]) }
    its(:to_write_script) { should be_empty }
  end
end
