#!/usr/bin/env ruby
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require 'active_support/core_ext'

module ExifTagger
  module Tag
    # Parent class for all tags
    class Tag
      include Comparable

      EXIFTOOL_TAGS = []
      attr_reader :errors, :value, :value_invalid, :warnings
      attr_accessor :info

      def initialize(value_norm)
        @value = value_norm
        @errors = []
        @value_invalid = []
        @warnings = []
        @info = ''
        validate
        @value.freeze
        @errors.freeze
        @value_invalid.freeze
        @warnings.freeze
      end

      def tag_id
        self.class.to_s.demodulize.underscore.to_sym
      end

      def tag_name
        self.class.to_s.demodulize
      end

      def <=>(other)
        if other.respond_to? :tag_id
          tag_id <=> other.tag_id
        else
          tag_id <=> other.to_s.to_sym
        end
      end

      def to_s
        "#{tag_id} = #{@value}"
      end

      def valid?
        @errors.empty?
      end

      def validate_with_original(values)
        @warnings = []
        self.class::EXIFTOOL_TAGS.each do |tag|
          v = values[tag]
          unless v.nil?
            case
            when v.kind_of?(String)
              @warnings << "#{tag_name} has original value: #{tag}='#{v}'" unless v.empty?
            when v.kind_of?(Array)
              @warnings << "#{tag_name} has original value: #{tag}=#{v}" unless v.join.empty?
            else
              @warnings << "#{tag_name} has original value: #{tag}=#{v}"
            end
          end
        end
        @warnings.freeze
      end

      private

      def print_info
        @info.empty? ? '' : "# INFO: #{@info}"
      end

      def print_warnings
        str = ''
        @warnings.each do |w|
          str << "# WARNING: #{w}\n"
        end
        str
      end

      def print_line(str)
        @warnings.empty? ? str : "# #{str}"
      end
    end
  end
end
