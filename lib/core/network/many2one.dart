import 'package:equatable/equatable.dart';

/// A parsed many2one value (`[id, "Display Name"]`).
class Many2One extends Equatable {
  const Many2One(this.id, this.name);

  final int id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}
