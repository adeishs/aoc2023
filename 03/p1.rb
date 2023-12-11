#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

def get_char_class(char)
  return nil if char.nil? || char == '.'
  return :number if char.match?(/[[:digit:]]/)

  :symbol
end

def get_symbol_locs(chars)
  symbol_locs = Set.new
  chars.each.with_index do |cols, y|
    cols.each.with_index do |c, x|
      symbol_locs << Complex(x, y) if get_char_class(c) == :symbol
    end
  end
  symbol_locs
end

def get_part_adj_number_locs(chars, symbol_locs)
  number_locs = Set.new
  symbol_locs.each do |loc|
    [
      -1 - 1i, 0 - 1i, 1 - 1i, -1, 1, -1 + 1i, 0 + 1i, 1 + 1i
    ].map { |d| loc + d }.each do |adj|
      number_locs << adj if get_char_class(chars[adj.imag][adj.real]) == :number
    end
  end

  number_locs
end

def get_part_number_locs(chars, symbol_locs)
  number_locs = get_part_adj_number_locs(chars, symbol_locs)
  more_number_locs = Set.new
  number_locs.each do |loc|
    [-1, 1].each do |dir|
      a = loc + dir
      loop do
        cl = get_char_class(chars[a.imag][a.real])
        break if cl.nil? || cl != :number

        more_number_locs << Complex(a.real, a.imag)
        a += dir
      end
    end
  end

  number_locs | more_number_locs
end

def find_part_numbers(chars)
  part_number_locs = get_part_number_locs(chars, get_symbol_locs(chars))

  chars.map.with_index do |cols, y|
    cols.map.with_index do |c, x|
      part_number_locs.member?(Complex(x, y)) ? c : ' '
    end.join('').strip.split(/\s+/).map(&:to_i)
  end.flatten
end

puts find_part_numbers(
  $stdin.each_line.map { |line| line.chomp.split('') }
).sum
