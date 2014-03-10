#!/usr/bin/env ruby -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative '../../../../spec/spec_helper'
require 'tag/collections'

describe ExifTagger::Tag::Collections do
  val1 = { collection_name: 'Collection Name', collection_uri: 'www.abc.net' }
  context "when saves the #{val1}" do
    subject { ExifTagger::Tag::Collections.new(val1) }
    its(:value) { should eql (val1) }
    its(:to_s) { should include(val1.to_s) }
    its(:tag_id) { should be(:collections) }
    its(:tag_name) { should eq('Collections') }
    it { should be_valid }
    its(:errors) { should  be_empty }
    its(:value_invalid) { should be_empty }

    it 'generates write_script to be used with exiftool' do
      script = subject.to_write_script
      expect(script).to include('-XMP-mwg-coll:Collections-={CollectionName=Collection Name, CollectionURI=www.abc.net}')
      expect(script).to include('-XMP-mwg-coll:Collections+={CollectionName=Collection Name, CollectionURI=www.abc.net}')
    end
  end

  it 'prevents its properties to be altered from outside' do
    tag = ExifTagger::Tag::Collections.new(val1)
    expect { tag.value[:collection_name] = 'new cn' }.to raise_error(RuntimeError)
    expect { tag.value_invalid << 'new invalid value' }.to raise_error(RuntimeError)
    expect { tag.errors << 'new error' }.to raise_error(RuntimeError)
  end

  context 'when gets invalid input' do
    context 'with unknown key' do
      val_nok = { coll_name_wrong: 'xyz', collection_uri: 'www.xyz.com' }
      subject { ExifTagger::Tag::Collections.new(val_nok) }
      its(:value) { should be_empty }
      it { should_not be_valid }
      its(:value_invalid) { should_not be_empty }
      its(:value_invalid) { should eql([val_nok]) }
      its('errors.inspect') { should include("'coll_name_wrong' is unknown") }
      its(:to_write_script) { should be_empty }
    end
    context 'when mandatory keys are missed' do
      val_nok = { collection_uri: 'www.xyz.com' }
      subject { ExifTagger::Tag::Collections.new(val_nok) }
      its(:value) { should be_empty }
      it { should_not be_valid }
      its(:value_invalid) { should_not be_empty }
      its(:value_invalid) { should eql([val_nok]) }
      its('errors.inspect') { should include("'collection_name' is missed") }
      its(:to_write_script) { should be_empty }
    end

    # val_nok = {coll_name_wrong: 'xyz', coll_uri_wrong: 'xyz'}
    # subject { ExifTagger::Tag::Collections.new(val_nok) }
    # its(:value) { should be_empty }
    # it { should_not be_valid }
    # its(:value_invalid) { should_not be_empty }
    # its(:value_invalid) { should eql([val_nok]) }
    # its(:to_write_script) { should be_empty }

    # val_nok.each do |k,v|
    #   its('errors.inspect') { should include("'#{k.to_s}'") }
    # end
  end
end
