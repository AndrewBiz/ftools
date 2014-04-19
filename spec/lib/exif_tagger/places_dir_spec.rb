#!/usr/bin/env ruby
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require 'spec_helper'
require 'exif_tagger'

# ExifTagger test
module ExifTagger
  describe PlacesDir do
    let(:places) { PlacesDir.new('./places.yml') }
    context 'when gets correct yml' do
      before :each do
        yml = { ptb: { world_region: 'Europe',
                       country: 'Russia',
                       country_code: 'RU',
                       state: 'Petersburg region',
                       city: 'Petersburg',
                       location: 'Palace Square',
                       gps_created: {
                         gps_latitude: '59 56 21.069',
                         gps_latitude_ref: 'N',
                         gps_longitude: '30 18 50.067',
                         gps_longitude_ref: 'E',
                         gps_altitude: '0.5',
                         gps_altitude_ref: 'Above Sea Level' } }
        }
        expect(File).to receive(:exist?).with('./places.yml').and_return(true)
        expect(File).to receive(:directory?).with('./places.yml').and_return(false)
        expect(YAML).to receive(:load_file).with('./places.yml').and_return(yml)
      end

      it 'stores the list of places' do
        expect(places).to be_valid
        expect(places.filename).to eq('./places.yml')
        expect(places[:ptb][:world_region]).to eql('Europe')
        expect(places[:ptb][:country]).to eql('Russia')
        expect(places[:ptb][:country_code]).to eql('RU')
        expect(places[:ptb][:state]).to eql('Petersburg region')
        expect(places[:ptb][:city]).to eql('Petersburg')
        expect(places[:ptb][:location]).to eql('Palace Square')
        expect(places[:ptb][:gps_created][:gps_latitude]).to eql('59 56 21.069')
        expect(places[:ptb][:gps_created][:gps_latitude_ref]).to eql('N')
        expect(places[:ptb][:gps_created][:gps_longitude]).to eql('30 18 50.067')
        expect(places[:ptb][:gps_created][:gps_longitude_ref]).to eql('E')
        expect(places[:ptb][:gps_created][:gps_altitude]).to eql('0.5')
        expect(places[:ptb][:gps_created][:gps_altitude_ref]).to eql('Above Sea Level')
      end

      it 'accepts STRING place name as a key' do
        expect(places['PTB'][:country]).to eq('Russia')
        expect(places['ptb'][:country]).to eq('Russia')
      end

      it 'returns empty hash if key does not exist' do
        expect(places[:xxx]).to eql({})
        expect(places['XXX'][:country]).to be_nil
        expect(places['xxx'][:city]).to be_nil
      end

      it 'prevents its properties to be altered from outside' do
        expect { places[:ptb][:xxx] = 'new' }.to raise_error(RuntimeError)
        expect { places[:ptb][:country] << 'new' }.to raise_error(RuntimeError)
        expect { places.filename[0] = 'X' }.to raise_error(RuntimeError)
        expect { places.errors << 'new error' }.to raise_error(RuntimeError)
      end
    end

    context 'when gets incorrect yml' do
      before :each do
        yml = {
          miss_parts: {
            world_region1: 'Europe',
            country1: 'Russia',
            country_code1: 'RU',
            state1: 'Petersburg region',
            city1: 'Petersburg',
            location1: 'Palace Square',
            gps_created1: {
              gps_latitude1: '59 56 21.069',
              gps_latitude_ref1: 'N',
              gps_longitude1: '30 18 50.067',
              gps_longitude_ref1: 'E',
              gps_altitude1: '0.5',
              gps_altitude_ref1: 'Above Sea Level' } },
          empty_parts: {
            world_region: '',
            country: '',
            country_code: '',
            state: '',
            city: '',
            location: '',
            gps_created: {
              gps_latitude: '',
              gps_latitude_ref: '',
              gps_longitude: '',
              gps_longitude_ref: '',
              gps_altitude: '',
              gps_altitude_ref: '' } },
          wrong_type: {
            world_region: [],
            country: 123,
            country_code: [],
            state: [],
            city: 123,
            location: [],
            gps_created: {
              gps_latitude: [],
              gps_latitude_ref: 123,
              gps_longitude: 123,
              gps_longitude_ref: [],
              gps_altitude: 123,
              gps_altitude_ref: [] } }
        }

        expect(File).to receive(:exist?).with('./places.yml').and_return(true)
        expect(File).to receive(:directory?).with('./places.yml').and_return(false)
        expect(YAML).to receive(:load_file).with('./places.yml').and_return(yml)
      end

      it 'reports yml has missing parts' do
        expect(places).not_to be_valid
        expect(places.errors).to include(%(miss_parts: 'world_region' is MISSED))
        expect(places.errors).to include(%(miss_parts: 'world_region' is MISSED))
        expect(places.errors).to include(%(miss_parts: 'country' is MISSED))
        expect(places.errors).to include(%(miss_parts: 'country_code' is MISSED))
        expect(places.errors).to include(%(miss_parts: 'state' is MISSED))
        expect(places.errors).to include(%(miss_parts: 'city' is MISSED))
        expect(places.errors).to include(%(miss_parts: 'location' is MISSED))
        expect(places.errors).to include(%(miss_parts: 'gps_created.gps_latitude' is MISSED))
        expect(places.errors).to include(%(miss_parts: 'gps_created.gps_latitude_ref' is MISSED))
        expect(places.errors).to include(%(miss_parts: 'gps_created.gps_longitude' is MISSED))
        expect(places.errors).to include(%(miss_parts: 'gps_created.gps_longitude_ref' is MISSED))
        expect(places.errors).to include(%(miss_parts: 'gps_created.gps_altitude' is MISSED))
        expect(places.errors).to include(%(miss_parts: 'gps_created.gps_altitude_ref' is MISSED))
      end

      it 'reports values are empty' do
        expect(places).not_to be_valid
        expect(places.errors).to include(%(empty_parts: 'world_region' is EMPTY))
        expect(places.errors).to include(%(empty_parts: 'world_region' is EMPTY))
        expect(places.errors).to include(%(empty_parts: 'country' is EMPTY))
        expect(places.errors).to include(%(empty_parts: 'country_code' is EMPTY))
        expect(places.errors).to include(%(empty_parts: 'state' is EMPTY))
        expect(places.errors).to include(%(empty_parts: 'city' is EMPTY))
        expect(places.errors).to include(%(empty_parts: 'location' is EMPTY))
        expect(places.errors).to include(%(empty_parts: 'gps_created.gps_latitude' is EMPTY))
        expect(places.errors).to include(%(empty_parts: 'gps_created.gps_latitude_ref' is EMPTY))
        expect(places.errors).to include(%(empty_parts: 'gps_created.gps_longitude' is EMPTY))
        expect(places.errors).to include(%(empty_parts: 'gps_created.gps_longitude_ref' is EMPTY))
        expect(places.errors).to include(%(empty_parts: 'gps_created.gps_altitude' is EMPTY))
        expect(places.errors).to include(%(empty_parts: 'gps_created.gps_altitude_ref' is EMPTY))
      end

      it 'reports the values are the wrong type' do
        expect(places).not_to be_valid
        expect(places.errors).to include(%(wrong_type: 'world_region' is WRONG TYPE, should be String))
        expect(places.errors).to include(%(wrong_type: 'world_region' is WRONG TYPE, should be String))
        expect(places.errors).to include(%(wrong_type: 'country' is WRONG TYPE, should be String))
        expect(places.errors).to include(%(wrong_type: 'country_code' is WRONG TYPE, should be String))
        expect(places.errors).to include(%(wrong_type: 'state' is WRONG TYPE, should be String))
        expect(places.errors).to include(%(wrong_type: 'city' is WRONG TYPE, should be String))
        expect(places.errors).to include(%(wrong_type: 'location' is WRONG TYPE, should be String))
        expect(places.errors).to include(%(wrong_type: 'gps_created.gps_latitude' is WRONG TYPE, should be String))
        expect(places.errors).to include(%(wrong_type: 'gps_created.gps_latitude_ref' is WRONG TYPE, should be String))
        expect(places.errors).to include(%(wrong_type: 'gps_created.gps_longitude' is WRONG TYPE, should be String))
        expect(places.errors).to include(%(wrong_type: 'gps_created.gps_longitude_ref' is WRONG TYPE, should be String))
        expect(places.errors).to include(%(wrong_type: 'gps_created.gps_altitude' is WRONG TYPE, should be String))
        expect(places.errors).to include(%(wrong_type: 'gps_created.gps_altitude_ref' is WRONG TYPE, should be String))
      end
    end
  end
end
