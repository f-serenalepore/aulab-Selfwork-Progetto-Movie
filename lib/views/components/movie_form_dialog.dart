import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moviesqlitemvvm/models/movie.dart';
import 'package:moviesqlitemvvm/viewmodels/movie_view_model.dart';

class MovieFormDialog extends StatefulWidget {
  final Movie? movie;
  const MovieFormDialog({super.key, this.movie});

  @override
  State<MovieFormDialog> createState() => _MovieFormDialogState();
}

class _MovieFormDialogState extends State<MovieFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _durationController;
  late TextEditingController _plotController;
  late TextEditingController _yearController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.movie?.title ?? '');
    _plotController = TextEditingController(text: widget.movie?.plot ?? '');
    _durationController = TextEditingController(
      text: widget.movie?.duration.toString() ?? '',
    );
    _yearController = TextEditingController(
      text: widget.movie?.year.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    _plotController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newMovie = Movie(
        id: widget.movie?.id,
        title: _titleController.text,
        duration: int.parse(_durationController.text),
        plot: _plotController.text,
        year: int.parse(_yearController.text),
      );
      

      final vm = context.read<MovieViewModel>();
      if (widget.movie == null) {
        vm.addMovie(newMovie);
      } else {
        vm.updateMovie(newMovie);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.movie == null ? 'Aggiungi film' : "modifica film"),
      content: SingleChildScrollView(
        
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Titolo"),
                validator: (value) => value == null || value.isEmpty
                    ? "campo obbligatorio"
                    : null,
              ),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(
                  labelText: "durata in minuti",
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || int.tryParse(value) == null
                    ? "inserisci un numero"
                    : null,
              ),
              TextFormField(
                controller: _plotController,
                decoration: const InputDecoration(labelText: "Trama"),
                validator: (value) => value == null || value.isEmpty
                    ? "trama obbligatoria"
                    : null,
              ),
              TextFormField(
                controller: _yearController,
                decoration: const InputDecoration(labelText: "anno di uscita"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || int.tryParse(value) == null
                    ? "inserisci un anno valido"
                    : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Annulla"),
        ),
        ElevatedButton(onPressed: _submitForm, child: const Text("Salva")),
      ],
    );
  }
}
