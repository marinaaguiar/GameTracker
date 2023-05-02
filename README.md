# GameTracker

The Game Tracker app allows users to search for board games, through different categories. Also, it shows a detail view for each game that the user selects featuring information as a minimum and maximum number of players, the playtime, a description, game images uploaded by other players, and videos about the game.

## Installation

Xcode version 14.1

Swift version 5.7

Minimum deployment iOS 15.5

## Usage

The application uses Board Game Atlas Api Key. [Get a API Key](https://www.boardgameatlas.com/api/docs/apps)	 before running the project. 
* Replace YOUR_API_KEY 

```
private struct APIDefinitions {
    static let APIKey = APIConstant.apiKey // replace for "YOUR_API_KEY"
    static let searchMethod = "api.boardgameatlas.com/api"
  }
```

## About

### Features

- MVC Design Pattern
- UICollectionView using Diffable Data Source
- ViewCode
- Reusable Cells
- RESTful API request from Board Games Atlas
- Swift Package Manager (Framework: KingFisher, MarkdownKit)
- Data persistence using Realm and UserDefaults
- Light and Dark Mode support

## Screens

<img width="1000" alt="image" src="https://user-images.githubusercontent.com/74434212/203025184-296399cb-49eb-4f83-8119-0d7882ddbf2a.png">

## Credits

[Board Game Atlas API](https://www.boardgameatlas.com/api/docs)
