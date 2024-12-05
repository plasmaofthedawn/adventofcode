program day2part2;

var
file_: text;
str: string;
sum: int32;
state: int32;
number: int32;

i: int32;
c: char;

rcount, gcount, bcount: int32;

(* Here the main program block starts *)
begin
    { open inp.txt for reading }
    assign(file_, 'resources/2023/day2.txt');
    reset(file_);

    { initialize sum to 0 }
    sum := 0;

    { until the file is empty }
    while not eof(file_) do
    begin


        { read a line from the file }
        readln(file_, str);

        { state of current searching }
        state := 0;
        { 0 = initial, going to colon -> 1}
        { 1 = wasting a space, resetting number -> 2}
        { 2 = searching for number -> 3}
        { 3 = checking color -> 4 }
        { 4 = waiting for space -> 2}

        { initialize counts to zero }
        rcount := 0;
        bcount := 0;
        gcount := 0;


        for c in str do
        begin

            { holy case statement. }

            case state of
                {seeking to first colon}
                0:
                begin
                    {colon, move to state 1}
                    if (c = ':') then
                        state := 1
                end;
                {wasting a space}
                1:
                begin
                    {move to state 2, initialize number}
                    state := 2;              
                    number := 0;      
                end;
                {reading number}
                2: 
                begin
                    {if number}
                    if (('0' <= c) and (c <= '9')) then
                    begin
                        {add number to number}
                        val(c, i);
                        number := number * 10 + i;
                    end;
                    {at the end move to state 3}
                    if (c = ' ') then
                        state := 3
                end;
                {update color}
                3:
                begin
                    {check red}
                    if (c = 'r') then
                    begin
                        {update red if it's max}
                        if (number > rcount) then 
                            rcount := number
                    end;

                    {check blue}
                    if (c = 'b') then
                    begin
                        {update blue if it's max}
                        if (number > bcount) then 
                            bcount := number
                    end;

                    {check green}
                    if (c = 'g') then
                    begin
                        {update green if it's max}
                        if (number > gcount) then 
                            gcount := number
                    end;

                    {if we're still here, move to state 4}
                    state := 4;
                end;
                {wait for a space}
                4:
                begin
                    if (c = ' ') then
                    begin
                        {reset number and go back to state 2}
                        number := 0;
                        state := 2;
                    end;
                end;
            end;
        end;

        { increase sum }
        sum := sum + rcount * bcount * gcount;

    end;

    { print out that beautiful sum }
    writeln(sum);
end.
