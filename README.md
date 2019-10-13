# expandable-collection-view-kit [![Awesome](https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg)](https://github.com/sindresorhus/awesome)

[![Platform](https://img.shields.io/badge/platform-iOS_13-yellow.svg)]()
[![Platform](https://img.shields.io/badge/platform-iPadOS_13-darkyellow.svg)]()
[![Language](https://img.shields.io/badge/language-Swift_5.1-orange.svg)]()
[![SPM](https://img.shields.io/badge/SPM-Supported-red.svg)]()
[![License](https://img.shields.io/badge/license-MIT-blue.svg)]()

**Last Update: 13/October/2019.**

![](cover-expandable-view.png)

### If you like the project, please give it a star ⭐ It will show the creator your appreciation and help others to discover the repo.

# ✍️ About
🗂 Expandable, hierarchical, flexible, declarative UICollectionView with diffable data sources & SwiftUI-like tree items builder [Swift 5.1, iOS & iPadOS 13].

# 📺 Demo

|  |  |  |
:-------------------------:|:-------------------------:|:-------------------------:
![](assets/waterfall-iphone.gif) | ![](assets/gallery-iphone.gif) | ![](assets/showcasegallery-iphone.gif)
![](assets/mosaic-iphone.gif) | ![](assets/groupgrid-iphone.gif) | ![](assets/mosaicbigredux-iphone.gif)
![](assets/tilegrid-iphone.gif) | ![](assets/mosaicsmallredux-iphone.gif) | ![](assets/orthogonalmagnet-iphone.gif)
![](assets/banergrid-iphone.gif) | ![](assets/portraitgrid-iphone.gif) | ![](assets/verticallycont-iphone.gif) 
   

# 🍱 Features
- **Ease of use**
    - Instantiate `ExpandableCollectionViewManager` class, provide its parent view controller and specify the `Folders` and `Items`.
- **Flexible API**
    - There are many customization points that can be used to adjust: `Folders`, `Items`, `Navigation`, `appeareances` and also custom `animations`.
    - Swift's `Function Builders` make it very easy to create a tree of interconnected items 
- **Autolayout**
    - You don't need to do anything related to autolayout - the component properly handles all the changes. The only thing you need to do is to instantiate the `ExpandableCollectionViewManager` and fill it in with items.
- **Performant**
    - The under-the-hood implementation uses Swift's `Diffable Data Sources` and `Collection View Compositional Layout` which provides high performance and tested backing APi.
- **Extendable**
    - The component can be futher extended with new types of items, `Function Builder` types (such as `For Each` that applies a group of modifiers to a set of items, rather than copy-pasting the same modifiers or managing boilderplate configuration), decoratable content views for items and the list goes on. 
  

# 📚 Usage

## Instantiation

## Configuration

## Item Modifiers

## Animator

## Transition Handling

## View Controller Configuration

# 🏗 Installation

## Swift Package Manager

## Manual 
You can always use copy-paste the sources method 😄. Or you can compile the framework and include it with your project.


# 🙋‍♀️🙋‍♂️ Contributing
Your contributions are always appreciated. There are many ways how you help with the project:

- You can suggest something
- You can write additional documentation or sample codes
- Implement a new feature 
- Fix a bug
- Help to maintain by answering to the questions (if any) that other folks have
- etc.

Overall guidelies are:

- Please, discuss a feature or a major source change/addition before spending time and creating a pool reequest via issues. 
- Create a separate branch and make sure that your code compiles and does not produce errors and warnings.
- Please, don't be upset if it takes a while to review your code or receive an answer.


# 👨‍💻 Author 
[Astemir Eleev](https://github.com/jVirus)

# 🔖 Licence 
The project is available under [MIT Licence](https://github.com/jVirus/expandable-collection-view-kit/blob/master/LICENSE)
