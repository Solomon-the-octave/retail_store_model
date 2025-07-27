import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(PricePredictionApp());
}

class PricePredictionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Price Predictor',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFFFF6B35, {
          50: Color(0xFFFFF4F1),
          100: Color(0xFFFFE4DC),
          200: Color(0xFFFFCBB8),
          300: Color(0xFFFFB194),
          400: Color(0xFFFF8B5A),
          500: Color(0xFFFF6B35),
          600: Color(0xFFE55A2B),
          700: Color(0xFFCC4D1F),
          800: Color(0xFFB24015),
          900: Color(0xFF99330B),
        }),
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
    
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFFFF6B35), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red[400]!, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red[400]!, width: 2),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFF6B35),
            foregroundColor: Colors.white,
            elevation: 4,
            shadowColor: Color(0xFFFF6B35).withOpacity(0.3),
          ),
        ),
      ),
      home: PricePredictionScreen(),
    );
  }
}

class PricePredictionScreen extends StatefulWidget {
  @override
  _PricePredictionScreenState createState() => _PricePredictionScreenState();
}

class _PricePredictionScreenState extends State<PricePredictionScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late AnimationController _resultAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _resultScaleAnimation;

  // Form controllers
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _inventoryController = TextEditingController();
  final TextEditingController _unitsSoldController = TextEditingController();
  final TextEditingController _unitsOrderedController = TextEditingController();
  final TextEditingController _demandForecastController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _weatherController = TextEditingController();
  final TextEditingController _holidayController = TextEditingController();
  final TextEditingController _seasonalityController = TextEditingController();
  final TextEditingController _competitorPricingController = TextEditingController();

  double? predictedPrice;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    _resultAnimationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));
    
    _resultScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _resultAnimationController, curve: Curves.elasticOut),
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _resultAnimationController.dispose();
    // Dispose controllers
    _dateController.dispose();
    _categoryController.dispose();
    _regionController.dispose();
    _inventoryController.dispose();
    _unitsSoldController.dispose();
    _unitsOrderedController.dispose();
    _demandForecastController.dispose();
    _discountController.dispose();
    _weatherController.dispose();
    _holidayController.dispose();
    _seasonalityController.dispose();
    _competitorPricingController.dispose();
    super.dispose();
  }

  Future<void> predictPrice() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      predictedPrice = null;
    });

    _resultAnimationController.reset();

    try {
      final response = await http.post(
        Uri.parse('http://172.16.17.0:8000/predict_price'),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'Date': _dateController.text,
          'Category': _categoryController.text,
          'Region': _regionController.text,
          'Inventory_Level': int.tryParse(_inventoryController.text.replaceAll(',', '')) ?? 0,
          'Units_Sold': int.tryParse(_unitsSoldController.text.replaceAll(',', '')) ?? 0,
          'Units_Ordered': int.tryParse(_unitsOrderedController.text.replaceAll(',', '')) ?? 0,
          'Demand_Forecast': int.tryParse(_demandForecastController.text.replaceAll(',', '')) ?? 0,
          'Discount': double.tryParse(_discountController.text.replaceAll(',', '')) ?? 0.0,
          'Weather_Condition': _weatherController.text,
          'Holiday_Promotion': int.tryParse(_holidayController.text.replaceAll(',', '')) ?? 0,
          'Seasonality': _seasonalityController.text,
          'Competitor_Pricing': double.tryParse(_competitorPricingController.text.replaceAll(',', '')) ?? 0.0,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          predictedPrice = data['predicted_price']?.toDouble();
        });
        _resultAnimationController.forward();
      } else {
        _showError('Failed to get prediction. Status: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Network error: Please check your connection');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isNumber = false, bool isFloat = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? (isFloat ? TextInputType.numberWithOptions(decimal: true) : TextInputType.number) : TextInputType.text,
        inputFormatters: isNumber ? [
          if (!isFloat) FilteringTextInputFormatter.digitsOnly,
          if (isFloat) FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
        ] : null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500),
          prefixIcon: Icon(
            isNumber ? Icons.numbers : Icons.text_fields,
            color: Color(0xFFFF6B35),
            size: 20,
          ),
          suffixIcon: isNumber && controller.text.isNotEmpty
              ? Icon(Icons.check_circle, color: Colors.green[600], size: 20)
              : null,
        ),
        style: TextStyle(
          color: Colors.grey[800],
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          if (isNumber) {
            final numValue = isFloat 
                ? double.tryParse(value.replaceAll(',', ''))
                : int.tryParse(value.replaceAll(',', ''));
            if (numValue == null) {
              return 'Please enter a valid ${isFloat ? 'decimal' : 'whole'} number';
            }
          }
          return null;
        },
        onChanged: (value) {
          if (isNumber && value.isNotEmpty) {
            setState(() {}); // Trigger rebuild to show check icon
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.grey[50]!,
              Colors.grey[100]!,
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Color(0xFFFF6B35).withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.analytics_outlined,
                                size: 48,
                                color: Color(0xFFFF6B35),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Price Predictor',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                                letterSpacing: -0.5,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'AI-Powered Market Intelligence',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Form Card
                      Card(
                        elevation: 12,
                        shadowColor: Colors.grey.withOpacity(0.1),
                        child: Padding(
                          padding: EdgeInsets.all(28),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.input, color: Color(0xFFFF6B35)),
                                  SizedBox(width: 12),
                                  Text(
                                    'Market Data Input',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 24),
                              
                              _buildTextField('Date (YYYY-MM-DD)', _dateController),
                              _buildTextField('Category', _categoryController),
                              _buildTextField('Region', _regionController),
                              _buildTextField('Inventory Level', _inventoryController, isNumber: true),
                              _buildTextField('Units Sold', _unitsSoldController, isNumber: true),
                              _buildTextField('Units Ordered', _unitsOrderedController, isNumber: true),
                              _buildTextField('Demand Forecast', _demandForecastController, isNumber: true),
                              _buildTextField('Discount', _discountController, isNumber: true, isFloat: true),
                              _buildTextField('Weather Condition', _weatherController),
                              _buildTextField('Holiday Promotion (0 or 1)', _holidayController, isNumber: true),
                              _buildTextField('Seasonality', _seasonalityController),
                              _buildTextField('Competitor Pricing', _competitorPricingController, isNumber: true, isFloat: true),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 28),

                      // Predict Button
                      Container(
                        height: 64,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : predictPrice,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFF6B35),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 8,
                            shadowColor: Color(0xFFFF6B35).withOpacity(0.4),
                          ),
                          child: isLoading
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Text(
                                      'Analyzing Market Data...',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.psychology_outlined, size: 26),
                                    SizedBox(width: 12),
                                    Text(
                                      'Generate Prediction',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),

                      // Result Card
                      if (predictedPrice != null) ...[
                        SizedBox(height: 28),
                        ScaleTransition(
                          scale: _resultScaleAnimation,
                          child: Card(
                            elevation: 16,
                            shadowColor: Colors.green.withOpacity(0.2),
                            color: Colors.white,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.green.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              padding: EdgeInsets.all(32),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.trending_up,
                                      size: 40,
                                      color: Colors.green[600],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    'Predicted Price',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    '\$${predictedPrice!.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 42,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[700],
                                      letterSpacing: -1,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'Confidence: High',
                                      style: TextStyle(
                                        color: Colors.green[700],
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],

                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}