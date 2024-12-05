program day10part1;
uses sysutils;

type
    direction = (Left, Up, Right, Down, NA);
    blocktype = (Empty, Pipe, Red, Blue);

var
    blocks: array[1..1000, 1..1000] of blocktype;


procedure replace_if_not_pipe(y: int32; x: int32; new_type: blocktype);
begin
    if blocks[y, x] <> Pipe then
        blocks[y, x] := new_type
end;

function step_path(var curr: array of int32; last_direction: direction; c: char): direction;
begin

    // step_path := curr;

    step_path := NA;

    { mark lefthand side as blue, righthand side as red }
    case last_direction of
        Left:
        begin
            replace_if_not_pipe(curr[0] - 1, curr[1], Red);
            replace_if_not_pipe(curr[0] + 1, curr[1], Blue);
        end;
        Right:
        begin
            replace_if_not_pipe(curr[0] - 1, curr[1], Blue);
            replace_if_not_pipe(curr[0] + 1, curr[1], Red);
        end;
        Down:
        begin
            replace_if_not_pipe(curr[0], curr[1] - 1, Red);
            replace_if_not_pipe(curr[0], curr[1] + 1, Blue);
        end;
        Up:
        begin
            replace_if_not_pipe(curr[0], curr[1] - 1, Blue);
            replace_if_not_pipe(curr[0], curr[1] + 1, Red);
        end;
    end;

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

    { mark lefthand side as blue, righthand side as red }
    case step_path of
        Left:
        begin
            replace_if_not_pipe(curr[0] - 1, curr[1], Red);
            replace_if_not_pipe(curr[0] + 1, curr[1], Blue);
        end;
        Right:
        begin
            replace_if_not_pipe(curr[0] - 1, curr[1], Blue);
            replace_if_not_pipe(curr[0] + 1, curr[1], Red);
        end;
        Down:
        begin
            replace_if_not_pipe(curr[0], curr[1] - 1, Red);
            replace_if_not_pipe(curr[0], curr[1] + 1, Blue);
        end;
        Up:
        begin
            replace_if_not_pipe(curr[0], curr[1] - 1, Blue);
            replace_if_not_pipe(curr[0], curr[1] + 1, Red);
        end;
    end;

    { move to the next pipe } 
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

    width: int32;

    steps: int32;
    step: char;

    s_loc, loc: array[0..1] of int32;
    ld: direction;

    i, j: int32;

    { node, left, right }
    nodes: array[0..1000, 0..2] of string;

    current: blocktype;
    invalid: blocktype;

    red_count, blue_count: int32;

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

    width := length(map[1]);

    loc := s_loc;

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

    // shitty memset
    for i := 1 to count do
    begin
        for j := 1 to width do
        begin
            blocks[i, j] := Empty;
        end;
    end;

    blocks[s_loc[0], s_loc[1]] := Pipe;
    
    
    { mark array of pipes, and set some red and blue squares }
    while (loc[0] <> s_loc[0]) or (loc[1] <> s_loc[1]) do
    begin

        { mark pipe }
        blocks[loc[0], loc[1]] := Pipe;

        ld := step_path(loc, ld, map[loc[0], loc[1]]);
    end;
    { step one additional time }
    ld := step_path(loc, ld, map[loc[0], loc[1]]);

    { fill in the map and count}
    { techincally filling in the map is uneccessary but it looks cool }

    red_count := 0;
    blue_count := 0;

    for i := 1 to count - 1 do
    begin
        current := Empty;
        for j := 1 to width do
        begin
            case blocks[i, j] of
                Empty:
                    begin
                        blocks[i, j] := current;
                        case current of
                            Red: red_count   := red_count + 1;
                            Blue: blue_count := blue_count + 1;
                        end;
                    end;
                // Pipe you do nothing
                Red: 
                    begin
                        current := Red;
                        red_count := red_count + 1;
                    end;
                Blue:
                    begin
                        current := Blue;
                        blue_count := blue_count + 1;
                    end;
            end;
        end;

        { if we're holding onto this at the end, then this is the color outside of the square}
        if current <> Empty then
            invalid := current
    end;

    { print out the map }
    for i := 1 to count - 1 do
    begin
        for j := 1 to width do
        begin
            case blocks[i, j] of
                Empty: write(' ');
                Pipe:  write('█');
                Red:   write('▒');
                Blue:  write('░');
            end;
        end;
        writeln();
    end;

    writeln(invalid, ' is bad color.');
    writeln('Red count is ', red_count);
    writeln('Blue count is ', blue_count);

end.

