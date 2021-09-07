import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

let scores = [2, 4, 3, 4, 5, 1, 2, 4, 3].publisher

let minPub = scores
    .min()
    .map { "min: \($0)" }
let maxPub = scores
    .max()
    .map { "max: \($0)" }
let countPub = scores
    .count()
    .map { "number of games: \($0)" }

minPub
    .merge(with: maxPub, countPub)
    .collect()
    .sink(receiveValue: { print("Your results: \($0.joined(separator: ", "))") })
    .store(in: &subscriptions)
