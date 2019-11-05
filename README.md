# 制作展アプリ

[![Build Status](https://app.bitrise.io/app/c5476a2de2ff1946/status.svg?token=pnssIcxbg6nDz5YqtaJ7uw&branch=master)](https://app.bitrise.io/app/c5476a2de2ff1946)

## About

制作展アプリを使うと，2019年11月14日〜11月18日に東京大学にて開催される制作展において，展示作品をより深く知ることができます！最新のAR技術を用いて作品を鑑賞することで，作品について豊富な情報を得られるだけでなく，AR技術を用いた斬新な鑑賞方法を体験することができます．また，鑑賞した作品をコレクションに保存して，制作展を訪れた後にも作品を楽しむことができます．ぜひ制作展アプリをインストールして制作展にご来場ください！

制作展HP: http://iiiexhibition.com/

## Features

- 最新のAR技術を用いた斬新な作品の鑑賞体験をすることができます．
- 鑑賞した作品はSNS等でシェアすることができます．
- 鑑賞した作品は端末に保存され，あとから楽しむこともできます．

## Screenshots

### Default Mode

### Dark Mode

## Requirements

- iPhone/iPad
- iOS 12.0 or later
- Xcode 11

## Setup

1. Install the latest [Xcode developer tools](https://developer.apple.com/xcode/downloads/) from Apple.
2. Install Carthage
    ```shell
    brew update
    brew install carthage
    ```
3. Clone the repository:
    ```shell
    git clone https://github.com/ashtkn/ExhibitionApp
    ```
4. Pull in the project dependencies:
    ```shell
    cd ExhibitionApp
    carthage update --platform iOS
    ```
5. Open `ExhibitionApp.xcodeproj` in Xcode.

## Acknowledgment

Special thanks to:

- [Shoichi Kanzaki](https://github.com/zkkn) for designing App UI,
- [Karin Kiho](https://github.com/charon616) for designing AR World,
- [Hidemaro Fujinami](https://github.com/maro525) for great directions.
