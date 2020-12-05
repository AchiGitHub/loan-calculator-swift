//
//  TableViewController.swift
//  Finance Calculator App
//
//  Created by Achintha Ikiriwatte on 2020-12-05.
//

import UIKit

class MobileBrand{
    var brandName: String?
    var modelName: [String]?
    
    init(brandName: String, modelName:[String]) {
        self.brandName = brandName
        self.modelName = modelName
    }
}

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    @IBOutlet weak var tableView: UITableView!
    
    var period = ""
    var interestRate = 0.0
    var loanBalance = ""
    var monthlyPayment = ""
    
    var totalPayments = [TotalPayments]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let calculatedPeriod = Helper.calculateNumberOfMonthlyPayments(Int(period) ?? 0)
        var convertedLoanAmount = Double(loanBalance) ?? 0
        let calculatedInterestRate = Helper.calculateMonthlyInterestRate(interestRate)
        let convertedMonthlyPayment = Double(monthlyPayment) ?? 0
        
        print(monthlyPayment)
        for i in 1..<calculatedPeriod {
            
            var amortizationPayment = [AmortizationPayment]()
            
            let interestPayment = calculatedInterestRate*convertedLoanAmount
            let principalPayment = convertedMonthlyPayment-interestPayment
            
            if convertedLoanAmount>principalPayment {
                convertedLoanAmount = convertedLoanAmount - principalPayment
            }
            
            amortizationPayment.append(AmortizationPayment.init(name: "Monthly Payment", value: "Rs.\(Helper.roundOffDoubleValue(convertedMonthlyPayment))"))
            amortizationPayment.append(AmortizationPayment.init(name: "Interest Payment", value: "Rs.\(Helper.roundOffDoubleValue(interestPayment))"))
            amortizationPayment.append(AmortizationPayment.init(name: "Principal Payment", value: "Rs.\(Helper.roundOffDoubleValue(principalPayment))"))
            amortizationPayment.append(AmortizationPayment.init(name: "Loan Balance", value: "Rs.\(Helper.roundOffDoubleValue(convertedLoanAmount))"))
            
            totalPayments.append(TotalPayments.init(period: "Period \(i)", payments: amortizationPayment))
        }
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return totalPayments.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalPayments[section].payments?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = totalPayments[indexPath.section].payments?[indexPath.row].name
        cell.detailTextLabel?.text = totalPayments[indexPath.section].payments?[indexPath.row].value
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return totalPayments[section].period
    }
    
}
