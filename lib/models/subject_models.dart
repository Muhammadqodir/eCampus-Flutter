import 'dart:isolate';

class AcademicYearsModel {
  String kursTypeName = "";
  String name = "";
  int id = -1;
  int parentId = -1;
  bool isCurrent = false;
  List<TermModel> termModels = [];

  AcademicYearsModel(this.kursTypeName, this.name, this.id, this.parentId, this.isCurrent, this.termModels);

  AcademicYearsModel.buildDefault();
}

class TermModel {
  bool isCurrent = false;
  String termTypeName = "";
  String name = "";
  int parentId = -1;
  int id = -1;

  TermModel.buildDefault();

  TermModel(this.isCurrent, this.termTypeName, this.name, this.parentId, this.id);
}