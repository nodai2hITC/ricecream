# frozen_string_literal: true

require_relative "ic_method"
require_relative "colorize"
require_relative "config"
require_relative "version"

module Ricecream
  @ic_methods = {}

  def self.ic(location, name, args)
    output format(location, name, args) if @enable
  end

  def self.format(location, name, args)
    str = prefix(location)
    arity = args.size
    if arity == 0
      return "#{str}#{context(location)} at #{Time.now.strftime('%H:%M:%S.%L')}"
    end

    path = location.absolute_path
    unless @ic_methods[path]
      require_relative "analyzer"
      @ic_methods[path] = Analyzer.new(path).ic_methods
    end

    lineno = location.lineno
    method = @ic_methods[path].find do |m|
      m.lineno == lineno && m.arity == arity && m.name == name
    end

    str += "#{context(location)}- " if @include_context || !method
    argstrs = method ? method.args.map { |arg| colorize_code(arg) } :
                       1.upto(arity).map { |i| "<arg#{i}>" }
    args = args.map { |arg| colorize_code(arg_to_s(arg)) }
    argpairs = argstrs.zip(args).map do |argstr, arg|
      argstr == arg ? argstr : "#{argstr}: #{arg}"
    end
    str + argpairs.join(", ")
  end

  def self.context(location)
    "#{location.path}:#{colorize_code(location.lineno)} in #{location.label}"
  end
end
