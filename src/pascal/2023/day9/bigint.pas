const
    UINT32MAX: uint64 = $00000000FFFFFFFF;
type
    int512 = record
        { 16 32 bit values in 64 bit ints }
        values: array[0..15] of int64;
    end;


operator := (n: int64) b: int512;
begin
    if n >= 0 then
        fillqword(b.values, 16, 0)
    else
        fillqword(b.values, 16, UINT32MAX);
    b.values[0] := n and UINT32MAX;
    b.values[1] := n shr 32;
end;

procedure print512(n: int512; printall: boolean = false);
var
    i: int32;
    started: boolean;
begin

    started := printall;

    for i := 0 to 15 do
    begin
        if (n.values[15 - i] <> 0) or started or (i = 15) then
        begin
            write(hexstr(n.values[15 - i], 8));
            if (i <> 15) then
                write(' ');
            started := true;
        end;
    end;
end;

procedure print512f(n: int512; printall: boolean = false);
var
    i: int32;
    started: boolean;
begin

    started := printall;

    for i := 0 to 15 do
    begin
        if (n.values[15 - i] <> 0) or started or (i = 15) then
        begin
            write(hexstr(n.values[15 - i], 16));
            if (i <> 15) then
                write(' ');
            started := true;
        end;
    end;
end;

function isneg(n: int512): boolean;
begin
    isneg := (n.values[15] and (1 shl 31)) <> 0
end;

function bigshiftleft(n: int512; b: int32): int512;
var
    i: int32;
begin

    bigshiftleft := 0;

    for i := 0 to 15 - b do
    begin
        bigshiftleft.values[i + b] := n.values[i];
    end;
end;

function bigshiftright(n: int512; b: int32): int512;
var
    i: int32;
begin

    bigshiftright := 0;

    for i := 0 to 15 - b do
    begin
        bigshiftright.values[i] := n.values[i + b];
    end;
end;

operator shl (a: int512; b: int32) o: int512;
var
    i: int32;
begin

    a := bigshiftleft(a, (b and (not 31)) shr 5);

    { handle first seperately }
    o.values[0] := (a.values[0] shl (b and 31)) and UINT32MAX;
    for i := 1 to 15 do
    begin
        o.values[i] := (((a.values[i - 1] shl (b and 31)) shr 32) or // leftover from behind cell          
                        ((a.values[i] shl (b and 31)))) and UINT32MAX;  // from this cell
    end;
end;

operator shr (a: int512; b: int32) o: int512;
var
    i: int32;
begin

    a := bigshiftright(a, (b and (not 31)) shr 5);

    {
        00001234 00005678 00001234
        12340000 56780000 12340000
        00000012 00003456 00007812

    }

    for i := 0 to 14 do
    begin
        o.values[i] := (((a.values[i + 1] shl (32 - (b and 31))) and UINT32MAX) or // from previous cell
                        (a.values[i] shr (b and 31))) // from this cell
    end;

    { handle last seperately }
    o.values[15] := a.values[15] shr (b and 31);
end;

operator + (a, b: int512) out_: int512;
var
    i: int32;
    t: int64;
    carry: int32;
begin

    carry := 0;

    for i := 0 to 15 do
    begin
        t := a.values[i] + b.values[i] + carry;
        carry := 0;

        if t > UINT32MAX then
        begin
            carry := t shr 32;
            t := t and UINT32MAX;
        end;

        out_.values[i] := t;

    end;

end;

operator - (a: int512) out_: int512;
var
    i: int32;
begin
    for i := 0 to 15 do
    begin
        a.values[i] := a.values[i] xor UINT32MAX;
    end;

    out_ := a + 1;
end;

operator - (a, b: int512) out_: int512;
begin
    out_ := a + (- b);
end;

operator > (a, b: int512) out_: boolean;
var
    i: int32;
begin

    out_ := false;

    for i := 0 to 15 do
    begin

        if (a.values[15 - i] > b.values[15 - i]) then
        begin
            out_ := true;
            break;
        end
        else if (a.values[15 - i] = b.values[15 - i]) then
            continue
        else
            break
    end;
end;

operator < (a, b: int512) out_: boolean;
var
    i: int32;
begin

    out_ := false;

    for i := 0 to 15 do
    begin

        if (a.values[15 - i] < b.values[15 - i]) then
        begin
            out_ := true;
            break;
        end
        else if (a.values[15 - i] = b.values[15 - i]) then
            continue
        else
            break
    end;
end;

operator >= (a, b: int512) out_: boolean;
begin
    out_ := not (a < b);
end;

operator <= (a, b: int512) out_: boolean;
begin
    out_ := not (a > b);
end;

