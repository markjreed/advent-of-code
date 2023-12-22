In a k-ms race, the distance traveled if you charge for x ms is 

      y = x(k - x)

We need to find the minimum and maximum values of x for which y &gt; r.
We can solve for x(k - x) &gt; r, and we find an interesting term 
d=sqrt(k^2-4r); the range of x values is from (k-d)/2 to (k+d)/2.

So consdier the part 1 version of the sample races.

race 1: k=7, r=9.  d = sqrt(49-36) = sqrt(13).  ceil((7 - sqrt(13)/2) is 2,
floor((7 + sqrt(13))/2) is 5. So there are 5-2+1=4 ways to win.


x=7, x=8, and x=9.

Time:      7  15   30
Distance:  9  40  200
