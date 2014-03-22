#!/usr/bin/env ruby
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative '../../../../spec/spec_helper'
require 'tag/coded_character_set'

describe ExifTagger::Tag::CodedCharacterSet do
  val1 = 'UTF8'
  context "when saves the #{val1}" do
    subject { ExifTagger::Tag::CodedCharacterSet.new(val1) }
    its(:value) { should eq(val1) }
    its(:to_s) { should include(val1.to_s) }
    its(:tag_id) { should be(:coded_character_set) }
    its(:tag_name) { should eq('CodedCharacterSet') }
    it { should be_valid }
    its(:errors) { should  be_empty }
    its(:value_invalid) { should be_empty }

    it 'generates write_script to be used with exiftool' do
      script = subject.to_write_script
      expect(script).to include('-IPTC:CodedCharacterSet=UTF8')
    end
  end

  it 'prevents its properties to be altered from outside' do
    val = 'zzz'
    tag = ExifTagger::Tag::CodedCharacterSet.new(val)
    expect { tag.value << 'newvalue' }.to raise_error(RuntimeError)
    expect { tag.value_invalid << 'new invalid value' }.to raise_error(RuntimeError)
    expect { tag.errors << 'new error' }.to raise_error(RuntimeError)
  end

  context 'when gets invalid values' do
    val_nok = '123456789012345678901234567890123' # bytesize=33

    subject { ExifTagger::Tag::CodedCharacterSet.new(val_nok) }
    its(:value) { should be_empty }
    it { should_not be_valid }
    its(:value_invalid) { should_not be_empty }
    its(:value_invalid) { should match_array([val_nok]) }
    its(:to_write_script) { should be_empty }
  end
end
