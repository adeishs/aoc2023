#!/usr/bin/env ruby
# frozen_string_literal: true

require 'singleton'

class Memo
  include Singleton

  attr_accessor :cache

  def initialize
    @cache = {}
  end
end

UNKNOWN = '?'
OPERATIONAL = '.'
DAMAGED = '#'

def calc_possible_unfolded_count(springs, conds, consec_count)
  return conds.empty? && consec_count.zero? ? 1 : 0 if springs.nil?

  possible_count = Memo.instance.cache[[springs, conds, consec_count]]
  return possible_count unless possible_count.nil?

  possible_count = 0
  (springs[0] == UNKNOWN ? [OPERATIONAL, DAMAGED] : [springs[0]]).each do |c|
    next_cond = c != DAMAGED && consec_count.positive?
    next if next_cond && conds.first != consec_count

    possible_count += calc_possible_unfolded_count(
      springs[1..],
      conds[(next_cond ? 1 : 0)..],
      c == DAMAGED ? consec_count + 1 : 0
    )
  end

  Memo.instance.cache[[springs, conds, consec_count]] = possible_count
  possible_count
end

def unfold_and_calc_possible_count(line)
  springs, cond_str = line.split(' ')
  conds = cond_str.split(',').map(&:to_i)

  # add operational as a no-op at the end of recursion
  calc_possible_unfolded_count(
    "#{([springs] * 5).join(UNKNOWN)}#{OPERATIONAL}", conds * 5, 0
  )
end

puts $stdin.each_line
           .map { |line| unfold_and_calc_possible_count(line.chomp) }
           .sum
