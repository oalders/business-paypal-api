package Example::Role::Auth;

use Moo::Role;
use MooX::Options;

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

has _client => (
    is      => 'ro',
    isa     => InstanceOf ['Business::PayPal::API::TransactionSearch'],
    lazy    => 1,
    builder => '_build_client',
);

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
