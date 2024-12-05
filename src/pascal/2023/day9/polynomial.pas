{$mode objfpc}

uses sysutils, math;

{$include fraction.pas}

const
    MAX_POLYNOMIAL_LENGTH = 100;

type
    polynomial = record
        degree: int64;
        { coefficients will be stored in reverse. ofc}
        coefficients: array[0..MAX_POLYNOMIAL_LENGTH] of fraction;
    end;


procedure fill_array_1(var a: array of fraction; l: int64 = MAX_POLYNOMIAL_LENGTH);
var
    i: int64;
begin

    for i := 0 to l do
        a[i] := c_fraction(0, 1);
    
end;

{ add polynomials }
operator + (a, b: polynomial) add_polynomial: polynomial;
var

    new_degree: int64;
    max_degree: int64;
    i: int64;

begin
    
    case a.degree > b.degree of 
        true: max_degree := a.degree;
        false: max_degree := b.degree;
    end;

    fill_array_1(add_polynomial.coefficients);

    for i := 0 to max_degree do
    begin
        add_polynomial.coefficients[i] := a.coefficients[i] + b.coefficients[i];

        if add_polynomial.coefficients[i].numerator <> 0 then
            new_degree := i
    end;
    
    add_polynomial.degree := new_degree;
end;

{ mult polynomials }
operator * (a, b: polynomial) out_: polynomial;
var 

    i, j: int64;
    new_degree: int32;

begin

    out_.degree := a.degree + b.degree;

    fill_array_1(out_.coefficients);

    for i := 0 to a.degree do
    begin
        for j := 0 to b.degree do
        begin

            out_.coefficients[i + j] := out_.coefficients[i + j] + a.coefficients[i] * b.coefficients[j];

        end;
    end;

    for i := 0 to out_.degree do
    begin

        if out_.coefficients[i].numerator <> 0 then
            new_degree := i
    end;
    
    out_.degree := new_degree;

end;

function constant(c: fraction): polynomial;
begin
    fill_array_1(constant.coefficients);
    constant.coefficients[0] := c;
    constant.degree := 0;
end;

function binomial(m, b: fraction): polynomial;
begin
    fill_array_1(binomial.coefficients);
    binomial.coefficients[0] := b;
    binomial.coefficients[1] := m;
    binomial.degree := 1;
end;


function eval_polynomial(a: polynomial; b: int512): fraction;
var
    i: int64;
begin

    eval_polynomial := c_fraction(0, 1);

    for i := 0 to a.degree do
    begin
        eval_polynomial := eval_polynomial + a.coefficients[i] * c_fraction(power(b, i), 1);
    end;
end;

procedure print_polynomial(a: polynomial);
var

    i: int64;

begin

    for i := 0 to a.degree do
    begin
        if (a.coefficients[a.degree - i].numerator <> 0) or (a.degree = 0) then
        begin
            if i <> 0 then
            begin
                if isneg(a.coefficients[a.degree - i].numerator) then
                begin
                    a.coefficients[a.degree - i].numerator := -a.coefficients[a.degree - i].numerator;
                    write(' - ');
                end
                else
                    write(' + ');
                end;

            { yeah. need an equality for fraction. }
            if (a.coefficients[a.degree - i].numerator <> 1) and (a.coefficients[a.degree - i].denominator <> 1) or (i = a.degree) then
                print_fraction(a.coefficients[a.degree - i]);

            if i = a.degree - 1 then
                write('x')
            else if i < a.degree - 1 then
            begin
                write('x^');
                write(a.degree - i);
            end;
        end;
    end;

    write(' (');
    write(a.degree);
    write(')');

end;

function simplify_poly(a: polynomial): polynomial;
var 
    i: int32;
begin
    for i := 0 to a.degree do
    begin
        simplify_poly.coefficients[i] := simplify(a.coefficients[i]);
    end;
    simplify_poly.degree := a.degree;
end;
