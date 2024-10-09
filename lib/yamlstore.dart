class YamlStore {
  String filename;

  YamlStore(this.filename);

  Future<String> loadFile() async {
    throw UnimplementedError();
  }

  Future<void> saveFile({required String yamlString, String? newFilename}) async {
    throw UnimplementedError();
  }
}
