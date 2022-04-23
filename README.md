# pokete-eaw-appimage -- 罫線表示が崩れる問題を修正した Pokete を起動する AppImage パッケージファイル作成用の Vagrantfile

## 概要

[Pokete][POKE] とは、人気ゲームポケモンライクのテキストベースゲームです。ここで、 [Pokete][POKE] を日本語環境で起動すると、罫線等の文字幅を適切に扱うことが出来ず、画面が崩れる不具合が発生します。

これは、  Unicode の規格における東アジア圏の各種文字のうち、いわゆる罫線文字及び "■" 等、 [East_Asian_Width 特性の値が A (Ambiguous) となる文字][EAWA] (以下、 [East Asian Ambiguous Character][EAWA]) が、日本語環境で文字幅を適切に扱うことが出来ない事が原因と考えられます。

上記の不具合を解消するためには、 [Pokete][POKE] に [Pokete において罫線表示が崩れる問題を修正するための差分ファイル][PEAW] を適用する必要があります。

また、 [AppImage][APPI] とは、 Linux 系 OS において、各種ディストリビューションの差異に関わらず、如何なる環境においてもアプリケーションの正常な動作を目指したアプリケーションの配布形式の一つです。同様な目的及び目標を持つアプリケーションの配布形式として、 [snap][SNAP] や [Flatpak][FLAT] 等が挙げられます。

[AppImage][APPI] は、 [snap][SNAP] や [Flatpak][FLAT] と異なり、 root 権限を取ること無く、パッケージファイルとして配布されている [AppImage][APPI] ファイルに実行権限を付与し、 [AppImage][APPI] ファイルを直接実行することにより、適切にアプリケーションを実行させることが出来るのが特徴です。

このリポジトリは、人気ゲームポケモンライクのテキストベースゲームである [Pokete][POKE] において、罫線文字及び "■" 等の [East Asian Ambiguous Character][EAWA] が日本語環境で文字幅を適切に扱うことが出来ない問題を修正するための差分ファイルを適用した [Pokete][POKE] を起動する [AppImage パッケージファイル][APPI]を生成するための [vagrant 仮想環境][VAGR]を構築する Vagrantfile 等を含むリポジトリです。

即ち、本リポジトリに含まれる Vagrantfile によって構築される仮想環境は、 "[Pokete において罫線表示が崩れる問題を修正するための差分ファイル][PEAW]" を適用した人気ゲームポケモンライクのテキストベースゲームである [Pokete][POKE] を起動するための [AppImage パッケージファイル][APPI]を生成する為の仮想環境です。

## 使用法

まず最初に、 [Pokete][POKE] の [AppImage パッケージファイル][APPI]を生成するための端末に [Vagrant 環境][VAGR]を構築します。 Vagrant のインストールにあたっては、以下の web ページを参考にして下さい。

- [Download Vagrant][VDWN]
- [Getting Started | Vagrant][VTUT]

そして、本リポジトリ内のシェルスクリプト ```build-appimage.sh``` を以下の通りに起動します。

```
  $ ./build-appimage.sh
```

シェルスクリプト ```build-appimage.sh``` の起動により、 [Pokete において罫線表示が崩れる問題を修正するための差分ファイル][PEAW]を適用した [Pokete][POKE] をビルドするための Vagrant 仮想環境が構築され、 Vagrant 仮想環境内にて、  に依存するライブラリ群等がビルドされ、 [Pokete][POKE] を起動するための [AppImage パッケージファイル][APPI]が生成されます。

そして、シェルスクリプトが正常に終了すると、ディレクトリ ```./opt/releases``` 以下に [AppImage パッケージファイル][APPI] ```pokete-eaw-*-x86_64.AppImage``` が生成されます。

## AppImage パッケージファイルの使用法

