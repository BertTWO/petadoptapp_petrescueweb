part of 'adoption_cubit.dart';

sealed class AdoptionState extends Equatable {
  const AdoptionState();

  @override
  List<Object> get props => [];
}

class AdoptionInitial extends AdoptionState {}

class AdoptionCanceled extends AdoptionState {}

class AdoptionLoading extends AdoptionState {}

class AdoptionSuccess extends AdoptionState {
  final String message;
  final String? applicationId;

  const AdoptionSuccess({required this.message, this.applicationId});

  @override
  List<Object> get props => [message];
}

class AdoptionError extends AdoptionState {
  final String message;

  const AdoptionError({required this.message});

  @override
  List<Object> get props => [message];
}

class ApplicationsLoaded extends AdoptionState {
  final List<AdoptionApplication> applications;

  const ApplicationsLoaded({required this.applications});

  @override
  List<Object> get props => [applications];
}

class ApplicationStatusUpdated extends AdoptionState {
  final String message;

  const ApplicationStatusUpdated({required this.message});

  @override
  List<Object> get props => [message];
}
