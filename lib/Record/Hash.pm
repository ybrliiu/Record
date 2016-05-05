package Record::Hash {
  
  use Mouse;
  with 'Record::Base'; # ロール
  
  use Record;
  use Carp qw/croak/; # モジュールでのdie;
  
  has 'Data' => (is => 'rw', isa => 'HashRef');
  
  # データ取得
  sub find {
    my ($self, $key) = @_;
    my $data = $self->Data;
    return exists($data->{$key}) ? $data->{$key} : croak 'キーが存在しません';
  }

  # キーに対応するデータの存在確認
  sub exists {
    my ($self, $key) = @_;
    my $data = $self->Data;
    return exists($data->{$key});
  }

  # 格納されているオブジェクト内、$nameアテリビュートと$valueが対応するオブジェクトのリストを返却(DBのSELECT文的な)
  sub search {
    my ($self, $name, $value) = @_;
    return map { $_->$name eq $value ? $_ : () } values %{ $self->Data };
  }
  
  # データ追加
  sub add {
    my ($self, $key, $obj) = @_;
    my $data = $self->Data;
    croak '空文字列をキーとして使用することはできません' if $key eq '';
    croak '既に同じキーのデータがあります' if exists $data->{$key};
    $data->{$key} = $obj;
    $self->Data($data);
    return $self;
  }
  
  # データ更新
  sub update {
    my ($self, $key, $obj) = @_;
    $self->find($key);
    my $data = $self->Data;
    $data->{$key} = $obj;
    $self->Data($data);
    return $self;
  }
  
  # データ削除
  sub delete {
    my ($self, $key) = @_;
    $self->find($key);
    my $data = $self->Data;
    delete $data->{$key};
    $self->Data($data);
    return $self;
  }
  
  # キーの一覧を取得
  sub get_list {
    my $self = shift;
    my @list = map { $_ } keys(%{$self->Data});
    return \@list;
  }
  
  __PACKAGE__->meta->make_immutable();
}

1;
