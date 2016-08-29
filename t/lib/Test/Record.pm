package Test::Record {

  use Record;
  use Carp qw/croak/;
  use Test::More;
  use Test::Name::FromLine;
  use Path::Tiny;

  sub new {
    my ($CLASS) = @_;
    return bless {}, $CLASS;
  }

  # データ記録ファイルを実際に作成、読み込み、書き込み、削除するテスト
  sub make_file {
    my ($CLASS, %args) = @_;
    for (qw/record data remove/) {
      croak "please give argment $_" unless exists $args{$_};
    }

    ok $args{record}->make;
    ok $args{record}->open;
    ok $args{record}->open('LOCK_EX');
    ok $args{record}->data($args{data});
    ok $args{record}->close;
    ok $args{record}->remove if $args{remove};
  }

  sub DESTROY {
    my $iter = path( Record::project_dir() )->iterator({recurse => 1});
    while (my $path = $iter->() ) {
      $path->remove() if $path =~ /\.dat$/;
    }
  }

}

1;
