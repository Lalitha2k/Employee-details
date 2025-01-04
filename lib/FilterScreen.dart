import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  bool? isActive; 
  RangeValues experienceRange = RangeValues(0, 20); 
  DateTimeRange? joiningDateRange; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Filters',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
         backgroundColor: Color(0xFF607D8B),
        elevation: 4,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Active/Inactive 
            Text(
              'Active/Inactive',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Row(
              children: [
                Checkbox(
                  value: isActive == true,
                  onChanged: (value) {
                    setState(() {
                      isActive = value == true ? true : null;
                    });
                  },
                  activeColor: Colors.blueGrey,
                ),
                Text(
                  'Active',
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
                ),
                SizedBox(width: 10),
                Checkbox(
                  value: isActive == false,
                  onChanged: (value) {
                    setState(() {
                      isActive = value == true ? false : null;
                    });
                  },
                  activeColor: Colors.blueGrey, 
                ),
                Text(
                  'Inactive',
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
            SizedBox(height: 20),
            
            //  Slider
            Text(
              'Years of Experience',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            RangeSlider(
              values: experienceRange,
              min: 0,
              max: 30,
              divisions: 30,
              activeColor: const Color(0xFFB0BEC5), 
              inactiveColor: const Color(0xFFCFD8DC), 
              labels: RangeLabels(
                '${experienceRange.start.round()}',
                '${experienceRange.end.round()}',
              ),
              onChanged: (values) {
                setState(() {
                  experienceRange = values;
                });
              },
            ),
            Text(
              'Drag to select range',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 20),
            
            // Joining Date Range
            Text(
              'Joining Date',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF607D8B), 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
              onPressed: () async {
                DateTimeRange? picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  setState(() {
                    joiningDateRange = picked;
                  });
                }
              },
              child: Text(
                joiningDateRange == null
                    ? 'Select Date Range'
                    : '${joiningDateRange!.start.toString().split(' ')[0]} - ${joiningDateRange!.end.toString().split(' ')[0]}',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
              ),
            ),
            Spacer(),
            
            // Apply Filters Button
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF455A64), 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 30),
                  textStyle: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pop(context, {
                    'isActive': isActive,
                    'experienceRange': experienceRange,
                    'joiningDateRange': joiningDateRange,
                  });
                },
                child: Text('Apply Filters', style: GoogleFonts.poppins(
    fontSize: 18, 
    fontWeight: FontWeight.bold, 
    color: Colors.white,)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
