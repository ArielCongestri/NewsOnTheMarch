//
//  PlistManager.swift
//  Digital House Tools
//
//  Copyright © 2017 Digital House. All rights reserved.
//

import Foundation


class PlistManager {

    /*
     *  Función a usar para leer un archivo PLIST cuyo elemento raíz es un array.
     *  Parámetro 'name' : nombre del archivo (sin la extensión .plist).
     *  Tipo de Retorno  : array de diccionarios
     */
    static func readArray(name: String) -> [[String: AnyObject]] {
        var result: [[String: AnyObject]] = []

        if let plistPath = Bundle.main.path(forResource: name, ofType: "plist") {
            if let plistData = FileManager.default.contents(atPath: plistPath) {

                var propertyListFormat =  PropertyListSerialization.PropertyListFormat.xml
                do {
                    result = try PropertyListSerialization.propertyList(from: plistData,
                                                                        options: .mutableContainersAndLeaves,
                                                                        format: &propertyListFormat) as! [[String: AnyObject]]
                } catch {
                    print("Error reading plist: \(error)")
                }

            } else {
                print("Error reading plist: could not read file")
            }

        } else {
            print("Error reading plist: file not found")
        }

        return result
    }


    /*
     *  Función a usar para leer un archivo PLIST cuyo elemento raíz es un diccionario.
     *  Parámetro 'name': nombre del archivo (sin la extensión .plist).
     *  Tipo de Retorno  : diccionario
     */
    static func readDictionary(name: String) -> [String: AnyObject] {
        var result: [String: AnyObject] = [:]

        if let plistPath = Bundle.main.path(forResource: name, ofType: "plist") {
            if let plistData = FileManager.default.contents(atPath: plistPath) {

                var propertyListFormat =  PropertyListSerialization.PropertyListFormat.xml
                do {
                    result = try PropertyListSerialization.propertyList(from: plistData,
                                                                        options: .mutableContainersAndLeaves,
                                                                        format: &propertyListFormat) as! [String: AnyObject]
                } catch {
                    print("Error reading plist: \(error)")
                }

            } else {
                print("Error reading plist: could not read file")
            }

        } else {
            print("Error reading plist: file not found")
        }

        return result
    }

}
