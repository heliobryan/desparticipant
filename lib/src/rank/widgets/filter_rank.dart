import 'package:des/src/GlobalConstants/font.dart';
import 'package:flutter/material.dart';

class FilterRank extends StatefulWidget {
  final Function(String) onCategorySelected;

  const FilterRank({super.key, required this.onCategorySelected});

  @override
  State<FilterRank> createState() => _FilterRankState();
}

class _FilterRankState extends State<FilterRank> {
  String selectedCategory = 'SUB 10'; // Categoria inicial

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
                  itemCount: 11,
                  itemBuilder: (context, index) {
                    final subValue = 7 + index;
                    return ListTile(
                      title: Text(
                        "SUB $subValue",
                        style: principalFont.medium(
                            color: const Color(0XffB0B0B0), fontSize: 20),
                      ),
                      onTap: () {
                        setState(() {
                          selectedCategory =
                              "SUB $subValue"; // Atualiza a categoria selecionada
                        });
                        debugPrint(
                            '[FilterRank] Categoria selecionada: SUB $subValue');
                        widget.onCategorySelected(
                            "SUB $subValue"); // Passa para o filtro em RankPage
                        Navigator.pop(context); // Fecha o modal
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
          color: Color(0XFFb0c32e),
        ),
      ),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.transparent),
        ),
        child: Text(
          selectedCategory,
          style: const TextStyle(
              color: Color(0XffB0B0B0),
              fontSize: 15,
              fontWeight: FontWeight.bold),
        ),
        onPressed: () => _showFilterRankModal(context),
      ),
    );
  }
}
