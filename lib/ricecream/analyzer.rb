# frozen_string_literal: true

require "ripper"
require_relative "ic_method"

module Ricecream
  class Analyzer < Ripper
    MethodName = /\Aic(?:_format)?\z/

    def initialize(path)
      @ic_methods = []
      @last_loc = [1, 0]
      @path = File.absolute_path(path.to_s)
      return unless File.file?(@path)
      @script = File.binread(@path) + " "
      super(@script, @path)
      parse
      enc = encoding
      enc = Encoding::UTF_8 if enc == Encoding::ASCII_8BIT
      @script.force_encoding(enc)
      @script_lines = @script.lines
    end

    def ic_methods
      @ic_methods.select { |ic| ic[:locs].size > 1 }.map do |ic|
        args = ic[:locs].each_cons(2).map do |locs|
          byteslice(locs[0], locs[1]).delete_prefix(",").strip.gsub(/\R+/, " ")
        end
        ICMethod.new(ic[:name], @path, ic[:lineno], ic[:column], args.size, args)
      end
    end

    def byteslice(from, to)
      return @script_lines[from[0] - 1].byteslice(from[1]...to[1]) if from[0] == to[0]

      str = @script_lines[from[0] - 1][from[1]...-1]
      (from[0]...(to[0] - 1)).each do |i|
        str += @script_lines[i]
      end
      str += @script_lines[to[0] - 1].byteslice(0...to[1])
    end

    (PARSER_EVENTS - %i[command vcall method_add_arg]).each do |event|
      module_eval(<<-End, __FILE__, __LINE__ + 1)
        def on_#{event}(*args)
          @token = ""
          args.unshift [:#{event}, @last_loc]
          args
        end
      End
    end

    SCANNER_EVENTS.each do |event|
      module_eval(<<-End, __FILE__, __LINE__ + 1)
        def on_#{event}(tok)
          @last_loc = [lineno(), column()]
          [:@#{event}, tok, @last_loc]
        end
      End
    end

    def on_command(*args)
      args.unshift [:command, @last_loc]
      return args unless args.dig(1, 0) == :@ident
      method_name = args.dig(1, 1)
      if MethodName === method_name
        line = args.dig(1, 2, 0)
        col1 = args.dig(1, 2, 1)
        col2 = col1 + args.dig(1, 1).length
        add_method_data(method_name, line, col1, col2, args.dig(2, 1))
      end
      args
    end

    def on_vcall(*args)
      args.unshift [:vcall, @last_loc]
      return args unless args.dig(1, 0) == :@ident
      method_name = args.dig(1, 1)
      if MethodName === method_name
        line = args.dig(1, 2, 0)
        col1 = args.dig(1, 2, 1)
        col2 = col1 + args.dig(1, 1).length
        add_method_data(method_name, line, col1, col2, args.dig(2, 1, 1))
      end
      args
    end

    def on_method_add_arg(*args)
      args.unshift [:method_add_arg, @last_loc]
      return args unless args.dig(1, 0, 0) == :fcall && args.dig(1, 1, 0) == :@ident
      method_name = args.dig(1, 1, 1)
      if MethodName === method_name
        line = args.dig(1, 1, 2, 0)
        col1 = args.dig(1, 1, 2, 1)
        col2 = col1 + args.dig(1, 1, 1).length + 1
        add_method_data(method_name, line, col1, col2, args.dig(2, 1, 1))
      end
      args
    end

    def add_method_data(name, line, col1, col2, args_add)
      locs = []
      while args_add
        break unless args_add.dig(0, 0) == :args_add
        locs.unshift args_add.dig(0, 1)
        args_add = args_add.dig(1)
      end
      locs.unshift [line, col2]
      @ic_methods.push({ name: name.to_sym, lineno: line, column: col1, locs: locs })
    end
  end
end
