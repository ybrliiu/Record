package Record::List::CommandList {
  
  use Mouse;
  extends 'Record::List'; # 継承
  
  use Record;
  
  # コマンドリストデータ取得
  sub find {
    my ($self, $no) = @_;
    return $self->Data->[$no];
  }
  
  # コマンドリストデータ更新
  sub update {
    my ($self, $no, $obj) = @_;
    my $data = $self->Data;
    $data->[$no] = $obj;
    $self->Data($data);
    return $self;
  }
  
  __PACKAGE__->meta->make_immutable();
}

1;

