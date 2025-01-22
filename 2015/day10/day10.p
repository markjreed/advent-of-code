{$H+}
program day10(input, output, stderr);

var
    i: integer;
    f: text;
    sequence: string;

function look_say(previous: String): String;
var
   total, count, i: LongInt;
   ch: char;
   count_str: String;
   next: String;

begin
    total := length(previous);
    count := 1;
    ch := previous[1];
    next := '';
    for i := 2 to total do begin
        if previous[i] = ch then
            count += 1
        else begin
            Str(count, count_str);
            next := next + count_str + ch;
            ch := previous[i];
            count := 1;
        end
    end;
    Str(count, count_str);
    look_say := next + count_str + ch;
end;

begin
    if paramCount() <> 1 then begin
        writeln(stderr, 'Usage: ' + paramStr(0) + ' input-file');
        exit()
    end;
    assign(f, paramStr(1));
    reset(f);
    readln(f, sequence);
    close(f);
    
    for i := 1 to 40 do 
        sequence := look_say(sequence);
    writeln(length(sequence));
    for i := 1 to 10 do
        sequence := look_say(sequence);
    writeln(length(sequence));
end.
