const cla = require('command-line-args')

function main(numbers, position, verbose) {
  let starting_list = numbers.split(',').map( n => Number(n) );
  let turn = starting_list.length-1;
  let last = starting_list[turn]
  let spoken = starting_list.splice(0,starting_list.length-1).reduce((dict, n, i) => { return { ...dict, [n]: i} }, {});
  while (turn < position -1) {
    let say = 0;
    if (last in spoken) {
      say = turn - spoken[last]
    }
    spoken[last] = turn;
    last = say;
    turn = turn + 1;
  }
  if (verbose)
    process.stdout.write(`Turn ${turn+1}: `);
  console.log(last);
}

const options = cla( [
  { name: 'verbose', alias: 'v', type: Boolean, defaultValue: false },
  { name: 'position', alias: 'p', type: Number, defaultValue: 2020 },
  { name: 'numbers', type: String, defaultOption: true }
]);

main(options.numbers, options.position, options.verbose)

