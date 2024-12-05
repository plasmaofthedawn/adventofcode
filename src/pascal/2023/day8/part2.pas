program day8part2;
uses sysutils;


var
    file_: text;

    instructions: AnsiString;
    str: string;

    count: int32;

    steps: int32;
    step: char;

    i, j: int32;

    { node, left, right }
    nodes: array[0..1000, 0..2] of string;

    prev_states: array[0..100000] of string;
    prev_ics: array[0..100000] of int32;
    prev_count: int32;

    b: array[0..1000] of int32;
    l: array[0..1000] of int32;
    a: array[0..1000, 0..1000] of int32;
    a_count: array[0..1000] of int32;

    current_nodes: array[0..1000] of string;
    current_nodes_count: int32;

    finished: boolean;

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

    current_nodes_count := 0;

    { find all nodes that end with A }
    for i := 0 to count - 1 do
    begin
        { if ends with A }
        if nodes[i, 0][3] = 'A' then
        begin
            { adds it to current nodes }
            current_nodes[current_nodes_count] := nodes[i, 0];
            current_nodes_count := current_nodes_count + 1;
        end;
    end; 



    { for each node }

    for j := 0 to current_nodes_count - 1 do
    begin

        steps := 0;
        prev_count := 0;
        finished := False;

        writeln(current_nodes[j]);

        while not finished do
        begin

            { add state }
            prev_states[prev_count] := current_nodes[j];
            prev_ics[prev_count] := (steps mod length(instructions)) + 1;

            { get step }
            step := instructions[(steps mod length(instructions)) + 1];
            steps := steps + 1;

            { find node }
            for i := 0 to count do
            begin
                if CompareText(nodes[i, 0], current_nodes[j]) = 0 then
                    break
            end;

            { go to next node }
            case step of
                'L': current_nodes[j] := nodes[i, 1];
                'R': current_nodes[j] := nodes[i, 2];
            end;

            { check if next node is in previous state }
            for i := 0 to prev_count do
            begin
                if (prev_states[i] = current_nodes[j]) and (prev_ics[i] = (steps mod length(instructions)) + 1) then
                begin
                    finished := true;
                    break;
                end;
            end;

            prev_count := prev_count + 1;

        end;

        { offset to start of loop }
        write('b = ');
        b[j] := i - 1;
        writeln(b[j]);

        { length of loop }
        write('l = ');
        l[j] := prev_count - i;
        writeln(l[j]);

        { find offsets to the loop where it's finished }
        a_count[j] := 0;

        for i := b[j] to prev_count - 1 do
        begin
        
            { i'm sure this will cause no problems }
            if i < 0 then
                continue;

            { if this is a finished state }
            if prev_states[i][3] = 'Z' then
            begin

                { add it to the a list }
                a[j, a_count[j]] := i - b[j];

                write('a_');
                write(a_count[j]);
                write(' = ');
                writeln(a[j, a_count[j]]);

                a_count[j] := a_count[j] + 1;

            end;
        end;

        // O( n * (l + b))
        // l is length of loop
        // b is length of leadup
        // n is number of nodes
        
        // O(a^n)
        // a is number of finished states

        {

            i might come back to this to actually do this i'm tired rn

        }

    end;

end.

