{$mode objfpc}
{$RANGECHECKS ON}

program day16part1;
uses sysutils;

type
    Tdirection = (Left, Up, Right, Down, NA);

var 
    map: array[1..1000] of string;
    illuminated: array[1..1000, 1..1000] of boolean;
    splitted: array[1..1000, 1..1000] of boolean; 
    height, width: int32;

procedure print_illuminated();
var
    i, j: int32;
begin
    for i := 1 to height do
    begin
        for j := 1 to width do
            case illuminated[i, j] of
                true:  write('#');
                false: write('.');
            end;
        writeln();
    end;
end;

function sum_illuminated(): int32;
var
    i, j: int32;
begin

    sum_illuminated := 0;

    for i := 1 to height do
        for j := 1 to width do
            if illuminated[i, j] then
                sum_illuminated := sum_illuminated + 1;
end;

procedure step_illumination(x, y: int32; dir: Tdirection);
begin

    { range check }
    if (x < 1) or (x > width) or (y < 1) or (y > height) then
        exit;

    writeln('(', x, ',', y, ')');

    illuminated[y, x] := true;

    { nested case my beloved }
    case map[y, x] of
        '.': 
        begin
            { continue same direction }
            case dir of
                Up:    step_illumination(x, y - 1, Up);
                Left:  step_illumination(x - 1, y, Left);
                Down:  step_illumination(x, y + 1, Down);
                Right: step_illumination(x + 1, y, Right);
            end;
        end;
        '/':
        begin
            { reflect direction }
            case dir of
                Up:    step_illumination(x + 1, y, Right);
                Left:  step_illumination(x, y + 1, Down);
                Down:  step_illumination(x - 1, y, Left);
                Right: step_illumination(x, y - 1, Up);
            end;
        end;
        '\':
        begin
            { reflect direction but in the other way}
            case dir of
                Up:    step_illumination(x - 1, y, Left);
                Left:  step_illumination(x, y - 1, Up); 
                Down:  step_illumination(x + 1, y, Right);
                Right: step_illumination(x, y + 1, Down);
            end;
        end;
        '|':
        begin
            { up down passthrough, left right split }
            case dir of
                Up:    step_illumination(x, y - 1, Up);
                Down:  step_illumination(x, y + 1, Down);
                Left, Right:
                begin
                    if not splitted[y, x] then // so we don't split forever in a loop
                    begin
                        splitted[y, x] := true;
                        step_illumination(x, y - 1, Up);
                        step_illumination(x, y + 1, Down);
                    end;
                end;
            end;
        end;
        '-':
        begin
            { lr passthrough, ud split }
            case dir of
                Left:   step_illumination(x - 1, y, Left);
                Right:  step_illumination(x + 1, y, Right);
                Up, Down:
                begin
                    if not splitted[y, x] then // so we don't split forever in a loop
                    begin
                        splitted[y, x] := true;
                        step_illumination(x - 1, y, Left);
                        step_illumination(x + 1, y, Right);
                    end;
                end;
            end;
        end;
    end;
end;

var

    file_: text;

begin

    assign(file_, 'resources/2023/day16.txt');
    reset(file_);

    height := 0;

    while not eof(file_) do
    begin
        height := height + 1;
        readln(file_, map[height]);
    end;
    width := length(map[1]);

    step_illumination(1, 1, Right);
    print_illuminated();
    writeln('Total illuminated is ', sum_illuminated());

end.
