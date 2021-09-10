import UIKit

let configuration = URLSessionConfiguration.default
let session = URLSession(configuration: configuration)

struct AMSongs: Codable {
    struct Song: Codable {
        let collectionName: String
        let trackName: String
        let artistViewUrl: String
        let collectionViewUrl: String
        let trackViewUrl: String
        let artworkUrl100: String
        let releaseDate: String
        let trackCount: Int
        let trackNumber: Int
        let primaryGenreName: String
    }
    var results: [Song]
}

guard let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=dookie+green+day") else {
    fatalError()
}

let task = session.dataTask(with: url) { data, response, error in
    guard let httpResponse = response as? HTTPURLResponse,
          (200..<300).contains(httpResponse.statusCode),
          let data = data else {
        return
    }
    
    do {
        let result = try JSONDecoder().decode(AMSongs.self, from: data)
        result.results.forEach { song in
            print(song, "\n")
        }
    } catch {
        print("Error decoding results: \(error)")
    }
}

task.resume()





