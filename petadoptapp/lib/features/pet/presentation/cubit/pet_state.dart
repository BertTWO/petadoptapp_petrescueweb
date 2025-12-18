part of 'pet_cubit.dart';

sealed class PetState extends Equatable {
  const PetState();

  @override
  List<Object?> get props => [];
}

class PetInitial extends PetState {}

class PetLoading extends PetState {}

class PetLoaded extends PetState {
  final List<Pet> pets;

  const PetLoaded({required this.pets});

  @override
  List<Object> get props => [pets];
}

class PetError extends PetState {
  final String message;

  const PetError({required this.message});

  @override
  List<Object> get props => [message];
}

class PetActionSuccess extends PetState {
  final String message;

  const PetActionSuccess({required this.message});

  @override
  List<Object> get props => [message];
}
