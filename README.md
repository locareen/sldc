# SereneLinux開発者向けコンテナ
===

## 概要

SereneLinux開発者向けの仮想コンテナ生成ツールです。
OVAやvdi, vmdkから生ディスクイメージを抽出し、生成した生ディスクイメージをloopでマウントします。
systemd-nspawnで起動し、Xephyrを使いホストのXに重ねて起動します。

## 対応形式

+ 生ディスクイメージ(.img)
+ OVAファイル
+ vmdkファイル
+ vdiファイル
+ qcow2ファイル
+ qedファイル
+ vhdファイル

それ以外の形式を使用したい場合はお手数ですが、各自で対応形式へ変換をお願いします。
## 使い方

デフォルトでは /opt/sldc/image.img をマウントしようとします。その場合は

```
$ sldc -c (COMMAND)
```

と入力すればコンテナが起動します。

もし、別の場所にあるディスクイメージを起動したい場合は

```

$ sldc (PATH) -c (COMMAND)

```

と**絶対パスで**指定してください。(修正予定)

デフォルトでは /mnt にイメージをマウントします。マウントポイントを変更したい場合は
`-p (MOUNTPOINT) ` もしくは `--mountpoint (MOUNTPOINT)` で指定ができます。

コンテナから出た際、自動でアンマウントする設定になっています。もし手動でアンマウントしたい場合は
`-m` もしくは `--no-umount` で自動アンマウントを無効にできます。

SereneLinux開発者へ
/opt/sldc/diskimages下にディスクイメージを設置している場合、バージョン名での指定も可能です。
また、SereneLinux19q2.6.5以降のイメージには /home/serene/xinit.sh が設置済みなので起動時のコマンド指定は不要です。

# SereneLinux Container for its developers
===
## Overview

Extract the raw disk image from the virtual disk and mount it.
Then start it with systemd-nspawn and nest X with Xephyr.

## Support format

+ raw disk image file (.img)
+ ova file
+ vmdk virtual disk file
+ vdi virtual disk file
+ qcow2 virtual disk file
+ qed virtual disk file
+ vhd virtual disk file

## How to use
See "sldc --help".
