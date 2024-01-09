import 'dart:convert';
import 'package:cadastro_viacep/repository/custom_dio.dart';
import 'package:http/http.dart' as http;
import '../model/viacepb4a_model.dart';
import '../model/viacepws_model.dart';

class ViaCepRepository {
  final _customDio = ViaCepCustomDio();

  ViaCepRepository();

  Future<ViaCepWsModel> consultarCep(String cep) async {
    var response =
        await http.get(Uri.parse("https://viacep.com.br/ws/$cep/json/"));
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return ViaCepWsModel.fromJson(json);
    }
    return ViaCepWsModel();
  }

  Future<ViaCepModel> consultaCepB4A(String cepWs) async {
    var validcep = "?where={\"cep\":\"$cepWs\"}";
    var result = await _customDio.dio.get("/cep$validcep");
    if (result.data != null) {
      return ViaCepModel.fromJson(result.data);
    } else {
      return ViaCepModel([]);
    }
  }

  Future<ViaCepModel> obterCep() async {
    var result = await _customDio.dio.get("/cep");
    return ViaCepModel.fromJson(result.data);
  }

  Future<void> salvar(ViaCep viaCep) async {
    try {
      await _customDio.dio.post("/cep", data: viaCep.toCreateJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> remover(String objectId) async {
    try {
      await _customDio.dio.delete("/cep/$objectId");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> atualizar(ViaCep viaCep) async {
    try {
      await _customDio.dio
          .put("/cep/${viaCep.objectId}", data: viaCep.toUpdateJson());
    } catch (e) {
      rethrow;
    }
  }
}
