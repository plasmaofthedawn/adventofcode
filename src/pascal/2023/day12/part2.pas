{$mode objfpc}
{$RANGECHECKS ON}

program day12part1;
uses sysutils;

type
    int64array = array of int64;
    stringarray = array of string;

function sum(l: array of int64; start: int64 = 0): int64;
var
    i: int64;
begin
    sum := 0;
    for i := start to length(l) - 1 do
        sum := l[i] + sum;
end;

function split_to_int(s: string; delim: char): int64array ;
var
    i, last_delim, count : int64;
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
    setlength(split_to_int, count);

    count := 0;
    last_delim := 0;

    { second interation }
    for i := 1 to length(s) do
    begin
        { if this is a delimeter }
        if s[i] = delim then
        begin
            { add the value between this delimiter and the previous one to splitted }
            val(
                copy(s, last_delim + 1, i - last_delim - 1), split_to_int[count]
            );
            count := count + 1;
            last_delim := i;
        end;
    end;
    
    { don't forget the final value }
    val(
        copy(s, last_delim + 1, length(s) - last_delim), split_to_int[count]
    );
end;

function split_to_str(s: string; delim: char): stringarray;
var
    i, last_delim, count : int64;
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

function will_fit(s: string; idx, length: int64): boolean;
var
    i: int64;
begin
    will_fit := true;
    for i := idx to idx + length - 1 do
    begin
        if s[i] = '.' then
        begin
            will_fit := false;
            break;
        end;
    end;
end;

function all_after_not(s: string; idx: int64; c: char): boolean;
var
    i: int64;
begin
    all_after_not := true;
    for i := idx to length(s) do
    begin
        if s[i] = c then
        begin
            all_after_not := false;
            break;
        end;
    end;
end;

var
    cache: array[0..1000, 0..1000] of int64;

procedure clear_cache();
var
    i, j: int64;
begin
    for i := 0 to 1000 do
    begin
        for j:= 0 to 1000 do
        begin
            cache[i, j] := -1;
        end;
    end;
end;

function possibilties(s: string; l: array of int64; start_s: int64 = 1; start_l: int64 = 0): int64;
var
    i: int64;

begin

    possibilties := 0;

    { clear the cache if we r starting }
    if start_l = 0 then
        clear_cache();
    
    { return cache if we have the value }
    if cache[start_s, start_l] <> -1 then
    begin
        possibilties := cache[start_s, start_l];
        exit;
    end;

    { if there is only one spring left then }
    if length(l) - start_l = 1 then
    begin

        { check every possibility }
        for i := start_s to length(s) - l[start_l] + 1 do
        begin
            { if it will fit here, then it's valid }
            if will_fit(s, i, l[start_l]) and all_after_not(s, i + l[start_l], '#') then
                possibilties := possibilties + 1;

            { if we pass by a #, then it's not valid anymore as the # won't be filled }
            if s[i] = '#' then
                break;
        end;

    end
    else
    begin

        for i := start_s to length(s) - sum(l, start_l) - length(l) + start_l + 2 do
        begin
            { if it will fit and we aren't skipping a '#', recursively find possibilities }

            if will_fit(s, i, l[start_l]) and (s[i + l[start_l]] <> '#') then
                possibilties := possibilties + possibilties(s, l, i + l[start_l] + 1, start_l + 1);

            { if we pass by a #, then it's not valid anymore as the # won't be filled }
            if s[i] = '#' then
                break;
        end;
    end;

    cache[start_s, start_l] := possibilties;

end;

function duplicate_int_array(arr: int64array; times: int64): int64array;
var
    i: int64;
begin
    setlength(duplicate_int_array, length(arr) * times);

    for i := 0 to length(arr) * times - 1 do
    begin
        duplicate_int_array[i] := arr[i mod length(arr)];
    end;
end;

var

    s: string;
    pattern: array of int64;

    split: array of string;

    file_: text;

    total: int64;

begin

    assign(file_, 'resources/2023/day12.txt');
    reset(file_);

    total := 0;

    while not EOF(file_) do
    begin

        readln(file_, s);
        split := split_to_str(s, ' ');

        pattern := split_to_int(split[1], ',');

        //total := total + possibilties(split[0], pattern);
        
        total := total + possibilties(split[0] + '?' + split[0] + '?' + split[0] + '?' + split[0] + '?' + split[0],
                                      duplicate_int_array(pattern, 5));
                                     
        
    end;

    writeln('The sum is ', total);
end.

