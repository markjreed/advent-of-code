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


let winner duration : ResizeArray<int> * int = 
    let mutable windices = ResizeArray<int>(Array.empty)
    let mutable maxDist = -1
    let mutable position = Array.create reindeer.Count 0

    for i in 0 .. reindeer.Count - 1  do
        let deer = reindeer[i]
        let period = deer.FlyTime + deer.RestTime
        let distance = deer.Speed * deer.FlyTime
        let complete = duration / period
        let partial  = duration % period
        let extra = if partial > deer.FlyTime then deer.FlyTime else partial
        position[i] <- complete * distance + extra * deer.Speed
        if position[i] = maxDist then
            windices.Add(i);
        else if position[i] > maxDist then
            maxDist <- position[i]
            windices <- ResizeArray<int>(Array.create 1 i);
    (windices, maxDist);;
    
let duration = args[3] |> int;;

// part 1
let (winners, dist) = winner(duration);;
printfn "%d" <| dist;;

// part 2
let mutable score = ResizeArray<int>(Array.create reindeer.Count 0)
for time in 1 .. duration do
    let (winners, dist) = winner(time)
    for i in winners do
        score[i] <- score[i] + 1

let mutable windex = -1
let mutable maxScore = 0

for i in 0 .. reindeer.Count - 1  do
    if score[i] > maxScore then
        maxScore <- score[i]
        windex <- i

printfn "%d" <| score[windex]
