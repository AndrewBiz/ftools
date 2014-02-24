#!/usr/bin/env ruby -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative '../../../../spec/spec_helper'
require 'tag/keywords'

Tag = ExifTagger::Tag::Keywords

describe Tag do
  val1 = %w{aaa bbb ййй ццц}
  context "when saves the #{val1}" do
    subject { Tag.new(val1) }
    its(:value) { should match_array(val1) }
    its(:to_s) { should include(val1.to_s) }
    its(:tag_id) { should be(:keywords) }
    its(:tag_name) { should eq('Keywords') }
    it { should be_valid }
    its(:errors) { should  be_empty }
    its(:value_invalid) { should be_empty }

    it 'generates write_script to be used with exiftool' do
      script = subject.to_write_script
      expect(script).to include('-MWG:Keywords-=aaa')
      expect(script).to include('-MWG:Keywords+=aaa')
      expect(script).to include('-MWG:Keywords-=bbb')
      expect(script).to include('-MWG:Keywords+=bbb')
      expect(script).to include('-MWG:Keywords-=ййй')
      expect(script).to include('-MWG:Keywords+=ййй')
      expect(script).to include('-MWG:Keywords-=ццц')
      expect(script).to include('-MWG:Keywords+=ццц')
    end
  end

  val2 = ['www', ['eee', 'rrr'], 'ttt', [1, [2, 3]]]
  context "when gets a non-flat array as input: #{val2}" do
    subject { Tag.new(val2) }
    val_normal = ['www', 'eee', 'rrr', 'ttt', '1', '2', '3']
    it 'converts the input to the flat array of strings' do
      expect(subject.value).to match_array(val_normal)
    end
    it { should be_valid }
    its(:errors) { should  be_empty }
    its(:value_invalid) { should be_empty }
  end

  it 'prevents its properties to be altered' do
    val = %w{zzz xxx}
    tag = Tag.new(val)
    expect { tag.value << 'newvalue' }.to raise_error(RuntimeError)
    expect { tag.value[0] = 'modvalue' }.to raise_error(RuntimeError)
    expect { tag.value_invalid << 'new invalid value' }.to raise_error(RuntimeError)
    expect { tag.errors << 'new error' }.to raise_error(RuntimeError)
  end

  it 'validates its value' do
    val_ok = []
    val_ok << 'just test string' # bytesize=16
    val_ok << '1234567890123456789012345678901234567890123456789012345678901234' # bytesize=64
    val_ok << 'абвгдеёжзийклмнопрстуфхцчшщъыьэю' # bytesize=64
    val_nok = []
    val_nok << '12345678901234567890123456789012345678901234567890123456789012345' # bytesize=65
    val_nok << 'абвгдеёжзийклмнопрстуфхцчшщъыьэюZ' # bytesize=65
    val_nok << 'абвгдеёжзийклмнопрстуфхцчшщъыьэюя' # bytesize=66

    tag = Tag.new((val_ok + val_nok).sort)

    expect(tag.value).to match_array(val_ok)
    expect(tag.valid?).to be_false
    expect(tag).not_to be_valid
    expect(tag.value_invalid).not_to be_empty
    expect(tag.value_invalid).to match_array(val_nok)

    estr = tag.errors.inspect
    val_nok.each do |i|
      expect(estr).to include("'#{i}'")
    end
    val_ok.each do |i|
      expect(estr.include?("'#{i}'")).to be_false
    end
  end
end
