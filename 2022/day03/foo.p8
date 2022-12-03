%import byteset 
%import textio
%zeropage basicsafe

main {
  uword myset
  sub start() {
    myset = byteset.new()
    txt.print("count=")
    txt.print_ub(byteset.count(myset))
    txt.nl()
    txt.print("is_set(0)=")
    if byteset.is_set(myset, 0) {
      txt.print("true")
    } else {
      txt.print("false")
    }
    txt.nl()
  }
}
