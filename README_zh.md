# 畢業禮物 App

語言： [English](README.md) | [中文](README_zh.md)

這是一個使用 Swift 和 SwiftUI 開發的 iOS 應用程式，作為給朋友的畢業禮物。它展示了一些文章，內容包括文字、圖片和影片，並逐句呈現在螢幕上。

## 功能

- **文章展示**： 首頁顯示所有文章列表，點擊可以查看詳細內容
- **內容呈現**： 文章內容依據設定，逐句在螢幕上顯示
- **多媒體支持**： 支持文字、圖片和影片的展示

## 使用方法

1. 打開應用程式，進入首頁
2. 瀏覽文章列表，選擇一篇文章
3. 點擊文章，進入詳細頁面
4. 點擊螢幕以查看下一句內容

## 安裝

### 使用 TestFlight 測試和安裝

1. 在 iOS 設備上安裝 [TestFlight](https://apps.apple.com/us/app/testflight/id899247664) 。
2. 接收我的邀請郵件，並點擊郵件中的 TestFlight 測試邀請鏈結。
3. 打開 TestFlight 應用程式，找到「畢 ya 了」，然後點擊「安裝」。
4. 安裝完成後，你可以打開應用程式並開始使用。

### 使用 Xcode 安裝 (僅限開發者)

1. 克隆此專案到本地
    ```bash
    git clone https://github.com/haner0834/HappyGraduation.git
    ```
2. 使用 Xcode 打開專案
3. 編譯並運行

## 項目結構

- `Extension`: 包含所有擴展
- `ViewModel`: 包含所有視圖模型文件
- `View`
  - `MainView`: 包含主要視圖
    - `Book`: 包含支持可翻頁的書UI元件
  - `Subview`: 包含主視圖中使用的子視圖
- `Resource`
  - `Article`: 包含所有文章資源
  - `Video`: 包含所有影片資源
- `Model`: 包含結構(struct)、枚舉(enum)、類(class)等
  - `Error`: 包含錯誤模型

## 截圖

<div>
  <img src="https://github.com/haner0834/HappyGraduation/blob/main/ScreenShot/WelcomePage.png" width=220>
  <img src="https://github.com/haner0834/HappyGraduation/blob/main/ScreenShot/HomePage.png" width=220>
  <img src="https://github.com/haner0834/HappyGraduation/blob/main/ScreenShot/ArticleDetail.png" width=220>
  <img src="https://github.com/haner0834/HappyGraduation/blob/main/ScreenShot/GraduationBook.png" width=220>
<div/>

## 聯絡方式

如果有任何問題或建議，請聯絡我：
- 電子郵件: [linandy40804@google.com](mailto:linandy40804@gmail.com)
- GitHub: [haner0834](https://github.com/haner0834)
