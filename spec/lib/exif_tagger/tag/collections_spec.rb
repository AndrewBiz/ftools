#!/usr/bin/env ruby
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require 'spec_helper'
require 'tag/collections'

describe ExifTagger::Tag::Collections do
  let(:val_ok) { { collection_name: 'Collection Name', collection_uri: 'www.abc.net' } }
  let(:val_orig) { { 'CollectionName' => 'tralala', 'CollectionURI' => 'trululu' } }
  let(:tag) { described_class.new(val_ok) }

  it_behaves_like 'any tag'

  it 'knows it\'s ID' do
    expect(tag.tag_id).to be :collections
    expect(tag.tag_name).to eq 'Collections'
  end

  it 'generates write_script for exiftool' do
    expect(tag.to_write_script).to include('-XMP-mwg-coll:Collections-={CollectionName=Collection Name, CollectionURI=www.abc.net}')
    expect(tag.to_write_script).to include('-XMP-mwg-coll:Collections+={CollectionName=Collection Name, CollectionURI=www.abc.net}')
  end

  context 'when the original value (read by mini_exiftool) exists -' do
    it 'generates warnings' do
      tag.validate_with_original(val_orig)
      expect(tag.warnings).not_to be_empty
      expect(tag.warnings.inspect).to include('has original value:')
    end
    it 'generates write_script with commented lines' do
      tag.validate_with_original(val_orig)
      expect(tag.to_write_script).to include('# -XMP-mwg-coll:Collections-={CollectionName=Collection Name, CollectionURI=www.abc.net}')
      expect(tag.to_write_script).to include('# -XMP-mwg-coll:Collections+={CollectionName=Collection Name, CollectionURI=www.abc.net}')
      expect(tag.to_write_script).to match(/# WARNING: ([\w]*) has original value:/)
    end
  end

  context 'when gets invalid input' do
    context 'with unknown key' do
      val_nok = { coll_name_wrong: 'xyz', collection_uri: 'www.xyz.com' }
      subject { described_class.new(val_nok) }
      its(:value) { should be_empty }
      it { should_not be_valid }
      its(:value_invalid) { should_not be_empty }
      its(:value_invalid) { should eql([val_nok]) }
      its('errors.inspect') { should include("'coll_name_wrong' is unknown") }
      its(:to_write_script) { should be_empty }
    end
    context 'when mandatory keys are missed' do
      val_nok = { collection_uri: 'www.xyz.com' }
      subject { described_class.new(val_nok) }
      its(:value) { should be_empty }
      it { should_not be_valid }
      its(:value_invalid) { should_not be_empty }
      its(:value_invalid) { should eql([val_nok]) }
      its('errors.inspect') { should include("'collection_name' is missed") }
      its(:to_write_script) { should be_empty }
    end
  end
end
