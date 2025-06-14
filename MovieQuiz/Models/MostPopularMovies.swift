import Foundation

struct MostPopularMovies: Codable {
    let errorMessage: String?
    let items: [MostPopularMovie]
}

struct MostPopularMovie: Codable {
    let rating: String
    let imageURL: URL
    var resizedImageURL: URL {
        let urlString = imageURL.absoluteString
        let imageUrlString = urlString.components(separatedBy: "._")[0] + "._V0_UX600_.jpg"
        guard let newURL = URL(string: imageUrlString) else {
            return imageURL
        }
        return newURL
    }
    
    private enum CodingKeys: String, CodingKey {
        case rating = "imDbRating"
        case imageURL = "image"
    }
}
