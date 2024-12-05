{$mode objfpc}

program day12part1;
uses sysutils;

type
    stringarray = array of string;

function split_to_str(s: AnsiString; delim: char): stringarray;
var
    i, last_delim, count : int32;
    c: char;
begin

    { there will always be at least one number }
    count := 1;
    { count number of delimeters }
    for c in s do
    begin
        if c = delim then
            count := count + 1;
    end;

    { allocate enough space for count}
    setlength(split_to_str, count);

    count := 0;
    last_delim := 0;

    { second interation }
    for i := 1 to length(s) do
    begin
        { if this is a delimeter }
        if s[i] = delim then
        begin
            { add the value between this delimiter and the previous one to splitted }
            split_to_str[count] := copy(s, last_delim + 1, i - last_delim - 1);
            count := count + 1;
            last_delim := i;
        end;
    end;
    
    { don't forget the final value }
    split_to_str[count] := copy(s, last_delim + 1, length(s) - last_delim)
end;

function hash(s: string): int32;
var
    c: char;
begin
    hash := 0;
    for c in s do
        hash := ((hash + ord(c)) * 17) and 255;


end;

var

    s: AnsiString;
    to_hash: array of string;

    split: array of string;

    file_: text;

    sum: int32;

begin

    assign(file_, 'resources/2023/day15.txt');
    reset(file_);
    readln(file_, s);

    to_hash := split_to_str(s, ',');
    writeln(length(to_hash));

    sum := 0;

    for s in to_hash do
        sum := sum + hash(s);

    writeln('The sum is ', sum);
end.

