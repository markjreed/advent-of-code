#!/usr/bin/env node
const fs = require('fs')

const map = fs.readFileSync(process.argv[2]).toString().split("\n").map(s => s.split(''));

const elevation = letter => {
  if (letter == 'S') {
    letter = 'a'
  } else if (letter == 'E') {
    letter = 'z'
  }
  return letter.charCodeAt(0) - 'a'.charCodeAt(0)
}

let alternates = []
let edges = {}
let start, end

for (const [i, row] of map.entries()) {
  for (const [j, letter] of row.entries()) {
    const coords = `${i},${j}`
    if (letter == 'S') {
      start = coords
    } else if (letter == 'E') {
      end = coords
    } else if (letter == 'a') {
       alternates.push(coords)
    }

    const level = elevation(letter)
    for (const [di, dj] of [[-1,0],[0,1],[1,0],[0,-1]]) {
      const ni = i + di
      if (0 <= ni  && ni < map.length) {
        const nj = j + dj
        if (0 <= nj && nj < map[ni].length) {
          const nlevel = elevation(map[ni][nj])
          if (nlevel <= level + 1) {
            (edges[coords]||=[]).push(`${ni},${nj}`)
          }
        }
      }
    }
  }
}

for (const part of [0,1]) {
  let heads = new Set([start])
  if (part)
    heads = new Set([...heads, ...alternates])

  let distance = 0;
  while (!heads.has(end)) {
    distance += 1
    for (const node of [...heads]) {
      for (const neighbor of (edges[node]||[])) {
        heads.add(neighbor)
      }
    }
  }

  console.log(`Part ${part+1}: ${distance}`)
}
