#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

RUBY_VERSION_WANTED = '2.1.0'

begin
  fail "Ruby version must be >= #{RUBY_VERSION_WANTED}" if
    RUBY_VERSION < RUBY_VERSION_WANTED
rescue => e
  STDERR.puts e.message
  exit 1
end
