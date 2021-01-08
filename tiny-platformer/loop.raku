use lib 'lib';
use NativeCall;
use OpenCV::Highgui;

use lib ".";
use agents::random-walker;

sub make_decision() {
    my $start = DateTime.new(now);

    shell "screencapture -t jpg -x -o screencapture.jpg";

    my $end = DateTime.new(now);
    say "screen capture duration: {$end - $start}s";

    $start = DateTime.new(now);
    
    my $mat = imread("screencapture.jpg");
    my $h = $mat.rows;
    my $w = $mat.cols;
    
    my $data = nativecast(Pointer[uint8], $mat.data);
    
    my $found = False;
    
    $found = False;
    
    my $x-start = -1;
    
    for 10..^$w -> $i {
        my $y = $h / 2;
        my $n = $y * $w + $i;
        my $c1 = $data[$n * 3 + 0];
        my $c2 = $data[$n * 3 + 1];
        my $c3 = $data[$n * 3 + 2];
        if not $found {
            if $c1 == 5 and $c2 == 5 and $c3 == 5 {
                $found = True;
            }
        } else {
            if $c1 != 5 or $c2 != 5 or $c3 != 5 {
                $x-start = $i;
                last;
            }
        }
    }
    
    $found = False;
    
    my $y-start = -1;
    
    for 10..^$h -> $i {
        my $x = $w / 2;
        my $n = $i * $w + $x;
        my $c1 = $data[$n * 3 + 0];
        my $c2 = $data[$n * 3 + 1];
        my $c3 = $data[$n * 3 + 2];
        if not $found {
            if $c1 == 5 and $c2 == 5 and $c3 == 5 {
                $found = True;
            }
        } else {
            if $c1 != 5 or $c2 != 5 or $c3 != 5 {
                $y-start = $i;
                last;
            }
        }
    }
    
    # say $x-start;
    # say $y-start;
    
    $end = DateTime.new(now);
    say "image read duration: {$end - $start}s";
    
    sub parse_map($image, $width, $height, $x-start, $y-start) {
        my @map = [];
        my @items = [];
        my $tile = 16;
        for 0..^48 -> $i {
            my @row = [];
            my $i1 = $i * $tile + $tile / 2 + $y-start;
            for 0..^64 -> $j {
                my $j1 = $j * $tile + $tile / 2 + $x-start;
                my $n = $i1 * $width + $j1;
                my $r = $image[$n * 3 + 0].Str;
                my $g = $image[$n * 3 + 1].Str;
                my $b = $image[$n * 3 + 2].Str;
                my $c = -1;
                for 0..^@items.elems -> $idx {
                    my $diff1 = abs($r - @items[$idx][0]);
                    my $diff2 = abs($g - @items[$idx][1]);
                    my $diff3 = abs($b - @items[$idx][2]);
                    if $diff1 <= 10 and $diff2 <= 10 and $diff3 <= 10 {
                        $c = $idx;
                        last;
                    }
                }
                if $c == -1 {
                    $c = @items.elems;
                    @items.push: [$r, $g, $b];
                }
                @row.push: $c;
            }
            @map.push: @row;
        }
        if 3 <= @items.elems and @items.elems <= 10 {
            return @map;
        }
        return [];
    }
    
    $start = DateTime.new(now);
    my @map = parse_map($data, $w, $h, $x-start, $y-start);
    $end = DateTime.new(now);
    say "map parse duration: {$end - $start}s";

    if @map.elems > 0 {
        nextAction(@map);
    }
}

while True {
    make_decision();
}
