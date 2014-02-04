#!/usr/bin/env ruby -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative '../../../spec/spec_helper'
require 'event'

describe FTools::Event do
  before :each do
    hash = { event: { title: 'Круиз Балтика',
                      sort: '_01',
                      uri: 'anblab.net',
                      date_start: '2013-01-02 00:00:00',
                      date_end: '2013-01-08 23:59:59',
                      keywords: { what: ['круиз', 'travel'],
                                  who: ['Andrew'],
                                  where: ['Балтийское море', 'Baltic'],
                                  when: ['день', 'day'],
                                  why: ['отпуск', 'vacation'],
                                  how: ['отлично', 'fine'],
                                  method: ['digital photo camera'] },
                      alias_place_created: 'peterburg' } }
    # mocking
    allow(File).to receive(:exist?).and_return(true)
    allow(File).to receive(:directory?).and_return(false)
    allow(YAML).to receive(:load_file).and_return(hash)
  end

  it 'stores parameters of the event profile' do
    event = FTools::Event.new('./event.yml')
    expect(event.profile).to eq('./event.yml')
    expect(event.title).to eq('Круиз Балтика')
    expect(event.sort).to eq('_01')
    expect(event.uri).to eq('anblab.net')
    expect(event.date_start).to eq DateTime.strptime('2013-01-02 00:00:00',
                                                     '%Y-%m-%d %H:%M:%S')
    expect(event.date_end).to eq DateTime.strptime('2013-01-08 23:59:59',
                                                   '%Y-%m-%d %H:%M:%S')
    expect(event.keywords).to match_array(['круиз', 'travel', 'Andrew',
                                           'Балтийское море', 'Baltic',
                                           'день', 'day', 'отпуск', 'vacation',
                                           'отлично', 'fine',
                                           'digital photo camera'])
    expect(event.alias_place_created).to eq('peterburg')
  end

  it 'generates event dirname based on event data' do
    event = FTools::Event.new('./event.yml', 'parent/dir')
    expect(event.basename).to eq('20130102-08_01 Круиз Балтика')
    expect(event.dirname).to eq('parent/dir/20130102-08_01 Круиз Балтика')
  end
end

describe FTools::Event, 'validates parameters:' do
  before :each do
    # mocking
    allow(File).to receive(:exist?).and_return(true)
    allow(File).to receive(:directory?).and_return(false)
  end

  it 'considers the one day event if date_end is not set' do
    hash = { event: { title: 'Круиз Балтика',
                      # sort: '_01',
                      uri: 'anblab.net',
                      date_start: '2013-01-02 00:00:00',
                      # date_end: '2013-01-08 23:59:59',
                      keywords: { what: ['travel'] },
                      alias_place_created: 'peterburg' } }
    allow(YAML).to receive(:load_file).and_return(hash)

    event = FTools::Event.new('./event.yml')
    expect(event.date_end).to eq DateTime.strptime('2013-01-02 23:59:59',
                                                   '%Y-%m-%d %H:%M:%S')
    expect(event.basename).to eq('20130102 Круиз Балтика')
  end

  it 'date_start is set' do
    hash = { event: { title: 'aaa',
                      # date_start: '2013-01-02 10:00:00',
                      keywords: { what: ['travel'] },
                      alias_place_created: 'peterburg' } }
    allow(YAML).to receive(:load_file).and_return(hash)

    expect { FTools::Event.new('./event.yml') }.to \
      raise_error(FTools::Error, \
       "reading event profile './event.yml' - parsing dates - date_start is not set")
  end

  it 'title is not empty' do
    hash = { event: {
                      # title: '',
                      date_start: '2013-01-02 10:00:00',
                      keywords: { what: ['travel'] },
                      alias_place_created: 'peterburg' } }
    allow(YAML).to receive(:load_file).and_return(hash)

    expect { FTools::Event.new('./event.yml') }.to \
      raise_error(FTools::Error,
                  'invalid event profile - title is not set')
  end

  it 'date_start < date_end' do
    hash = { event: { title: 'Круиз Балтика',
                      date_start: '2013-01-02 10:00:00',
                      date_end: '2013-01-02 09:59:59',
                      keywords: { what: ['travel'] },
                      alias_place_created: 'peterburg' } }
    allow(YAML).to receive(:load_file).and_return(hash)

    expect { FTools::Event.new('./event.yml') }.to \
      raise_error(FTools::Error,
                  'invalid event profile - date_end < date_start')
  end
  it 'removes trailing spaces from all but sort' do
    hash = { event: { title: ' Круиз Балтика ',
                      sort: ' 01',
                      uri: ' anblab.net ',
                      date_start: '2013-01-02 00:00:00',
                      date_end: '2013-01-08 23:59:59',
                      keywords: { what: [' travel ', 'путешествие '] },
                      alias_place_created: 'peterburg ' } }
    allow(YAML).to receive(:load_file).and_return(hash)

    event = FTools::Event.new('./event.yml')
    expect(event.title).to eq('Круиз Балтика')
    expect(event.sort).to eq(' 01')
    expect(event.uri).to eq('anblab.net')
    expect(event.keywords).to match_array(['travel', 'путешествие'])
    expect(event.alias_place_created).to eq('peterburg')
  end
end
