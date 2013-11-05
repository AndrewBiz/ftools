#!/usr/bin/env ruby -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative '../../../spec/spec_helper'
require 'file_name'

describe FTools, 'module' do
  it 'has NICKNAME_MIN_SIZE == 3' do
    expect(FTools::NICKNAME_MIN_SIZE).to eq 3
  end

  it 'has NICKNAME_MAX_SIZE == 6' do
    expect(FTools::NICKNAME_MAX_SIZE).to eq 6
  end

  it 'has NICKNAME_SIZE within the range of MIN-MAX' do
    expect(FTools::NICKNAME_SIZE).to be <= FTools::NICKNAME_MAX_SIZE
    expect(FTools::NICKNAME_SIZE).to be >= FTools::NICKNAME_MIN_SIZE
  end
end

describe FTools::FileName, 'object'  do
  it 'stores file dir name' do
    fn = FTools::FileName.new('./aaa/bbb/file.ext')
    expect(fn.dirname).to eq('./aaa/bbb')
  end

  it 'stores file base name' do
    fn = FTools::FileName.new('./aaa/bbb/file.ext')
    expect(fn.basename).to eq('file')
  end

  it 'stores file extention name' do
    fn = FTools::FileName.new('./aaa/bbb/file.ext')
    expect(fn.extname).to eq('.ext')
  end

  describe 'parses the basename of' do

    fn1 = '20011231-112233_ANB[20010101-ABCDEF]{flags}cleanname.jpg'
    it fn1 do
      obj = FTools::FileName.new(fn1)
      expect(obj.basename_part[:prefix]).to eq \
        '20011231-112233_ANB[20010101-ABCDEF]{flags}'
      expect(obj.basename_part[:clean]).to eq 'cleanname'
      expect(obj.basename_part[:date]).to eq '20011231'
      expect(obj.basename_part[:time]).to eq '112233'
      expect(obj.basename_part[:author]).to eq 'ANB'
      expect(obj.basename_part[:id]).to eq '20010101-ABCDEF'
      expect(obj.basename_part[:flags]).to eq 'flags'
    end

    fn2 = '20011231-112233_ANB[20010101-ABCDEF]cleanname.jpg'
    it fn2 do
      obj = FTools::FileName.new(fn2)
      expect(obj.basename_part[:prefix]).to eq \
        '20011231-112233_ANB[20010101-ABCDEF]'
      expect(obj.basename_part[:clean]).to eq 'cleanname'
      expect(obj.basename_part[:date]).to eq '20011231'
      expect(obj.basename_part[:time]).to eq '112233'
      expect(obj.basename_part[:author]).to eq 'ANB'
      expect(obj.basename_part[:id]).to eq '20010101-ABCDEF'
      expect(obj.basename_part[:flags]).to eq ''
    end

    fn3 = '20011231-112233_ANB_cleanname.jpg'
    it fn3 do
      obj = FTools::FileName.new(fn3)
      expect(obj.basename_part[:prefix]).to eq \
      '20011231-112233_ANB_'
      expect(obj.basename_part[:clean]).to eq 'cleanname'
      expect(obj.basename_part[:date]).to eq '20011231'
      expect(obj.basename_part[:time]).to eq '112233'
      expect(obj.basename_part[:author]).to eq 'ANB'
      expect(obj.basename_part[:id]).to eq ''
      expect(obj.basename_part[:flags]).to eq ''
    end

    describe '(STANDARD template)' do
      fn4 = '20011231-112233_ANB cleanname.jpg'
      it fn4 do
        obj = FTools::FileName.new(fn4)
        expect(obj.basename_part[:prefix]).to eq \
        '20011231-112233_ANB '
        expect(obj.basename_part[:clean]).to eq 'cleanname'
        expect(obj.basename_part[:date]).to eq '20011231'
        expect(obj.basename_part[:time]).to eq '112233'
        expect(obj.basename_part[:author]).to eq 'ANB'
        expect(obj.basename_part[:id]).to eq ''
        expect(obj.basename_part[:flags]).to eq ''
      end
      fn5 = '20011231-112233_ANDREW cleanname.jpg'
      it fn5 do
        obj = FTools::FileName.new(fn5)
        expect(obj.basename_part[:prefix]).to eq \
        '20011231-112233_ANDREW '
        expect(obj.basename_part[:clean]).to eq 'cleanname'
        expect(obj.basename_part[:date]).to eq '20011231'
        expect(obj.basename_part[:time]).to eq '112233'
        expect(obj.basename_part[:author]).to eq 'ANDREW'
        expect(obj.basename_part[:id]).to eq ''
        expect(obj.basename_part[:flags]).to eq ''
      end
    end
  end
end
