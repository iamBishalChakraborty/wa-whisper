import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';

class PhoneInput extends StatefulWidget {
  final void Function(String) onPhoneChanged;

  const PhoneInput({super.key, required this.onPhoneChanged});

  @override
  State<PhoneInput> createState() => _PhoneInputState();
}

class _PhoneInputState extends State<PhoneInput> {
  String _countryCode = '+91';
  // late Country _selectedCountry; // Unused field

  @override
  void initState() {
    super.initState();
    // _selectedCountry = Country( // Unused field
    //   phoneCode: '91',
    //   countryCode: 'IN',
    //   e164Sc: 0,
    //   geographic: true,
    //   level: 0,
    //   name: 'India',
    //   example: 'India',
    //   displayName: 'India (IN) [+91]',
    //   displayNameNoCountryCode: 'India (IN)',
    //   e164Key: '91-IN-0',
    // );
  }

  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _updatePhone() {
    if (_phoneController.text.isEmpty) return;
    final phone = '$_countryCode${_phoneController.text.trim()}';
    widget.onPhoneChanged(phone);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 56, // Match TextField height
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade50,
          ),
          margin: const EdgeInsets.only(right: 8),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                showCountryPicker(
                  context: context,
                  showPhoneCode: true,
                  favorite: const ['IN', 'US', 'GB'],
                  countryListTheme: CountryListThemeData(
                    borderRadius: BorderRadius.circular(12),
                    inputDecoration: InputDecoration(
                      hintText: 'Search country',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                  ),
                  onSelect: (Country country) {
                    if (!mounted) return;
                    setState(() {
                      // _selectedCountry = country; // Unused field
                      _countryCode = '+${country.phoneCode}';
                    });
                    _updatePhone();
                  },
                );
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _countryCode,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_drop_down,
                        size: 20, color: colorScheme.primary),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: 'Phone Number',
              prefixIcon: Icon(Icons.phone,
                  color: colorScheme.primary.withAlpha((255 * 0.7).round())),
              helperText: 'Enter number without country code',
              helperStyle: TextStyle(
                color: colorScheme.onSurfaceVariant,
                overflow: TextOverflow.ellipsis, // Added overflow
                // softWrap is implicitly true for helperText if it needs to wrap,
                // but explicitly setting maxLines is better.
              ),
              helperMaxLines: 2, // Added helperMaxLines for TextField
            ),
            onChanged: (_) => _updatePhone(),
          ),
        ),
      ],
    );
  }
}
