#!/usr/bin/env ruby
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require 'spec_helper'
require 'tag/world_region'

describe ExifTagger::Tag::WorldRegion do
  let(:val_ok) { 'Asia' }
  let(:val_orig) { { 'LocationShownWorldRegion' => 'America' } }
  let(:val_orig_empty) { { 'LocationShownWorldRegion' => '' } }
  let(:tag) { described_class.new(val_ok) }

  it_behaves_like 'any tag'

  it 'knows it\'s ID' do
    expect(tag.tag_id).to be :world_region
    expect(tag.tag_name).to eq 'WorldRegion'
  end

  it 'generates write_script for exiftool' do
    expect(tag.to_write_script).to include('-XMP-iptcExt:LocationShownWorldRegion=Asia')
  end

  context 'when the original value (read by mini_exiftool) exists -' do
    it 'generates warnings' do
      tag.validate_with_original(val_orig)
      expect(tag.warnings).not_to be_empty
      expect(tag.warnings.inspect).to include('has original value:')
    end
    it 'generates write_script with commented lines' do
      tag.validate_with_original(val_orig)
      expect(tag.to_write_script).to include('# -XMP-iptcExt:LocationShownWorldRegion=Asia')
      expect(tag.to_write_script).to match(/# WARNING: ([\w]*) has original value:/)
    end
    it 'considers empty strings as a no-value' do
      tag.validate_with_original(val_orig_empty)
      expect(tag.warnings).to be_empty
      expect(tag.warnings.inspect).not_to include('has original value:')
    end
  end

  context 'when gets invalid values' do
    val_nok = '12345678901234567890123456789012345678901234567890123456789012345'# bytesize=65
    subject { described_class.new(val_nok) }
    its(:value) { should be_empty }
    it { should_not be_valid }
    its(:value_invalid) { should_not be_empty }
    its(:value_invalid) { should match_array([val_nok]) }
    its('errors.inspect') { should include("'#{val_nok}'") }
    its(:to_write_script) { should be_empty }
  end
end