前述で生成した [AppImage パッケージファイル][APPI] ```pokete-eaw-0.6.0-x86_64.AppImage``` を用いて [Pokete][POKE] を起動するには、以下の通りにして  [AppImage パッケージファイル][APPI] ```pokete-eaw-0.6.0-x86_64.AppImage``` にファイルの実行権限を付与して環境変数 ```PATH``` が示すディレクトリに配置します。

そして、以下のようにして ```pokete-eaw-0.6.0-x86_64.AppImage``` から ```pokete``` へシンボリックリンクを張ると、コマンドラインから ```pokete``` と入力することで、 [Pokete において罫線表示が崩れる問題を修正するための差分ファイル][PEAW]を適用した [Pokete][POKE] が起動します。

```
  $ cd opt/release
  $ chmod u+x ./pokete-eaw-0.6.0-x86_64.AppImage
  $ sudo cp -pRv ./pokete-eaw-0.6.0-x86_64.AppImage /usr/local/bin    # (一例として /usr/local/bin 以下に導入する場合を示す。)
  $ cd /usr/local/bin
  $ sudo ln -sf pokete-eaw-0.6.0-x86_64.AppImage pokete
  ...
  $ pokete
  ...
```

ここで、 [Pokete において罫線表示が崩れる問題を修正するための差分ファイル][PEAW]を適用した [Pokete][POKE] の詳細については、 "[Pokete において罫線表示が崩れる問題を修正するための差分ファイル][PEAW]" を参照して下さい。

## AppImage パッケージファイルの配布

[Pokete において罫線表示が崩れる問題を修正するための差分ファイル][PEAW]を適用した [Pokete][POKE] のビルド済の [AppImage パッケージファイル][APPI]については、以下の URL より配布いたしますので、どうか宜しく御願い致します。

- Pokete を起動する AppImage パッケージファイルの配布ページ
    - [https://github.com/z80oolong/pokete-eaw-appimage/releases][APPR]

## 謝辞

まず最初に、各種ディストリビューションの差異に関わらず、如何なる環境においてもアプリケーションの正常な動作を目指したアプリケーションの配布形式である [AppImage][APPI] を開発した [AppImage][APPI] の開発コミュニティの各位に心より感謝致します。

そして、人気ゲームポケモンライクのテキストベースゲームである [Pokete][POKE] の作者である [lxgr-linux][LXGR] 氏及び [MaFeLP][MAFE] 氏に心より感謝致します。

最後に、 [Pokete の開発コミュニティ][POKE]及び [Pokete][POKE] と [AppImage][APPI] に関わる全ての人々に心より感謝致します。

## 使用条件

本リポジトリは、 [Pokete において罫線表示が崩れる問題を修正するための差分ファイル][PEAW]を適用した [Pokete][POKE] を起動するための [AppImage パッケージファイル][APPI]を生成するための Vagrant 仮想環境の構築を行う Vagrantfile 等を含むリポジトリであり、 [Z.OOL. (mailto:zool@zool.jpn.org)][ZOOL] が著作権を有し、 [MIT ライセンス][MITL] に基づいて配布されるものとします。

本リポジトリの使用条件の詳細については、本リポジトリに同梱する ```LICENSE``` を参照して下さい。

<!-- 外部リンク一覧 -->

[EAWA]:http://www.unicode.org/reports/tr11/#Ambiguous
[APPI]:https://appimage.org/
[SNAP]:https://snapcraft.io/
[FLAT]:https://flatpak.org/
[POKE]:https://github.com/lxgr-linux/pokete
[BREW]:https://docs.brew.sh/Homebrew-on-Linux
[VAGR]:https://www.vagrantup.com/
[VDWN]:https://www.vagrantup.com/downloads
[VTUT]:https://learn.hashicorp.com/collections/vagrant/getting-started
[DEBI]:https://www.debian.org/
[APPR]:https://github.com/z80oolong/pokete-eaw-appimage/releases
[LXGR]:https://github.com/lxgr-linux
[MAFE]:https://github.com/MaFeLP
[ZOOL]:http://zool.jpn.org/
[MITL]:https://opensource.org/licenses/mit-license.php
