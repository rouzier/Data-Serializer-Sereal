=head1 NAME

01-serialize

=cut

=head1 DESCRIPTION

01-serialize

=cut

use threads;
use strict;
use warnings;

use Test::More tests => 5;                      # last test to print

use Test::NoWarnings;

use Data::Serializer;

my $serializer_default = Data::Serializer->new( serializer => 'Sereal'),

my %object = (
    a => [0 .. 100],
    b => ['a'.. 'z' ],
    c => {
        d => [0 .. 100],
        e => ['A'.. 'Z' ],
    }
);

is_deeply(\%object,$serializer_default->deserialize($serializer_default->serialize(\%object)),"Serialization/Deserialize using default encoder/decoder");

my $serializer_options = Data::Serializer->new( serializer => 'Sereal', options => { encoder => Sereal::Encoder->new,decoder => Sereal::Decoder->new} );

is_deeply(\%object,$serializer_options->deserialize($serializer_options->serialize(\%object)),"Serialization/Deserialize using provided encoder/decoder");


my $thr = threads->create(
    {'context' => 'list'},
    sub {
        is_deeply(\%object,$serializer_default->deserialize($serializer_default->serialize(\%object)),"Serialization/Deserialize using default encoder/decoder in a thread after cloning");

        is_deeply(\%object,$serializer_options->deserialize($serializer_options->serialize(\%object)),"Serialization/Deserialize using provided encoder/decoder in a thread after cloning");

    }
);


$thr->join();

=head1 AUTHOR

James Rouzier, C<< <rouzier at gmail.com> >>

=head1 LICENSE AND COPYRIGHT

Copyright 2014 James Rouzier.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1;


