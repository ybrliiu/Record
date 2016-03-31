package Record::List {
  
  use Mouse;
  with 'Record::Base'; # ロール
  
  use Record;
  
  # Dataの最大数
  has 'Max' => (is => 'ro', isa => 'Int', required => 1);
  
  # Dataアテリビュートの型
  around '_data_type' => sub {
    my ($orig, $class, $type) = @_;
    return "ArrayRef[$type]";
  };
  
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
