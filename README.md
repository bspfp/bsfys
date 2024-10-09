# bsfys

(BS) (F)lutter (Y)AML (S)torage

BS가 만든 Flutter 프로젝트를 위한 YAML 저장소

(A simple YAML storage for Flutter projects created by BS.)

간단한 앱을 작성할 때 DB 대용으로 사용할 용도로 만들었습니다.

(The purpose of using this as a DB when writing a simple app.)

## 사용법 (Usage)

아래 내용을 `pubspec.yaml` 파일에 추가하세요.

(Adds the following dependencies to the Flutter project's `pubspec.yaml` file)

```
dependencies:
  flutter:
    sdk: flutter

  yaml_manager:
    git:
      url: https://github.com/bspfp/bsfys.git
      ref: main
```

패키지를 가져오기 위해 아래 명령어를 실행하세요.

(Run the following command to import the package)

```bash
$ flutter pub get
```
