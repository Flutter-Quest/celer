import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:chalkdart/chalk.dart';

class ColoredScoreEmitter implements ScoreEmitter {
  final num red;
  final num green;
  final num blue;

  ColoredScoreEmitter(this.red, this.green, this.blue);

  @override
  void emit(String testName, double value) {
    print(chalk.rgb(red, green, blue)('$testName(Runtime): $value us.'));
  }
}
