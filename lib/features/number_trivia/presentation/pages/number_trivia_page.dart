import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../bloc/number_trivia_bloc.dart';
import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: SingleChildScrollView(
        child: BlocProvider(
          create: (_) => sl<NumberTriviaBloc>(),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                  builder: ((context, state) {
                    if (state is Empty) {
                      return const MessageDisplay(
                        message: "Start searching",
                      );
                    } else if (state is Loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is Loaded) {
                      return TriviaDisplay(
                          numberTriviaEntity: state.triviaEntity);
                    } else if (state is Error) {
                      return MessageDisplay(
                        message: state.errorMessage,
                      );
                    }
                    return Container();
                  }),
                ),
                const SizedBox(
                  height: 20,
                ),
                const TriviaControls(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
