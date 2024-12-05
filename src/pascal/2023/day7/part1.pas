program day5part1;
uses sysutils;

type
    MState = (ReadCards, ReadBet);


var


    state: MState;
    file_: text;

    c: char;
    i, j, b: int64;

    sum, count: int32;

    rank: array[1..1000] of int32;
    bet: array[1..1000] of int32;

    line: string;


function CardToValue(inp: char): int32;
begin
    case inp of
        'A': CardToValue := 12;
        'K': CardToValue := 11;
        'Q': CardToValue := 10;
        'J': CardToValue := 9;
        'T': CardToValue := 8;
        '9': CardToValue := 7;
        '8': CardToValue := 6;
        '7': CardToValue := 5;
        '6': CardToValue := 4;
        '5': CardToValue := 3;
        '4': CardToValue := 2;
        '3': CardToValue := 1;
        '2': CardToValue := 0;
    end;
end;

function HandToValue(inp: string): int32;
var

    c: char;
    type_, hand_value: int32;
    counts: array[0..12] of int32;
    duos, trips, quads, quints: int32;

    i: int32;

begin

    filldword(counts, length(counts), 0);

    for c in inp do
        counts[CardToValue(c)] := counts[CardToValue(c)] + 1;

    duos := 0;
    trips := 0;
    quads := 0;
    quints := 0;

    for i in counts do
    begin
        if (i = 2) then
            duos := duos + 1
        else if (i = 3) then
            trips := trips + 1
        else if (i = 4) then
            quads := quads + 1
        else if (i = 5) then
            quints := quints + 1

    end;

    {5K, 4K, FH, 3K, 2P, 1P, HC}
    { 7,  6,  5,  4,  3,  2,  1}
    if (quints = 1) then
        type_ := 7
    else if (quads = 1) then
        type_ := 6
    else if ((trips = 1) and (duos = 1)) then
        type_ := 5
    else if (trips = 1) then
        type_ := 4
    else if (duos = 2) then
        type_ := 3
    else if (duos = 1) then
        type_ := 2
    else
        type_ := 1;

    hand_value := CardToValue(inp[1]) * 28561 + CardToValue(inp[2]) * 2197 + CardToValue(inp[3]) * 169 + CardToValue(inp[4]) * 13 + CardToValue(inp[5]);

    HandToValue := 371293 * type_ + hand_value;

end; 

procedure DoubleSort(var arr1: array of int32; var arr2: array of int32; l: int32);
var

    i, t: int32;
    swapped: boolean;

begin

    while (true) do
    begin
        swapped := false;
        for i := 1 to l-1 do
        begin
            if (arr1[i-1] > arr1[i]) then
            begin
                t := arr1[i-1];
                arr1[i-1] := arr1[i];
                arr1[i] := t;

                t := arr2[i-1];
                arr2[i-1] := arr2[i];
                arr2[i] := t;

                swapped := true;

            end;
        end;

        if (not swapped) then
            break;

    end

end; 


begin

    { open inp.txt for reading }
    assign(file_, 'resources/2023/day7.txt');
    reset(file_);

    count := 0;

    while not EOF(file_) do
    begin
        count := count + 1;

        readln(file_, line);

        writeln(count);

        writeln(line);

        rank[count] := HandToValue(copy(line, 1, 5));
        val(copy(line, 6, length(line) - 5), bet[count]);

        write(rank[count]);
        write(' ');
        writeln(bet[count]);

    end;

    writeln('a');
    for i := 1 to count do
        writeln(rank[i]);
    writeln();

    doublesort(rank, bet, count);

    writeln(rank[count]);
    writeln(bet[count]);

    sum := 0;

    writeln('a');
    for i := 1 to count do
        writeln(rank[i]);
    writeln();

    for i := 1 to count do

        sum := sum + bet[i] * i;

    writeln(sum);

end.
