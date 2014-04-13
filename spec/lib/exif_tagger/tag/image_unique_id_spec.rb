#!/usr/bin/env ruby
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require 'spec_helper'
require 'tag/image_unique_id'

describe ExifTagger::Tag::ImageUniqueId do
  let(:val_ok) { %(20140413-172725-002) }
  let(:val_orig_ok) { { 'ImageUniqueID' => '20140301-180023-001' } }
  let(:val_orig_nok) { { 'ImageUniqueID' => 'ab3b4bc6ba4bb2c343ab' } }
  let(:tag) { described_class.new(val_ok) }

  it_behaves_like 'any tag'

  it 'knows it\'s ID' do
    expect(tag.tag_id).to be :image_unique_id
    expect(tag.tag_name).to eq 'ImageUniqueId'
  end

  it 'generates write_script for exiftool' do
    expect(tag.to_write_script).to include('-ImageUniqueID=20140413-172725-002')
  end

  context 'when the original value (read by mini_exiftool) exists -' do
    context 'and the original value was generated by ftools' do
      it 'generates warnings' do
        tag.validate_with_original(val_orig_ok)
        expect(tag.warnings).not_to be_empty
        expect(tag.warnings.inspect).to include('has original correct value:')
      end
      it 'generates write_script with commented lines' do
        tag.validate_with_original(val_orig_ok)
        expect(tag.to_write_script).to include('# -ImageUniqueID=20140413-172725-002')
        expect(tag.to_write_script).to match(/# WARNING: ([\w]*) has original correct value:/)
      end
    end
    context 'and the original value is not ftools-friendly format' do
      it 'generates NO warnings' do
        tag.validate_with_original(val_orig_nok)
        expect(tag.warnings).to be_empty
      end
      it 'generates write_script for exiftool' do
        tag.validate_with_original(val_orig_nok)
        expect(tag.to_write_script).to include('-ImageUniqueID=20140413-172725-002')
        expect(tag.to_write_script).not_to include('# -ImageUniqueID=20140413-172725-002')
        expect(tag.to_write_script).not_to match(/# WARNING: ([\w]*) has original value:/)
      end
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
