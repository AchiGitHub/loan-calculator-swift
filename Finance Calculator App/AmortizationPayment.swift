//
//  AmortizationPayment.swift
//  Finance Calculator App
//
//  Created by Achintha Ikiriwatte on 2020-12-05.
//

import Foundation

class AmortizationPayment {
    var name = ""
    var value = ""
    
    init(name: String, value:String) {
        self.name = name
        self.value = value
    }
}

class TotalPayments {
    var period: String?
    var payments: [AmortizationPayment]?
    
    init(period: String, payments: [AmortizationPayment]) {
        self.period = period
        self.payments = payments
    }
}
