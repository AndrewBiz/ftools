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

Then(/^the stdout should contain each of:$/) do |table|
  # table is a Cucumber::Ast::Table
  outs = table.raw.flatten
  outs.each do |item|
    step %{the stdout should contain "#{item}"}
  end
end

Then(/^the stdout should not contain any of:$/) do |table|
  # table is a Cucumber::Ast::Table
  outs = table.raw.flatten
  outs.each do |item|
    step %{the stdout should not contain "#{item}"}
  end
end

Then(/^the stderr should contain each of:$/) do |table|
  # table is a Cucumber::Ast::Table
  outs = table.raw.flatten
  outs.each do |item|
    step %{the stderr should contain "#{item}"}
  end
end