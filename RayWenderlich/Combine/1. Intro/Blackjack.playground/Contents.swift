import Foundation
import Combine
import PlaygroundSupport

var subscriptions = Set<AnyCancellable>()

example(of: "Create a Blackjack card dealer") {
  let dealtHand = PassthroughSubject<Hand, HandError>()
  
  func deal(_ cardCount: UInt) {
    var deck = cards
    var cardsRemaining = 52
    var hand = Hand()
    
    for _ in 0 ..< cardCount {
      let randomIndex = Int.random(in: 0 ..< cardsRemaining)
      hand.append(deck[randomIndex])
      deck.remove(at: randomIndex)
      cardsRemaining -= 1
    }
    
    // Add code to update dealtHand here
    if hand.points > 21 {
        dealtHand.send(completion: .failure(.busted))
    } else {
        dealtHand.send(hand)
        dealtHand.send(completion: .finished)
    }
  }
  
  // Add subscription to dealtHand here
    dealtHand
        .sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Game over: \(error)")
                case .finished:
                    break
                }
                PlaygroundPage.current.finishExecution()
            },
            receiveValue: { print("\($0.cardString) (\($0.points) points)") }
        )
        .store(in: &subscriptions)
  
  deal(3)
}


