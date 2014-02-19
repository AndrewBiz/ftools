#!/usr/bin/env ruby -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative '../../../../spec/spec_helper'
require 'tag/keywords'

Tag = ExifTagger::Tag::Keywords

describe Tag do
  it 'saves the value' do
    val = %w{aaa bbb ааа ббб}
    tag = Tag.new(val)

    expect(tag.value).to match_array(val)
    expect(tag.to_s).to include(val.to_s)
    expect(tag.tag_id).to be(:keywords)
    expect(tag.tag_name).to eq('Keywords')
    expect(tag).to be_valid
    expect(tag.errors).to be_empty
    expect(tag.value_invalid).to be_empty

    script = tag.to_write_script
    expect(script).to include('-MWG:Keywords-=aaa')
    expect(script).to include('-MWG:Keywords+=aaa')
    expect(script).to include('-MWG:Keywords-=bbb')
    expect(script).to include('-MWG:Keywords+=bbb')
    expect(script).to include('-MWG:Keywords-=ааа')
    expect(script).to include('-MWG:Keywords+=ааа')
    expect(script).to include('-MWG:Keywords-=ббб')
    expect(script).to include('-MWG:Keywords+=ббб')
  end

  it 'converts value to flat array of strings' do
    val = ['aaa', ['bbb', 'ааа'], 'ббб', [1, [2, 3]]]
    val_normal = ['aaa', 'bbb', 'ааа', 'ббб', '1', '2', '3']
    tag = Tag.new(val)

    expect(tag.value).to match_array(val_normal)
    expect(tag).to be_valid
    expect(tag.errors).to be_empty
    expect(tag.value_invalid).to be_empty
  end

  it 'prevents values and errors to be altered' do
    val = %w{aaa bbb}
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
    expect(tag.value_invalid.empty?).to be_false
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
