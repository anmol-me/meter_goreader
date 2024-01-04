import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CustomDropdownButton extends StatelessWidget {
  const CustomDropdownButton({
    super.key,
    required this.selectedGraphDate,
    required this.onChanged,
  });

  final String? selectedGraphDate;
  final Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          customButton: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Icon(Icons.date_range),
                const SizedBox(width: 10),
                Text(selectedGraphDate ?? 'This Month'),
              ],
            ),
          ),
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(2),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 7,
                  spreadRadius: 7,
                  color: Colors.black12,
                ),
              ],
            ),
          ),
          isExpanded: true,
          iconStyleData: const IconStyleData(
            icon: SizedBox.shrink(),
          ),
          buttonStyleData: ButtonStyleData(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
            ),
          ),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

final dateKeyValues = {
  'item1': 'This Week',
  'item2': 'Last Week',
  'item3': 'This Month',
  'item4': 'Last Month',
  'item5': 'This Year',
  'item6': 'Custom',
};

List<DropdownMenuItem<String>> items = dateKeyValues.entries
    .map(
      (entry) => DropdownMenuItem(
        value: entry.key,
        child: Text(entry.value),
      ),
    )
    .toList();
