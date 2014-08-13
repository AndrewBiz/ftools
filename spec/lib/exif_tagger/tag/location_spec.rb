#!/usr/bin/env ruby
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require 'spec_helper'
require 'tag/location'

describe ExifTagger::Tag::Location do
  let(:val_ok) { 'Orekhovo-Borisovo' }
  let(:val_orig) { { 'Location' => 'Maidan' } }
  let(:val_orig_empty) do
    { 'Location' => '',
      'Sub-location' => '',
      'LocationShownSublocation' => '' }
  end
  let(:tag) { described_class.new(val_ok) }

  it_behaves_like 'any tag'

  it 'knows it\'s ID' do
    expect(tag.tag_id).to be :location
    expect(tag.tag_name).to eq 'Location'
  end

  it 'generates write_script for exiftool' do
    expect(tag.to_write_script).to include('-MWG:Location=Orekhovo-Borisovo')
  end

  it_behaves_like 'any paranoid tag'

  context 'when the original value exists' do
    it 'considers empty strings as a no-value' do
      tag.check_for_warnings(original_values: val_orig_empty)
      expect(tag.warnings).to be_empty
      expect(tag.warnings.inspect).not_to include('has original value:')
    end
  end

  context 'when gets invalid values' do
    val_nok = '123456789012345678901234567890123'# bytesize=33
    subject { described_class.new(val_nok) }
    its(:value) { should be_empty }
    it { should_not be_valid }
    its(:value_invalid) { should_not be_empty }
    its(:value_invalid) { should match_array([val_nok]) }
    its('errors.inspect') { should include("'#{val_nok}'") }
    its(:to_write_script) { should be_empty }
  end
end
