import 'package:cadastro_viacep/model/viacepb4a_model.dart';
import 'package:cadastro_viacep/pages/viacep_page.dart';
import 'package:flutter/material.dart';

import '../repository/viacep_repository.dart';

class ViaCepAlterarPage extends StatefulWidget {
  ViaCep viacep;
  ViaCepAlterarPage({super.key, required this.viacep});

  @override
  State<ViaCepAlterarPage> createState() => _ViaCepAlterarPageState();
}

class _ViaCepAlterarPageState extends State<ViaCepAlterarPage> {
  var viaCepB4A = ViaCepModel([]);
  var viaCepRepository = ViaCepRepository();
  var objectIdCtrl = TextEditingController();
  var cepCtrl = TextEditingController();
  var enderecoCtrl = TextEditingController();
  var complementoCtrl = TextEditingController();
  var bairroCtrl = TextEditingController();
  var cidadeCtrl = TextEditingController();
  var ufCtrl = TextEditingController();
  var dddCtrl = TextEditingController();
  var ibgeCtrl = TextEditingController();
  var giaCtrl = TextEditingController();
  var siafiCtrl = TextEditingController();
  bool salvando = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    carregarDados();
  }

  carregarDados() {
    cepCtrl.text = widget.viacep.cep;
    enderecoCtrl.text = widget.viacep.logradouro;
    complementoCtrl.text = widget.viacep.complemento;
    bairroCtrl.text = widget.viacep.bairro;
    cidadeCtrl.text = widget.viacep.localidade;
    ufCtrl.text = widget.viacep.uf;
    dddCtrl.text = widget.viacep.ddd;
    objectIdCtrl.text = widget.viacep.objectId;
    ibgeCtrl.text = widget.viacep.ibge;
    giaCtrl.text = widget.viacep.gia;
    siafiCtrl.text = widget.viacep.siafi;
  }

  void obterCeps() async {
    viaCepB4A = await viaCepRepository.obterCep();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cep: ${widget.viacep.cep}"),
      ),
      body: salvando
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    decoration: const InputDecoration(labelText: 'Endereço'),
                    controller: enderecoCtrl,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    decoration: const InputDecoration(labelText: 'Complemento'),
                    controller: complementoCtrl,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    decoration: const InputDecoration(labelText: 'Bairro'),
                    controller: bairroCtrl,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    decoration: const InputDecoration(labelText: 'Cidade'),
                    controller: cidadeCtrl,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    decoration: const InputDecoration(labelText: 'UF'),
                    controller: ufCtrl,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    decoration: const InputDecoration(labelText: 'DDD'),
                    controller: dddCtrl,
                  ),
                ),
                TextButton(
                    onPressed: () {
                      setState(() {
                        salvando = false;
                      });
                      viaCepRepository.atualizar(ViaCep.atualizar(
                          objectIdCtrl.text,
                          cepCtrl.text,
                          enderecoCtrl.text,
                          complementoCtrl.text,
                          bairroCtrl.text,
                          cidadeCtrl.text,
                          ufCtrl.text,
                          ibgeCtrl.text,
                          giaCtrl.text,
                          dddCtrl.text,
                          siafiCtrl.text));
                      setState(() {
                        salvando = true;
                      });
                      Future.delayed(
                        const Duration(seconds: 2),
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("Dados alterados com sucesso")));
                          setState(() {
                            salvando = false;
                          });
                          //Navigator.pushAndRemoveUntil(context, newRoute, (route) => false)
                          Navigator.pushAndRemoveUntil<void>(
                            context,
                            MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    const ViaCepPage()),
                            ModalRoute.withName('/'),
                          );
                        },
                      );
                    },
                    child: const Text("Salvar"))
              ],
            ),
    );
  }
}
