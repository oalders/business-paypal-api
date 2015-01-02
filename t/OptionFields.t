# This file is part of Business:PayPal:API Module.   License: Same as Perl.  See its README for details.
# -*- mode: cperl -*-
use Test::More;
use strict;
use autodie qw(:all);
use Cwd;

if ( !$ENV{WPP_TEST} || !-f $ENV{WPP_TEST} ) {
    plan skip_all =>
        'No WPP_TEST env var set. Please see README to run tests';
}
else {
    plan tests => 14;
}

use_ok( 'Business::PayPal::API::TransactionSearch' );
use_ok( 'Business::PayPal::API::GetTransactionDetails' );

#########################

require 't/API.pl';

my %args = do_args();

=pod

These tests verify the options work.

=cut

open(OPTIONS_PAY_HTML, ">", "options-payment.html");
print OPTIONS_PAY_HTML <<_OPTIONS_PAYMENT_DATA_
<html>
<body>
<form action="https://www.sandbox.paypal.com/cgi-bin/webscr" method="post" target="_top">
   <input type="hidden" name="cmd" value="_xclick" />
   <input type="hidden" name="business" value="$args{SellerEmail}" />
   <input type="hidden" name="item_name" value="Field Options Tester" />
   <input id="no_shipping" type="hidden" name="no_shipping" value="0" />
   <input id="amount" type="text" name="amount" size="7" minimum="120" value="120" />
   <input type="hidden" name="on1" value="firstOption" />
   <input type="hidden" name="os1" value="Yes" />
   <input type="hidden" name="on2" value="size"/>
   <input name="os2" id="os2" value="Large"/>
   <input type="image" border="0" name="submit" alt="Submit Field Tester with $120 payment">
</form></body></html>
_OPTIONS_PAYMENT_DATA_
  ;
close(OPTIONS_PAY_HTML);

my $cwd = getcwd;

print STDERR <<"_OPTIONS_LINK_";
Please note the next series of tests will not succeeed unless there is at
least one transaction that is part of a subscription payments in your business
account.

if you haven't made one yet, you can visit:
      file://$cwd/options-payment.html

and use the sandbox buyer account to make the payment.
_OPTIONS_LINK_

my $startdate = '1998-01-01T01:45:10.00Z';

my $ts   = new Business::PayPal::API::TransactionSearch( %args );
my $td   = new Business::PayPal::API::GetTransactionDetails( %args );

my $resp = $ts->TransactionSearch(StartDate     => $startdate);
my %detail;
foreach my $record (@{$resp}) {
    %detail = $td->GetTransactionDetails(TransactionID => $record->{TransactionID});
    last if $detail{PII_Name} =~ /Field\s+Options/i;
}
like($detail{PaymentItems}[0]{Name}, qr/Field\s+Options/i, 'Found field options test transaction');
like($detail{PII_Name}, qr/Field\s+Options/i, 'Found field options test transaction');

foreach my $options ($detail{PaymentItems}[0]{Options}, $detail{PII_Options}[0]) {
    ok(scalar(keys %$options) == 2, "The PaymentItems Options has 2 elements");
    ok(defined $options->{firstOption}, "'firstOption' is present");
    ok($options->{firstOption} eq 'Yes', "'firstOption' is selected as 'Yes'");
    ok(defined $options->{size}, "'size' option is present");
    ok($options->{size} eq "Large", "'size' option is selected as 'Large'");
}

# Local Variables:
#   Mode: CPerl
#   indent-tabs-mode: nil
#   cperl-indent-level: 4
#   cperl-brace-offset: 0
#   cperl-continued-brace-offset: 0
#   cperl-label-offset: -4
#   cperl-continued-statement-offset: 4
# End:

