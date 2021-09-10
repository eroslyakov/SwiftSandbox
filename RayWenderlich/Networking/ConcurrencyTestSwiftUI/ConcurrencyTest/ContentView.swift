//
//  ContentView.swift
//  ConcurrencyTest
//
//  Created by Rosliakov Evgenii on 08.09.2021.
//

import SwiftUI

struct ContentView: View {
    @State var isCalculating = false
    
    var body: some View {
        VStack {
            Spacer()
            DatePicker("Date", selection: .constant(Date()), displayedComponents: .hourAndMinute)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
            Button(action: calculatePrimes, label: {
                Text(isCalculating ? "Calculating..." : "Calculate Primes")
            }).disabled(isCalculating)
            Spacer()
        }
    }
    
    func calculatePrimes() {
        OperationQueue().addOperation {
            isCalculating = true
            for num in 0...1_000_000 {
                let isPrimeNumber = isPrime(number: num)
                print("\(num) is prime: \(isPrimeNumber) is Main Thread: \(Thread.current.isMainThread)")
            }
            isCalculating = false
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
