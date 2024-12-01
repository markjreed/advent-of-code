#!/usr/bin/env raku
say ([Z-] ([Z] lines».words)».sort)».abs.sum
