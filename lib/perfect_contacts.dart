library perfect_contacts;

import 'package:flutter/services.dart';

import 'package:permission_handler/permission_handler.dart';

part 'core/either/either.dart';

part 'data/repositories/contact_repository_impl.dart';

part 'domain/repositories/contact_repository.dart';

part 'domain/usecase/get_contacts_usecase.dart';

part 'perfect_contacts_plugin.dart';

part 'core/enums/contact_state_status.dart';

part 'core/error/failures.dart';

part 'core/state/contact_state.dart';

part 'data/models/contact_model.dart';

part 'data/sources/contact_method_channel.dart';

part 'domain/entities/contact.dart';
