#!/usr/bin/env ruby
# frozen_string_literal: true

CARD_STRENGTH = [
  *(2..9).map(&:to_s), 'T', 'J', 'Q', 'K', 'A'
].map.with_index { |v, i| [v, i] }.to_h

TYPE_STRENGTH = [
  'high', 'one pair', 'two pair', 'three of a kind', 'full house',
  'four of a kind', 'five of a kind'
].map.with_index { |v, i| [v, i] }.to_h

def calc_hand_strength(hand)
  hand.reverse
      .split('')
      .map.with_index { |c, i| CARD_STRENGTH[c] * (CARD_STRENGTH.size**i) }
      .sum
end

def get_type(hand)
  vals = hand.split('').group_by { |e| e }.transform_values(&:size).values.sort
  TYPE_STRENGTH[case vals.last
                when 5
                  'five of a kind'
                when 4
                  'four of a kind'
                when 3
                  vals == [2, 3] ? 'full house' : 'three of a kind'
                when 2
                  vals == [1, 2, 2] ? 'two pair' : 'one pair'
                when 1
                  'high'
                end]
end

def parse_line(line)
  hand, bid_str = line.split(' ')
  {
    hand: hand,
    type_strength: get_type(hand),
    hand_strength: calc_hand_strength(hand),
    bid: bid_str.to_i
  }
end

def cmp_cards(a, b)
  [a[:type_strength], a[:hand_strength]] <=>
    [b[:type_strength], b[:hand_strength]]
end

puts $stdin.each_line
           .map { |l| parse_line(l) }
           .sort { |a, b| cmp_cards(a, b) }
           .map.with_index { |hb, i| hb[:bid] * (i + 1) }
           .sum
