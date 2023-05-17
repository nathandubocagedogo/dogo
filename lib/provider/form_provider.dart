// Flutter
import 'package:flutter/material.dart';

// Models
import 'package:dogo_final_app/models/provider/form_provider.dart';

class FormProvider extends ChangeNotifier {
  FormProviderModel dataModel = FormProviderModel(
    city: null,
  );
}
