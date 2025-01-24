#!/usr/bin/env lua
if #arg ~= 1 then
   io.stderr:write(string.format("Usage: %s filename\n", arg[0]))
   os.exit(1)
end

inspect = require('inspect')

ingredients = {}
for line in io.lines(arg[1]) do
    field = "name"
    ingredient = {}
    for word in line:gmatch("[-%w]+") do
        if #field == 0 then
            field = word
        else
            ingredient[field] = word
            field = ""
        end
    end
    table.insert(ingredients, ingredient)
end

if #ingredients > 4 then
   io.stderr:write(string.format("%s: solution only works for <= 4 ingredients\n", arg[0]))
   os.exit(1)
end

function compute_score(counts,part)
    totals = {}
    product = 1
    calories = 0
    for k, v in pairs(ingredients[1]) do
        if k ~= "name" then
            totals[k] = 0
            for i, ingredient in ipairs(ingredients) do
               totals[k] = totals[k] + (counts[i] * ingredient[k])
            end
            if totals[k] < 0 then 
                totals[k] = 0
            end
            if k ~= "calories" then
                product = product * totals[k]
            end
        end
    end
    if part == 2 and totals.calories ~= 500 then
        return 0
    else
        return product
    end
end

for part = 1, 2 do
    best = 0
    for a = 1, 100 do
        if #ingredients == 2 then
            b = 100 - a
            score = compute_score({a, b}, part)
            if score > best then 
                best = score
            end
        else
            for b = 1, 100 - a  do
                if #ingredients == 3 then
                    c = 100 - a - b
                    score = compute_score({a, b, c}, part)
                    if score > best then
                        best = score
                    end
                else
                    for c = 1, 100 - a - b do
                        d = 100 - a - b - c
                        score = compute_score({a, b, c, d}, part)
                        if score > best then 
                            best = score
                        end
                    end
                end
            end
       end
    end
    print(best)
end
