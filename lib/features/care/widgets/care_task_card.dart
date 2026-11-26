import 'package:flutter/material.dart';

class CareTaskCard extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool isCompleted;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const CareTaskCard({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    required this.onTap,
    this.onDelete,
  }) : super(key: key);

  @override
  State<CareTaskCard> createState() => _CareTaskCardState();
}

class _CareTaskCardState extends State<CareTaskCard> {
  bool _isExpanded = false;

  String _getMotivation(String title) {
    final t = title.toLowerCase();
    if (t.contains('caminhada')) return "Caminhar pelo menos 20 minutos por dia pode mudar o seu humor e disposição!";
    if (t.contains('água') || t.contains('agua')) return "Manter-se hidratado faz bem para a memória, rins e energia física.";
    if (t.contains('leitura')) return "Ler exercita o cérebro e melhora o foco e a tranquilidade diária.";
    if (t.contains('alongamento')) return "Esticar o corpo evita lesões e alivia as tensões do dia a dia.";
    return "Pequenos hábitos diários constroem uma grande qualidade de vida.";
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final isDark = themeData.brightness == Brightness.dark;
    final bgColor = isDark ? Colors.grey[900] : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF000080);
    final iconBgColor = widget.iconColor.withValues(alpha: 0.2);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ==========================================
              // PARTE SUPERIOR CLICÁVEL (FORÇA O TOQUE)
              // ==========================================
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                behavior: HitTestBehavior.opaque, // OBRIGA o Flutter a detetar o toque no espaço vazio!
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: iconBgColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(widget.icon, color: widget.iconColor),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            if (widget.subtitle.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  widget.subtitle,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),

                      // BOTÃO DE CHECKBOX
                      GestureDetector(
                        onTap: widget.onTap, // Marca/desmarca a bolinha
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: widget.isCompleted ? const Color(0xFF126E51) : Colors.grey.shade300,
                              width: 2,
                            ),
                            color: widget.isCompleted ? const Color(0xFF126E51) : Colors.transparent,
                          ),
                          child: widget.isCompleted
                              ? const Icon(Icons.check, size: 20, color: Colors.white)
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ==========================================
              // PARTE INFERIOR EXPANSÍVEL (ANIMAÇÃO ROBUSTA)
              // ==========================================
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 250),
                crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                firstChild: const SizedBox(width: double.infinity, height: 0),
                secondChild: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Divider(height: 1, color: Colors.grey.shade200),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _getMotivation(widget.title),
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Excluir Tarefa'),
                                  content: const Text('Tem certeza que deseja remover este hábito de hoje?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(ctx); // Fecha o dialog
                                        if (widget.onDelete != null) widget.onDelete!(); // Apaga a tarefa
                                      },
                                      child: const Text('Excluir', style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                            label: const Text('Excluir', style: TextStyle(color: Colors.red)),
                          ),
                          const Spacer(),
                          ElevatedButton.icon(
                            onPressed: widget.onTap,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.isCompleted ? Colors.grey.shade400 : const Color(0xFF126E51),
                              foregroundColor: Colors.white,
                              elevation: 0,
                            ),
                            icon: Icon(
                                widget.isCompleted ? Icons.close : Icons.check,
                                size: 20
                            ),
                            label: Text(widget.isCompleted ? 'Desmarcar' : 'Concluir Tarefa'),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}