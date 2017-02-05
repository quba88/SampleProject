//
//  RSA.swift
//  SampleProject
//
//  Created by Jakub Krystek on 17.12.2016.
//  Copyright © 2016 Jakub Krystek. All rights reserved.
//

import Foundation

private extension Character
{
    func unicodeScalarCodePoint() -> UInt32
    {
        let characterString = String(self)
        let scalars = characterString.unicodeScalars
        
        return scalars[scalars.startIndex].value
    }
}


class RSA{
    
    private var publicKey:(UInt, UInt) = (0, 0)
    private var privateKey:(UInt, UInt) = (0, 0)
    
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
        
        var i:UInt = 2
        while i < number {
            if number % i == 0 {
                isPrime = false
                break
            }
            i += 1
        }
        return isPrime}
    
    
    private func generatePrimeNumber() -> UInt{ //TODO: improve prime number generator
        var isPrime = false
        var number:UInt = 0
        
        while !isPrime {
            number = randomFromRange(range: Range(uncheckedBounds: (260, 400)))
            isPrime = checkIsPrime(number)
        }
   
    return number
    }
    
    // MARK: - Coprime integers
    
    private func findGreatestCommonDivisor(a:UInt, b:UInt)->UInt{
    
        var tmpValue:UInt = 0
        var bTmp = b
        var aTmp = a

        while bTmp != 0 {
            
            tmpValue = bTmp
            bTmp = aTmp % bTmp
            aTmp = tmpValue
        }
        
    return aTmp}
    
    
 private func modularMultiplicativeInverse(a:UInt, n:UInt) ->UInt{
        
        // helper varble
        var a0:Int64 = 0
        var n0:Int64 = 0
        var p0:Int64 = 0
        var p1:Int64 = 0
        var q:Int64 = 0
        var r:Int64 = 0
        var t:Int64 = 0
        
        p1 = 1
        a0 = Int64(a)
        n0 = Int64(n)
        
        q  = n0 / a0;
        r  = n0 % a0;
        while(r > 0)
        {
            t = p0 - q * p1
            if(t >= 0){
                t = t % Int64(n)}
            else{
                t = Int64(n) - ((-t) % Int64(n))}
            p0 = p1
            p1 = t
            n0 = a0
            a0 = r
            q  = n0 / a0
            r  = n0 % a0
        }
        return UInt(p1);
}
    
    // MARK: - RSA algorithm
  func generateKeys(){
        let pNumber:UInt = generatePrimeNumber()
        let qNumber:UInt = generatePrimeNumber()
    
    let eulerFunction = (pNumber - 1) * (qNumber - 1)
    let nNumber = pNumber * qNumber
    
        var eNumber:UInt = 3 // public key
        var dNumber:UInt = 0 // private key
        
        dNumber = modularMultiplicativeInverse(a:eNumber, n: eulerFunction) // generate max value
        
        while findGreatestCommonDivisor(a: eNumber, b: eulerFunction) != 1
        {
            eNumber += 2
            dNumber = modularMultiplicativeInverse(a:eNumber, n: eulerFunction)
        }
        
    self.publicKey = (eNumber, nNumber)
    self.privateKey = (dNumber, nNumber)
    }
    
    
    private func encrypt(valueToEncrypt:String)->String{
        
        guard valueToEncrypt.characters.count != 0 else {return "";}
        
        let charValue = UInt(valueToEncrypt.characters.first!.unicodeScalarCodePoint())

        
        var encr:UInt = 0
            
        if charValue > UInt(" ".characters.first!.unicodeScalarCodePoint()){
            encr = self.moduloOfBigPower(number: charValue, power: self.publicKey.0, modulo: self.publicKey.1)
            
        }else{
            encr = UInt(pow(Double(charValue), Double(self.publicKey.0))) % self.publicKey.1
        }
        
        var encriptedValue:String = "\(encr)"// encrypted value
        
        
        if encriptedValue.characters.count < 8 {
            encriptedValue = String(repeating: "0", count:  (8 - encriptedValue.characters.count)).appending(encriptedValue) // set value to contain 8 char
        }
        
        return encriptedValue}
    
    private func decrypt(valueToDecrypt:String) -> String {
        guard valueToDecrypt.characters.count != 0 else {return "";}

        let intValue = UInt(valueToDecrypt)!

        let decript = self.moduloOfBigPower(number: intValue, power: self.privateKey.0, modulo: self.privateKey.1)
        
        guard let charValue = UnicodeScalar(UInt32(decript)) else {return ""}
        
        
    return "\(Character(charValue))"}

    
    private  func moduloOfBigPower(number:UInt, power:UInt, modulo:UInt) -> UInt { // calculate modulo of big power

        var arrayOfExponents = [UInt]() // array with exponents used to calculate modulo
        var currentExponent:UInt = 0
        var maxValue = power
        
        while maxValue != 0 {
            
            if maxValue < currentExponent {
                currentExponent >>= 1
                arrayOfExponents.append(currentExponent)
                maxValue -= currentExponent
                currentExponent = 0
            }
            
            if(currentExponent == 0){
                currentExponent = 1}
            else{
                currentExponent <<= 1}
        }
        
        var lastModValue = number % modulo
        
        if(arrayOfExponents.contains(1)){
            arrayOfExponents[arrayOfExponents.index(of: 1)!] = lastModValue
        }
        
        currentExponent <<= 1
        while currentExponent <= arrayOfExponents.max()!
        {
            lastModValue = UInt(pow(Double(lastModValue), 2.0)) % modulo
            
            if(arrayOfExponents.contains(currentExponent)){
                arrayOfExponents[arrayOfExponents.index(of: currentExponent)!] = lastModValue
            }
            
            currentExponent <<= 1
        }
        
        var result:UInt = 1
        for element in arrayOfExponents {
            result = (result * element) % modulo
        }
        
        result %= modulo
        return result}
    
    
// MARK: - public interface
    
    public func encryptValue(value:String) -> String {
        guard value.characters.count != 0 else {return ""}
        var valueEncripted = ""
        
        
        for singleChar in value.characters {
          valueEncripted.append(self.encrypt(valueToEncrypt: String(singleChar)))
        }
        
    return valueEncripted}
    
    
    public func decryptValue(value:String) -> String {
        guard value.characters.count != 0 else {return ""}
        guard (value.characters.count % 8) == 0 else {return ""}

        let numberOfSteps = value.characters.count / 8
        var valueDecrypt = ""

        for step in 0..<numberOfSteps{
            
            let startIndex = value.index(value.startIndex, offsetBy: step*8)
            let endIndex = value.index(startIndex, offsetBy: 7)
            valueDecrypt.append(self.decrypt(valueToDecrypt: value[startIndex...endIndex]))
        }
 
        return valueDecrypt}

}
