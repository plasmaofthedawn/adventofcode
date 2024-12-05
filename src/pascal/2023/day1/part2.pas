program day2part2;
uses sysutils;

var
file_: text;
start: string;
c: char;
first, last: char;
value, sum: int32;
names: array [0..9] of string =  ('zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine');
numbers: array [0..9] of char = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9');
i, j: int32;
s: string;

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
        for i := 1 to length(start) do
        begin

            c := start[i];

            { check for text number }
            for j := 0 to 9 do
            begin
                { compare the substring with the name of a number }
                s := copy(start, i, length(names[j]));
                if (comparestr(s, names[j]) = 0) then
                begin
                    { if it matches then this is a number }
                    c := numbers[j];
                    break;
                end;
            end;
            
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
        val(first + last, value);
        sum := sum + value;

    end;

    { print out that beautiful sum }
    writeln(sum);

end.
