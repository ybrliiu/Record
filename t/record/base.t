use Record 'test';
use Test::More;
use Test::Record;
my $TR = Test::Record->new();
use Record::Hash;

subtest 'file lock' => sub {
  my $record = Record::Hash->new(file => 'file_lock.dat');
  $record->make();
  $record->open('LOCK_EX');

  my $record2 = Record::Hash->new(file => 'file_lock.dat');
  eval { $record2->open('NB_LOCK_EX') };
  like $@, qr/flock失敗:Resource temporarily unavailable/;

  $record->close();
  ok $record2->open('LOCK_EX');
};

subtest 'rollback' => sub {
  my $record = Record::Hash->new(file => 'rollback.dat');
  Test::Record->make_file(
    record => $record,
    data   => {
      dummy => 'hoge',
      foo   => 'bar',
    },
    remove => 0,
  );

  $record->open('LOCK_EX');
  $record->update(dummy => 'change');
  $record->rollback();

  is $record->fetch('dummy'), 'hoge', 'rollback success';

  my $rec2 = Record::Hash->new(file => 'rollback.dat');
  $rec2->open('LOCK_EX');
  is $record->fetch('dummy'), 'hoge', 'rollback success at other file handle.';
  $rec2->close();
};

subtest 'confilm when throw exception, flock is unlocked.' => sub {
  my $record = Record::Hash->new(file => 'exception.dat');
  Test::Record->make_file(
    record => $record,
    data   => {some => 'thing'},
    remove => 0,
  );

  {
    eval {
      $record->open('LOCK_EX');
      Record::Exception->throw('why exception throwed????', $record);
    };
    my $record2 = Record::Hash->new(file => 'exception.dat');
    ok $record2->open('NB_LOCK_EX'), '$record is unlocked.';
  }

};

done_testing();
