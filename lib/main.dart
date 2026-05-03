import 'package:flutter/material.dart';

void main() {
  runApp(const BMICalculatorApp());
}

// ==================== APP ====================
class BMICalculatorApp extends StatelessWidget {
  const BMICalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Premium BMI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A), // Slate 900
        primaryColor: const Color(0xFF3B82F6), // Blue 500
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF3B82F6),
          secondary: Color(0xFF8B5CF6), // Purple 500
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
            color: Colors.white,
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

enum Gender { male, female }

// ==================== HOME SCREEN ====================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Gender? _selectedGender;
  double _height = 170;
  double _weight = 60.0;
  double _age = 25.0;

  void _calculate() {
    if (_selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Please select your gender first',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFFEF4444), // Red 500
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: const EdgeInsets.all(20),
        ),
      );
      return;
    }

    double heightInMeters = _height / 100;
    double bmi = _weight / (heightInMeters * heightInMeters);

    String category;
    String description;
    Color categoryColor;

    if (bmi < 18.5) {
      category = 'UNDERWEIGHT';
      description = 'You have a lower than normal body weight. You can eat a bit more.';
      categoryColor = const Color(0xFF60A5FA); // Blue 400
    } else if (bmi < 25) {
      category = 'NORMAL';
      description = 'You have a normal body weight. Good job!';
      categoryColor = const Color(0xFF4ADE80); // Green 400
    } else if (bmi < 30) {
      category = 'OVERWEIGHT';
      description = 'You have a higher than normal body weight. Try to exercise more.';
      categoryColor = const Color(0xFFFBBF24); // Amber 400
    } else {
      category = 'OBESE';
      description = 'You have a much higher than normal body weight. Consider consulting a doctor.';
      categoryColor = const Color(0xFFEF4444); // Red 500
    }

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ResultScreen(
          bmi: bmi,
          category: category,
          description: description,
          categoryColor: categoryColor,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI CALCULATOR'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              // 1. Gender Selection Row
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: GenderCard(
                        icon: Icons.female_rounded,
                        label: 'FEMALE',
                        isSelected: _selectedGender == Gender.female,
                        onTap: () => setState(() => _selectedGender = Gender.female),
                        activeColor: const Color(0xFFEC4899), // Pink 500
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: GenderCard(
                        icon: Icons.male_rounded,
                        label: 'MALE',
                        isSelected: _selectedGender == Gender.male,
                        onTap: () => setState(() => _selectedGender = Gender.male),
                        activeColor: const Color(0xFF3B82F6), // Blue 500
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 2. Height Card
              Expanded(
                child: HeightCard(
                  height: _height,
                  onChanged: (value) => setState(() => _height = value),
                ),
              ),
              const SizedBox(height: 20),

              // 3. Weight & Age Row
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: CounterCard(
                        label: 'WEIGHT',
                        value: _weight,
                        onDecrement: () => setState(() {
                          if (_weight > 0) _weight -= 0.5;
                        }),
                        onIncrement: () => setState(() => _weight += 0.5),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: CounterCard(
                        label: 'AGE',
                        value: _age,
                        isInteger: true,
                        onDecrement: () => setState(() {
                          if (_age > 0) _age -= 1;
                        }),
                        onIncrement: () => setState(() => _age += 1),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // 4. Calculate Button
              Container(
                height: 70,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFF3B82F6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3B82F6).withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _calculate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'CALCULATE',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== RESULT SCREEN ====================
class ResultScreen extends StatelessWidget {
  final double bmi;
  final String category;
  final String description;
  final Color categoryColor;

  const ResultScreen({
    super.key,
    required this.bmi,
    required this.category,
    required this.description,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YOUR RESULT'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B), // Slate 800
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        category,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: categoryColor,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        bmi.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 100,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                height: 70,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFF3B82F6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3B82F6).withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'RE-CALCULATE',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== GENDER CARD WIDGET ====================
class GenderCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color activeColor;

  const GenderCard({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withOpacity(0.15) : const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? activeColor : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: activeColor.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 70,
              color: isSelected ? activeColor : Colors.white60,
            ),
            const SizedBox(height: 15),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isSelected ? activeColor : Colors.white60,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== HEIGHT CARD WIDGET ====================
class HeightCard extends StatelessWidget {
  final double height;
  final ValueChanged<double> onChanged;

  const HeightCard({
    super.key,
    required this.height,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'HEIGHT',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white60,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                height.toInt().toString(),
                style: const TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 5),
              const Text(
                'cm',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white60,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: const Color(0xFF8B5CF6),
                inactiveTrackColor: Colors.white12,
                thumbColor: const Color(0xFF3B82F6),
                overlayColor: const Color(0xFF3B82F6).withOpacity(0.2),
                trackHeight: 6.0,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 15.0),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 30.0),
              ),
              child: Slider(
                value: height,
                min: 100,
                max: 220,
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== COUNTER CARD WIDGET ====================
class CounterCard extends StatelessWidget {
  final String label;
  final double value;
  final bool isInteger;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const CounterCard({
    super.key,
    required this.label,
    required this.value,
    this.isInteger = false,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white60,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            isInteger || value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoundButton(
                icon: Icons.remove_rounded,
                onTap: onDecrement,
              ),
              const SizedBox(width: 15),
              RoundButton(
                icon: Icons.add_rounded,
                onTap: onIncrement,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ==================== ROUND BUTTON WIDGET ====================
class RoundButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const RoundButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: const Color(0xFF334155), // Slate 700
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          splashColor: const Color(0xFF8B5CF6).withOpacity(0.3),
          highlightColor: Colors.transparent,
          child: Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            child: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}