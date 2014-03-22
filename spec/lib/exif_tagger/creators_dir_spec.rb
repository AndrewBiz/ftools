#!/usr/bin/env ruby
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative '../../../spec/spec_helper'
require 'creators_dir'

describe ExifTagger::CreatorsDir do
  let(:creators) { ExifTagger::CreatorsDir.new('./creators.yml') }
  context 'when gets correct yml' do
    before :each do
      yml = { anb: { creator: ['Andrey Bizyaev (photographer)', 'Andrey Bizyaev (camera owner)'],
                     copyright: '(c) Andrey Bizyaev. All Rights Reserved.' },
              put: { creator: ['Vladimir Putin'],
                     copyright: '(c) Vladimir Putin. All Rights Reserved.' },
              oba: { creator: ['Barak Obama'],
                     copyright: '(c) Barak Obama. All Rights Reserved.' } }
      expect(File).to receive(:exist?).with('./creators.yml').and_return(true)
      expect(File).to receive(:directory?).with('./creators.yml').and_return(false)
      expect(YAML).to receive(:load_file).with('./creators.yml').and_return(yml)
    end

    it 'stores the list of creators' do
      expect(creators).to be_valid
      expect(creators.filename).to eq('./creators.yml')
      expect(creators[:anb][:creator]).to match_array(['Andrey Bizyaev (photographer)', 'Andrey Bizyaev (camera owner)'])
      expect(creators[:anb][:copyright]).to eql('(c) Andrey Bizyaev. All Rights Reserved.')
      expect(creators[:put][:creator]).to match_array(['Vladimir Putin'])
      expect(creators[:put][:copyright]).to eql('(c) Vladimir Putin. All Rights Reserved.')
      expect(creators[:oba][:creator]).to match_array(['Barak Obama'])
      expect(creators[:oba][:copyright]).to eql('(c) Barak Obama. All Rights Reserved.')
    end

    it 'accepts STRING author name as a key' do
      expect(creators['ANB'][:creator]).to match_array(['Andrey Bizyaev (photographer)', 'Andrey Bizyaev (camera owner)'])
      expect(creators['anb'][:copyright]).to eql('(c) Andrey Bizyaev. All Rights Reserved.')
    end

    it 'returns empty hash if key does not exist' do
      expect(creators[:xxx]).to eql({})
      expect(creators['XXX'][:creator]).to be_nil
      expect(creators['xxx'][:copyright]).to be_nil
    end

    it 'prevents its properties to be altered from outside' do
      expect { creators[:anb][:xxx_tag] = 'new' }.to raise_error(RuntimeError)
      expect { creators[:anb][:creator] << 'new' }.to raise_error(RuntimeError)
      expect { creators.filename[0] = 'X' }.to raise_error(RuntimeError)
      expect { creators.errors << 'new error' }.to raise_error(RuntimeError)
    end
  end

  context 'when gets incorrect yml' do
    before :each do
      yml = { anb: { creator: 'Andrey Bizyaev',
                     copyright: 333 },
              'Put' => { creator: [],
                         copyright1: '(c) Vladimir Putin' },
              cam: { creator1: ['James Cameron'],
                     copyright1: '(c) James Cameron' },
              'OBA' => { creator: ['', 123],
                         copyright: '' } }
      expect(File).to receive(:exist?).with('./creators.yml').and_return(true)
      expect(File).to receive(:directory?).with('./creators.yml').and_return(false)
      expect(YAML).to receive(:load_file).with('./creators.yml').and_return(yml)
    end

    it 'checks missing parts' do
      expect(creators).not_to be_valid
      expect(creators.errors).to include(%(put: :copyright: is MISSED))
      expect(creators.errors).to include(%(cam: :creator: is MISSED))
      expect(creators.errors).to include(%(cam: :copyright: is MISSED))
    end

    it 'checks creator: value to be valid' do
      expect(creators).not_to be_valid
      expect(creators.errors).to include(%(anb: :creator: is WRONG TYPE, expected Array of strings, e.g. ["Creator1", "Creator2"]))
      expect(creators.errors).to include(%(put: :creator: is EMPTY, expected Array of strings, e.g. ["Creator1", "Creator2"]))
      expect(creators.errors).to include(%(oba: :creator: has EMPTY parts, expected Array of strings, e.g. ["Creator1", "Creator2"]))
      expect(creators.errors).to include(%(oba: :creator: has NON-STRING parts, expected Array of strings, e.g. ["Creator1", "Creator2"]))
    end

    it 'checks copyright: value to be valid' do
      expect(creators).not_to be_valid
      expect(creators.errors).to include(%(anb: :copyright: is WRONG TYPE, expected String, e.g. "2014 Copyright"))
      expect(creators.errors).to include(%(oba: :copyright: is EMPTY, expected String, e.g. "2014 Copyright"))
    end
  end
end
