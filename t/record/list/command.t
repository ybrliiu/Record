use Record 'Test';
use Test::More;
use Test::Record;

use Record::List::Command;
my $obj;
my $class = 'Record::List::Command';

subtest 'new' => sub {
  $obj = $class->new(File => 'test_command.dat', Max => 15);
  isa_ok($obj, $class);
};

subtest 'input' => sub {
  $obj->add('command') for 0 .. 25;
  my $input = [qw/0 2 4 6 8 10 16 24/];
  $obj->input('write', $input);
  my $commands = $obj->Data;
  is($commands->[$_], 'write') for @$input;
};

subtest 'insert' => sub {
  my $none = 'nothing';
  $obj->insert($none, 5, 3);
  my $commands = $obj->Data;
  is($commands->[4], 'write');
  is($commands->[5], $none);
  is($commands->[6], $none);
  is($commands->[7], $none);
  is($commands->[8], 'command');
};

subtest 'make' => sub {
  Test::Record->makefile($obj, $obj->Data);
};

done_testing;

