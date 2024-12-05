program day5part1;
uses sysutils;

type
    SState = (ToColon, WasteSpace, ReadSeeds, NewLine);
    MState = (Seed, WaitMap, ReadMap);


var

    seeds: array[1..20] of int64;
    next_seeds: array[1..20] of int64;
    map: array[1..3] of int64;
    
    seed_length: int64;
    cmap: int64;

    seed_state: SState;
    state: MState;
    file_: text;
    str: string;
    number: int64;

    c: char;
    i, j, b: int64;

    srange, erange: int64;

begin
    { open inp.txt for reading }
    assign(file_, 'resources/2023/day5.txt');
    reset(file_);

    state := Seed;

    while not EOF(file_) do
    begin

        { read in a file}
        readln(file_, str);

        case state of 
            Seed:
                begin
                    seed_state := ToColon;
                    for c in str do
                    begin
                        case seed_state of
                            ToColon:
                                begin
                                    if (c = ':') then
                                        seed_state := WasteSpace
                                end;
                            WasteSpace:
                                begin
                                    seed_state := ReadSeeds;
                                    number := 0;
                                    seed_length := 0;
                                end;
                            ReadSeeds:
                                begin
                                    if (('0' <= c) and (c <= '9')) then
                                    begin
                                        {add number to number}
                                        val(c, b);
                                        number := number * 10 + b;
                                    end
                                    else if (c = ' ')  then
                                    begin
                                        seed_length := seed_length + 1;
                                        seeds[seed_length] := number;
                                        number := 0;
                                    end
                                end;
                        end;
                    end;

                    seed_length := seed_length + 1;
                    seeds[seed_length] := number;
                    
                    fillqword(next_seeds, length(next_seeds), 18446744073709551615);
                    state := WaitMap;
                end;
            WaitMap:
                if (length(str) > 0) then
                begin
                    state := ReadMap;

                    { change this later because this is wrong }

                    for i := 0 to length(seeds) do
                    begin
                        if (next_seeds[i] <> -1) then
                            seeds[i] := next_seeds[i]
                    end;

                    { this is -1 }
                    fillqword(next_seeds, length(next_seeds), 18446744073709551615);

                    writeln('break');
                end;
            ReadMap:
                begin

                    if (length(str) = 0) then
                    begin
                        state := WaitMap;
                        continue;
                    end;

                    cmap := 0;
                    number := 0;

                    for c in str do
                    begin
                        if (('0' <= c) and (c <= '9')) then
                        begin
                            {add number to number}
                            val(c, b);
                            number := number * 10 + b;
                        end
                        else if (c = ' ')  then
                        begin
                            cmap := cmap + 1;
                            map[cmap] := number;
                            number := 0;
                        end;
                    end;

                    cmap := cmap + 1;
                    map[cmap] := number;

                    srange := map[2];
                    erange := map[2] + map[3] - 1;

                    for i := 1 to length(seeds) do
                    begin
                        if ((seeds[i] >= srange) and (seeds[i] <= erange)) then
                        begin
                            next_seeds[i] := seeds[i] - srange + map[1];
                        end;
                    end;

                    writeln();
                    for i in next_seeds do
                        writeln(i);
                end;

        end;
    end;

    writeln();

    for i := 0 to length(seeds) do
    begin
        if (next_seeds[i] <> -1) then
            seeds[i] := next_seeds[i]
    end;

    for i in seeds do
        writeln(i);

end.
