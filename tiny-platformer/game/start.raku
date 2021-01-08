use HTTP::Server::Tiny;

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
    my $fh = ".$uri".IO.open;
    return 200, ["Content-Type" => contentType($uri)], $fh;
});

