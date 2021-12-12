#!/usr/bin/env ruby
require 'set'
grid = ARGF.map { |l|
  l.chomp.split('').map(&:to_i)
}
size = grid.map(&:length).sum

new_flashes = 0
total_flashes = 0
n = 0
while new_flashes < size
  flashers = Set.new
  new_flashes = 0
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
      new_flashes += 1
      (-1..1).each do |di|
        ni = i + di
        next if ni < 0 || ni >= grid.length
        (-1..1).each do |dj|
          nj = j + dj
          next if nj < 0 || nj >= grid.length
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
  total_flashes += new_flashes if n < 100 

  n += 1
end

puts "Flashes after 100 steps: #{total_flashes}"
puts "First step where all flash: #{n}"
