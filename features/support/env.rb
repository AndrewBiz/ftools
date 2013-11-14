# $LOAD_PATH.unshift(File.dirname(__FILE__) + '/../bin')
# $LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../bin')
require 'aruba/cucumber'
ENV['PATH'] = "#{File.dirname(__FILE__) + '/../bin'}:" + ENV['PATH']
ENV['PATH'] = "#{File.dirname(__FILE__) + '/../../bin'}:" + ENV['PATH']
