#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

EXP_SIZE = 999_999
AXES = %w[real imag].freeze
EXTREMA = %w[min max].freeze

def parse_input(input)
  input.split("\n").map(&:chars).map.with_index do |cols, y|
    cols.map.with_index { |point, x| point == '#' ? Complex(x, y) : nil }
  end.flatten.reject(&:nil?)
end

def init_border
  EXTREMA.map do |e|
    [
      e,
      AXES.map { |a| [a, e == 'min' ? Float::INFINITY : -Float::INFINITY] }.to_h
    ]
  end.to_h
end

def get_universe_borders(galaxy_locs)
  border = init_border
  galaxy_locs.each do |l|
    border.each_key do |m|
      border[m].each_key do |a|
        border[m][a] = [l.send(a), border[m][a]].send(m)
      end
    end
  end

  border
end

def get_empty_axis_lines(galaxy_locs)
  border = get_universe_borders(galaxy_locs)
  get_empty_lines = lambda { |ax|
    s, e = EXTREMA.map { |e| border[e][ax] }
    [*s + 1..e - 1].select { |i| galaxy_locs.none? { |l| l.send(ax) == i } }
                   .sort { |a, b| b <=> a }
  }

  AXES.map { |c| [c, get_empty_lines.call(c)] }.to_h
end

def expand_universe(galaxy_locs)
  empty_lines = get_empty_axis_lines(galaxy_locs)
  AXES.each do |c|
    empty_lines[c].each do |r|
      galaxy_locs = galaxy_locs.map do |l|
        Complex(
          *AXES.map { |a| l.send(a) + (c == a && l.send(a) > r ? EXP_SIZE : 0) }
        )
      end
    end
  end

  galaxy_locs
end

def calc_dist(a, b)
  d = a - b
  AXES.map { |ax| d.send(ax).abs }.sum
end

puts expand_universe(parse_input($stdin.read)).combination(2)
                                              .map { |a, b| calc_dist(a, b) }
                                              .sum
