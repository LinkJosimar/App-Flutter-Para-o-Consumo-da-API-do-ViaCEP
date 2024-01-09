import 'package:cadastro_viacep/model/viacepb4a_model.dart';
import 'package:flutter/material.dart';

import '../model/viacepws_model.dart';
import '../repository/viacep_repository.dart';
import 'viacepalterar_page.dart';

class ViaCepPage extends StatefulWidget {
  const ViaCepPage({super.key});

  @override
  State<ViaCepPage> createState() => _ViaCepPageState();
}

class _ViaCepPageState extends State<ViaCepPage> {
  var cepController = TextEditingController();
  var viaCepB4A = ViaCepModel([]);
  var viaCep = ViaCepWsModel();
  var validaCepB4A = ViaCepModel([]);
  bool validaCep = false;
  var viaCepRepository = ViaCepRepository();
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    obterCeps();
    super.initState();
  }

  obterCeps() async {
    setState(() {
      loading = true;
    });
    viaCepB4A = await viaCepRepository.obterCep();
    setState(() {
      loading = false;
    });
  }

  detalhesCep(ViaCep viaCep) {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => ViaCepAlterarPage(viacep: viaCep)));
    obterCeps();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
              title: const Text("Consulta Cep",
                  style: TextStyle(color: Colors.amber)),
              centerTitle: true,
              automaticallyImplyLeading: false),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  keyboardType: TextInputType.number,
                  controller: cepController,
                  decoration: const InputDecoration(
                      labelText: "Insira um CEP",
                      labelStyle: TextStyle(color: Colors.amber)),
                ),
                Center(
                  child: TextButton(
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        //var viaCepModel = await viaCecRepository.obterCep();
                        //print(viaCepModel);
                        viaCep = await viaCepRepository
                            .consultarCep(cepController.text);
                        var cep = viaCep.cep!;
                        validaCepB4A =
                            await viaCepRepository.consultaCepB4A(cep);

                        if (validaCepB4A.cep.isEmpty) {
                          await viaCepRepository.salvar(ViaCep.criar(
                              viaCep.cep!,
                              viaCep.logradouro!,
                              viaCep.complemento!,
                              viaCep.bairro!,
                              viaCep.localidade!,
                              viaCep.uf!,
                              viaCep.ibge!,
                              viaCep.gia!,
                              viaCep.ddd!,
                              viaCep.siafi!));
                        } else {
                          setState(() {
                            obterCeps();
                          });
                        }
                        setState(() {
                          obterCeps();
                        });
                        cepController.text = "";
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.amber[900])),
                      child: const Text("Buscar CEP")),
                ),
                const SizedBox(
                  height: 10,
                ),
                loading
                    ? const CircularProgressIndicator()
                    : Expanded(
                        child: ListView.builder(
                            itemCount: viaCepB4A.cep.length,
                            itemBuilder: (BuildContext bc, int index) {
                              var viaCep = viaCepB4A.cep[index];
                              return Dismissible(
                                  onDismissed: (DismissDirection
                                      dismissDirection) async {
                                    await viaCepRepository
                                        .remover(viaCep.objectId);
                                    obterCeps();
                                  },
                                  key: Key(viaCep.cep),
                                  child: ListTile(
                                    title: Text(
                                      viaCep.cep,
                                      style: const TextStyle(
                                          color: Colors.amber,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    leading: CircleAvatar(
                                      child: Image.asset(
                                          "lib/images/correios.png"),
                                    ),
                                    subtitle: Text(
                                      'Endereço: ${viaCep.logradouro} Complemento: ${viaCep.complemento} Bairro: ${viaCep.bairro} Cidade: ${viaCep.localidade}-${viaCep.uf} DDD: ${viaCep.ddd} ',
                                      style:
                                          const TextStyle(color: Colors.amber),
                                    ),
                                    onTap: () => detalhesCep(viaCep),
                                  ));
                            }))
              ],
            ),
          )),
    );
  }
}
