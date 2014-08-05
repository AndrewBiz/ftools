#!/usr/bin/env ruby
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

shared_examples_for 'any tag' do

  it 'knows it\'s own exiftool tag name' do
    expect(described_class::EXIFTOOL_TAGS).not_to be_empty
  end

  it 'gets info and puts it into write_script for exiftool' do
    tag.info = "Here I describe usefull info about this tag"
    expect(tag.to_write_script).to include('# INFO: Here I describe usefull info about this tag')
  end

  context 'when saves the correct value' do
    subject { described_class.new(val_ok) }
    its(:value) { should eql(val_ok) }
    its(:to_s) { should include(val_ok.to_s) }
    it { should be_valid }
    its(:errors) { should be_empty }
    its(:value_invalid) { should be_empty }
    its(:warnings) { should be_empty }
  end

  it 'prevents its properties to be modified' do
    expect(tag.value).to be_frozen
    expect(tag.value_invalid).to be_frozen
    expect(tag.errors).to be_frozen
    expect(tag.warnings).to be_frozen
  end
end
