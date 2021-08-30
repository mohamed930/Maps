//
//  LocationsModel.swift
//  Maps
//
//  Created by Mohamed Ali on 29/08/2021.
//

import Foundation
import FirebaseFirestoreSwift

struct LocationModel: Codable {
    var id: String
    var shopName: String
    var shopDescribtion: String
    var shopicon: String
    var long: Double
    var lati: Double
}
