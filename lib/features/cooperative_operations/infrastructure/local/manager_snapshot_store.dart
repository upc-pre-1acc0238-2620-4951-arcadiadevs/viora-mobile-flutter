import 'dart:convert';

import 'package:viora/core/datastore/session_store.dart';
import 'package:viora/features/cooperative_operations/domain/valueobject/kept.dart';
import 'package:viora/features/cooperative_operations/infrastructure/local/manager_snapshot_dao.dart';

/// Keeps the last answer of each read for the signed-in account only: what another account kept
/// on the phone never shows. It is forgotten when the session or the license ends.
class ManagerSnapshotStore {
  ManagerSnapshotStore({required this.dao, required this.sessionStore, DateTime Function()? clock})
      : _clock = clock ?? DateTime.now;

  final ManagerSnapshotDao dao;
  final SessionStore sessionStore;
  final DateTime Function() _clock;

  /// Saves [json], the body of an answer just read. A failure to save never breaks the read.
  Future<void> keep(String readKey, Object? json) async {
    try {
      final userId = await sessionStore.userId();
      if (userId == null) return;
      await dao.keep(userId, readKey, jsonEncode(json), _clock());
    } on Object {
      // The screen already has the answer; only the copy for later is lost.
    }
  }

  /// The kept body of [readKey], decoded, or null when nothing was kept.
  Future<Kept<Object?>?> read(String readKey) async {
    final userId = await sessionStore.userId();
    if (userId == null) return null;
    final row = await dao.read(userId, readKey);
    return row == null ? null : Kept(jsonDecode(row.body), row.savedAt);
  }

  Future<void> clear() => dao.clear();
}
