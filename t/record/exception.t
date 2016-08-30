use Record 'test';
use Test::More;
use Test::Exception;
use Test::Record;
use Record::Hash;

use Record::Exception;
my $CLASS = 'Record::Exception';
my $PATH  = 'test.dat';

subtest 'throw exception' => sub {
  throws_ok {
    $CLASS->throw(
      message => 'test_throw',
      obj     => Record::Hash->new(file => $PATH),
    )
  } qr/test_throw/, 'throw success';
};

subtest 'operation verification' => sub {
  eval {
    $CLASS->throw(
      message => 'test_throw',
      obj     => Record::Hash->new(file => $PATH),
    )
  };
  my $e = $@;
  ok $CLASS->caught($e), 'discriminate error';
  like $e->obj->file, qr/$PATH/, '例外投げた時のデータ確認';
  like $e, qr/test_throw at t\/record\/exception.t line /, 'メッセージ確認';
};

done_testing;
