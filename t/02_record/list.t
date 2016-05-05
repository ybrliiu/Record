use Record 'Test';
use Test::More;
use Test::Record; # テストメソッド集

use Record::List;
my $obj;
my $class = 'Record::List';
my $max = 50;

subtest 'new' => sub {
  $obj = $class->new(
    File => 'test_list.dat',
    Max => $max,
  );
  isa_ok($obj,$class);
  can_ok($obj,qw/open make close remove/);
};

subtest 'set_alldata' => sub {
  ok $obj->Data([0 .. 15]);
};

subtest 'get' => sub {
  my $gets = $obj->get(5);
  is($gets->[$_], $_) for 0 .. 4;
};

subtest 'add' => sub {
  $obj->add('test')->add('test2');
  my $data = $obj->Data;
  is($data->[0], 'test2');
  is($data->[1], 'test');
};

subtest 'make' => sub {
  Test::Record->makefile($obj, [0 .. 100], 1);
  $obj->open();
  is(@{$obj->Data}, $max, 'after_close');
  ok $obj->remove();
};

done_testing;
