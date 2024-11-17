//
//  FileLoader.swift
//  iOS
//
//  Created by George Nyakundi on 13/03/2023.
//

import Foundation
import OSLog

/// FileLoader is reads the contents of a file,  as type `T`, where T is Decodable
class FileLoader<T> where T: Decodable {
    private let fileName: String
    private let fileExt: String
    private let bundle: Bundle
    
    private let decoder = JSONDecoder()
    private let logger = Logger(subsystem: .subsystem, category: .categoryFileloader)
    
    init(fromFile fileName: String, withExtension fileExt: String = "json", bundle: Bundle = .main){
        self.fileName = fileName
        self.fileExt = fileExt
        self.bundle = bundle
    }
    
    enum Error: Swift.Error {
        case fileNotFound
        case corruptedFile
    }
    
    func load(completion: @escaping(Result<T, Error>) -> Void) {
        guard let url = bundle.url(forResource: fileName, withExtension: fileExt) else {
            completion(.failure(.fileNotFound))
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let information = try decoder.decode(T.self, from: data)
            completion(.success(information))
        } catch {
            logger.error("loading/decoding failed: \(error.localizedDescription)")
            completion(.failure(.corruptedFile))
        }
    }
    
}
