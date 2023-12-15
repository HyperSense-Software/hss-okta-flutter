enum IdxStatus {
  success('SUCCESS'),
  failure('FAILURE'),
  pending('PENDING'),
  terminal('TERMINAL'),
  canceled('CANCELED');

  const IdxStatus(this.name);
  final String name;
}
