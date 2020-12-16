#!/usr/bin/env ruby

def main(numbers, position=2020, verbose=False)
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
