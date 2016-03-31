use Record 'Test';
use Test::More; # テストモジュール
use Test::Exception; # 例外を伴うテスト
use Test::Record; # テストメソッド集

use Record::Hash;
my $class = 'Record::Hash';
my $obj;
my $dir = 'test_hash.dat';

subtest 'new' => sub {
  $obj = $class->new(File => $dir);
  isa_ok($obj,$class);
  can_ok($obj,qw/open make close remove find add delete get_list/);
};

subtest 'set_alldata' => sub {
  ok $obj->Data({});
};

subtest 'add' => sub {
  my $str = "文章です";
  ok $obj->add(what => $str);
  is($obj->Data->{what}, $str);
  dies_ok { $obj->add('' => 'aaaa') } '空文字列キー使用';
  dies_ok { $obj->add(what => 'aaaa') } '既に同じキーのデータがある';
};

subtest 'update&find' => sub {
  my $str = 'change';
  ok $obj->update(what => $str);
  is($obj->find('what'), $str);
};

subtest 'Filedir' => sub {
  like($obj->File, qr/$dir/);
};

subtest 'make' => sub {
  Test::Record->makefile($obj, {qw/a b c d e f/});
};

done_testing;
