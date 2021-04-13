# Test


## Désactiver la connection clavier sous simulateur

- Dans le scheme, allez dans la partie Test et dans les préaction ecrire le script ci-dessous

```
killall Simulator

defaults write com.apple.iphonesimulator ConnectHardwareKeyboard

```

## Sources

[WWDC 2019](https://developer.apple.com/videos/play/wwdc2019/413/)
[Test Cheat](https://www.hackingwithswift.com/articles/148/xcode-ui-testing-cheat-sheet)

## Exemple 

```swift

func testUserSignIn() throws {
            
    app.textFields["Identifiant"].tap()
    
    app.keys["f"].tap()
    app.keys["b"].tap()
    app.keys["x"].tap()
    app.buttons["Return"].tap()
    
    app.secureTextFields["Mot de passe"].tap()
    
    app.keys["more"].tap()
    app.keys["1"].tap()
    app.keys["2"].tap()
    app.keys["3"].tap()
    app.buttons["Return"].tap()
    
    app.buttons["Se connecter"].tap()
    
    XCTAssertTrue(app.tabBars["Barre d’onglets"].waitForExistence(timeout: timeoutEnv))
}
```
