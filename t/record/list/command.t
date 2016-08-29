use Record 'test';
use Test::More;
use Test::Record;
my $TR = Test::Record->new();

use Record::List::Command;
my $OBJ;
my $CLASS = 'Record::List::Command';

subtest 'new' => sub {
  $OBJ = $CLASS->new(file => 'test_command.dat', max => 15);
  isa_ok($OBJ, $CLASS);
};

subtest 'input' => sub {
  $OBJ->add('command') for 0 .. 25;
  my $input = [qw/0 2 4 6 8 10 16 24/];
  $OBJ->input('write', $input);
  my $commands = $OBJ->data;
  is($commands->[$_], 'write') for @$input;
};

subtest 'insert' => sub {
  my $none = 'nothing';
  $OBJ->insert($none, [2, 4], 3); # 1,4番に3つ空白を入れる
  my $commands = $OBJ->data;
  isnt($commands->[1], $none);
  is($commands->[$_], $none) for (2 .. 4);
  isnt($commands->[5], $none);
  
  isnt($commands->[6], $none);
  is($commands->[$_], $none) for (7 .. 9);
  isnt($commands->[10], $none);
};

subtest 'make' => sub {
  Test::Record->make_file(
    record => $OBJ,
    data   => $OBJ->data,
    remove => 1,
  );
};

done_testing;

