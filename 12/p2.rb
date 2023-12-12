#!/usr/bin/env ruby
# frozen_string_literal: true

UNKNOWN = '?'
OPERATIONAL = '.'
DAMAGED = '#'

$cache = {}

def calc_possible_unfolded_count(springs, conds, conseq_count)
  return conds.empty? && conseq_count.zero? ? 1 : 0 if springs.nil?

  possible_count = $cache[[springs, conds, conseq_count]]
  return possible_count unless possible_count.nil?

  possible_count = 0
  (springs[0] == UNKNOWN ? [OPERATIONAL, DAMAGED] : [springs[0]]).each do |c|
    next_cond = c != DAMAGED && conseq_count.positive?
    next if next_cond && conds.first != conseq_count

    possible_count += calc_possible_unfolded_count(
      springs[1..],
      conds[(next_cond ? 1 : 0)..],
      c == DAMAGED ? conseq_count + 1 : 0
    )
  end

  $cache[[springs, conds, conseq_count]] = possible_count
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
