#!/usr/bin/env ruby
# frozen_string_literal: true

UNKNOWN = '?'
OPERATIONAL = '.'
DAMAGED = '#'

def get_conds(arr)
  conds = []
  conseq_count = 0
  arr.chars.each do |c|
    if c == DAMAGED
      conseq_count += 1
    elsif conseq_count.positive?
      conds.append(conseq_count)
      conseq_count = 0
    end
  end
  conds.append(conseq_count) if conseq_count.positive?
  conds
end

def replace_unknowns(springs, subs, unknown_idxs)
  s = springs.to_s
  unknown_idxs.each_with_index { |ui, si| s[ui] = subs[si] }
  s
end

def possible?(springs, conds)
  unknown_idxs = (0...springs.size).find_all { |i| springs[i] == UNKNOWN }
  [OPERATIONAL, DAMAGED].repeated_permutation(unknown_idxs.size)
                        .map do |s|
    get_conds(replace_unknowns(springs, s, unknown_idxs)) == conds
  end
end

def calc_possible_count(line)
  springs, cond_str = line.split(' ')
  conds = cond_str.split(',').map(&:to_i)

  possible?(springs, conds).select { |p| p }.size
end

puts $stdin.each_line
           .map { |line| calc_possible_count(line.chomp) }
           .sum
