program day4part1;
uses sysutils;

type
    MState = (ToColon, WasteSpace, ReadWin, WasteSpace2, ReadHave);

var
    state: MState;
    file_: text;
    str: string;
    number: int32;

    winning: array[1..100] of int32;
    have: array[1..100] of int32;

    winning_length, have_length: int32;

    b, d: int32;
    c: char;
    i, j: int32;

    scores: array[0..10] of int32 = (0, 1, 2, 4, 8, 16, 32, 64, 128, 256, 512);

    sum: int32;

begin
    { open inp.txt for reading }
    assign(file_, 'resources/2023/day4.txt');
    reset(file_);

    sum := 0;
    
    while not EOF(file_) do
    begin

        { state of current searching }
        state := ToColon;

        { read in a file}
        readln(file_, str);

        fillchar(have[1], sizeof(have), 0);
        fillchar(winning[1], sizeof(winning), 0);

        for c in str do
        begin

            { holy case statement. }
            case state of
                ToColon:
                    begin
                        if (c = ':') then
                            state := WasteSpace
                    end;

                WasteSpace:
                    begin
                        state := ReadWin;
                        number := 0;
                        winning_length := 1;
                    end;
                ReadWin:
                    begin
                        if (('0' <= c) and (c <= '9')) then
                        begin
                            {add number to number}
                            val(c, b);
                            number := number * 10 + b;
                        end
                        else if (c = ' ')  then
                        begin
                            winning[winning_length] := number;
                            winning_length := winning_length + 1;
                            number := 0;
                        end
                        else if (c = '|') then
                        begin
                            state := WasteSpace2;
                            number := 0;
                        end;
                    end;
                WasteSpace2:
                    begin
                        state := ReadHave;
                        number := 0;
                        have_length := 1;
                    end;
                ReadHave:
                    begin
                        if (('0' <= c) and (c <= '9')) then
                        begin
                            {add number to number}
                            val(c, b);
                            number := number * 10 + b;
                        end
                        else if (c = ' ') then
                        begin
                            have[have_length] := number;
                            have_length := have_length + 1;
                            number := 0;
                        end
                        else if (c = '|') then
                        begin
                            state := WasteSpace2;
                            number := 0;
                        end;
                    end;
            end;
        end;

        have[have_length] := number;
        have_length := have_length + 1;

        d := 0;
        for i in winning do
        begin
            if (i = 0) then
            begin
                continue;
            end;
            
            
            for j in have do
            begin
                if (j = 0) then
                begin
                    continue;
                end;

                if (i = j) then
                    d := d + 1
            end;
        end;

        sum := sum + scores[d];

    end; 

    writeln(sum);

end.
