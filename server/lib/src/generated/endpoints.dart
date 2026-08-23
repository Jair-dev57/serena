/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../auth/email_idp_endpoint.dart' as _i2;
import '../auth/jwt_refresh_endpoint.dart' as _i3;
import '../endpoints/block_entry_endpoint.dart' as _i4;
import '../endpoints/difficult_word_endpoint.dart' as _i5;
import '../endpoints/exercise_progress_endpoint.dart' as _i6;
import '../endpoints/practice_session_endpoint.dart' as _i7;
import '../greetings/greeting_endpoint.dart' as _i8;
import 'package:serena_poc_server/src/generated/block_severity.dart' as _i9;
import 'package:serena_poc_server/src/generated/block_context.dart' as _i10;
import 'package:serena_poc_server/src/generated/block_entry.dart' as _i11;
import 'package:serena_poc_server/src/generated/difficult_word.dart' as _i12;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i13;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i14;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'emailIdp': _i2.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _i3.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'blockEntry': _i4.BlockEntryEndpoint()
        ..initialize(
          server,
          'blockEntry',
          null,
        ),
      'difficultWord': _i5.DifficultWordEndpoint()
        ..initialize(
          server,
          'difficultWord',
          null,
        ),
      'exerciseProgress': _i6.ExerciseProgressEndpoint()
        ..initialize(
          server,
          'exerciseProgress',
          null,
        ),
      'practiceSession': _i7.PracticeSessionEndpoint()
        ..initialize(
          server,
          'practiceSession',
          null,
        ),
      'greeting': _i8.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
    };
    connectors['emailIdp'] = _i1.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint).login(
                session,
                email: params['email'],
                password: params['password'],
              ),
        ),
        'startRegistration': _i1.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _i1.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _i1.ParameterDescription(
              name: 'accountRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _i1.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _i1.ParameterDescription(
              name: 'registrationToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _i1.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _i1.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _i1.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _i1.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _i1.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newPassword': _i1.ParameterDescription(
              name: 'newPassword',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
        'hasAccount': _i1.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['jwtRefresh'] = _i1.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _i1.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _i1.ParameterDescription(
              name: 'refreshToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['jwtRefresh'] as _i3.JwtRefreshEndpoint)
                  .refreshAccessToken(
                    session,
                    refreshToken: params['refreshToken'],
                  ),
        ),
      },
    );
    connectors['blockEntry'] = _i1.EndpointConnector(
      name: 'blockEntry',
      endpoint: endpoints['blockEntry']!,
      methodConnectors: {
        'getAllEntries': _i1.MethodConnector(
          name: 'getAllEntries',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['blockEntry'] as _i4.BlockEntryEndpoint)
                  .getAllEntries(session),
        ),
        'createEntry': _i1.MethodConnector(
          name: 'createEntry',
          params: {
            'dateTime': _i1.ParameterDescription(
              name: 'dateTime',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
            'severity': _i1.ParameterDescription(
              name: 'severity',
              type: _i1.getType<_i9.BlockSeverity>(),
              nullable: false,
            ),
            'context': _i1.ParameterDescription(
              name: 'context',
              type: _i1.getType<_i10.BlockContext>(),
              nullable: false,
            ),
            'note': _i1.ParameterDescription(
              name: 'note',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['blockEntry'] as _i4.BlockEntryEndpoint)
                  .createEntry(
                    session,
                    params['dateTime'],
                    params['severity'],
                    params['context'],
                    params['note'],
                  ),
        ),
        'updateEntry': _i1.MethodConnector(
          name: 'updateEntry',
          params: {
            'entry': _i1.ParameterDescription(
              name: 'entry',
              type: _i1.getType<_i11.BlockEntry>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['blockEntry'] as _i4.BlockEntryEndpoint)
                  .updateEntry(
                    session,
                    params['entry'],
                  ),
        ),
        'deleteEntry': _i1.MethodConnector(
          name: 'deleteEntry',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['blockEntry'] as _i4.BlockEntryEndpoint)
                  .deleteEntry(
                    session,
                    params['id'],
                  ),
        ),
      },
    );
    connectors['difficultWord'] = _i1.EndpointConnector(
      name: 'difficultWord',
      endpoint: endpoints['difficultWord']!,
      methodConnectors: {
        'getAllWords': _i1.MethodConnector(
          name: 'getAllWords',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['difficultWord'] as _i5.DifficultWordEndpoint)
                      .getAllWords(session),
        ),
        'createWord': _i1.MethodConnector(
          name: 'createWord',
          params: {
            'word': _i1.ParameterDescription(
              name: 'word',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'note': _i1.ParameterDescription(
              name: 'note',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['difficultWord'] as _i5.DifficultWordEndpoint)
                      .createWord(
                        session,
                        params['word'],
                        params['note'],
                      ),
        ),
        'updateWord': _i1.MethodConnector(
          name: 'updateWord',
          params: {
            'word': _i1.ParameterDescription(
              name: 'word',
              type: _i1.getType<_i12.DifficultWord>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['difficultWord'] as _i5.DifficultWordEndpoint)
                      .updateWord(
                        session,
                        params['word'],
                      ),
        ),
        'deleteWord': _i1.MethodConnector(
          name: 'deleteWord',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['difficultWord'] as _i5.DifficultWordEndpoint)
                      .deleteWord(
                        session,
                        params['id'],
                      ),
        ),
      },
    );
    connectors['exerciseProgress'] = _i1.EndpointConnector(
      name: 'exerciseProgress',
      endpoint: endpoints['exerciseProgress']!,
      methodConnectors: {
        'getAllProgress': _i1.MethodConnector(
          name: 'getAllProgress',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['exerciseProgress']
                          as _i6.ExerciseProgressEndpoint)
                      .getAllProgress(session),
        ),
        'getProgressForExercise': _i1.MethodConnector(
          name: 'getProgressForExercise',
          params: {
            'exerciseId': _i1.ParameterDescription(
              name: 'exerciseId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['exerciseProgress']
                          as _i6.ExerciseProgressEndpoint)
                      .getProgressForExercise(
                        session,
                        params['exerciseId'],
                      ),
        ),
        'incrementProgress': _i1.MethodConnector(
          name: 'incrementProgress',
          params: {
            'exerciseId': _i1.ParameterDescription(
              name: 'exerciseId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['exerciseProgress']
                          as _i6.ExerciseProgressEndpoint)
                      .incrementProgress(
                        session,
                        params['exerciseId'],
                      ),
        ),
      },
    );
    connectors['practiceSession'] = _i1.EndpointConnector(
      name: 'practiceSession',
      endpoint: endpoints['practiceSession']!,
      methodConnectors: {
        'getAllSessions': _i1.MethodConnector(
          name: 'getAllSessions',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['practiceSession'] as _i7.PracticeSessionEndpoint)
                      .getAllSessions(session),
        ),
        'insertSession': _i1.MethodConnector(
          name: 'insertSession',
          params: {
            'exerciseTitle': _i1.ParameterDescription(
              name: 'exerciseTitle',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'date': _i1.ParameterDescription(
              name: 'date',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['practiceSession'] as _i7.PracticeSessionEndpoint)
                      .insertSession(
                        session,
                        params['exerciseTitle'],
                        params['date'],
                      ),
        ),
        'getCurrentStreak': _i1.MethodConnector(
          name: 'getCurrentStreak',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['practiceSession'] as _i7.PracticeSessionEndpoint)
                      .getCurrentStreak(session),
        ),
      },
    );
    connectors['greeting'] = _i1.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _i1.MethodConnector(
          name: 'hello',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['greeting'] as _i8.GreetingEndpoint).hello(
                session,
                params['name'],
              ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _i13.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _i14.Endpoints()
      ..initializeEndpoints(server);
  }
}
