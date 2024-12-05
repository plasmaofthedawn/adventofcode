program day8part1;
uses sysutils;

type
    MState = (ReadCards, ReadBet);

var
    file_: text;

    instructions: AnsiString;
    str: string;

    count: int32;

    steps: int32;
    step: char;

    i: int32;

    { node, left, right }
    nodes: array[0..1000, 0..2] of string;

begin
     { open inp.txt for reading }
    assign(file_, 'resources/2023/day8.txt');
    reset(file_);

    { read instructions }
    readln(file_, instructions);

    { read empty line }
    readln(file_, str);

    count := 0;

    { read nodes }
    while not EOF(file_) do
    begin

        readln(file_, str);

        { start }
        nodes[count, 0] := copy(str, 1,  3);
        { left }
        nodes[count, 1] := copy(str, 8,  3);
        { right }
        nodes[count, 2] := copy(str, 13, 3);

        count := count + 1;

    end;

    { start at AAA }
    steps := 0;
    str := 'AAA';

    { until we reach the end }
    while CompareText(str, 'ZZZ') <> 0 do
    begin

        { get step }
        step := instructions[(steps mod length(instructions)) + 1];
        steps := steps + 1;

        { find node }
        for i := 0 to count do
        begin
            if CompareText(nodes[i, 0], str) = 0 then
                break
        end;

        { go to next node}
        case step of
            'L': str := nodes[i, 1];
            'R': str := nodes[i, 2];
        end;

    end;

    writeln(steps);
end.

