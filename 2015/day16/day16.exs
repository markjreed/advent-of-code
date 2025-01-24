#!/usr/bin/env elixir
if Enum.count(System.argv) != 1 do
    IO.write(:stderr, "Usage: #{Path.basename(__ENV__.file)} filename\n")
    System.halt(1)
end
[filename|_] = System.argv
    
mfcsam = Map.new(
    Enum.map(
        Enum.filter(
            String.split(File.read!("mfcsam.txt"),"\n"),
            fn s -> String.length(s) > 0 end
        ), 
        fn s -> String.split(s, ": ") end
    ), fn [k, v] -> {String.to_atom(k), String.to_integer(v)} end
)


sues =  Enum.map(
    Enum.filter(
        String.split(File.read!(filename),"\n"), 
        fn s -> String.length(s) > 0 end
    ), 
    fn s -> 
        [_|[num|fields]] = String.split(s," ");
        Map.new(
            Enum.to_list(
                Stream.chunk_every(
                    Enum.map(["number"|[num|fields]], 
                              fn s -> 
                                  [s|_] = String.split(s,":");
                                  [s|_] = String.split(s, ",");
                                  s
                               end
                    ),
                    2
                )
            ),
            fn [k, v] -> { String.to_atom(k), String.to_integer(v) } end
        )
     end
)


[ found | _ ] = Enum.reduce(
    mfcsam, 
    sues, 
    fn {k, v}, sues -> 
        Enum.filter(
            sues, 
            fn sue -> !Map.has_key?(sue, k) or sue[k] == v end
        )
    end
)
IO.puts(found.number)

more = MapSet.new([:cats, :trees])
less = MapSet.new([:pomeranians, :goldfish])
special = MapSet.union(more, less)

[ found| _ ] = Enum.reduce(
    mfcsam,
    sues,
    fn {k, v}, sues -> 
        Enum.filter(
            sues,
            fn sue ->
                !Map.has_key?(sue, k) or 
                (MapSet.member?(more, k) and sue[k] > v) or
                (MapSet.member?(less, k) and sue[k] < v) or
                (!MapSet.member?(special, k) and sue[k] == v)
            end
        )
    end
)
IO.puts(found.number)
