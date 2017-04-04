requires "Carp" => "0";
requires "Data::Printer" => "0";
requires "SOAP::Lite" => "0.67";
requires "perl" => "5.008001";
requires "strict" => "0";
requires "warnings" => "0";

on 'test' => sub {
  requires "Cwd" => "0";
  requires "List::AllUtils" => "0";
  requires "Test::More" => "0";
  requires "Test::Most" => "0";
  requires "autodie" => "0";
  requires "perl" => "5.008001";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "0";
  requires "perl" => "5.008001";
};

on 'develop' => sub {
  requires "Pod::Coverage::TrustPod" => "0";
  requires "Test::CPAN::Changes" => "0.19";
  requires "Test::Code::TidyAll" => "0.50";
  requires "Test::More" => "0.88";
  requires "Test::Pod::Coverage" => "1.08";
  requires "Test::Spelling" => "0.12";
};
