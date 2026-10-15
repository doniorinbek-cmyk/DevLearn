import 'package:flutter/material.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final PageController controller = PageController();
  int currentPage = 0;

  final List<Map<String, dynamic>> pages = [
    {
      'icon': Icons.school,
      'title': 'Учись новому',
      'description': 'Изучай Flutter и другие технологии.',
    },
    {
      'icon': Icons.code,
      'title': 'Пиши код',
      'description': 'Закрепляй знания на практике.',
    },
    {
      'icon': Icons.rocket_launch,
      'title': 'Создавай проекты',
      'description': 'Превращай свои идеи в приложения.',
    },
  ];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Знакомство с DevLearn')),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: controller,
              itemCount: pages.length,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final page = pages[index];

                return Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        page['icon'] as IconData,
                        size: 100,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 30),
                      Text(
                        page['title'] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        page['description'] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Text('${currentPage + 1} из ${pages.length}'),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(20),
            child: FilledButton(
              onPressed: () {
                if (currentPage < pages.length - 1) {
                  controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else {
                  Navigator.pop(context);
                }
              },
              child: Text(
                currentPage < pages.length - 1
                    ? 'Далее'
                    : 'Завершить',
              ),
            ),
          ),
        ],
      ),
    );
  }
}