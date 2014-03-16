#!/usr/bin/env ruby -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative '../../../spec/spec_helper'
require 'places_dir'

describe ExifTagger::PlacesDir do
  let(:places) { ExifTagger::PlacesDir.new('./places.yml') }
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

    # it 'accepts STRING place name as a key' do
    #   expect(places['ANB'][:creator]).to match_array(['Andrey Bizyaev (photographer)', 'Andrey Bizyaev (camera owner)'])
    #   expect(places['anb'][:copyright]).to eql('(c) Andrey Bizyaev. All Rights Reserved.')
    # end

    it 'returns empty hash if key does not exist' do
      expect(places[:xxx]).to eql({})
      expect(places['XXX'][:country]).to be_nil
      expect(places['xxx'][:city]).to be_nil
    end

  #   it 'prevents its properties to be altered from outside' do
  #     expect { places[:ptb][:xxx_tag] = 'new' }.to raise_error(RuntimeError)
  #     expect { places[:ptb][:creator] << 'new' }.to raise_error(RuntimeError)
  #     expect { places.filename[0] = 'X' }.to raise_error(RuntimeError)
  #     expect { places.errors << 'new error' }.to raise_error(RuntimeError)
  #   end
  # end

  # context 'when gets incorrect yml' do
  #   before :each do
  #     yml = { anb: { creator: 'Andrey Bizyaev',
  #                    copyright: 333 },
  #             'Put' => { creator: [],
  #                        copyright1: '(c) Vladimir Putin' },
  #             cam: { creator1: ['James Cameron'],
  #                    copyright1: '(c) James Cameron' },
  #             'OBA' => { creator: ['', 123],
  #                        copyright: '' } }
  #     expect(File).to receive(:exist?).with('./places.yml').and_return(true)
  #     expect(File).to receive(:directory?).with('./places.yml').and_return(false)
  #     expect(YAML).to receive(:load_file).with('./places.yml').and_return(yml)
  #   end

  #   it 'checks missing parts' do
  #     expect(places).not_to be_valid
  #     expect(places.errors).to include(%(put: :copyright: is MISSED))
  #     expect(places.errors).to include(%(cam: :creator: is MISSED))
  #     expect(places.errors).to include(%(cam: :copyright: is MISSED))
  #   end

  #   it 'checks creator: value to be valid' do
  #     expect(places).not_to be_valid
  #     expect(places.errors).to include(%(anb: :creator: is WRONG TYPE, expected Array of strings, e.g. ["Creator1", "Creator2"]))
  #     expect(places.errors).to include(%(put: :creator: is EMPTY, expected Array of strings, e.g. ["Creator1", "Creator2"]))
  #     expect(places.errors).to include(%(oba: :creator: has EMPTY parts, expected Array of strings, e.g. ["Creator1", "Creator2"]))
  #     expect(places.errors).to include(%(oba: :creator: has NON-STRING parts, expected Array of strings, e.g. ["Creator1", "Creator2"]))
  #   end

  #   it 'checks copyright: value to be valid' do
  #     expect(places).not_to be_valid
  #     expect(places.errors).to include(%(anb: :copyright: is WRONG TYPE, expected String, e.g. "2014 Copyright"))
  #     expect(places.errors).to include(%(oba: :copyright: is EMPTY, expected String, e.g. "2014 Copyright"))
  #   end
  end
end
