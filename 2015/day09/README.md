# 2015 Day 9 Solution
The randomly-chosen language for today is SNOBOL 4.

To run: `snobol4 day9.sno input.txt`.

Got to do a little pattern matching to parse the input file, but the meat of the solution is brute force:
trying all the permutations of the cities (though some we can skip because they try to go between cities where
there's no edge) and remembering which one had the shortest (longest) distance. It uses a global array to hold
the permutation and a compute-next-permutation routine to loop through them.
routine.

|File|Description
|---|--------|
|[day9.sno](day9.sno)     | Solution |
|[sample.txt](sample.txt) | Sample input from the problem description |
|[input.txt](input.txt)   | My program input (encrypted) |
