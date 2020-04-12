//
//  LocalizedErrorMessageResponseDTO.swift
//  App
//
//  Created by Bruno Metzker on 12/04/20.
//

import Foundation
import Vapor

struct LocalizedErrorMessageResponseDTO: Content {
    let message: String
}
