program day3part2;
uses sysutils;

var
file_: text;
curr: string;
sum, game: int32;
state: int32;
number: int32;
valid: boolean;

i, a, b: int32;
line: int32;
c: char;

LINE_LENGTH: int32 = 140;

curr_asterisk: int32;
asterisks: int32;
asterisk_values: array[1..1000] of int32;
asterisk_locations: array[1..1000, 1..2] of int32;

function is_symbol(str: string; ind: int32): boolean;
begin
    is_symbol := (str[ind] = '*')
end;

function find_asterisk(hpos: int32; vpos: int32): int32;
var
    j: int32;

begin

    find_asterisk := -1;

    for j := 1 to asterisks do 
    begin
        if ((asterisk_locations[j, 1] = hpos) and (asterisk_locations[j, 2] = vpos)) then
        begin
            find_asterisk := j;
            break;
        end;
    end;
end;

function get_asterisk_id(hpos: int32; vpos: int32): int32;
var
    fucked_up: int32;

begin

    get_asterisk_id := -1;

    fucked_up := find_asterisk(hpos-1, vpos-1);
    if (fucked_up <> -1) then
        get_asterisk_id := fucked_up;
    fucked_up := find_asterisk(hpos, vpos-1);
    if (fucked_up <> -1) then
        get_asterisk_id := fucked_up;
    fucked_up := find_asterisk(hpos+1, vpos-1);
    if (fucked_up <> -1) then
        get_asterisk_id := fucked_up;
    fucked_up := find_asterisk(hpos-1, vpos);
    if (fucked_up <> -1) then
        get_asterisk_id := fucked_up;
    fucked_up := find_asterisk(hpos+1, vpos);
    if (fucked_up <> -1) then
        get_asterisk_id := fucked_up;
    fucked_up := find_asterisk(hpos-1, vpos+1);
    if (fucked_up <> -1) then
        get_asterisk_id := fucked_up;
    fucked_up := find_asterisk(hpos, vpos+1);
    if (fucked_up <> -1) then
        get_asterisk_id := fucked_up;
    fucked_up := find_asterisk(hpos+1, vpos+1);
    if (fucked_up <> -1) then
        get_asterisk_id := fucked_up;

end;

(* Here the main program block starts *)
begin
    { open inp.txt for reading }
    assign(file_, 'resources/2023/day3.txt');
    reset(file_);

    { initialize sum and count to 0 }
    sum := 0;

    { read the first two lines }

    line := 1;
    asterisks := 0;


    {find the position of all asterisks}

    while not eof(file_) do
    begin

        readln(file_, curr);
    
        for i := 1 to LINE_LENGTH do
        begin
            if is_symbol(curr, i) then
            begin
                asterisk_locations[asterisks + 1][1] := i;
                asterisk_locations[asterisks + 1][2] := line;

                asterisk_values[asterisks + 1] := 0;

                asterisks := asterisks + 1;
            end;
        end;

        line := line + 1;

    end;

    line := 0;

    reset(file_);

    writeln('boobs');

    { main loop }
    while not eof(file_) do 
    begin

        state := 0;
        line := line + 1;

        readln(file_, curr);

        for i := 1 to LINE_LENGTH do
        begin
            c := curr[i];
            write(c);
            case state of
                    {waiting for number}
                    0:
                    begin
                        {number}
                        if (('0' <= c) and (c <= '9')) then
                        begin
                            {add number to number}
                            val(c, number);
                            state := 1;

                            curr_asterisk := get_asterisk_id(i, line);

                        end;
                    end;
                    {reading number and checking true}
                    1:
                    begin
                        if (('0' <= c) and (c <= '9')) then
                        begin

                            writeln('boobs2');

                            {add number to number}
                            val(c, b);
                            number := number * 10 + b;

                            {look for symbol}
                            b := get_asterisk_id(i, line);
                            if (b <> -1) then
                                curr_asterisk := b;

                        end
                        else 
                        begin
                            state := 0;
                            writeln(curr_asterisk);

                            if (curr_asterisk <> -1) then
                            begin
                                if (asterisk_values[curr_asterisk] = 0) then
                                    asterisk_values[curr_asterisk] := number
                                else if (asterisk_values[curr_asterisk] > 0) then
                                begin
                                    sum := sum + asterisk_values[curr_asterisk] * number;
                                    asterisk_values[curr_asterisk] := -1;
                                end;
                            end;

                        end;
                            
                    end;
            end;

            write(state);

        end;

        if (state = 1) then
        begin
            begin

                if (curr_asterisk <> -1) then
                begin
                    if (asterisk_values[curr_asterisk] = 0) then
                        asterisk_values[curr_asterisk] := number
                    else if (asterisk_values[curr_asterisk] > 0) then
                    begin
                        sum := sum + asterisk_values[curr_asterisk] * number;
                        asterisk_values[curr_asterisk] := -1;
                    end;
                end;

            end;
        end;

    end;

    i := get_asterisk_id(114, 126);
    writeln(i);
    writeln(asterisk_locations[i, 1]);
    writeln(asterisk_locations[i, 2]);
    writeln(sum);


end.
