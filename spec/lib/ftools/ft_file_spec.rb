#!/usr/bin/env ruby -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative '../../../spec/spec_helper'
require 'ft_file'

describe FTools::FTFile, 'constants' do
  it 'include NICKNAME_MIN_SIZE == 3' do
    expect(FTools::FTFile::NICKNAME_MIN_SIZE).to eq 3
  end

  it 'include NICKNAME_MAX_SIZE == 6' do
    expect(FTools::FTFile::NICKNAME_MAX_SIZE).to eq 6
  end

  it 'include NICKNAME_SIZE within the range of MIN-MAX' do
    expect(FTools::FTFile::NICKNAME_SIZE).to be <=
      FTools::FTFile::NICKNAME_MAX_SIZE
    expect(FTools::FTFile::NICKNAME_SIZE).to be >=
      FTools::FTFile::NICKNAME_MIN_SIZE
  end
end

describe FTools::FTFile do
  it 'stores file dir name' do
    fn = FTools::FTFile.new('./aaa/bbb/file.ext')
    expect(fn.dirname).to eq('./aaa/bbb')
  end

  it 'stores file base name' do
    fn = FTools::FTFile.new('./aaa/bbb/file.ext')
    expect(fn.basename).to eq('file')
  end

  it 'stores file extention name' do
    fn = FTools::FTFile.new('./aaa/bbb/file.ext')
    expect(fn.extname).to eq('.ext')
  end

  describe 'parses the basename of' do

    fn1 = '20011231-112233_ANB[20010101-ABCDEF]{flags}cleanname.jpg'
    it fn1 do
      obj = FTools::FTFile.new(fn1)
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
      obj = FTools::FTFile.new(fn2)
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
      obj = FTools::FTFile.new(fn3)
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
        obj = FTools::FTFile.new(fn4)
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
        obj = FTools::FTFile.new(fn5)
        expect(obj.basename_part[:prefix]).to eq \
        '20011231-112233_ANDREW '
        expect(obj.basename_part[:clean]).to eq 'cleanname'
        expect(obj.basename_part[:date]).to eq '20011231'
        expect(obj.basename_part[:time]).to eq '112233'
        expect(obj.basename_part[:author]).to eq 'ANDREW'
        expect(obj.basename_part[:id]).to eq ''
        expect(obj.basename_part[:flags]).to eq ''
      end
      fn6 = '20011231-112233_ANB_cleanname.jpg'
      it fn6 do
        obj = FTools::FTFile.new(fn6)
        expect(obj.basename_part[:prefix]).to eq \
        '20011231-112233_ANB_'
        expect(obj.basename_part[:clean]).to eq 'cleanname'
        expect(obj.basename_part[:date]).to eq '20011231'
        expect(obj.basename_part[:time]).to eq '112233'
        expect(obj.basename_part[:author]).to eq 'ANB'
        expect(obj.basename_part[:id]).to eq ''
        expect(obj.basename_part[:flags]).to eq ''
      end
    end

    fn7 = '20011231-1122_ANB_cleanname.jpg'
    it fn7 do
      obj = FTools::FTFile.new(fn7)
      expect(obj.basename_part[:prefix]).to eq \
      '20011231-1122_ANB_'
      expect(obj.basename_part[:clean]).to eq 'cleanname'
      expect(obj.basename_part[:date]).to eq '20011231'
      expect(obj.basename_part[:time]).to eq '1122'
      expect(obj.basename_part[:author]).to eq 'ANB'
      expect(obj.basename_part[:id]).to eq ''
      expect(obj.basename_part[:flags]).to eq ''
    end
    fn8 = '20011231-1122-ANB_cleanname.jpg'
    it fn8 do
      obj = FTools::FTFile.new(fn8)
      expect(obj.basename_part[:prefix]).to eq \
      '20011231-1122-ANB_'
      expect(obj.basename_part[:clean]).to eq 'cleanname'
      expect(obj.basename_part[:date]).to eq '20011231'
      expect(obj.basename_part[:time]).to eq '1122'
      expect(obj.basename_part[:author]).to eq 'ANB'
      expect(obj.basename_part[:id]).to eq ''
      expect(obj.basename_part[:flags]).to eq ''
    end
    fn9 = '20011231-1122_ANB cleanname.jpg'
    it fn9 do
      obj = FTools::FTFile.new(fn9)
      expect(obj.basename_part[:prefix]).to eq \
      '20011231-1122_ANB '
      expect(obj.basename_part[:clean]).to eq 'cleanname'
      expect(obj.basename_part[:date]).to eq '20011231'
      expect(obj.basename_part[:time]).to eq '1122'
      expect(obj.basename_part[:author]).to eq 'ANB'
      expect(obj.basename_part[:id]).to eq ''
      expect(obj.basename_part[:flags]).to eq ''
    end

    fn10 = '20011231-1122_cleanname.jpg'
    it fn10 do
      obj = FTools::FTFile.new(fn10)
      expect(obj.basename_part[:prefix]).to eq \
      '20011231-1122_'
      expect(obj.basename_part[:clean]).to eq 'cleanname'
      expect(obj.basename_part[:date]).to eq '20011231'
      expect(obj.basename_part[:time]).to eq '1122'
      expect(obj.basename_part[:author]).to eq ''
      expect(obj.basename_part[:id]).to eq ''
      expect(obj.basename_part[:flags]).to eq ''
    end
    fn11 = '20011231-1122 cleanname.jpg'
    it fn11 do
      obj = FTools::FTFile.new(fn11)
      expect(obj.basename_part[:prefix]).to eq \
      '20011231-1122 '
      expect(obj.basename_part[:clean]).to eq 'cleanname'
      expect(obj.basename_part[:date]).to eq '20011231'
      expect(obj.basename_part[:time]).to eq '1122'
      expect(obj.basename_part[:author]).to eq ''
      expect(obj.basename_part[:id]).to eq ''
      expect(obj.basename_part[:flags]).to eq ''
    end

    fn12 = '20011231_cleanname.jpg'
    it fn12 do
      obj = FTools::FTFile.new(fn12)
      expect(obj.basename_part[:prefix]).to eq \
      '20011231_'
      expect(obj.basename_part[:clean]).to eq 'cleanname'
      expect(obj.basename_part[:date]).to eq '20011231'
      expect(obj.basename_part[:time]).to eq ''
      expect(obj.basename_part[:author]).to eq ''
      expect(obj.basename_part[:id]).to eq ''
      expect(obj.basename_part[:flags]).to eq ''
    end
    fn13 = '20011231 cleanname.jpg'
    it fn13 do
      obj = FTools::FTFile.new(fn13)
      expect(obj.basename_part[:prefix]).to eq \
      '20011231 '
      expect(obj.basename_part[:clean]).to eq 'cleanname'
      expect(obj.basename_part[:date]).to eq '20011231'
      expect(obj.basename_part[:time]).to eq ''
      expect(obj.basename_part[:author]).to eq ''
      expect(obj.basename_part[:id]).to eq ''
      expect(obj.basename_part[:flags]).to eq ''
    end
    fn14 = '20011231-cleanname.jpg'
    it fn14 do
      obj = FTools::FTFile.new(fn14)
      expect(obj.basename_part[:prefix]).to eq \
      '20011231-'
      expect(obj.basename_part[:clean]).to eq 'cleanname'
      expect(obj.basename_part[:date]).to eq '20011231'
      expect(obj.basename_part[:time]).to eq ''
      expect(obj.basename_part[:author]).to eq ''
      expect(obj.basename_part[:id]).to eq ''
      expect(obj.basename_part[:flags]).to eq ''
    end

    fn15 = '2001_cleanname.jpg'
    it fn15 do
      obj = FTools::FTFile.new(fn15)
      expect(obj.basename_part[:prefix]).to eq '2001_'
      expect(obj.basename_part[:clean]).to eq 'cleanname'
      expect(obj.basename_part[:date]).to eq '2001'
      expect(obj.basename_part[:time]).to eq ''
      expect(obj.basename_part[:author]).to eq ''
      expect(obj.basename_part[:id]).to eq ''
      expect(obj.basename_part[:flags]).to eq ''
    end
    fn16 = '2001-cleanname.jpg'
    it fn16 do
      obj = FTools::FTFile.new(fn16)
      expect(obj.basename_part[:prefix]).to eq '2001-'
      expect(obj.basename_part[:clean]).to eq 'cleanname'
      expect(obj.basename_part[:date]).to eq '2001'
      expect(obj.basename_part[:time]).to eq ''
      expect(obj.basename_part[:author]).to eq ''
      expect(obj.basename_part[:id]).to eq ''
      expect(obj.basename_part[:flags]).to eq ''
    end
    fn17 = '2001 cleanname.jpg'
    it fn17 do
      obj = FTools::FTFile.new(fn17)
      expect(obj.basename_part[:prefix]).to eq '2001 '
      expect(obj.basename_part[:clean]).to eq 'cleanname'
      expect(obj.basename_part[:date]).to eq '2001'
      expect(obj.basename_part[:time]).to eq ''
      expect(obj.basename_part[:author]).to eq ''
      expect(obj.basename_part[:id]).to eq ''
      expect(obj.basename_part[:flags]).to eq ''
    end

    fn99 = 'cleanname.jpg'
    it fn99 do
      obj = FTools::FTFile.new(fn99)
      expect(obj.basename_part[:prefix]).to eq ''
      expect(obj.basename_part[:clean]).to eq 'cleanname'
      expect(obj.basename_part[:date]).to eq ''
      expect(obj.basename_part[:time]).to eq ''
      expect(obj.basename_part[:author]).to eq ''
      expect(obj.basename_part[:id]).to eq ''
      expect(obj.basename_part[:flags]).to eq ''
    end
  end

  describe 'reveals date_time from the filename' do
    fndt1 = '20011231-112233_ANB cleanname.jpg'
    it fndt1 do
      obj = FTools::FTFile.new(fndt1)
      expect(obj.date_time).to eq \
        DateTime.strptime('2001-12-31T11:22:33+00:00')
      expect(obj.date_time_ok?).to be_true
    end
    fndt2 = '20011231-112269_ANB cleanname.jpg'
    it fndt2 do
      obj = FTools::FTFile.new(fndt2)
      expect(obj.date_time_ok?).to be_false
    end
    fndt3 = '20011231-1122_ANB cleanname.jpg'
    it fndt3 do
      obj = FTools::FTFile.new(fndt3)
      expect(obj.date_time).to eq \
        DateTime.strptime('2001-12-31T11:22:00+00:00')
      expect(obj.date_time_ok?).to be_true
    end
    fndt4 = '20011231_cleanname.jpg'
    it fndt4 do
      obj = FTools::FTFile.new(fndt4)
      expect(obj.date_time).to eq \
        DateTime.strptime('2001-12-31T00:00:00+00:00')
      expect(obj.date_time_ok?).to be_true
    end
    fndt5 = '2001_cleanname.jpg'
    it fndt5 do
      obj = FTools::FTFile.new(fndt5)
      expect(obj.date_time).to eq \
        DateTime.strptime('2001-01-01T00:00:00+00:00')
      expect(obj.date_time_ok?).to be_true
    end
  end

  describe 'checks if the name complies with FT standard for' do
    fts1 = '20011231-112233_ANB[20010101-ABCDEF]{flags}cleanname.jpg'
    it fts1 do
      obj = FTools::FTFile.new(fts1)
      expect(obj.basename_is_standard?).to be_false
    end
    fts2 = '20011231-112233_ANB[20010101-ABCDEF]cleanname.jpg'
    it fts2 do
      obj = FTools::FTFile.new(fts2)
      expect(obj.basename_is_standard?).to be_false
    end
    fts3 = '20011231-112233_ANB_cleanname.jpg'
    it fts3 do
      obj = FTools::FTFile.new(fts3)
      expect(obj.basename_is_standard?).to be_false
    end
    fts4 = '20011231-112233_ANB-cleanname.jpg'
    it fts4 do
      obj = FTools::FTFile.new(fts4)
      expect(obj.basename_is_standard?).to be_false
    end
    fts5 = '20011232-112233_ANB cleanname.jpg'
    it fts5 do
      obj = FTools::FTFile.new(fts5)
      expect(obj.basename_is_standard?).to be_false
    end
    # STANDARD name!
    fts6 = '20011231-112233_ANB cleanname.jpg'
    it fts6 do
      obj = FTools::FTFile.new(fts6)
      expect(obj.basename_is_standard?).to be_true
    end
    fts7 = '20011231-1122_ANB cleanname.jpg'
    it fts7 do
      obj = FTools::FTFile.new(fts7)
      expect(obj.basename_is_standard?).to be_false
    end
    fts8 = '20011231-1122_cleanname.jpg'
    it fts8 do
      obj = FTools::FTFile.new(fts8)
      expect(obj.basename_is_standard?).to be_false
    end
    fts9 = '20011231_cleanname.jpg'
    it fts9 do
      obj = FTools::FTFile.new(fts9)
      expect(obj.basename_is_standard?).to be_false
    end
    fts10 = '2001_cleanname.jpg'
    it fts10 do
      obj = FTools::FTFile.new(fts10)
      expect(obj.basename_is_standard?).to be_false
    end
  end
end
