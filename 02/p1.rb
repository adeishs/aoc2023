#!/usr/bin/env ruby
# frozen_string_literal: true

class Game
  attr_reader :id
  attr_accessor :sets

  def initialize(id)
    @id = id
    @sets = []
  end

  MAX_COUNT = {
    'red' => 12,
    'green' => 13,
    'blue' => 14
  }.freeze

  def possible?
    sets.all? { |set| set.keys.all? { |k| (set[k] || 0) <= MAX_COUNT[k] } }
  end
end

def parse_cube(cube_str)
  strs = cube_str.split(' ')
  [strs.last, strs.first.to_i]
end

def parse_sets(sets_str)
  sets_str.split('; ').map do |cubes_str|
    Hash[*cubes_str.split(', ').map { |c| parse_cube(c) }.flatten]
  end
end

def parse_game(game_str)
  game_id_str, sets_str = game_str.split(': ')
  _, game_id = game_id_str.split(' ')
  game = Game.new(game_id.to_i)
  game.sets = parse_sets(sets_str)
  game
end

puts $stdin.each_line.map { |line| parse_game(line.chomp) }
           .select(&:possible?)
           .map(&:id)
           .sum
