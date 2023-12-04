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

def get_num_of_wins(game)
  game[:win_nums].intersection(game[:possess_nums]).size
end

games = $stdin.each_line.map { |line| parse_game(line.chomp) }
queued_cards = [*0...games.size]
processed_cards = []
until queued_cards.empty?
  curr_idx = queued_cards.shift
  curr_game = games[curr_idx]
  num_of_wins = get_num_of_wins(curr_game)
  if num_of_wins.positive?
    queued_cards.append(
      *curr_idx + 1..curr_idx + num_of_wins
    )
  end
  processed_cards.append(curr_idx)
end

puts processed_cards.size
