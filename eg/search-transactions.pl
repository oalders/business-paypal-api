package Example::TransactionSearcher;

use Moo;
use MooX::Options;

use feature qw( say );

use Business::PayPal::API::TransactionSearch;
use DateTime;
use Data::Printer;
use Types::Standard qw( InstanceOf );

# credentials
option password => (
    is       => 'ro',
    format   => 's',
    required => 1,
    doc      => 'password',
);

# defaults to boolean if no format specified
option sandbox => (
    is      => 'ro',
    default => 0,
    doc     => 'use sandbox',
);

option signature => (
    is       => 'ro',
    format   => 's',
    required => 1,
    doc      => 'signature',
);

option username => (
    is       => 'ro',
    format   => 's',
    required => 1,
    doc      => 'username',
);

# search options
option start_date => (
    is       => 'ro',
    format   => 's',
    required => 0,
    lazy     => 1,
    doc      => 'start date for search. eg 2005-12-22T08:51:28Z',
    default => sub { DateTime->now->truncate( to => 'day' )->datetime . 'Z' },
);

option payer => (
    is       => 'ro',
    format   => 's',
    required => 0,
    doc      => 'payer email address',
);

has _client => (
    is      => 'ro',
    isa     => InstanceOf ['Business::PayPal::API::TransactionSearch'],
    lazy    => 1,
    builder => '_build_client',
);

sub search {
    my $self = shift;
    say 'Search begins on ' . $self->start_date;

    my @response = $self->_client->TransactionSearch(
        StartDate => $self->start_date,
        $self->payer ? ( Payer => $self->payer ) : (),
    );

    unless ( ref $response[0] ) {
        my %error = @response;
        p %error;
        die;
    }

    return $response[0];
}

sub _build_client {
    my $self = shift;
    return Business::PayPal::API::TransactionSearch->new(
        Password  => $self->password,
        Signature => $self->signature,
        Username  => $self->username,
        sandbox   => $self->sandbox,
    );
}

1;

package main;

use strict;
use warnings;
use feature qw( say );

use Data::Printer;

my $searcher = Example::TransactionSearcher->new_with_options();
my $txns     = $searcher->search;
say 'no results' unless @{$txns};

foreach my $txn ( @{$txns} ) {
    p $txn if @$txn;
}
