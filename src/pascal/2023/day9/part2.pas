program day9part1;
{$INCLUDE 'polynomial.pas'}

function lagrange(x, y: array of int64; l: int64 = 0): polynomial;
var
    
    new: polynomial;
    idx: int64;
    i: int64;

begin
    lagrange := constant(c_fraction(0, 1));

    if l = 0 then
    begin
        case length(x) > length(y) of 
            true: l := length(y);
            false: l := length(x);
        end;
    end;

    for idx := 0 to l - 1 do
    begin

        new := constant(c_fraction((y[idx]), 1));

        for i := 0 to l - 1 do
        begin
            if i = idx then
                continue;

            new := new * binomial(c_fraction(1, 1), c_fraction(- x[i], 1));

            new := new * constant(c_fraction(1, (x[idx] - x[i])));

        end;

        lagrange := lagrange + new;

    end;
            
end;


var

    { couldn't have done that with a for loop }
    x: array[0..100] of int64 = (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100);
    y: array[0..100] of int64;

    file_: text;
    str: string;
    negative, number: int64;

    c: char;

    count, b: int64;

    sum: fraction;
    p: polynomial;
    f: fraction;

begin

    assign(file_, 'resources/2023/day9.txt');
    reset(file_);

    sum := c_fraction(0, 1);

    while not EOF(file_) do
    begin

        readln(file_, str);
        count := 0;
        number := 0;
        negative := 1;

        for c in str do
        begin
            if c = '-' then
                negative := -1
            else if (('0' <= c) and (c <= '9')) then
            begin
                //add number to number
                val(c, b);
                number := number * 10 + b;
            end
            else
            begin
                y[count] := number * negative;
                count := count + 1;
                number := 0;
                negative := 1;
            end;
        end;

        y[count] := number * negative;

        p := simplify_poly(lagrange(x, y, count + 1));

        print_polynomial(p);
        write(' at ');
        write(-1);
        write(' is ');

        f := simplify(eval_polynomial(p, -1));

        print_fraction(f);

        sum := sum + f;

        writeln();

    end;

    write('The final sum is: ');

    print_fraction(sum);

end.
