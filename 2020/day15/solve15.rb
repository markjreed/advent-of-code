#!/usr/bin/env ruby

def main(numbers, last_turn=2020, verbose=False)
  starting_list = numbers.split(',').map(&:to_i)
  last = starting_list.pop

  if verbose
    starting_list.each_with_index do |n, i|
      puts "Turn #{i+1}: #{n}"
    end
  end

  turn = starting_list.length
  spoken = starting_list.each_with_index.to_h

  while turn < position - 1

    puts "Turn #{turn+1}: #{last}" if verbose

    say = 0
    if spoken.include?(last)
      say = turn - spoken[last]
    end
    spoken[last] = turn
    last = say
    turn += 1
  end

  print("Turn #{turn+1}: ") if verbose;
  puts(last)
end

if __FILE__ == $0
  last_turn=2020
  verbose=false
  while ARGV[0] =~ /^-/ do
    opt = ARGV.shift
    if opt =~ /^-v/ then verbose = 1
    elsif opt =~ /^-t(\d+)/ then last_turn=$1.to_i
    elsif opt =~ /^-t$/ then last_turn = ARGV.shift.to_i
    else raise "Usage: #{$0} [-t last_turn] [-v] start-list\n"
    end
  end
  numbers = ARGV.shift
  main(numbers, position, verbose)
end
