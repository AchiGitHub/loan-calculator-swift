//
//  utility.swift
//  Finance Calculator App
//
//  Created by Achintha Ikiriwatte on 2020-11-30.
//
import Darwin

class Helper{
    
    //MARK: Utility function to calculate monthly interest rate
    static func calculateMonthlyInterestRate(_ interestRate:Double) -> Double {
        return interestRate/1200
    }
    
    //MARK: Utility function to calculate number of months
    static func calculateNumberOfMonthlyPayments(_ numberOfYears: Int) -> Int{
        return numberOfYears*12
    }
    
    //MARK: Utility function to calculate q value in determining interest rate
    static func calculateQpower(_ numberOfPayments: Int) -> Double {
        return log(1+(1/Double(numberOfPayments)))/log(2)
    }
    
    //MARK: Round the double values for 2 decimal places
    static func roundOffDoubleValue(_ exp: Double)-> Double {
        return round(100*exp)/100
    }
    
    // MARK: Calculate mortagage payment
    static func calculateMortgagePaymentAmount(_ interestRate: Double, _ initialInvestment: Double, _ numberOfPayments: Int)-> String {
        
        let calculatedMonthlyInterestRate = calculateMonthlyInterestRate(interestRate)
        let calculatedNumberOfMonthlyPayments = Double(calculateNumberOfMonthlyPayments(numberOfPayments))
        
        let calculated_power_value: Double = pow(1+calculatedMonthlyInterestRate, calculatedNumberOfMonthlyPayments)
        
        let func_numerator: Double = calculateMonthlyInterestRate(interestRate)*initialInvestment*calculated_power_value

        let func_denominator: Double = calculated_power_value - 1;

        let calculated_monthly_payment: Double = func_numerator/func_denominator
        
        let rounded_value = round(100*calculated_monthly_payment)/100
        
        if rounded_value.isNaN {
            return "Calculated payment is unreasonable. Check inputs."
        }
        return String("Rs. \(rounded_value)")
    }
    
    // MARK: Calculate loan payment amount
    static func calculateLoanPaymentAmount(_ interestRate: Double, _ initialInvestment: Double, _ numberOfPayments: Int)-> String {
        
        let calculatedMonthlyInterestRate = calculateMonthlyInterestRate(interestRate)
        let calculatedNumberOfMonthlyPayments = Double(numberOfPayments)
        
        let calculated_power_value: Double = pow(1+calculatedMonthlyInterestRate, calculatedNumberOfMonthlyPayments)
        
        let func_numerator: Double = calculateMonthlyInterestRate(interestRate)*initialInvestment*calculated_power_value

        let func_denominator: Double = calculated_power_value - 1;

        let calculated_monthly_payment: Double = func_numerator/func_denominator
        
        return String("Rs. \(roundOffDoubleValue(calculated_monthly_payment))")
    }
    
    // MARK: Calculate initial amount on a loan
    static func calculateInitialLoanAmount(_ paymentValue: Double, _ interestRate: Double, _ numberOfPayments: Int) -> String {
        
        let calculatedMonthlyInterestRate = calculateMonthlyInterestRate(interestRate)
        let calculatedNumberOfMonthlyPayments = Double(numberOfPayments)
        
        let firstTerm = paymentValue/calculatedMonthlyInterestRate
        
        let secondTerm = 1-pow(1+calculatedMonthlyInterestRate, -1*calculatedNumberOfMonthlyPayments)
        
        return String("Rs. \(roundOffDoubleValue(firstTerm*secondTerm))")
    }
    
    // MARK: Calculate number of payments on a loan
    static func calculateNumberOfPayments(_ paymentValue: Double, _ interestRate: Double, _ loanAmount: Double) -> String {
        
        let calculatedMonthlyInterestRate = calculateMonthlyInterestRate(interestRate)
        
        let funcNumerator = -1*log(Double(1-((calculatedMonthlyInterestRate*loanAmount)/paymentValue)))
        
        let funcDenominator = log(Double(1+calculatedMonthlyInterestRate))
        
        if funcNumerator.isNaN {
            return "Calculated periods unreasonable. Check inputs."
        }
        let numberOfPayments = Int(round(funcNumerator/funcDenominator))
        return String(numberOfPayments)
    }
    
    //MARK: Calculate final value of a loan
    static func calculateFinalValue(_ paymentValue: Double, _ interestRate: Double, _ loanAmount: Double, _ numberOfPayments: Int, _ loan: Bool) -> String {
        
        let calculatedMonthlyInterestRate = calculateMonthlyInterestRate(interestRate)
        let calculatedNumberOfMonthlyPayments = Double(numberOfPayments)
        
        let firstTerm = loanAmount*pow(1+calculatedMonthlyInterestRate,calculatedNumberOfMonthlyPayments)
        
        let paymentInterestRatio = paymentValue/calculatedMonthlyInterestRate
        let paymentInterestRatioTermTwo = pow(1+calculatedMonthlyInterestRate, calculatedNumberOfMonthlyPayments)-1
        
        let secondTerm = paymentInterestRatio*paymentInterestRatioTermTwo
        
        if loan {
            return String(firstTerm-secondTerm)
        } else {
            return String(firstTerm+secondTerm)
        }
    }
    
