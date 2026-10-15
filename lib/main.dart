import 'package:flutter/material.dart';

void main() {
  runApp(const DevLearnApp());
}

// ГЛАВНОЕ ПРИЛОЖЕНИЕ
class DevLearnApp extends StatefulWidget {
  const DevLearnApp({super.key});

  @override
  State<DevLearnApp> createState() => _DevLearnAppState();
}

class _DevLearnAppState extends State<DevLearnApp> {
  ThemeMode themeMode = ThemeMode.light;

  void changeTheme() {
    setState(() {
      themeMode = themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DevLearn',
      themeMode: themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F6FA),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),

      // Именованные маршруты
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(
              onThemeChanged: changeTheme,
              isDark: themeMode == ThemeMode.dark,
            ),
        '/intro': (context) => const IntroPage(),
      },

      // Передача параметров через arguments
      onGenerateRoute: (settings) {
        if (settings.name == '/course') {
          final course =
              settings.arguments as Map<String, dynamic>;

          return MaterialPageRoute(
            builder: (context) => CoursePage(course: course),
          );
        }
        return null;
      },
    );
  }
}

// ГЛАВНАЯ СТРАНИЦА
class HomePage extends StatefulWidget {
  final VoidCallback onThemeChanged;
  final bool isDark;

  const HomePage({
    super.key,
    required this.onThemeChanged,
    required this.isDark,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  String selectedCategory = 'Все';

  final List<String> categories = [
    'Все',
    'Flutter',
    'Python',
    'Web',
  ];

  final List<Map<String, dynamic>> courses = [
    {
      'title': 'Основы Flutter',
      'description': 'Создание приложений с нуля',
      'icon': Icons.phone_android,
      'color': Colors.blue,
      'category': 'Flutter',
      'lessons': 12,
    },
    {
      'title': 'Python для начинающих',
      'description': 'Изучаем программирование',
      'icon': Icons.code,
      'color': Colors.green,
      'category': 'Python',
      'lessons': 18,
    },
    {
      'title': 'Веб-разработка',
      'description': 'HTML, CSS и JavaScript',
      'icon': Icons.language,
      'color': Colors.orange,
      'category': 'Web',
      'lessons': 15,
    },
  ];

  final List<Map<String, dynamic>> favorites = [];

  @override
  Widget build(BuildContext context) {
    final visibleCourses = selectedCategory == 'Все'
        ? courses
        : courses
            .where((course) =>
                course['category'] == selectedCategory)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DevLearn',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Знакомство с приложением',
            icon: const Icon(Icons.slideshow),
            onPressed: () {
              Navigator.pushNamed(context, '/intro');
            },
          ),
          IconButton(
            tooltip: 'Профиль',
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              setState(() => selectedIndex = 3);
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: [
          buildHome(visibleCourses),
          buildCatalog(visibleCourses),
          buildFavorites(),
          buildProfile(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() => selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Главная',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Курсы',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: 'Избранное',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }

  // ГЛАВНАЯ: Container, BoxDecoration, Column, Row, ListView
  Widget buildHome(List<Map<String, dynamic>> visibleCourses) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF246BFD),
                Color(0xFF7048E8),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Привет, разработчик!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Изучай новое и создавай собственные приложения.',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              SizedBox(height: 18),
              Icon(
                Icons.rocket_launch,
                color: Colors.white,
                size: 42,
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        const Text(
          'Направления обучения',
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 42,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: categories.map((category) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(category),
                  selected: selectedCategory == category,
                  onSelected: (_) {
                    setState(() => selectedCategory = category);
                  },
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 22),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Популярные курсы',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () => setState(() => selectedIndex = 1),
              child: const Text('Все курсы'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...visibleCourses.map((course) => buildCourseCard(course)),
      ],
    );
  }

  // КАТАЛОГ: GridView
  Widget buildCatalog(List<Map<String, dynamic>> visibleCourses) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Каталог курсов',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: visibleCourses.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            final course = visibleCourses[index];

            return InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => openCourse(course),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      course['icon'] as IconData,
                      color: course['color'] as Color,
                      size: 36,
                    ),
                    const Spacer(),
                    Text(
                      course['title'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('${course['lessons']} уроков'),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // КАРТОЧКА КУРСА И ДОБАВЛЕНИЕ В ИЗБРАННОЕ
  Widget buildCourseCard(Map<String, dynamic> course) {
    final isFavorite = favorites.contains(course);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
       leading: CircleAvatar(
  backgroundColor: (course['color'] as Color).withAlpha(30),
  child: Icon(
    course['icon'] as IconData,
    color: course['color'] as Color,
  ),
),
        title: Text(
          course['title'] as String,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(course['description'] as String),
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.grey,
          ),
          onPressed: () {
            setState(() {
              if (isFavorite) {
                favorites.remove(course);
              } else {
                favorites.add(course);
              }
            });
          },
        ),
        onTap: () => openCourse(course),
      ),
    );
  }

  // ИЗБРАННОЕ
  Widget buildFavorites() {
    if (favorites.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_border, size: 64, color: Colors.grey),
            SizedBox(height: 12),
            Text('Пока нет избранных курсов'),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Избранное',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...favorites.map((course) => buildCourseCard(course)),
      ],
    );
  }

  // ПРОФИЛЬ И ПЕРЕКЛЮЧЕНИЕ ТЕМЫ
  Widget buildProfile() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const CircleAvatar(
          radius: 45,
          child: Icon(Icons.person, size: 48),
        ),
        const SizedBox(height: 18),
        const Center(
          child: Text(
            'Мой профиль',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        const Center(
          child: Text('Продолжай изучать программирование!'),
        ),
        const SizedBox(height: 28),
        SwitchListTile(
          secondary: const Icon(Icons.dark_mode_outlined),
          title: const Text('Тёмная тема'),
          subtitle: const Text('Изменить оформление приложения'),
          value: widget.isDark,
          onChanged: (_) => widget.onThemeChanged(),
        ),
        ListTile(
          leading: const Icon(Icons.school_outlined),
          title: const Text('Мои курсы'),
          subtitle: const Text('Твой путь в разработке'),
          onTap: () => setState(() => selectedIndex = 1),
        ),
        const ListTile(
          leading: Icon(Icons.info_outline),
          title: Text('О приложении'),
          subtitle: Text('DevLearn — обучение программированию'),
        ),
      ],
    );
  }

  // ИМЕНОВАННЫЙ МАРШРУТ + ARGUMENTS
  void openCourse(Map<String, dynamic> course) {
    Navigator.pushNamed(
      context,
      '/course',
      arguments: course,
    );
  }
}

