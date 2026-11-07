import 'package:viora/features/cooperative_operations/domain/entity/cooperative_member.dart';
import 'package:viora/features/cooperative_operations/domain/entity/invitation_code.dart';
import 'package:viora/features/cooperative_operations/domain/entity/license_capacity.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';

/// The chips over the roster of G40.
enum MembersFilter { all, sharing, withdrawn }

/// G40 · Socios: the license, the codes to redeem and the roster.
class MembersUiState {
  const MembersUiState({
    this.loading = true,
    this.failure,
    this.capacity,
    this.members = const [],
    this.availableCodes = const [],
    this.query = '',
    this.filter = MembersFilter.all,
  });

  final bool loading;
  final CooperativeFailure? failure;
  final LicenseCapacity? capacity;
  final List<CooperativeMember> members;
  final List<InvitationCode> availableCodes;
  final String query;
  final MembersFilter filter;

  int get sharingCount => members.where((m) => m.sharing == MemberSharing.sharing).length;

  int get withdrawnCount => members.where((m) => m.sharing == MemberSharing.withdrawn).length;

  /// The members the chips and the search leave, by name or sector, ignoring case.
  List<CooperativeMember> get visibleMembers {
    final text = query.trim().toLowerCase();
    return members.where((member) {
      final kept = switch (filter) {
        MembersFilter.all => true,
        MembersFilter.sharing => member.sharing == MemberSharing.sharing,
        MembersFilter.withdrawn => member.sharing == MemberSharing.withdrawn,
      };
      if (!kept || text.isEmpty) return kept;
      return member.fullName.toLowerCase().contains(text) ||
          member.sectorNames.any((sector) => sector.toLowerCase().contains(text));
    }).toList();
  }

  /// The codes to redeem that expire first, and their day: the yellow card of G40.
  ({int count, DateTime date})? get soonestExpiry {
    if (availableCodes.isEmpty) return null;
    final first = availableCodes.map((code) => code.expiresAt).reduce((a, b) => a.isBefore(b) ? a : b);
    final local = first.toLocal();
    bool sameDay(DateTime date) {
      final day = date.toLocal();
      return day.year == local.year && day.month == local.month && day.day == local.day;
    }

    return (count: availableCodes.where((code) => sameDay(code.expiresAt)).length, date: first);
  }

  MembersUiState copyWith({
    bool? loading,
    CooperativeFailure? Function()? failure,
    LicenseCapacity? capacity,
    List<CooperativeMember>? members,
    List<InvitationCode>? availableCodes,
    String? query,
    MembersFilter? filter,
  }) =>
      MembersUiState(
        loading: loading ?? this.loading,
        failure: failure != null ? failure() : this.failure,
        capacity: capacity ?? this.capacity,
        members: members ?? this.members,
        availableCodes: availableCodes ?? this.availableCodes,
        query: query ?? this.query,
        filter: filter ?? this.filter,
      );
}
