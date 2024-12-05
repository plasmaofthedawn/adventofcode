program day5part1;
uses sysutils;

type
    SState = (ToColon, WasteSpace, ReadSeeds, NewLine);
    MState = (Seed, WaitMap, ReadMap, Q);


var

    seeds: array[1..100000] of int64;
    next_seeds: array[1..100000] of int64;
    map: array[1..3] of int64;
    
    seed_length: int64;
    cmap: int64;

    seed_state: SState;
    state: MState;
    file_: text;
    str: string;
    number: int64;

    c: char;
    i, b: int64;

    srange, erange: int64;
    sseed, eseed: int64;

    times: int64;

procedure add_seed(a: int64; b: int64);
begin
    seeds[seed_length + 1] := a;
    seeds[seed_length + 2] := b - a + 1;
    seed_length := seed_length + 2;
end;

begin
    { open inp.txt for reading }
    assign(file_, 'resources/2023/day5.txt');
    reset(file_);

    times := 0;
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
                    for i := 1 to seed_length do
                    begin
                        write(seeds[i]);
                        write(' ');
                    end;

                    writeln();
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

                    write('here we go: ');
                    writeln(times);

                    for i := 1 to length(seeds) do
                    begin
                        if ((i and 1) = 0) then
                            continue;
                        if (seeds[i + 1] = 0) then
                            continue;
                        if (i >= seed_length) then
                            break;
                        writeln(i);

                        sseed := seeds[i];
                        eseed := seeds[i] + seeds[i + 1] - 1;

                        write(sseed);
                        write(' ');
                        writeln(eseed);

                        srange := map[2];
                        erange := map[2] + map[3] - 1;

                        write(srange);
                        write(' ');
                        writeln(erange);

                        { range contained }
                        if ((eseed > erange) and (sseed < srange)) then
                        begin
                            writeln('range contained');
                            { add the right tail }
                            add_seed(erange + 1, eseed);
                            { add the left tail }
                            add_seed(sseed, srange - 1);

                            next_seeds[i + 1] := erange - srange;
                            next_seeds[i] := map[1];
                            seeds[i + 1] := 0;

                        end 
                        { left tailed }
                        else if ((eseed > erange) and (erange >= sseed)) then
                        begin
                            writeln('left');
                            { add the right tail}
                            add_seed(erange + 1, eseed);
                            { update length }
                            next_seeds[i + 1] := erange - sseed + 1;
                            { adjust according to map }
                            next_seeds[i] := map[1] + sseed - srange;
                            seeds[i + 1] := 0;

                        end
                        { right tailed }
                        else if ((eseed >= srange) and (srange > sseed))  then
                        begin
                            writeln('right');
                            { add the left tail}
                            add_seed(sseed, srange - 1);
                            { update length }
                            next_seeds[i + 1] := eseed - srange + 1;
                            { adjust according to map }
                            next_seeds[i] := map[1];
                            seeds[i + 1] := 0;
                        end
                        else if ((srange <= sseed) and (eseed <= erange)) then
                        begin
                            writeln('easy mode');
                            next_seeds[i] := map[1] + sseed - srange;
                        end
                        else
                        begin
                             writeln('GOD FUCKING DAMMIT');
                        end;
                
                    end;

                    writeln();
                    for i := 1 to seed_length do
                    begin
                        write(next_seeds[i]);
                        write(' ');
                    end;
                    writeln();
                    for i := 1 to seed_length do
                    begin
                        write(seeds[i]);
                        write(' ');
                    end;
                    writeln();
                    writeln(seed_length);

                    writeln('next');

                    times := times + 1;
                    { if (times = 6) then
                        break;}
                end;

        end;
    end;

    writeln();

    for i := 0 to length(seeds) do
    begin
        if (next_seeds[i] <> -1) then
            seeds[i] := next_seeds[i]
    end;

    for i := 1 to seed_length do
    begin;
        if ((i and 1) = 0) then
            continue;
        writeln(seeds[i]);
    end;

end.
