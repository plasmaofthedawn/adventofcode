{$mode objfpc}
{$RANGECHECKS ON}

program day14part1;
uses sysutils;

procedure print_map(map: array of string; height: int32);
var
    i: int32;
begin
    for i := 0 to height - 1 do
        writeln(map[i]);
end;

procedure copy_map(map: array of string; var map2: array of string; height: int32);
var
    i: int32;
begin
    for i := 0 to height - 1 do
        map2[i] := map[i]
end;

procedure shift_up(var map: array of string; height: int32; width: int32);
var
    i, j, k: int32;
    current_boulders: int32;
begin
    for i := 1 to width do
    begin

        current_boulders := 0;

        for j := 1 to height do
        begin
            case map[height - j][i] of
                'O':
                begin
                    current_boulders := current_boulders + 1;
                    map[height - j][i] := '.'
                end;
                '#':
                begin
                    for k := height - j + 1 to height - j + current_boulders do
                    begin
                        map[k][i] := 'O'
                    end;
                    current_boulders := 0;
                end;
            end;
        end;

        for k := 0 to current_boulders - 1 do
        begin
            map[k][i] := 'O'
        end;
        current_boulders := 0;

    end;
end;

procedure shift_left(var map: array of string; height: int32; width: int32);
var
    i, j, k: int32;
    current_boulders: int32;
begin
    for i := 0 to height - 1 do
    begin

        current_boulders := 0;

        for j := 0 to width - 1 do
        begin
            case map[i][width - j] of
                'O':
                begin
                    current_boulders := current_boulders + 1;
                    map[i][width - j] := '.'
                end;
                '#':
                begin
                    for k := width - j + 1 to width - j + current_boulders do
                    begin
                        map[i][k] := 'O'
                    end;
                    current_boulders := 0;
                end;
            end;
        end;

        for k := 1 to current_boulders do
        begin
            map[i][k] := 'O'
        end;
        current_boulders := 0;

    end;
end;

procedure shift_down(var map: array of string; height: int32; width: int32);
var
    i, j, k: int32;
    current_boulders: int32;
begin
    for i := 1 to width do
    begin

        current_boulders := 0;

        for j := 0 to height - 1 do
        begin
            case map[j][i] of
                'O':
                begin
                    current_boulders := current_boulders + 1;
                    map[j][i] := '.'
                end;
                '#':
                begin
                    for k := j - current_boulders to j - 1 do
                    begin
                        map[k][i] := 'O'
                    end;
                    current_boulders := 0;
                end;
            end;
        end;

        for k := height - current_boulders to height - 1 do
        begin
            map[k][i] := 'O'
        end;
        current_boulders := 0;

    end;
end;

procedure shift_right(var map: array of string; height: int32; width: int32);
var
    i, j, k: int32;
    current_boulders: int32;
begin
    for i := 0 to height - 1 do
    begin

        current_boulders := 0;

        for j := 1 to width do
        begin
            case map[i][j] of
                'O':
                begin
                    current_boulders := current_boulders + 1;
                    map[i][j] := '.'
                end;
                '#':
                begin
                    for k := j - current_boulders to j - 1 do
                    begin
                        map[i][k] := 'O'
                    end;
                    current_boulders := 0;
                end;
            end;
        end;

        for k := width - current_boulders + 1 to width do
        begin
            map[i][k] := 'O'
        end;
        current_boulders := 0;

    end;
end;

procedure spin_cycle(var map: array of string; height: int32; width: int32);
begin
    shift_up(map, height, width);
    shift_left(map, height, width);
    shift_down(map, height, width);
    shift_right(map, height, width);
end;

function calculate_load(map: array of string; height: int32): int32;
var
    i: int32;
    c: char;
begin
    calculate_load := 0;
    for i := 0 to height - 1 do
    begin
        for c in map[i] do
        begin
            if c = 'O' then
                calculate_load := calculate_load + height - i;
        end;
    end;
end;

function strcomp(s1: string; s2: string): boolean;
var
    i: int32;
begin
    strcomp := true;
    for i := 1 to length(s1) do
    begin
        if (s1[i] <> s2[i]) then
        begin
            strcomp := false;
            break;
        end;
    end;
end;

function map_equal(map: array of string; map2: array of string; height: int32): boolean;
var
    i: int32;
begin
    map_equal := true;
    for i := 0 to height - 1 do
    begin
        if not strcomp(map[i], map2[i]) then
        begin
            map_equal := false;
            break;
        end;
    end;
end;

var

    file_: text;

    map: array[1..10000, 1..100] of string;
    values: array[1..10000] of int32;
    
    height, width: int32;
    i, j: int32;

    finished: boolean;

    wanted: int32;

begin

    assign(file_, 'resources/2023/day14.txt');
    reset(file_);

    height := 0;

    while not eof(file_) do
    begin
        height := height + 1;
        readln(file_, map[1, height]);
    end;

    width := length(map[1, 1]);
    values[1] := calculate_load(map[1], height);
    finished := false;

    for i := 2 to 100000 do
    begin

        copy_map(map[i - 1], map[i], height);
        spin_cycle(map[i], height, width);
        values[i] := calculate_load(map[i], height);

        writeln('Found value ', values[i], ' for the ', i, 'th spin cycle');

        for j := 1 to i - 1 do
        begin
            if map_equal(map[i], map[j], height) then
            begin
                writeln('This map is equal to the ', j, 'th map');
                finished := true;
                break;
            end;
        end;

        if finished then
            break;

    end;

    wanted := 1000000000;

    writeln('This map has a cycle length of ', i - j, 'x + ', j);
    writeln('This places ', wanted, ' at position ', (wanted - j) mod (i - j) + j + 1, ' in the cycle');
    writeln('It would have a total load of ', values[(wanted - j) mod (i - j) + j + 1]);

end.
