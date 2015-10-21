package Dancer2::Plugin::SendAs;
# ABSTRACT: Dancer2 plugin to send data as specific content type

use strict;
use warnings;

use Dancer2::Plugin;

use Class::Load 'try_load_class';
use Encode;
use List::Util 'first';

# VERSION

register send_as => sub {
    my ( $dsl, $type, $data ) = @_;

    # allow lower cased serializer names
    my $serializer_class = first { try_load_class($_) }
                           map { "Dancer2::Serializer::$_" }
                           ( uc $type, $type );

    my %options = ();
    my $content;

    if ( $serializer_class ) {
        my $serializer = $serializer_class->new;
        $content = $serializer->serialize( $data );
        $options{content_type} = $serializer->content_type;
    }
    else {
        # send as HTML
        $content = Encode::encode( 'UTF-8', $data );
        $options{content_type} = 'text/html; charset=UTF-8';        
    }
    
    $dsl->app->send_file( \$content, %options );
}, { prototype => '$@' };

register_plugin;

1;

=pod

=encoding utf-8

=head1 SYNOPSIS

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

=cut

