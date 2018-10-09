//
//  IAProduct.swift
//  nekochat
//
//  Created by Chang Woo Son on 2017. 6. 30..
//  Copyright © 2017년 manekineko. All rights reserved.
//

import Foundation

public struct IAProduct {
    
    public static let UI = "com.manekineko.VoteKorea.UI"
    public static let UX = "com.manekineko.VoteKorea.UX"
    public static let develop = "com.manekineko.VoteKorea.develop"
    public static let plan = "com.manekineko.VoteKorea.plan"

    fileprivate static let productIdentifiers: Set<ProductIdentifier> = [IAProduct.plan, IAProduct.develop, IAProduct.UI, IAProduct.UX]
    
    public static let store = IAPHelper(productIds: IAProduct.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}
