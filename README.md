# 制作展アプリ

[![Build Status](https://app.bitrise.io/app/c5476a2de2ff1946/status.svg?token=pnssIcxbg6nDz5YqtaJ7uw&branch=master)](https://app.bitrise.io/app/c5476a2de2ff1946)

## About

制作展アプリを使うと，2019年11月14日〜11月18日に東京大学にて開催される制作展において，展示作品をより深く知ることができます！最新のAR技術を用いて作品を鑑賞することで，作品について豊富な情報を得られるだけでなく，AR技術を用いた斬新な鑑賞方法を体験することができます．また，鑑賞した作品をコレクションに保存して，制作展を訪れた後にも作品を楽しむことができます．ぜひ制作展アプリをインストールして制作展にご来場ください！

ExhibitionApp (制作展アプリ) enriches your experience at III EXHIBITION held at University of Tokyo from November 14th to November 18th in 2019. With this app, you will understand and enjoy our works with new AR technology. You can collect the works at the exhibition so that you can find more information later. We are looking forward to seeing you. Thank you.

制作展ウェブサイト: http://iiiexhibition.com/

III EXHIBITION Website (Japanese): http://iiiexhibition.com/

## Features

日本語

- 最新のAR技術を用いた斬新な作品の鑑賞体験をすることができます．
- 鑑賞した作品はSNS等でシェアすることができます．
- 鑑賞した作品は端末に保存され，あとから楽しむこともできます．

English

- You can see rich information about our works with new AR technology.
- You can share the photo or video of AR world on social media.
- You can collect the works so that you can find more information later.

## Screenshots

### Default Mode

<img src="https://user-images.githubusercontent.com/24489109/68183754-a0615000-ffe0-11e9-8202-ac2cb4f7c458.png" width="200px"> <img src="https://user-images.githubusercontent.com/24489109/68183789-b2db8980-ffe0-11e9-8677-c2bdc8cadb03.png" width="200px">

### Dark Mode

<img src="https://user-images.githubusercontent.com/24489109/68183814-c1c23c00-ffe0-11e9-8050-0ac3563697c3.png" width="200px"> <img src="https://user-images.githubusercontent.com/24489109/68183843-d30b4880-ffe0-11e9-911e-ac1e8f2972d3.png" width="200px">

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
