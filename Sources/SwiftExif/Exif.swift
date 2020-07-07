//
//  Extensions.swift
//  SwiftExif
//
//  Created by Kristoffer Dalby on 05/07/2020.
//

import Foundation
import exif

let EXIFIFDCOUNT = 5

extension ExifData {
  static func new(imagePath: String) -> ExifData? {
    let rawUnsafeExifData = exif_data_new_from_file(imagePath)

    if let rawExifData = rawUnsafeExifData {
      return rawExifData.pointee
    }

    return nil
  }

  mutating func content() -> [ExifContent] {

    let contents = withUnsafePointer(
      to: &self.ifd.0
    ) {
      Array(
        UnsafeBufferPointer(
          start: $0, count: EXIFIFDCOUNT
        ))
    }

    return contents.compactMap({ $0?.pointee })
  }

  mutating func toDict() -> [String: [String: String]] {
    let ifds = ["0", "1", "EXIF", "GPS", "Interoperability"]
    return Dictionary(
      uniqueKeysWithValues:
        zip(ifds, self.content()).map({ ($0, $1.toDict()) }))
  }
}

extension ExifContent {
  // mutating func ifdName() -> String? {
  //   let ifd = withUnsafeMutablePointer(
  //     to: &self
  //   ) { exif_content_get_ifd($0) }

  //   if let ifdName = exif_ifd_get_name(ifd) {
  //     let str = String(cString: ifdName)
  //     return str
  //   }

  //   return nil
  // }

  func entries() -> [ExifEntry] {
    if let rawEntries = self.entries {
      let entries = Array(
        UnsafeBufferPointer(
          start: rawEntries,
          count: Int(self.count)
        )
      )

      return entries.compactMap({ $0?.pointee })
    }

    return []
  }

  func toDict() -> [String: String] {
    var entries = [(String, String)]()
    for var entry in self.entries() {
      if let tuple = entry.toTuple() {
        entries.append(tuple)
      }
    }

    return Dictionary(uniqueKeysWithValues: entries)
  }
}

extension ExifEntry {
  func key() -> String? {

    let ifd = exif_content_get_ifd(self.parent)

    if let name = exif_tag_get_title_in_ifd(self.tag, ifd) {
      let str = String(cString: name)
      return str
    }

    return nil
  }

  mutating func value() -> String {

    let value = UnsafeMutablePointer<Int8>.allocate(capacity: 256)
    exif_entry_get_value(
      &self,
      value,
      256
    )

    let str = String(cString: value)
    return str
  }

  mutating func toTuple() -> (String, String)? {
    if let key = self.key() {
      let value = self.value()

      return (key, value)
    }
    return nil
  }
}