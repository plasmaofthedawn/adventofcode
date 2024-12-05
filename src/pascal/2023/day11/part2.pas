program day11part1;
uses sysutils;


function dist_between(x1, x2: int32; empty_list: array of boolean): int64;
var
    i: int32;
begin
    
    { swap operands so x1 is always smaller}
    if (x2 < x1) then
    begin
        i := x2;
        x2 := x1;
        x1 := i;
    end;

    { calculate distance }
    dist_between := 0;
    for i := x1 to x2 - 1 do
    begin

        dist_between := dist_between + 1;

        { if gap, increment by an additional 999999 }
        if empty_list[i] then
            dist_between := dist_between + 999999;
        

    end;
end;

function galaxy_dist(g1, g2: array of int64; row_list, col_list: array of boolean): int64;
begin
    galaxy_dist := dist_between(g1[0], g2[0], col_list) + dist_between(g1[1], g2[1], row_list);
end;

var
    file_: text;

    str: string;

    galaxies: array[0..1000, 0..1] of int64;
    galaxy_count: int32;

    column_empty: array[1..1000] of boolean;
    row_empty: array[1..1000] of boolean;

    i, j: int32;
    count: int32;

    sum: int64;

begin
     { open inp.txt for reading }
    assign(file_, 'resources/2023/day11.txt');
    reset(file_);

    { set row/cols to empty }
    for i := 0 to 1000 do
    begin
        column_empty[i] := true;
        row_empty[i] := true;
    end;

    count := 0;
    galaxy_count := 0;

    { read file }
    while not EOF(file_) do
    begin

        count := count + 1;

        readln(file_, str);

        for i := 1 to length(str) do
        begin
            
            if str[i] = '#' then
            begin

                { record this galaxy }
                galaxy_count := galaxy_count + 1;

                galaxies[galaxy_count][0] := i;
                galaxies[galaxy_count][1] := count;

                { mark rows/cols as nonempty }
                row_empty[count] := false;
                column_empty[i] := false;

            end;

        end;
    end;

    sum := 0;
    { for each pair }
    for i := 1 to galaxy_count do
    begin
        for j := i + 1 to galaxy_count do
        begin

        { sum the pairwise distance }
        sum := sum + galaxy_dist(galaxies[i], galaxies[j], row_empty, column_empty);

        end;
    end;

    writeln('The sum is ', sum);
end.

