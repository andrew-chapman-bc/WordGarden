//
//  ViewController.swift
//  WordGarden
//
//  Created by Andrew Chapman on 9/12/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var wordsGuessedLabel: UILabel!
    @IBOutlet weak var wordsRemainingLabel: UILabel!
    @IBOutlet weak var wordsMissedLabel: UILabel!
    @IBOutlet weak var wordsInGameLabel: UILabel!
    @IBOutlet weak var wordBeingRevealedLabel: UILabel!
    @IBOutlet weak var guessedLetterTextField: UITextField!
    @IBOutlet weak var guessLetterButton: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var gameStatusMessageLabel: UILabel!
    @IBOutlet weak var flowerImageView: UIImageView!
    
    var wordsToGuess = ["SWIFT", "DOG", "CAT"]
    var currentWordIndex = 0
    var wordToGuess = ""
    var lettersGuessed = ""
    let maxNumberOfWrongGuesses = 8
    var wrongGuessesRemaining = 8
    var wordsGuessedCount = 0
    var wordsMissedCount = 0
    var guessCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let text = guessedLetterTextField.text!
        guessLetterButton.isEnabled = !(text.isEmpty)
        wordToGuess = wordsToGuess[currentWordIndex]
        wordBeingRevealedLabel.text = "_" + String(repeating: " _", count: wordToGuess.count-1)
        updateGameStatusLabels()
    }
    
    func updateUIAfterGuess(){
        //dismisses keyboard
        guessedLetterTextField.resignFirstResponder()
        //clears guess
        guessedLetterTextField.text! = ""
        
        guessLetterButton.isEnabled = false
    }
    
    func formatRevealedWord() {
        //format and show revealedWord in wordBeingRevealedLabel to include new guess
        var revealedWord = ""
        
        //loop through all letters in wordToGuess
        for letter in wordToGuess{
            if lettersGuessed.contains(letter){
                revealedWord = revealedWord + "\(letter)"
            } else {
                revealedWord = revealedWord + "_ "
            }
        }
        
        revealedWord.removeLast()
        wordBeingRevealedLabel.text = revealedWord
    }
    
    func updateAfterWinOrLoss() {
        //
        currentWordIndex += 1
        guessedLetterTextField.isEnabled = false
        guessLetterButton.isEnabled = false
        playAgainButton.isHidden = false
        
        updateGameStatusLabels()
        
    }
    
    func updateGameStatusLabels(){
        //update labels at top of screen
        wordsGuessedLabel.text = "Words Guessed: \(wordsGuessedCount)"
        wordsMissedLabel.text = "Words Missed: \(wordsMissedCount)"
        wordsRemainingLabel.text = "Words to Guess: \(wordsToGuess.count - (wordsGuessedCount + wordsMissedCount))"
        wordsInGameLabel.text = "Words in Game: \(wordsToGuess.count)"
    }
    
    func guessALetter() {
        //get current letters guessed and add it to all lettersGuessed
        let currentLetterGuessed = guessedLetterTextField.text!
        lettersGuessed = lettersGuessed + currentLetterGuessed
        
        formatRevealedWord()
        
        //update image, if needed, and keep track of wrong guesses
        if !wordToGuess.contains(currentLetterGuessed){
            wrongGuessesRemaining = wrongGuessesRemaining - 1
            flowerImageView.image = UIImage(named: "flower\(wrongGuessesRemaining)")
        }
        
        //update gameStatusMessageLabel
        guessCount += 1
        let guesses = ( guessCount==1 ? "Guess" : "Guesses")
        gameStatusMessageLabel.text = "You've made \(guessCount) \(guesses)"
        
        //Check for win or lose
        
        if !wordBeingRevealedLabel.text!.contains("_"){
            gameStatusMessageLabel.text = "You've guessed it! It took you \(guessCount) guesses to guess the word."
            wordsGuessedCount += 1
            updateAfterWinOrLoss()
        } else if wrongGuessesRemaining == 0 {
            gameStatusMessageLabel.text = "So Sorry. You're all out of guesses."
            wordsMissedCount += 1
            updateAfterWinOrLoss()
        }
        
        //check to see if you've played all the words. If so, update the message indicating the player can restart the entire game
        if currentWordIndex == wordsToGuess.count {
            gameStatusMessageLabel.text! += "\n\nYou've tried all the words! Restart from the begining?"
        }
    }
    
    @IBAction func guessedLetterFieldChanged(_ sender: UITextField) {
        sender.text = String(sender.text?.last ?? " ").trimmingCharacters(in: .whitespaces)
        guessLetterButton.isEnabled = !(sender.text!.isEmpty)
    }
    
    @IBAction func doneKeyPressed(_ sender: UITextField) {
        guessALetter()
        updateUIAfterGuess()
    }
    
    @IBAction func guessLetterButtonPressed(_ sender: UIButton) {
        guessALetter()
        updateUIAfterGuess()
    }
    
    @IBAction func playAgainButtonPressed(_ sender: UIButton) {
        //if all words have been guessed select play again, then restart all games as if the app has been restored
        if currentWordIndex == wordsToGuess.count {
            currentWordIndex = 0
            wordsGuessedCount = 0
            wordsMissedCount = 0
        }
        
        playAgainButton.isHidden = false
        guessedLetterTextField.isEnabled = true
        guessLetterButton.isEnabled = false
        wordToGuess = wordsToGuess[currentWordIndex]
        wrongGuessesRemaining = maxNumberOfWrongGuesses
        wordBeingRevealedLabel.text = "_" + String(repeating: " _", count: wordToGuess.count-1)
        guessCount = 0
        flowerImageView.image = UIImage(named: "flower\(maxNumberOfWrongGuesses)")
        lettersGuessed = ""
        updateGameStatusLabels()
        gameStatusMessageLabel.text = "You've Made Zero Guesses"
    }
    
    
    
}

