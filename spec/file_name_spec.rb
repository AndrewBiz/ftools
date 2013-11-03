#!/usr/bin/env ruby -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative '../spec/spec_helper'
require 'file_name'

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

  describe 'finds original (clean) name for the file:' do

    fn = '20011231-000101_ANB[20010101-ABCDEF]{blabla}cleanname.jpg'
    it fn do
      fno = FTools::FileName.new(fn)
      expect(fno.basename_clean).to eq('cleanname')
    end

    fn = '20011231-000101_ANB[20010101-ABCDEF]cleanname.jpg'
    it fn do
      fno = FTools::FileName.new(fn)
      expect(fno.basename_clean).to eq('cleanname')
    end

  end
end
