
{$include bigint.pas}

type
    fraction = record
        numerator: int512;
        denominator: int512;
    end;

const
    { i don't think there's a better way of doing this unfortunately }
    SIMPLIFY_CUTOFF: int512 = (
        values: ($00000000FFFFFFFF, $00000000FFFFFFFF, $00000000FFFFFFFF, $00000000FFFFFFFF, $00000000FFFFFFFF, $00000000FFFFFFFF, $00000000FFFFFFFF, $0000000000000000,
                 $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000);
    );

procedure print_fraction(a: fraction);
begin
    if a.denominator <> 1 then
    begin
        print512d(a.numerator);
        write('/');
        print512d(a.denominator);
    end
    else
        print512d(a.numerator);
end;

function c_fraction(num: int512; den: int512): fraction;
begin
    if den = 0 then
        writeln('holy hell what are you doing');

    c_fraction.numerator := num;
    c_fraction.denominator := den;

end;

operator := (f: int64) out_ : fraction;
begin
    out_ := c_fraction(f, 1);
end;


function gcd(a, b: int512): int512;
var
    r: int512;
begin

    while true do
    begin

        r := a mod b;

        if r = 0 then
            break;

        a := b;
        b := r;
        
    end;

    gcd := b;
end;

function simplify(f: fraction): fraction;
var
    b: int512;
    neg: boolean;

begin

    neg := false;
    if isneg(f.numerator) then
    begin
        neg := not neg;
        f.numerator := -f.numerator;
    end;

    if isneg(f.denominator) then
    begin
        neg := not neg;
        f.denominator := -f.denominator;
    end;

    b := gcd(f.numerator, f.denominator);
    
    if b <> 0 then
        simplify := c_fraction(f.numerator div b, f.denominator div b)
    else
        simplify := f;

    if neg then
        simplify.numerator := -simplify.numerator;

end;

{ add fractions }
operator + (a, b: fraction) out_: fraction;
//var
    // g: int512;
begin

    // print_fraction(a);
    // write(' ');
    // print_fraction(b);
    // write(' ');

    // g := gcd(a.denominator, b.denominator);

    out_.denominator := a.denominator * b.denominator;
    out_.numerator := a.denominator * b.numerator + b.denominator * a.numerator;

    // print_fraction(out_);
    // write(' ');
    if abs(out_.numerator) > SIMPLIFY_CUTOFF then
        out_ := simplify(out_);
    // print_fraction(out_);
    // writeln('ya');
end;

{ mult fractions }
operator * (a, b: fraction) out_: fraction;
begin
    out_.denominator := a.denominator * b.denominator;
    out_.numerator := a.numerator * b.numerator;
    
    if abs(out_.numerator) > SIMPLIFY_CUTOFF then
        out_ := simplify(out_);

end;