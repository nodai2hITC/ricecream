# frozen_string_literal: true

module Ricecream
  def self.colorize_code(code)
    return code unless @colorize
    require "irb"
    unless defined?(IRB::Color) &&
           IRB::Color.respond_to?(:colorize_code) &&
           @output.respond_to?(:tty?) &&
           @output.tty?
      return code
    end
    IRB::Color.colorize_code(code.to_s)
  end
end