// СТРАНИЦА КУРСА
class CoursePage extends StatelessWidget {
  final Map<String, dynamic> course;

  const CoursePage({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('О курсе')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Stack и Positioned
          Stack(
            children: [
              Container(
                height: 190,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: (course['color'] as Color).withAlpha(35),
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              Positioned(
                right: 18,
                top: 18,
                child: Icon(
                  course['icon'] as IconData,
                  color: course['color'] as Color,
                  size: 90,
                ),
              ),
              const Positioned(
                left: 18,
                bottom: 18,
                child: Text(
                  'DEVLEARN',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            course['title'] as String,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            course['description'] as String,
            style: const TextStyle(fontSize: 17),
          ),
          const SizedBox(height: 20),
          Text('Количество уроков: ${course['lessons']}'),
          const SizedBox(height: 12),
          const Text(
            'В этом курсе ты познакомишься с основами программирования '
            'и научишься создавать собственные проекты.',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 28),
          FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Ты готов начать обучение!'),
                ),
              );
            },
            icon: const Icon(Icons.play_arrow),
            label: const Text('Начать обучение'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Назад к курсам'),
          ),
        ],
      ),
    );
  }
}

// PAGEVIEW: СТРАНИЦЫ С ПЕРЕЛИСТЫВАНИЕМ
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
      'description': 'Превращай идеи в приложения.',
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
                setState(() => currentPage = index);
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