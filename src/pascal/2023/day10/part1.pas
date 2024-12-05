program day10part1;
uses sysutils;

type
    direction = (Left, Up, Right, Down, NA);


function step_path(var curr: array of int32; last_direction: direction; c: char): direction;
begin

    // step_path := curr;

    step_path := NA;

    case last_direction of
        Left:
            begin
                case c of
                    '-': step_path := Left;
                    'L': step_path := Up;
                    'F': step_path := Down;
                end;
            end;
        Up:
            begin
                case c of
                    '|': step_path := Up;
                    '7': step_path := Left;
                    'F': step_path := Right;
                end;
            end;
        Right:
            begin
                case c of
                    '-': step_path := Right;
                    '7': step_path := Down;
                    'J': step_path := Up;
                end;
            end;
        Down:
            begin
                case c of
                    '|': step_path := Down;
                    'J': step_path := Left;
                    'L': step_path := Right;
                end;
            end;
    end;

    case step_path of
        Up:    curr[0] := curr[0] - 1;
        Down:  curr[0] := curr[0] + 1;
        Left:  curr[1] := curr[1] - 1;
        Right: curr[1] := curr[1] + 1;
    end;

    if (last_direction = NA) then
        writeln('bruh');

end;

var
    file_: text;

    map: array[1..1000] of string;
    str: string;

    count: int32;

    steps: int32;
    step: char;

    s_loc, loc: array[0..1] of int32;
    ld: direction;

    i: int32;

    { node, left, right }
    nodes: array[0..1000, 0..2] of string;

begin
     { open inp.txt for reading }
    assign(file_, 'resources/2023/day10.txt');
    reset(file_);

    count := 1;
    while not EOF(file_) do
    begin

        readln(file_, map[count]);

        i := pos('S', map[count]);
        
        if i <> 0 then
        begin
            s_loc[0] := count;
            s_loc[1] := i;
        end;

        count := count + 1;

    end;

    loc := s_loc;
    count := 0;

    { get possible initial directions }
    if (map[s_loc[0], s_loc[1] - 1] = '-') or (map[s_loc[0], s_loc[1] - 1] = 'F') or (map[s_loc[0], s_loc[1] - 1] = 'L') then
    begin
        loc[1] := loc[1] - 1;
        ld := Left;
    end
    else if (map[s_loc[0] - 1, s_loc[1]] = '|') or (map[s_loc[0] - 1, s_loc[1]] = '7') or (map[s_loc[0] - 1, s_loc[1]] = 'F') then
    begin
        loc[0] := loc[0] - 1;
        ld := Up;
    end
    else
    begin
        { if it's neither up nor left, then both right and down must be valid. }
        { pick right arbitrarily }
        ld := Right;
        loc[1] := loc[1] + 1;
    end;
    
    while (loc[0] <> s_loc[0]) or (loc[1] <> s_loc[1]) do
    begin
        count := count + 1;
        ld := step_path(loc, ld, map[loc[0], loc[1]]);
    end;

    count := count + 1;
    writeln(count div 2);
   
end.

