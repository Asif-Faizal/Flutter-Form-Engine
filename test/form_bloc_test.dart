import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_form_engine/flutter_form_engine.dart';

void main() {
  const validator = BuiltInValidator();
  const conditionalEngine = ConditionalEngine();

  final combinedSchema = FormSchema.fromMap({
    'id': 'combined_demo',
    'title': 'Combined demo',
    'fields': [
      {
        'key': 'full_name',
        'type': 'text',
        'label': 'Full name',
        'validations': [
          {'rule': 'required', 'message': 'Name is required'},
        ],
      },
      {
        'key': 'country',
        'type': 'dropdown',
        'label': 'Country',
        'validations': [
          {'rule': 'required', 'message': 'Select a country'},
        ],
        'options': [
          {'label': 'India', 'value': 'IN'},
        ],
      },
      {
        'key': 'category',
        'type': 'dropdown',
        'label': 'Category',
        'dependsOn': {
          'field': 'country',
          'condition': 'notEmpty',
          'action': 'show',
          'clearOnHide': true,
        },
        'validations': [
          {'rule': 'required', 'message': 'Select a category'},
        ],
        'options': [
          {'label': 'Technology', 'value': 'tech'},
        ],
      },
      {
        'key': 'notes',
        'type': 'text',
        'label': 'Notes',
        'dependsOn': {
          'field': 'category',
          'condition': 'equals',
          'value': 'other',
          'action': 'show',
          'clearOnHide': true,
        },
        'validations': [
          {'rule': 'required', 'message': 'Please specify'},
        ],
      },
    ],
  });

  blocTest<FormEngineBloc, FormEngineState>(
    'submit succeeds when hidden conditional fields are empty',
    build: () => FormEngineBloc(
      validator: validator,
      conditionalEngine: conditionalEngine,
      onSubmit: (_) {},
    ),
    act: (bloc) async {
      bloc.add(FormSchemaLoaded(combinedSchema));
      await Future<void>.delayed(Duration.zero);
      bloc
        ..add(const FormFieldChanged(key: 'full_name', value: 'Jane Doe'))
        ..add(const FormFieldChanged(key: 'country', value: 'IN'))
        ..add(const FormFieldChanged(key: 'category', value: 'tech'))
        ..add(const FormSubmitRequested());
      await Future<void>.delayed(Duration.zero);
    },
    verify: (bloc) {
      expect(bloc.state.submitStatus, FormSubmitStatus.success);
      expect(bloc.state.errors['notes'], isNull);
      expect(bloc.state.errors['category'], isNull);
    },
  );
}
