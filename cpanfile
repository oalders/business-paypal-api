requires "Carp" => "0";
requires "Data::Printer" => "0";
requires "IPC::System::Simple" => "0";
requires "SOAP::Lite" => "0.67";
requires "perl" => "5.008001";
requires "strict" => "0";
requires "warnings" => "0";

on 'build' => sub {
  requires "Module::Build" => "0.28";
};

on 'test' => sub {
  requires "Cwd" => "0";
  requires "List::AllUtils" => "0";
  requires "Test::More" => "0";
  requires "Test::Most" => "0";
  requires "autodie" => "0";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "0";
  requires "Module::Build" => "0.28";
};
