

import Foundation

struct CreateAcronymData: Codable {
  let short: String
  let long: String
}

extension Acronym {
  func toCreateData() -> CreateAcronymData {
    CreateAcronymData(short: self.short, long: self.long)
  }
}
