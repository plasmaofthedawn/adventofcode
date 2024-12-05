{$mode objfpc}
{$RANGECHECKS ON}

program day13part1;
uses sysutils;

type
    Tmap = record
        map: array[1..100] of string;
        height: int32;
        width: int32;
    end;

function max(a, b: int32): int32;
begin
    max := a;
    if b > a then
        max := b;
end;

{ check for mirrors that lay vertically (column mirror) }
function check_v_mirror(map: Tmap; col: int32): boolean;
var
    i, j: int32;
begin

    check_v_mirror := true;
    for j := 1 to map.height do 
    begin
        for i := max(1, 2 * col - map.width + 1) to col do
        begin
            // writeln(i, ' ',  col*2 - i);
            if map.map[j, i] <> map.map[j, col * 2 - i + 1] then
            begin
                check_v_mirror := false;
                break
            end;
        end;

        if not check_v_mirror then
            break;
    end;

    check_v_mirror := check_v_mirror;

end;

{ check for mirrors that lay vertically (column mirror) }
function check_h_mirror(map: Tmap; row: int32): boolean;
var
    i, j: int32;
begin

    check_h_mirror := true;
    for j := 1 to map.width do 
    begin
        for i := max(1, 2 * row - map.height + 1) to row do
        begin
            //writeln(i, ' ',  row*2 - i + 1);
            if map.map[i, j] <> map.map[row * 2 - i + 1, j] then
            begin
                check_h_mirror := false;
                break
            end;
        end;

        if not check_h_mirror then
            break;
    end;
end;


function get_mirror(map: Tmap): int32;
var
    i: int32;
begin
    { check vertical ones first } 
    for i := 1 to map.width - 1 do
    begin
        if check_v_mirror(map, i) then
        begin
            get_mirror := i;
            exit;
        end;
    end;

    { check horizontal ones now }
    for i := 1 to map.height - 1 do
    begin
        if check_h_mirror(map, i) then
        begin
            get_mirror := i shl 6 + i shl 5 + i shl 2;
            exit;
        end;
    end;

end;

var

    map: Tmap;
    file_: text;
    s: string;
    total, map_count: int32;

begin

    assign(file_, 'resources/2023/day13.txt');
    reset(file_);

    total := 0;
    map_count := 0;

    while not EOF(file_) do
    begin

        readln(file_, s);
        writeln(s);
        if length(s) = 0 then
        begin
            // come back to this

            total := total + get_mirror(map);

            map_count := 0;

        end
        else
        begin

            map_count := map_count + 1;
            map.map[map_count] := s;
            map.height := map_count;
            map.width := length(s);

        end;

    end;

    writeln(total);

end.
