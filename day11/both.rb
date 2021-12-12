#!/usr/bin/env ruby
require 'set'
grid = ARGF.map { |l|
  l.chomp.split('').map(&:to_i)
}

#puts "Before any steps:"
#puts grid.map{ |r| r.join '' }.join("\n")
flashes = 0
100.times do |n|
  flashers = Set.new
  was = flashers.length
  grid.length.times do |i|
    grid[i].length.times do |j|
      grid[i][j] += 1
      if grid[i][j] > 9 then
        flashers << [i,j]
      end
    end
  end

  while flashers.length > was do
    was = flashers.length
    flashers.to_a.each do |i,j|
      next if grid[i][j] == 0
      grid[i][j] = 0
      flashes += 1
      (-1..1).each do |di|
        ni = i + di
        if ni < 0 || ni >= grid.length then
          next
        end
        (-1..1).each do |dj|
          nj = j + dj
          if nj < 0 || nj >= grid.length then
            next
          end
          if grid[ni][nj] > 0 then
            grid[ni][nj] += 1
            if grid[ni][nj] > 9 then
              flashers << [ni,nj]
            end
          end
        end
      end
    end
  end
  #puts "After step #{n+1}, there have been #{flashes} flashes. Grid:"
  #puts grid.map{ |r| r.join '' }.join("\n")
end

puts flashes
