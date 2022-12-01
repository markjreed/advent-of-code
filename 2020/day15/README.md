Raku took quite a long time to do part 2, so I reached for some other
languages. Perl runs a little faster than Python for earlier positions, but
loses ground further into the sequence; for the 30M target, Perl ran in about
17 seconds vs about 13 for the Python. Ruby was surprisingly a lot faster than
both, clocking it at only 6 seconds to get the 30-millionth item.  I also threw
together a Node.JS version, but it was slower even than Raku, which
_definitely_ surprised me. I let them both run to completion and Raku took just
over 10 minutes while Python took over 12. Not sure if I lost something in
translation there.
