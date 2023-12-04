#!/usr/bin/env ruby
# frozen_string_literal: true

def parse_nums(num_str)
  num_str.strip.split(/ +/).map(&:to_i)
end

def parse_game(game_str)
  card_str, num_str = game_str.split(': ')
  win_str, possess_str = num_str.split(' | ')
  {
    id: card_str.split(' ').last.to_i,
    win_nums: parse_nums(win_str),
    possess_nums: parse_nums(possess_str)
  }
end

def calc_points(game)
  1 << (game[:win_nums].intersection(game[:possess_nums]).size - 1)
end

puts $stdin.each_line.map { |line| calc_points(parse_game(line.chomp)) }.sum
