use Record 'Test';
use Test::More 0.98;

use_ok $_ for qw(
  Record
  Record::Base
  Record::Hash
  Record::List
  Record::List::Log
  Record::List::Letter
  Record::List::Command
  Record::List::CommandList
);

done_testing;

