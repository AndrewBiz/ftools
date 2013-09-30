#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

Given(/^empty files named:$/) do |table|
  # table is a Cucumber::Ast::Table
  files = table.raw.flatten
  files.each do |file|
    step %{an empty file named "#{file}"}
  end
end
