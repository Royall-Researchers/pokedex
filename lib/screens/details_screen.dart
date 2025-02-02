import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../tabs/about.dart';
import '../tabs/base.dart';
import '../tabs/evaluation.dart';

class DetailsScreen extends StatelessWidget {
  final Pokemon pokemon;
  final ValueNotifier<bool> isLiked = ValueNotifier(false);

  DetailsScreen({super.key, required this.pokemon});

  Color getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'grass':
        return Colors.green;
      case 'fire':
        return Colors.red;
      case 'water':
        return Colors.blue;
      case 'electric':
        return Colors.yellow;
      case 'ground':
        return Colors.brown;
      default:
        return Colors.grey.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: getTypeColor(pokemon.type),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            ValueListenableBuilder<bool>(
              valueListenable: isLiked,
              builder: (context, value, child) {
                return IconButton(
                  icon: Icon(
                    value ? Icons.favorite : Icons.favorite_border,
                    color: value ? Colors.red : Colors.white,
                  ),
                  onPressed: () => isLiked.value = !value,
                );
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Column(
                children: [
                  Container(
                    height: 350,
                    width: double.infinity,
                    color: getTypeColor(pokemon.type),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -20,
                          bottom: 100,
                          child: Opacity(
                            opacity: 0.35,
                            child: Image.asset(
                              'images/pokeball.png',
                              height: 230,
                              width: 230,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 30,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Image.network(
                              pokemon.imageUrl,
                              height: 150,
                              width: 150,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: Container(color: Colors.white)),
                ],
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pokemon.name[0].toUpperCase() +
                                pokemon.name.substring(1).toLowerCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 70),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                            decoration: BoxDecoration(
                              color: const Color(0x4CFFFFFF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              pokemon.type.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "#${pokemon.id}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        const TabBar(
                          labelColor: Colors.black,
                          indicatorColor: Colors.green,
                          tabs: [
                            Tab(text: "About"),
                            Tab(text: "Base Stats"),
                            Tab(text: "Evolution"),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TabBarView(
                              children: [
                                AboutTab(pokemon: pokemon),
                                BaseStatsTab(pokemon: pokemon),
                                EvolutionTab(pokemon: pokemon),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
