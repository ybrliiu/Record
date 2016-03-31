package Record::List {
  
  use Mouse;
  with 'Record::Base'; # ロール
  
  use Record;
  
  # データ格納,Dataの最大数
  has 'Data' => (is => 'rw', isa => 'ArrayRef');
  has 'Max' => (is => 'ro', isa => 'Int', required => 1);
  
  # データ取得
  sub get {
    my ($self, $num) = @_;
    my @result = @{$self->Data};
    splice(@result, $num);
    return \@result;
  }
  
  # データ追加
  sub add {
    my ($self, $data) = @_;
    my $tmp = $self->Data;
    unshift(@$tmp, $data);
    $self->Data($tmp);
    return $self;
  }
  
  # 書き込み前の処理
  before 'close' => sub {
    my $self = shift;
    splice(@{$self->Data}, $self->Max);
  };
  
  __PACKAGE__->meta->make_immutable();
}

1;
