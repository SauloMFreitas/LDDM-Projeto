import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'sobre.dart';
import 'app_styles.dart';
import 'lista.dart';
import 'sql_helper.dart';
import 'package:intl/intl.dart';

class Calendario extends StatefulWidget {
  const Calendario({super.key});

  @override
  _CalendarioState createState() => _CalendarioState();
}

class _CalendarioState extends State<Calendario> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<dynamic>> _events = {};

  @override
  void initState() {
    super.initState();
    // Chama a função ao inicializar o estado
    fetchEvents();
  }

  bool _eventIndicator(DateTime day) {
    return _events.containsKey(day) && _events[day]!.isNotEmpty;
  }


  // Função para preencher _events usando getTarefasByDate(data)
  void fetchEvents() async {
    final DateTime now = DateTime.now();
    final DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    final DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    final DateTime firstDayOfNextMonth = DateTime(now.year, now.month + 1, 1);

    // Preenche _events para o mês atual
    _events.addAll(await getEventsForRange(firstDayOfMonth, lastDayOfMonth));

    // Preenche _events para o próximo mês
    _events.addAll(await getEventsForRange(firstDayOfNextMonth, firstDayOfNextMonth.add(const Duration(days: 30))));

    setState(() {}); // Atualiza o estado para refletir as mudanças
  }

  // Função auxiliar para obter tarefas para um intervalo de datas
  Future<Map<DateTime, List<dynamic>>> getEventsForRange(DateTime start, DateTime end) async {
    Map<DateTime, List<dynamic>> events = {};

    for (DateTime date = start; date.isBefore(end); date = date.add(const Duration(days: 1))) {
      final dynamic task = await SQLHelper.getTarefasByDate(DateFormat('dd/MM/yyyy').format(date.toLocal()).toString()); // Use toLocal() para corrigir a questão de fusos horários
      final bool hasTask = task.isNotEmpty; // Verifica se há uma tarefa para a data

      if (hasTask) {
        events[date] = [true]; // Adiciona true se houver uma tarefa para a data
      }
    }

    return events;
  }

  @override
  Widget build(BuildContext context) {
    AppStyles appStyles = AppStyles();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Calendário'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.info,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Sobre(),
                ),
              );
            },
          ),
        ],
        backgroundColor: appStyles.highlightColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          TableCalendar(
            locale: 'pt_BR',
            firstDay: DateTime(2022),
            lastDay: DateTime(3000),
            focusedDay: _focusedDay,

            calendarStyle: const CalendarStyle(

              outsideDaysVisible: false,

              selectedDecoration: BoxDecoration(
                color: Color.fromARGB(255, 230, 72, 74),
                shape: BoxShape.circle,
              ),

              selectedTextStyle: TextStyle(color: Colors.black),

              defaultDecoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),

              weekendDecoration: BoxDecoration(
                //color: Colors.white,
                //shape: BoxShape.circle,
              ),

              defaultTextStyle: AppStyles.bodyTextStyle,

              markersMaxCount: 1, // Adicionado para limitar a quantidade de marcadores
            ),

            daysOfWeekStyle: const DaysOfWeekStyle(
              weekendStyle: AppStyles.bodyTextStyle,
              weekdayStyle: AppStyles.bodyTextStyle,
            ),

            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: AppStyles.titleTextStyle,
            ),

            eventLoader: (day) {
              // Retorna a lista de eventos (tarefas) para o dia selecionado
              return _events[day] ?? [];
            },

            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Lista(dataSelecionada: DateFormat('dd/MM/yyyy').format(_selectedDay!))
                ),
              );
            },
            selectedDayPredicate: (day) {
              return isSameDay(day, _focusedDay);
            },

            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                // Adiciona um marcador abaixo do dia se houver eventos
                if (events.isNotEmpty) {
                  return Stack(
                    children: [
                      Positioned(
                        bottom: 5,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.red, // Cor do marcador
                            shape: BoxShape.circle,
                          ),
                          width: 6,
                          height: 6,
                        ),
                      ),
                      Center(
                        child: Text(
                          '${date.day}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              },
            ),

          )
        ],
      ),
    );
  }
}
