#!/usr/bin/env lua
require "string"
verbose = false
last_turn = 2020

while (string.sub(arg[1],1,1) == "-") do
  first = table.remove(arg,1)
  if first == '-v' then verbose = true
  elseif first == '-t' then last_turn = table.remove(arg,1)-0
  else error("Usage: "..arg[0].."[-t last-turn] [-v] starting-list")
  end
end

starting_list = {}
for n in string.gmatch(arg[1], "[^, ]+") do
  table.insert(starting_list, n)
end
last = table.remove(starting_list)
turn = #starting_list + 1

spoken = {}
for i, n in ipairs(starting_list) do
  if verbose then
    print("Turn " .. i .. ": " .. n)
  end
  spoken[n] = i
end

while turn < last_turn do
  if verbose then
    print("Turn " .. turn ..": " .. last)
  end
  say = 0
  key = tostring(last)
  if spoken[key] ~= nil then
    say = turn - spoken[key]
  end
  spoken[key] = turn
  last = say
  turn = turn + 1
end

if verbose then
  io.write("Turn " .. turn+1 .. ":")
end
print(last)

