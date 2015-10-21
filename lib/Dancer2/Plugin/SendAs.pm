package Dancer2::Plugin::SendAs;
# ABSTRACT Dancer2 plugin to send data as specific content type

use strict;
use warnings;

use Dancer2::Plugin;

use Class::Load 'load_class';
use Encode;

register send_as => sub {
    my ( $dsl, $type, $data ) = @_

    my $serializer_class = load_class( "Dancer2::Serializer::$type" )
                        || load_class( "Dancer2::Serializer::" . uc $type );
    my $headers = {};
    my $content;

    if ( $serializer_class ) {
        my $serializer = $serializer_class->new;
        $content = $serializer->serialize( $data )
        $headers->{content_type} = $serializer->content_type;
    }
    else {
        # send as HTML
        $content = Encode::encode( 'UTF-8', $data );
        $headers->{content_type} = 'text/html; charset=UTF-8';        
    }
    
    $dsl->app->send_file( \$content, $headers );
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

    get '/html' => {
        send_as html => template 'foo';
    }

    get '/json/**' => sub {
        send_as json => splat;
    };

=cut