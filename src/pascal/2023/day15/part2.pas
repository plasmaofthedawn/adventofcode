{$mode objfpc}

program day12part1;
uses sysutils;

type
    stringarray = array of string;
    lens = record
        label_: string;
        focal: int32;
    end;


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

function streq(s1: string; s2: string): boolean;
var
    i: int32;
begin
    streq := true;
    for i := 1 to length(s1) do
    begin
        if (s1[i] <> s2[i]) then
        begin
            streq := false;
            break;
        end;
    end;
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
    { ideally a linked list would be nice for the second dim, but eh.}
    boxes: array[0..255, 1..100] of lens;
    b_length: array[0..255] of int32;

procedure insert_lens(l: string; f: int32);
var
    hvalue: int32;
    i: int32;
begin

    hvalue := hash(l);

    { check for duplicate }
    for i := 1 to b_length[hvalue] do
    begin
        if streq(boxes[hvalue, i].label_, l) then
        begin
            boxes[hvalue, i].focal := f;
            exit;
        end;
    end;

    { add to end }

    b_length[hvalue] := b_length[hvalue] + 1;
    boxes[hvalue, b_length[hvalue]].label_ := l;
    boxes[hvalue, b_length[hvalue]].focal := f;

end;

procedure remove_lens(l: string);
var
    hvalue: int32;
    i: int32;
    shifting: boolean;
begin
    hvalue := hash(l);
    
    shifting := false;
    for i := 1 to b_length[hvalue] do
    begin
        if shifting then
            boxes[hvalue, i - 1] := boxes[hvalue, i]
        else if streq(boxes[hvalue, i].label_, l) then
            shifting := true;
    end;

    if shifting then
        b_length[hvalue] := b_length[hvalue] - 1;
end;

procedure write_boxes();
var
    i, j: int32;
begin

    for i := 0 to 255 do
    begin
        if b_length[i] <> 0 then
        begin

            write('Box ', i, ': ');

            for j := 1 to b_length[i] do
            begin
                write('[', boxes[i, j].label_, ' ', boxes[i, j].focal, '] ');
            end;

            writeln();
        end;
    end;
end;

var

    s: AnsiString;
    to_hash: array of string;

    split: array of string;

    file_: text;

    i, j: int32;
    sum: int32;

begin

    assign(file_, 'resources/2023/day15.txt');
    reset(file_);
    readln(file_, s);

    to_hash := split_to_str(s, ',');

    { fill boxes }
    for s in to_hash do
    begin
        if s[length(s)] = '-' then
            remove_lens(copy(s, 0, length(s) - 1))
        else if s[length(s) - 1] = '=' then
        begin
            val(s[length(s)], i);
            insert_lens(copy(s, 0, length(s) - 2), i);
        end;
    end;

    { sum }
    sum := 0;
    for i := 0 to 255 do
        for j := 1 to b_length[i] do
            sum := sum + (i + 1) * j * boxes[i, j].focal;


    write_boxes();
    writeln('The sum is ', sum);
end.

