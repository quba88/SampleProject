//
//  RSA.swift
//  SampleProject
//
//  Created by Jakub Krystek on 17.12.2016.
//  Copyright © 2016 Jakub Krystek. All rights reserved.
//

import Foundation

class RSA{

    private var firstPrimeNumber:UInt = 0
    private var secondPrimeNumber:UInt = 0
    
  // MARK: - prime number generator
    private func randomFromRange(range: Range<Int> ) -> UInt
    {
        var offset = 0
        
        if range.lowerBound < 0   // allow negative ranges
        {
            offset = Swift.abs(range.lowerBound)
        }
        
        let mini = UInt32(range.lowerBound + offset)
        let maxi = UInt32(range.upperBound + offset)
        
        return UInt(mini + arc4random_uniform(maxi - mini)) - UInt(offset)
    }
    
    private func checkIsPrime(_ number:UInt)->Bool{
        var isPrime = true
        if number == 1 {
            isPrime = false
        }
        let stopNumber = UInt(sqrt(Double(number)))
        
        var i:UInt = 2
        while i < stopNumber {
            if number % i == 0 {
                isPrime = false
                break
            }
            i += 1
        }
        return isPrime}
    
    
    private func generatePrimeNumber(){
        var isPrime = false
        var number:UInt = 0
        
        while !isPrime {
            number = randomFromRange(range: Range(uncheckedBounds: (900000000, 1000910000)))
            isPrime = checkIsPrime(number)}
    }
}
