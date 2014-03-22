#!/usr/bin/env ruby
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative '../../../../spec/spec_helper'
require 'tag/creator'

describe ExifTagger::Tag::Creator do
  val1 = %w{Andrew Natalia}
  context "when saves the #{val1}" do
    subject { ExifTagger::Tag::Creator.new(val1) }
    its(:value) { should match_array(val1) }
    its(:to_s) { should include(val1.to_s) }
    its(:tag_id) { should be(:creator) }
    its(:tag_name) { should eq('Creator') }
    it { should be_valid }
    its(:errors) { should  be_empty }
    its(:value_invalid) { should be_empty }

    it 'generates write_script to be used with exiftool' do
      script = subject.to_write_script
      expect(script).to include('-MWG:Creator-=Andrew')
      expect(script).to include('-MWG:Creator+=Andrew')
      expect(script).to include('-MWG:Creator-=Natalia')
      expect(script).to include('-MWG:Creator+=Natalia')
    end
  end

  val2 = ['www', ['eee', 'rrr'], 'ttt', [1, [2, 3]]]
  context "when gets a non-flat array as input: #{val2}" do
    subject { ExifTagger::Tag::Creator.new(val2) }
    val_normal = ['www', 'eee', 'rrr', 'ttt', '1', '2', '3']
    it 'converts the input to the flat array of strings' do
      expect(subject.value).to match_array(val_normal)
    end
    it { should be_valid }
    its(:errors) { should  be_empty }
    its(:value_invalid) { should be_empty }
  end

  it 'prevents its properties to be altered from outside' do
    val = %w{zzz xxx}
    tag = ExifTagger::Tag::Creator.new(val)
    expect { tag.value << 'newvalue' }.to raise_error(RuntimeError)
    expect { tag.value[0] = 'modvalue' }.to raise_error(RuntimeError)
    expect { tag.value_invalid << 'new invalid value' }.to raise_error(RuntimeError)
    expect { tag.errors << 'new error' }.to raise_error(RuntimeError)
  end

  context 'when gets invalid values' do
    val_ok = []
    val_ok << 'just test string' # bytesize=16
    val_ok << '12345678901234567890123456789012' # bytesize=32
    val_ok << 'абвгдеёжзийклмно' # bytesize=32
    val_nok = []
    val_nok << '123456789012345678901234567890123' # bytesize=33
    val_nok << 'абвгдеёжзийклмноZ' # bytesize=33
    val_nok << 'абвгдеёжзийклмноп' # bytesize=34

    subject { ExifTagger::Tag::Creator.new((val_ok + val_nok).sort) }
    its(:value) { should match_array(val_ok) }
    it { should_not be_valid }
    its(:value_invalid) { should_not be_empty }
    its(:value_invalid) { should match_array(val_nok) }

    val_nok.each do |i|
      its('errors.inspect') { should include("'#{i.to_s}'") }
      its(:to_write_script) { should_not include("#{i.to_s}") }
    end
    val_ok.each do |i|
      its('errors.inspect') { should_not include("'#{i.to_s}'") }
      its(:to_write_script) { should include("#{i.to_s}") }
    end
  end
end
