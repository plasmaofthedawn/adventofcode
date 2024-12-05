program day3part1;
uses sysutils;

var
file_: text;
prev, curr, next: string;
sum, game: int32;
state: int32;
number: int32;
valid: boolean;

i, b: int32;
c: char;

LINE_LENGTH: int32 = 140;

function is_symbol(str: string; ind: int32): boolean;
begin
    is_symbol := ((not ((ind < 1) or (ind > LINE_LENGTH))) and (('0' > str[ind]) or (str[ind] > '9')) and (str[ind] <> '.'));
end;

function is_ok(prev: string; curr: string; next: string; ind: int32): boolean;
begin
    is_ok := is_symbol(curr, i-1);
    is_ok := (is_ok or is_symbol(curr, i+1));
    is_ok := (is_ok or is_symbol(next, i-1));
    is_ok := (is_ok or is_symbol(next, i));
    is_ok := (is_ok or is_symbol(next, i+1));
    is_ok := (is_ok or is_symbol(prev, i-1));
    is_ok := (is_ok or is_symbol(prev, i));
    is_ok := (is_ok or is_symbol(prev, i+1));
end;


(* Here the main program block starts *)
begin
    { open inp.txt for reading }
    assign(file_, 'resources/2023/day3.txt');
    reset(file_);

    { initialize sum and count to 0 }
    sum := 0;

    { read the first two lines }
    readln(file_, curr);
    readln(file_, next);

    writeln(length(curr));

    writeln(booltostr(true));
    writeln(booltostr(false));

    { writeln(curr); }
    { writeln(next); }

    state := 0;
    number := 0;
    { 0 : waiting for number }
    { 1 : reading number }

    { first loop }
    for i := 1 to LINE_LENGTH do
    begin
        c := curr[i];
        case state of
                {waiting for number}
                0:
                begin
                    {number}
                    if (('0' <= c) and (c <= '9')) then
                    begin
                        {add number to number}
                        val(c, number);
                        valid := false;
                        state := 1;

                        valid := (valid or is_ok(next, curr, next, i-1));

                    end;
                end;
                {reading number and checking true}
                1:
                begin
                    if (('0' <= c) and (c <= '9')) then
                    begin
                        {add number to number}
                        val(c, b);
                        number := number * 10 + b;

                        {look for symbol}

                        valid := (valid or is_ok(next, curr, next, i-1));

                    end
                    else 
                    begin
                        state := 0;

                        if (valid) then
                            sum := sum + number;

                    end;
                        
                end;
        end;
    end;

    { main loop }
    while not eof(file_) do 
    begin

        state := 0;

        prev := curr;
        curr := next;
        readln(file_, next);

        writeln();
        writeln(prev);
        writeln(curr);
        writeln(next);

        for i := 1 to LINE_LENGTH do
        begin
            c := curr[i];
            case state of
                    {waiting for number}
                    0:
                    begin
                        {number}
                        if (('0' <= c) and (c <= '9')) then
                        begin
                            {add number to number}
                            val(c, number);
                            valid := false;
                            state := 1;

                            valid := (valid or is_ok(prev, curr, next, i-1));

                        end;
                    end;
                    {reading number and checking true}
                    1:
                    begin
                        if (('0' <= c) and (c <= '9')) then
                        begin
                            {add number to number}
                            val(c, b);
                            number := number * 10 + b;

                            {look for symbol}

                            valid := (valid or is_ok(prev, curr, next, i-1));

                        end
                        else 
                        begin
                            state := 0;

                            if (valid) then
                                sum := sum + number;

                        end;
                            
                    end;
            end;

            write(state);

        end;

        if (state = 1) then
        begin
            begin

                if (valid) then
                    sum := sum + number;

            end;
        end;

    end;

    state := 0;

    prev := curr;
    curr := next;
    

    for i := 1 to LINE_LENGTH do
    begin
        c := curr[i];
        case state of
                {waiting for number}
                0:
                begin
                    {number}
                    if (('0' <= c) and (c <= '9')) then
                    begin
                        {add number to number}
                        val(c, number);
                        valid := false;
                        state := 1;

                        valid := (valid or is_ok(prev, curr, prev, i-1));

                    end;
                end;
                {reading number and checking true}
                1:
                begin
                    if (('0' <= c) and (c <= '9')) then
                    begin
                        {add number to number}
                        val(c, b);
                        number := number * 10 + b;

                        {look for symbol}

                        valid := (valid or is_ok(prev, curr, prev, i-1));

                    end
                    else 
                    begin
                        state := 0;

                        if (valid) then
                            sum := sum + number;

                    end;
                        
                end;
        end;
    end;

    writeln();
    writeln(sum);
end.
