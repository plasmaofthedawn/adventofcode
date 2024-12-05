{$mode objfpc}
{$RANGECHECKS ON}

program day14part1;
uses sysutils;

var

    file_: text;
    s: string;

    map: array[1..1000] of string;
    
    current_boulders: int32;
    height, width: int32;
    i, j, k: int32;

    sum: int32;

begin

    assign(file_, 'resources/2023/day14.txt');
    reset(file_);

    height := 1;
    fillchar(map[1], 255, '#');

    while not eof(file_) do
    begin
        height := height + 1;
        readln(file_, map[height]);
    end;

    width := length(map[2]);

    sum := 0;

    for i := 1 to width do
    begin

        current_boulders := 0;

        for j := 1 to height do
        begin
            case map[height - j + 1][i] of
                'O': current_boulders := current_boulders + 1;
                '#':
                begin
                    for k := j - current_boulders to j - 1 do
                    begin
                        sum := sum + k;
                    end;
                    current_boulders := 0;
                end;
            end;
        end;
    end;

    writeln('sum: ', sum);

end.
