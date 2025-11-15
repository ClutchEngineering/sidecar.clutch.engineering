import Foundation

package func localizedNameForStandardizedMake(_ make: String) -> String {
  switch make {
  case "alfaromeo": return "Alfa Romeo"
  case "bmw": return "BMW"
  case "citroen": return "Citroën"
  case "greatwall": return "GWM"
  case "gwm": return "GWM"
  case "gmc": return "GMC"
  case "landrover": return "Land Rover"
  case "mg": return "MG"
  case "smart": return "smart"
  case "skoda": return "Škoda"
  default: return make.capitalized
  }
}

package func standardizeMake(_ make: String) -> String {
  let normalizedMake = make.lowercased()
  let mapping: [String: String] = [
    "audidi": "audi",
    "audu": "audi",
    "bmw4series": "bmw",
    "alfa romeo": "alfaromeo",
    "great wall": "gwm",
    "land rover": "landrover",
    "peugeot iran khodro": "peugeot",
    "mercedes-benz": "mercedes",
    "mercedes benz": "mercedes",
    "opel": "vauxhall-opel",
    "citroën": "citroen",
    "vw": "Volkswagen",
    "vauxhall": "vauxhall-opel",
    "vauxhall/opel": "vauxhall-opel",
  ]

  let make = mapping[normalizedMake] ?? normalizedMake
  let standardizedMake = make
    .replacingOccurrences(of: " ", with: "")
    .replacingOccurrences(of: "-s", with: "")
    .replacingOccurrences(of: "/", with: "-")
    .applyingTransform(.stripDiacritics, reverse: false)!
    .lowercased()
  return mapping[standardizedMake] ?? standardizedMake
}
