# NAME

Dancer2::Plugin::SendAs - (DEPRECATED) Dancer2 plugin to send data as specific content type

# VERSION

version 0.002

# SYNOPSIS

    use Dancer2;
    use Dancer2::Plugin::SendAs;

    set serializer => 'YAML';
    set template => 'template_toolkit';

    get '/html' => sub {
        send_as html => template 'foo';
    };

    get '/json/**' => sub {
        send_as json => splat;
    };

# DESCRIPTION

This plugin is DEPRECATED. The `send_as` functionality was merged into
[Dancer2](https://metacpan.org/pod/Dancer2) v0.200000.

A plugin to make it easy to return a specific content type from routes.

When an app has a serializer defined, returning HTML content is messy. You
could use `send_file`, but need to take care of encoding yourself, adding
unnecessary boilerplate. Another solution is to split your app; resulting
in routes that return serialized content separated from routes that return
HTML. If there are a small number of routes (think O(1)) that return HTML,
splitting the app is tedious.

Conversly, returning serialized content from a small number of routes from
an app that otherwise returns HTML has similar issues.

This plugin provides a `send_as` keyword, allowing content to be returned
from any available Dancer2 serializer, or HTML.

# METHODS

## send\_as type => content

Send the content "serialized" using the specified serializer, or as HTML if no
matching serializer is found.

Any available Dancer2 serializer may be used. Serializers are loaded at runtime
(if necessary). Both the uppercase 'type' and the provided case of the type are
used to find an appropriate serializer class to use.

The implementation of `send_as` uses Dancer2's `send_file`. Your route will be
exited immediately when `send_as` is executed. `send_file` will stream
content back to the client if your server supports psgi streaming.

# ACKNOWLEDGEMENTS

This module has been written during the
[Perl Dancer 2015](https://www.perl.dance/) conference.

# AUTHOR

Russell Jenkins <russellj@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Russell Jenkins.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
