import 'package:blood_line_desktop/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final bool showSearch;
  final Function(String)? onSearch; // Callback for search input

  const CustomHeader({
    Key? key,
    required this.title,
    this.showSearch = false,
    this.onSearch, // Pass search function
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(28),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (showSearch)
                SizedBox(
                  width: 438,
                  height: 40,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: const Icon(Icons.search),
                      fillColor: AppTheme.lightred,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: AppTheme.black, width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.only(left: 10, top: 10),
                    ),
                    onChanged: onSearch, // Trigger callback on text change
                  ),
                ),
            ],
          ),
        ),
        // Full-width divider without padding
        const Divider(
          color: Colors.grey,
          thickness: 1,
        ),
      ],
    );
  }
}
