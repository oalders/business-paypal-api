package Business::PayPal::API::GetBalance;

use 5.008001;
use strict;
use warnings;

use SOAP::Lite 0.67;
use Business::PayPal::API ();

our @ISA         = qw(Business::PayPal::API);
our @EXPORT_OK   = qw(GetBalance);              ## fake exporter

sub GetBalance {
    my $self = shift;
    my %args = @_;

    my @trans = ( $self->version_req, );

    my $request
        = SOAP::Data->name(
        GetBalanceRequest => \SOAP::Data->value( @trans ) )
        ->type( "ns:GetBalanceRequestType" );

    my $som = $self->doCall( GetBalanceReq => $request )
        or return;

    my $path = '/Envelope/Body/GetBalanceResponse';

    my %response = ();
    unless ( $self->getBasic( $som, $path, \%response ) ) {
        $self->getErrors( $som, $path, \%response );
        return %response;
    }

    $self->getFields(
        $som, $path,
        \%response,
        {   Balance          => 'Balance',
            BalanceTimeStamp => 'BalanceTimeStamp',
        }
    );

    return %response;
}

1;
__END__