operator = (a, b: int512) out_: boolean;
var
    i: int32;
begin

    out_ := true;

    for i := 0 to 15 do
    begin
        if (a.values[15 - i] = b.values[15 - i]) then
            continue
        else
        begin
            out_ := false;
            break;
        end;
    end;
end;

operator <> (a, b: int512) out_: boolean;
begin
    out_ := not (a = b);
end;

operator * (a, b: int512) out_: int512;
var

    i, j: int32;
    t: uint64;
    carry: int512;
    neg: boolean;

begin

    neg := false;
    if isneg(a) then
    begin
        neg := not neg;
        a := -a;
    end;

    if isneg(b) then
    begin
        neg := not neg;
        b := -b;
    end;

    carry := 0;
    out_ := 0;

    for i := 0 to 15 do
    begin
        for j := 0 to 15 do
        begin
            if (i + j > 15) then
                continue;
                    
            t := a.values[i] * b.values[j];

            if t > UINT32MAX then
            begin
                carry.values[i + j + 1] := carry.values[i + j + 1] + (t shr 32);
                t := t and UINT32MAX;
            end;

            out_.values[i + j] := out_.values[i + j] + t;
        end;
    end;

    out_ := carry + out_;

    if neg then
        out_ := -out_;

end;


operator mod (a, b: int512) out_: int512;
var

    i: int32;
    normalize_factor: int32;

begin

    { normalize divisor }

    { big normalize }
    for i := 0 to 15 do
    begin
        if b.values[15 - i] <> 0 then
        begin
            normalize_factor := i * 32;
            b := bigshiftleft(b, i);
            break;
        end;
    end;


    { small normalize }
    for i := 0 to 31 do
    begin
        if (b.values[15] and (1 shl (31 - i))) <> 0 then
        begin
            normalize_factor := normalize_factor + i;
            b := b shl i;
            break;
        end;
    end;

    {subtract}

    for i := 0 to (normalize_factor) do
    begin

        if a >= b then
        begin
            //print512f(a);
            //write('a ');
            //print512f(b);
            //write('b ');
            //writeln();
            a := a - b;
            // only necessary for true division
            // out_ := out_ + 1;
            // out_ := out_ shl 1;
        end;

        b := b shr 1;
    end;

    out_ := a;
end;

operator div (a, b: int512) out_: int512;
var

    i: int32;
    normalize_factor: int32;
    neg: boolean;

begin

    neg := false;
    if isneg(a) then
    begin
        neg := not neg;
        a := -a;
    end;

    if isneg(b) then
    begin
        neg := not neg;
        b := -b;
    end;

    { normalize divisor }

    { big normalize }
    for i := 0 to 15 do
    begin
        if b.values[15 - i] <> 0 then
        begin
            normalize_factor := i * 32;
            b := bigshiftleft(b, i);
            break;
        end;
    end;

    { small normalize }
    for i := 0 to 31 do
    begin
        if (b.values[15] and (1 shl (31 - i))) <> 0 then
        begin
            normalize_factor := normalize_factor + i;
            b := b shl i;
            break;
        end;
    end;

    {subtract}

    out_ := 0;

    for i := 0 to (normalize_factor) do
    begin

        out_ := out_ shl 1;

        if a >= b then
        begin

            {print512f(a);
            write('a ');
            print512f(b);
            write('b ');
            print512f(out_);
            write('o ');
            print512f(out_ shl 1);
            writeln('o ');}

            a := a - b;

            out_ := out_ + 1;
        end;

        b := b shr 1;
    end;

    if neg then
        out_ := -out_;

end;

procedure print512d(n: int512);
var
    c: array[0..1000] of char;
    count: int32;
    q: int32;
begin

    if isneg(n) then
    begin
        write('-');
        n := -n;
    end;

    if n = 0 then
        write('0')
    else
    begin
        count := 0;
        while n <> 0 do
        begin
            c[count] := chr(byte((n mod 10).values[0]) + 48);
            n := n div 10;
            count := count + 1;
        end;

        for q := 1 to count do
        begin
            write(c[count - q]);
        end;
    end;
end;

function abs(n: int512): int512;
begin
    abs := n;
    if isneg(n) then
        abs := -n;
end;

function power(n: int512; m: int32): int512;
var
    i: int32;
begin
    power := 1;
    for i := 1 to m do
    begin
        power := power * n;
    end;
end;



// testing
{

var
    a, b, c: int512;
begin
    b := $1111;
    a := $FFFFFFFFFFFFFFFF;
    c := $3000000000000003;

    a := a shl 72 + 1;

    print512(a);
    writeln();
    print512(b);
    writeln();
    print512(a div b);
    // 0f000f00 0f000f00 00000000 00000000
end.

}