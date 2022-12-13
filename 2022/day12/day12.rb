#!/usr/bin/env ruby
require 'set'

map = ARGF.map { |line| line.chars }

def elevation(letter)
    letter.tr('SE','az').ord - 'a'.ord
end

alternates = []
edges = {}
start = nil
dest = nil

map.each_with_index do |row, i|
  row.each_with_index do |letter, j|
    coords = "#{i},#{j}"
    if letter == 'S' then
      start = coords
    elsif letter == 'E' then
      dest = coords
    elsif letter == 'a' then
      alternates << coords
    end
    level = elevation(letter)
    [ [-1,0], [0,1], [1,0], [0,-1] ].each do |di, dj|
      ni = i + di
      if 0 <= ni and ni < map.length then
        nj = j + dj
        if 0 <= nj and nj < map[ni].length then
          nlevel = elevation(map[ni][nj])
          edges[coords] ||= []
          edges[coords] << "#{ni},#{nj}" if nlevel <= level + 1
        end
      end
    end
  end
end

2.times do |part|
  heads = Set.new([start])
  heads += alternates if part > 0

  distance = 0
  while !heads.include? dest do
    distance += 1
    heads.entries.each do |node|
      edges[node].each do |neighbor|
        heads << neighbor
      end
    end
  end

  puts "Part #{part+1}: #{distance}";
end
