%import bignum
%zeropage basicsafe

main {
    sub start() {
        txt.lowercase()

        ^^bignum.Number num = bignum.newFromByte(-128)
;       bignum.inspectNum(num)
        txt.print_bn(num) txt.nl()
        bignum.shiftLeft(num)
        txt.print_bn(num) txt.nl()
        bignum.freeNumber(num)

        num = bignum.newFromUbyte(255)
;       bignum.inspectNum(num)
        txt.print_bn(num) txt.nl()
        bignum.shiftLeft(num)
        txt.print_bn(num) txt.nl()
        bignum.freeNumber(num)

        num = bignum.newFromWord(-32768)
;       bignum.inspectNum(num)
        txt.print_bn(num) txt.nl()
        bignum.shiftLeft(num)
        txt.print_bn(num) txt.nl()
        bignum.freeNumber(num)

        num = bignum.newFromUword(65535)
;       bignum.inspectNum(num)
        txt.print_bn(num) txt.nl()
        bignum.shiftLeft(num)
        txt.print_bn(num) txt.nl()
        bignum.freeNumber(num)

        num = bignum.newFromString("170520923035051")
;       bignum.inspectNum(num)
        txt.print_bn(num) txt.nl()
        bignum.shiftLeft(num)
        txt.print_bn(num) txt.nl()
        bignum.freeNumber(num)

    }
}
