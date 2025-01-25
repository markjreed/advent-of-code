/=>/         { subs[NR] = $1 "," $3 }
/./ && !/=>/ { molecule = $0 }
END {
    for (i=1; i<=length(subs); ++i) {
        repl = subs[i]
        split(repl, fromto, ",")
        split(molecule, pieces, fromto[1])
        for (j=1; j<=length(pieces)-1; ++j) {
            out = pieces[1]
            for (k=2; k<=length(pieces); ++k)  {
                out = out fromto[1 + (j+1==k)] pieces[k]
            }
            distinct[out] = 1
        }
    }
    print(length(distinct));
    count = patsplit(molecule,components,/[A-Z][a-z]*/)
    for (i=1; i<=count; ++i) {
        if (components[i] == "Rn" || components[i] == "Ar") {
            RnAr += 1
        } else if (components[i] == "Y") {
            Y += 1
        }
    }
    print(count - RnAr - 2*Y - 1)
}
ORnPBPMgArCaCaCaSiThCaCaSiThCaCaPBSiRnFArRnFArCaCaSiThCaCaSiThCaCaCaCaCaCaSiRnFYFArSiRnMgArCaSiRnPTiTiBFYPBFArSiRnCaSiRnTiRnFArSiAlArPTiBPTiRnCaSiAlArCaPTiTiBPMgYFArPTiRnFArSiRnCaCaFArRnCaFArCaSiRnSiRnMgArFYCaSiRnMgArCaCaSiThPRnFArPBCaSiRnMgArCaCaSiThCaSiRnTiMgArFArSiThSiThCaCaSiRnMgArCaCaSiRnFArTiBPTiRnCaSiAlArCaPTiRnFArPBPBCaCaSiThCaPBSiThPRnFArSiThCaSiThCaSiThCaPTiBSiRnFYFArCaCaPRnFArPBCaCaPBSiRnTiRnFArCaPRnFArSiRnCaCaCaSiThCaRnCaFArYCaSiRnFArBCaCaCaSiThFArPBFArCaSiRnFArRnCaCaCaFArSiRnFArTiRnPMgArF
