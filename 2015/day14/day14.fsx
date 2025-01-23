open System

let args = Environment.GetCommandLineArgs();;

if args.Length <> 4 then
    eprintfn "Usage: %s %s filename time-limit" <| args[0] <| args[1]
    exit 1;;

type Reindeer = struct
    val Name     : string
    val Speed    : int
    val FlyTime  : int
    val RestTime : int
    new(name, speed, flyTime, restTime) = { Name = name; Speed = speed; FlyTime = flyTime; RestTime = restTime }
end;;


let readLines filePath = IO.File.ReadLines(filePath);;

let reindeer = ResizeArray<Reindeer>(Array.empty);;

for line in readLines(args[2]) do
    let words = line.Split(" ")
    let name = words[0]
    let speed = words[3] |> int
    let flyTime = words[6] |> int
    let restTime = words[13] |> int
    reindeer.Add(new Reindeer(name, speed, flyTime, restTime));;

let position = ResizeArray<int>(Array.create reindeer.Count 0);;

let duration = args[3] |> int;;
let mutable winner = -1;;
let mutable maxDist = 0;;

for i in 0 .. reindeer.Count - 1  do
    let deer = reindeer[i]
    let period = deer.FlyTime + deer.RestTime;
    let distance = deer.Speed * deer.FlyTime
    let complete = duration / period
    let partial  = duration % period
    let extra = if partial > deer.FlyTime then deer.FlyTime else partial
    position[i] <- complete * distance + extra * deer.Speed
    if position[i] > maxDist then 
        maxDist <- position[i]
        winner <- i
    
//    printfn "%s (%d km/s %d/%d seconds) is at %d" <| deer.Name <| deer.Speed <| deer.FlyTime <| deer.RestTime <| position[i]
    ;;

printfn "The winner is %s at distance %d km" <| reindeer[winner].Name  <| position[winner];;


