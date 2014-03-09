#!/usr/bin/env ruby -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative '../../../../spec/spec_helper'
require 'tag/gps_created'

describe ExifTagger::Tag::GpsCreated do
  val1 = { gps_latitude: '55 36 31.49',
           gps_latitude_ref: 'N',
           gps_longitude: '37 43 28.27',
           gps_longitude_ref: 'E',
           gps_altitude: '170.0',
           gps_altitude_ref: 'Above Sea Level' }
  context "when saves the #{val1}" do
    subject { ExifTagger::Tag::GpsCreated.new(val1) }
    its(:value) { should eql(val1) }
    its(:to_s) { should include(val1.to_s) }
    its(:tag_id) { should be(:gps_created) }
    its(:tag_name) { should eq('GpsCreated') }
    it { should be_valid }
    its(:errors) { should  be_empty }
    its(:value_invalid) { should be_empty }

    it 'generates write_script to be used with exiftool' do
      script = subject.to_write_script
      expect(script).to include('-GPSLatitude="55 36 31.49"')
      expect(script).to include('-GPSLatitudeRef=N')
      expect(script).to include('-GPSLongitude="37 43 28.27"')
      expect(script).to include('-GPSLongitudeRef=E')
      expect(script).to include('-GPSAltitude=170.0')
      expect(script).to include('-GPSAltitudeRef=Above Sea Level')
    end
  end

  it 'prevents its properties to be altered from outside' do
    tag = ExifTagger::Tag::GpsCreated.new(val1)
    expect { tag.value[:gps_latitude] = '00 00 00.00' }.to raise_error(RuntimeError)
    expect { tag.value_invalid << 'new invalid value' }.to raise_error(RuntimeError)
    expect { tag.errors << 'new error' }.to raise_error(RuntimeError)
  end

  # context 'when gets invalid values' do
  #   val_nok = {coll_name_wrong: 'xyz', coll_uri_wrong: 'xyz'}
  #   subject { ExifTagger::Tag::GpsCreated.new(val_nok) }
  #   its(:value) { should be_empty }
  #   it { should_not be_valid }
  #   its(:value_invalid) { should_not be_empty }
  #   its(:value_invalid) { should eql([val_nok]) }

  #   val_nok.each do |k,v|
  #     its('errors.inspect') { should include("'#{k.to_s}'") }
  #   end
  # end
end
