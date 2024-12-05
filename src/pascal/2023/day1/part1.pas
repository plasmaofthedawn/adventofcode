program day1part1;

var
file_: text;
start: string;
c: char;
first, last: char;
sum, value: int32;

(* Here the main program block starts *)
begin
    { open inp.txt for reading }
    assign(file_, 'resources/2023/day1.txt');
    reset(file_);

    { initialize sum to 0 }
    sum := 0;

    { until the file is empty }
    while not eof(file_) do
    begin

        { read a line from the file }
        readln(file_, start);

        { fill in placeholders }
        first := 'a';
        last := 'a';

        { for each characters }
        for c in start do
        begin
            { if it is a number }
            if (('0' <= c) and (c <= '9')) then
            begin
                { set last to that number }
                last := c;
                { if first hasn't been set, then set it as a number}
                if (first = 'a') then
                    first := c
            end;
        end;

        { calculate the actual value of the number and add it to the sum }
        val(concat(first, last), value);
        sum := sum + value;
        
    end;

    { print out that beautiful sum}
    writeln(sum);
    
end.
