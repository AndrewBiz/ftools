#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require 'active_support/core_ext'

module ExifTagger
  module Tag
    # Parent class for all tags
    class Tag
      include Comparable

      attr_reader :errors, :value

      def tag_id
        self.class.to_s.demodulize.underscore.to_sym
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
