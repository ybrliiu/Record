use Record 'Test';
use Test::More;
use Test::Record;

use Record::List::Command;
my $obj;
my $class = 'Record::List::Command';

subtest 'new' => sub {
  $obj = $class->new(file => 'test_command.dat', max => 15);
  isa_ok($obj, $class);
};

subtest 'input' => sub {
  $obj->add('command') for 0 .. 25;
  my $input = [qw/0 2 4 6 8 10 16 24/];
  $obj->input('write', $input);
  my $commands = $obj->data;
  is($commands->[$_], 'write') for @$input;
};

subtest 'insert' => sub {
  my $none = 'nothing';
  $obj->insert($none, [2, 4], 3); # 1,4番に3つ空白を入れる
  my $commands = $obj->data;
  isnt($commands->[1], $none);
  is($commands->[$_], $none) for (2 .. 4);
  isnt($commands->[5], $none);
  
  isnt($commands->[6], $none);
  is($commands->[$_], $none) for (7 .. 9);
  isnt($commands->[10], $none);
};

subtest 'make' => sub {
  Test::Record->makefile($obj, $obj->data);
};

done_testing;

