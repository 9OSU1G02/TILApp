//
//  File.swift
//
//
//  Created by Nguyen Quoc Huy on 5/26/23.
//

import Fluent
import Foundation

// 1
final class AcronymCategoryPivot: Model {
  static let schema = "acronym-category-pivot"
  
  // 2
  @ID
  var id: UUID?
  
  // 3
  @Parent(key: "acronymID")
  var acronym: Acronym
  
  @Parent(key: "categoryID")
  var category: Category
  
  // 4
  init() {}
  
  // 5
  init(
    id: UUID? = nil,
    acronym: Acronym,
    category: Category
  ) throws {
    self.id = id
    self.$acronym.id = try acronym.requireID()
    self.$category.id = try category.requireID()
  }
}
