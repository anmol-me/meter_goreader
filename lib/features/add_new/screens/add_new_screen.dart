import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

final selectedReadingTimeProvider = StateProvider.autoDispose<String?>((ref) {
  return null;
});

final selectedReadingDateProvider = StateProvider.autoDispose<String?>((ref) {
  return null;
});

class AddNewScreen extends HookConsumerWidget {
  const AddNewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedReadingTime = ref.watch(selectedReadingTimeProvider);

    final formKey = useMemoized(GlobalKey<FormState>.new, const []);

    final amountController = useTextEditingController();
    final descriptionController = useTextEditingController();

    String? valid(
      String? value, {
      String message = 'Please enter some text',
    }) {
      if (value == null || value.isEmpty) {
        return 'Please enter some text';
      }
      return null;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Reading',
          style: TextStyle(color: Colors.blueGrey.shade900),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Reading Time',
                  ),
                  value: selectedReadingTime,
                  items: const <DropdownMenuItem<String>>[
                    DropdownMenuItem(
                      value: 'morning',
                      child: Text('Morning'),
                    ),
                    DropdownMenuItem(
                      value: 'evening',
                      child: Text('Evening'),
                    ),
                  ],
                  onChanged: (val) {
                    ref
                        .read(selectedReadingTimeProvider.notifier)
                        .update((state) => val!);
                    print(ref.read(selectedReadingTimeProvider));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Select Date',
                  ),
                  value: selectedReadingTime,
                  iconDisabledColor: Colors.transparent,
                  iconEnabledColor: Colors.transparent,
                  items: const <DropdownMenuItem<String>>[],
                  onChanged: (val) {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Select Time',
                  ),
                  value: selectedReadingTime,
                  iconDisabledColor: Colors.transparent,
                  iconEnabledColor: Colors.transparent,
                  items: const <DropdownMenuItem<String>>[],
                  onChanged: (val) {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: TextFormField(
                  controller: amountController,
                  decoration: const InputDecoration(
                    labelText: 'Reading',
                  ),
                  validator: valid,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Select Image',
                  ),
                  value: selectedReadingTime,
                  iconDisabledColor: Colors.transparent,
                  iconEnabledColor: Colors.transparent,
                  items: const <DropdownMenuItem<String>>[],
                  onChanged: (val) {},
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: TextFormField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                    alignLabelWithHint: true,
                  ),
                  validator: valid,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                    }
                  },
                  child: const Text('Add'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
