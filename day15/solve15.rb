#!/usr/bin/env ruby

def main(numbers, position=2020, verbose=False)
  starting_list = numbers.split(',').map(&:to_i)
  spoken = starting_list[0..-2].each_with_index.map.to_h
  last = starting_list[-1]
  turn = starting_list.length - 1
  while turn < position -1 do 
    if spoken.include? last then
      say = turn - spoken[last]
    else
      say = 0
    end
    spoken[last] = turn
    last = say
    turn = turn + 1
  end

  print("Turn #{turn+1}: ") if verbose;
  puts(last)
end

if __FILE__ == $0 
  position=2020
  verbose=false
  while ARGV[0] =~ /^-/ do
    opt = ARGV.shift
    if opt =~ /^-v/ then verbose = 1
    elsif opt =~ /^-p(\d+)/ then position=$1.to_i
    elsif opt =~ /^-p$/ then position = ARGV.shift.to_i
    else raise "Usage: #{$0} [-p position] [-v] start-list\n"
    end
  end
  numbers = ARGV.shift
  main(numbers, position, verbose)
end
