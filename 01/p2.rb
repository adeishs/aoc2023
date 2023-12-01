#!/usr/bin/env ruby
# frozen_string_literal: true

WORD_NUM = {
  'zero' => 0,
  'one' => 1,
  'two' => 2,
  'three' => 3,
  'four' => 4,
  'five' => 5,
  'six' => 6,
  'seven' => 7,
  'eight' => 8,
  'nine' => 9
}.freeze
R = Regexp.new("(#{WORD_NUM.keys.join('|')})")
A = Regexp.new('[a-z]')

def parse(s)
  loop do
    m = s.match(R)
    break unless m

    matched_word = m[0]
    idx = m.begin(0)
    s = "#{s[0...idx]}#{WORD_NUM[matched_word]}#{s[idx + 1..]}"
  end
  nums = s.gsub(A, '').split('')
  "#{nums.first}#{nums.last}".to_i
end

puts $stdin.each_line
           .map { |line| parse(line.chomp) }
           .sum
