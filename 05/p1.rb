#!/usr/bin/env ruby
# frozen_string_literal: true

def parse_map(map_str)
  map_str.split(":\n")
         .pop
         .split("\n")
         .map { |l| l.split(' ').map(&:to_i) }
         .map { |dest, src, len| { dest: dest, src: src, len: len } }
end

def parse_input(input_str)
  els = input_str.split("\n\n")
  {
    seeds: els.shift.split(': ').pop.split(' ').map(&:to_i),
    maps: els.map { |m| parse_map(m) }
  }
end

def construct_maps(input)
  input[:maps].map do |media_map|
    Hash[*media_map.map do |mm|
      [*0...mm[:len]].map { |i| [mm[:src] + i, mm[:dest] + i] }.flatten
    end.flatten]
  end
end

input = parse_input($stdin.read)
maps = construct_maps(input)
input[:seeds].map do |loc|
  maps.each do |m|
    loc = m[loc] || loc
  end
  puts loc
end
