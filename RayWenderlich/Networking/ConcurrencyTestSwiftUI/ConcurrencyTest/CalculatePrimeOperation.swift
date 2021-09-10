//
//  CalculatePrimeOperation.swift
//  ConcurrencyTest
//
//  Created by Rosliakov Evgenii on 08.09.2021.
//

import Foundation

class CalculatePrimeOperation: Operation {
    
    override func main() {
        for num in 0...1_000_000 {
            let isPrimeNumber = isPrime(number: num)
            print("\(num) is prime: \(isPrimeNumber) is Main Thread: \(Thread.current.isMainThread)")
        }
    }
    
    func isPrime(number: Int) -> Bool {
        if number <= 1 { return false }
        if number <= 3 { return true }
        
        var i = 2
        while i * i <= number {
            if number % i == 0 {
                return false
            }
            i += 2
        }
        return true
    }
}
