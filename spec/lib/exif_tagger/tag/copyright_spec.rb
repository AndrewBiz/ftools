#!/usr/bin/env ruby -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative '../../../../spec/spec_helper'
require 'tag/copyright'

describe ExifTagger::Tag::Copyright do
  val1 = %{2014 (c) Andrew Bizyaev}
  context "when saves the #{val1}" do
    subject { ExifTagger::Tag::Copyright.new(val1) }
    its(:value) { should eql(val1) }
    its(:to_s) { should include(val1.to_s) }
    its(:tag_id) { should be(:copyright) }
    its(:tag_name) { should eq('Copyright') }
    it { should be_valid }
    its(:errors) { should  be_empty }
    its(:value_invalid) { should be_empty }

    it 'generates write_script to be used with exiftool' do
      script = subject.to_write_script
      expect(script).to include('-MWG:Copyright=2014 (c) Andrew Bizyaev')
    end
  end

  val2 = 12_345
  context "when gets a non-string as input: #{val2}" do
    subject { ExifTagger::Tag::Copyright.new(val2) }
    val_normal = '12345'
    it 'converts the input to the string' do
      expect(subject.value).to eql(val_normal)
    end
    it { should be_valid }
    its(:errors) { should  be_empty }
    its(:value_invalid) { should be_empty }
  end

  it 'prevents its properties to be altered from outside' do
    tag = ExifTagger::Tag::Copyright.new(val1)
    expect { tag.value << 'newvalue' }.to raise_error(RuntimeError)
    expect { tag.value_invalid << 'new invalid value' }.to raise_error(RuntimeError)
    expect { tag.errors << 'new error' }.to raise_error(RuntimeError)
  end

  context 'when gets invalid values' do
    val_nok = '123456789012345678901234567890123456789012345678901234567890123412345678901234567890123456789012345678901234567890123456789012345' # bytesize=129
    subject { ExifTagger::Tag::Copyright.new(val_nok) }
    its(:value) { should be_empty }
    it { should_not be_valid }
    its(:value_invalid) { should_not be_empty }
    its(:value_invalid) { should match_array([val_nok]) }
    its('errors.inspect') { should include("'#{val_nok.to_s}'") }
    its(:to_write_script) { should be_empty }
  end
end
