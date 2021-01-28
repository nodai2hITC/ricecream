# frozen_string_literal: true

module Ricecream
  @enable = true
  @prefix = "ic| "
  @output = STDERR
  @include_context = false
  @colorize = false

  module Config
    def enable
      @enable = true
    end

    def disable
      @enable = false
    end

    def prefix(location)
      @prefix
    end

    def prefix=(value)
      @prefix = value
    end

    def output(str)
      @output.puts str
    end

    def output=(value)
      @output = value
    end

    def arg_to_s(arg)
      arg.inspect
    end

    def include_context=(value)
      @include_context = value
    end

    def colorize=(value)
      @colorize = value
    end
  end

  extend Config
end
