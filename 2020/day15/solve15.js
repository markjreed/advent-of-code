const cla = require('command-line-args')

function main(numbers, last_turn, verbose) {
  let starting_list = numbers.split(',').map( n => Number(n) );
  let last = starting_list.pop();

  if (verbose) {
    for (let i=0; i<starting_list.length; ++i) {
      console.log(`Turn ${i+1}: ${starting_list[i]}`);
    }
  }

  let spoken = starting_list.reduce((dict, n, i) => { return { ...dict, [n]: i} }, {});
  let turn = starting_list.length;

  while (turn < last_turn -1) {
    if (verbose) {
      console.log(`Turn ${turn+1}: ${last}`);
    }
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
  { name: 'turn', alias: 't', type: Number, defaultValue: 2020 },
  { name: 'numbers', type: String, defaultOption: true }
]);

main(options.numbers, options.turn, options.verbose)

