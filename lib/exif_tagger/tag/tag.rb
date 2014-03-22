#!/usr/bin/env ruby
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require 'active_support/core_ext'

module ExifTagger
  module Tag
    # Parent class for all tags
    class Tag
      include Comparable

      attr_reader :errors, :value, :value_invalid

      def initialize(value_norm)
        @value = value_norm
        @errors = []
        @value_invalid = []
        validate
        @value.freeze
        @errors.freeze
        @value_invalid.freeze
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
    end
  end
end
