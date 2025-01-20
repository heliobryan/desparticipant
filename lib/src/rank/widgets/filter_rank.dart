import 'package:des/src/GlobalConstants/font.dart';
import 'package:flutter/material.dart';

class FilterRank extends StatefulWidget {
  const FilterRank({super.key});

  @override
  State<FilterRank> createState() => _FilterRankState();
}

class _FilterRankState extends State<FilterRank> {
  void _showFilterRankModal(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: const Color(0xFF2C2C2C),
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "ESCOLHA A CATEGORIA DESEJADA",
                style: principalFont.bold(color: const Color(0XffB0B0B0)),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: 11, // SUB 7 ao SUB 17 (11 categorias)
                  itemBuilder: (context, index) {
                    final subValue =
                        7 + index; // Gera os valores SUB 7 a SUB 17
                    return ListTile(
                      title: Text(
                        "SUB $subValue",
                        style: principalFont.medium(
                            color: const Color(0XffB0B0B0), fontSize: 20),
                      ),
                      onTap: () {
                        // Lógica ao selecionar a categoria
                        Navigator.pop(context, "SUB $subValue");
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0XffB0B0B0),
        ),
      ),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.transparent),
        ),
        child: const Text(
          'SUB 10',
          style: TextStyle(
              color: Color(0XffB0B0B0),
              fontSize: 15,
              fontWeight: FontWeight.bold),
        ),
        onPressed: () => _showFilterRankModal(context),
      ),
    );
  }
}
