# frozen_string_literal: true

require_relative "ic"

module Ricecream
  refine Kernel do
    def ic(*args)
      Ricecream.ic(caller_locations(1, 1).first, :ic, args)
      return *args
    end

    def ic_format(*args)
      Ricecream.format(caller_locations(1, 1).first, :ic_format, args)
    end

    private :ic, :ic_format
  end
end
