#!/usr/bin/env ruby
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative '../../../../spec/spec_helper'
require 'tag/modify_date'

describe ExifTagger::Tag::ModifyDate do
  val1 = 'now'
  context "when saves the #{val1}" do
    subject { ExifTagger::Tag::ModifyDate.new(val1) }
    its(:value) { should eq(val1) }
    its(:to_s) { should include(val1.to_s) }
    its(:tag_id) { should be(:modify_date) }
    its(:tag_name) { should eq('ModifyDate') }
    it { should be_valid }
    its(:errors) { should  be_empty }
    its(:value_invalid) { should be_empty }

    it 'generates write_script to be used with exiftool' do
      script = subject.to_write_script
      expect(script).to include("-EXIF:ModifyDate=#{val1}")
    end
  end

  it 'prevents its properties to be altered from outside' do
    val = 'zzz'
    tag = ExifTagger::Tag::ModifyDate.new(val)
    expect { tag.value << 'newvalue' }.to raise_error(RuntimeError)
    expect { tag.value_invalid << 'new invalid value' }.to raise_error(RuntimeError)
    expect { tag.errors << 'new error' }.to raise_error(RuntimeError)
  end

  context 'when gets invalid values' do
    val_nok = '123456789012345678901234567890123' # bytesize=33

    subject { ExifTagger::Tag::ModifyDate.new(val_nok) }
    its(:value) { should be_empty }
    it { should_not be_valid }
    its(:value_invalid) { should_not be_empty }
    its(:value_invalid) { should match_array([val_nok]) }
    its(:to_write_script) { should be_empty }
  end
end