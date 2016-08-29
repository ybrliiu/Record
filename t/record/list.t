use Record 'test';
use Test::More;
use Test::Record;
my $TR = Test::Record->new();

use Record::List;
my $obj;
my $class = 'Record::List';
my $max = 50;

subtest 'new' => sub {
  $obj = $class->new(
    file => 'test_list.dat',
    max => $max,
  );
  isa_ok($obj,$class);
  can_ok($obj,qw/open make close remove/);
};

subtest 'set_alldata' => sub {
  ok $obj->data([0 .. 15]);
};

subtest 'get' => sub {
  my $gets = $obj->get(5);
  is($gets->[$_], $_) for 0 .. 4;
};

subtest 'add' => sub {
  $obj->add('test')->add('test2');
  my $data = $obj->data;
  is($data->[0], 'test2');
  is($data->[1], 'test');
};

subtest 'make' => sub {
  Test::Record->make_file(
    record => $obj,
    data   => [0 .. 100],
    remove => 0,
  );
  $obj->open();
  is(@{$obj->data}, $max, 'after_close');
  ok $obj->remove();
};

done_testing;
