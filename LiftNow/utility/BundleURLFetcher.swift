//
//  BundleURLFetcher.swift
//  LiftNow
//
//  Created by Prithiviraj on 01/07/22.
//

import Foundation

//MARK: ENUM(FileFormat)
enum FileFormat {
    case apng
    case webp
}

final class BundleURLFetcher {
        
    //MARK: PROPERTIES
    // defined properties for static file names
    private let apnResources: [String] = ["water_waves"]
    
    private let webPResources: [String] = ["webp_anim"]
    
    
    //MARK: FETCH URL METHOD
    func fetchURL(for format: FileFormat) -> URL? {
        switch format {
        case .apng:
            return fetchAPNGUrl()
        case .webp:
            return fetchWebPUrl()
        }
    }
}

//MARK: PRIVATE METHODS
private extension BundleURLFetcher {
    
    func fetchAPNGUrl() -> URL? {
        let resource = apnResources.randomElement()
        let bundleUrl = Bundle.main.url(forResource: resource, withExtension: "png")
        return bundleUrl
    }
    
    func fetchWebPUrl() -> URL? {
        let resource = webPResources.randomElement()
        let bundleUrl = Bundle.main.url(forResource: resource, withExtension: "webp")
        return bundleUrl
    }
}