    //MARK: Calculate interest rate on a loan
    static func calculateInterestRate(_ paymentValue: Double, _ loanAmount: Double, _ numberOfPayments: Int ) -> String {
        let calculatedQValue = calculateQpower(numberOfPayments)
        
        let expressionOne = pow(1+(paymentValue/loanAmount), 1/calculatedQValue)
        
        let approximatedInterest = pow(expressionOne-1, calculatedQValue)-1
        
        if approximatedInterest.isNaN {
            return "Calculated interest rate is unreasonable. Check inputs."
        }
        return String("\(roundOffDoubleValue(approximatedInterest*1200)) %")
        
    }
    
    //MARK: Calculate monthly payment amount to react future value
    static func paymentAmountToReachFutureValue(_ futureValue: Double,_ interestRate: Double, _ numberOfPayments: Int)-> Double{
        let calculatedMonthlyInterestRate = calculateMonthlyInterestRate(interestRate)
        
        let funcNumerator = calculatedMonthlyInterestRate*futureValue
        
        let funcDenominator = pow(1+calculatedMonthlyInterestRate, Double(numberOfPayments))-1
        
        return roundOffDoubleValue(funcNumerator/funcDenominator)
    }
    
    //MARK: Calculate number of payments for invetment
    static func calculatePaymentsForInvestment(_ futureValue: Double,_ interestRate: Double, _ paymentValue: Double) -> Double{
        let calculatedMonthlyInterestRate = calculateMonthlyInterestRate(interestRate)
        
        let funcNumerator = log(1+(calculatedMonthlyInterestRate*futureValue)/paymentValue)
        
        let funcDenominator = log(1+calculatedMonthlyInterestRate)
        
        return roundOffDoubleValue(funcNumerator/funcDenominator)
        
    }
    
    //MARK: Calculate interest rate on invetment
    static func calculateInterestRateForInvestment(_ futureValue: Double, _ investmentAmount: Double, _ numberOfCompunds: Double, _ investedDuration: Int) -> String {
        let secondTerm = pow(futureValue/investmentAmount, 1/(numberOfCompunds*Double(investedDuration)))-1
        
        let interestRateOnInvestment = roundOffDoubleValue(numberOfCompunds*secondTerm)
        
        if interestRateOnInvestment.isNaN {
            return "Invalid Inputs. Please check the inputs."
        }
        return String("\(interestRateOnInvestment) %")
    }
    
    //MARK: Calculate time that will be elapsed for investment to reach future value
    
    static func calculateDuration(_ futureValue: Double, _ initialInvestment: Double, _ interestRate: Double, _ numberOfCompounds: Double) -> String {
        let calculatedMonthlyInterestRate = calculateMonthlyInterestRate(interestRate)
        let numerator = log(futureValue/initialInvestment)
        let denominator = numberOfCompounds*(log(1+calculatedMonthlyInterestRate/numberOfCompounds))
        
        if Int(numerator/denominator) < 0 {
            return "Invalid Inputs. Please check the Inputs"
        }
        return String("\(Int(numerator/denominator)) Months")
    }
    
    //MARK: Calculate principal amount on investment
    static func calculatePrincipalAmount(_ futureValue: Double, _ interestRate: Double, _ numberOfCompounds: Int, _ duration: Int) -> String {
        let calculatedMonthlyInterestRate = calculateMonthlyInterestRate(interestRate)
        let denominator = pow(1+(calculatedMonthlyInterestRate/Double(numberOfCompounds)), Double(numberOfCompounds*duration))
        
        if denominator.isNaN {
            return "Invalid Inputs. Please check the values"
        }
        return String("Rs. \(roundOffDoubleValue(futureValue/denominator))")
    }
    
    // MARK: Compound Interest for principal
    static func calculateCompoundInterest(_ initialValue: Double, _ numberOfCompounds: Int, _ interestRate: Double, _ duration: Int) -> Double {
        return initialValue*pow((1+interestRate/Double(numberOfCompounds)), Double(numberOfCompounds*duration))
    }
    
    //MARK: Calculate Final future value
    static func calculateTotalFutureValue(_ initialInvestment: Double, _ interestRate: Double,_ paymentAmount: Double, _ duration: Int, _ numberOfCompounds: Int ,_ monthStart: Bool) -> String {
        let calculatedMonthlyInterestRate = calculateMonthlyInterestRate(interestRate)
        let compoundInterest = calculateCompoundInterest(initialInvestment, numberOfCompounds, interestRate, duration)
        
        let numerator = pow(1+(calculatedMonthlyInterestRate/Double(numberOfCompounds)), Double(numberOfCompounds*duration))-1
        let denominator = calculatedMonthlyInterestRate/Double(numberOfCompounds)
        
        if denominator == 0 {
            return "Invalid Inputs. Please Provide valid inputs"
        }
        let futureValueOfASeries = paymentAmount*(numerator/denominator)
        
        if monthStart {
            let futureValueAtStart = futureValueOfASeries*(1+(calculatedMonthlyInterestRate/Double(numberOfCompounds)))
            return "Rs. \(roundOffDoubleValue(compoundInterest+futureValueAtStart))"
        }
        
        return String("Rs. \(roundOffDoubleValue(compoundInterest+futureValueOfASeries))")
    }
    
}
