# パラメータシート作成シェル
## 各種ディレクトリの説明

|ディレクトリ名|内容|
|:--|:--|
|create_document_codebuild|AWSサービスのみを使ってパラメータシート作成シェルの処理を行う際に使用|
|create_document_github|GitHub Actionsを使ってパラメータシート作成シェルの処理を行う際に使用|
|create_document_shell|パラメータシート作成シェル本体|

### create_document_codebuild
`GitHub`を使わず、AWSのサービスのみを使用してパラメータシート作成シェルを実行、結果を公開する場合に本ディレクトリ配下のリソースを`terraform`でデプロイする。

### create_document_github
`GitHub Actions`を使用してパラメータシート作成シェルを実行、`GitHub Pages`で結果を公開する場合に本ディレクトリ配下のリソースを`terraform`でデプロイする。

パラメータを取得するAWS側にも、`GitHub Actions`からOIDCでアクセスを受け付けるためのIAM設定が必要となるため、AWS側も`terraform`でデプロイする。

### create_document_shell
ディレクトリ配下のファイルを`GitHub`のリポジトリや`CodeCommit`にコミット・プッシュして使用する。
