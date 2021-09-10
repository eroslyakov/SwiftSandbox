import SwiftUI
import Combine

@available(iOS 14.0, *)
struct ContentView: View {
    
    enum SearchPlaceholder: String {
        case search = "Search for music"
        case empty = "Enter something for search"
    }
    
    @State var searchingText: String = "dookie"
    
    @State private var musicItems: [MusicItem] = []
    @State private var cancellable: AnyCancellable?
    @State private var isEmptySearch = false
    @State var placeholder = SearchPlaceholder.search
    
    var body: some View {
        VStack {
            HStack() {
                Spacer(minLength: 8)
                TextField(placeholder.rawValue, text: $searchingText)
                    .padding(7)
                    .padding(.horizontal, 25)
                    .background(Color(.systemGray6))
                    .accentColor(isEmptySearch ? .red : .black)
                    .cornerRadius(8)
                    .shadow(color: isEmptySearch ? Color(.systemRed) : .white, radius: 2)
                    .onChange(of: "text", perform: { _ in if isEmptySearch { isEmptySearch = false } })
                    .overlay(
                        HStack(alignment: .top, spacing: 20) {
                            if !searchingText.isEmpty {
                                Button(action: { self.searchingText = "" }, label: {
                                    Image(systemName: "multiply.circle.fill")
                                })
                                .foregroundColor(Color(.systemGray))
                                .frame(width: 20, height: 20)
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width - 64, alignment: .trailing)
                    )
                Button(action: fetchMusic, label: {
                    Image(systemName: "magnifyingglass.circle.fill")
                }).foregroundColor(.blue)
                Spacer(minLength: 8)
            }
            
            List(musicItems) { item in
                HStack(spacing: 20) {
                    Text(item.trackName)
                        .frame(width: UIScreen.main.bounds.width - 160, alignment: .center)
                        .multilineTextAlignment(.trailing)
                    AsyncImage(url: item.artwork)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                    Spacer(minLength: 20)
                }
                .frame(width: UIScreen.main.bounds.width, height: 120)
            }
            Spacer()
        }
    }
    
    func fetchMusic() {
        guard !searchingText.isEmpty else {
            isEmptySearch = true
            placeholder = SearchPlaceholder.empty
            return
        }
        let formatted = searchingText
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: " ", with: "+")
        guard let url =  URL(string:"https://itunes.apple.com/search?media=music&entity=song&term=\(formatted)") else {
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .replaceError(with: Data())
            .decode(type: MediaResponse.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { _ in },
                  receiveValue: { decoded in
                    self.musicItems = decoded.results
                    self.searchingText = ""
                  })
    }
}


@available(iOS 14.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
