use JSON::Tiny;
use HTTP::Server::Tiny;
use URI::Encode;
use MIME::Base64;

use lib ".";
use agents::random-walker;

my $port = 8088;

my $host = "127.0.0.1";

sub contentType($uri) {
    if $uri.ends-with("html") {
        return "text/html";
    } elsif $uri.ends-with("js") {
        return "text/javascript";
    } elsif $uri.ends-with("png") {
        return "image/png";
    }
    return "text/plain";
}

HTTP::Server::Tiny.new(:$host, :$port).run(sub ($env) {
    my $uri = $env<REQUEST_URI>;
    if $uri eq "/" {
        $uri = "/index.html";
    }
    my $count = 0;
    if $uri.starts-with("/api/action") {
        my $query = $env<QUERY_STRING>;
        my $image = $query.substr("image=data%3Aimage%2Fpng%3Bbase64%2C".chars);
        $image = uri_decode_component($image);
        $image = MIME::Base64.decode($image);
        $count++;
        # my $fh = open "$count.png", :rw, :bin;
        # $fh.write($image);
        # $fh.close();
        my %action = action => nextAction();
        my $channel = Channel.new;
        $channel.send((to-json %action).encode("utf-8"));
        $channel.close;
        return 200, ["Content-Type" => "text/json"], $channel;
    } else {
        my $fh = "game$uri".IO.open;
        return 200, ["Content-Type" => contentType($uri)], $fh;
    }
});

