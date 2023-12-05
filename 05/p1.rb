#!/usr/bin/env ruby
# frozen_string_literal: true

def parse_map(map_str)
  map_str.split(":\n")
         .pop
         .split("\n")
         .map do |l|
           dest, src, len = l.split(' ').map(&:to_i)
           { src_range: src...src + len, ofs: dest - src }
         end
end

def parse_input(input_str)
  els = input_str.split("\n\n")
  {
    seeds: els.shift.split(': ').pop.split(' ').map(&:to_i),
    maps: els.map { |m| parse_map(m) }
  }
end

input = parse_input($stdin.read)
min_loc = input[:seeds].max
input[:seeds].map do |loc|
  input[:maps].each do |media_maps|
    media_maps.each do |m|
      if m[:src_range].include?(loc)
        loc += m[:ofs]
        break
      end
    end
  end
  min_loc = [min_loc, loc].min
end
puts min_loc
