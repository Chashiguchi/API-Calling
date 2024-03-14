//
//  ContentView.swift
//  API Calling
//
//  Created by chase Hashiguchi on 3/8/24.
//

import SwiftUI

struct ContentView: View {
    @State private var facts = [String]()
    var body: some View {
        NavigationView {
            List(facts, id: \.self) {fact in
                Text(fact)
            }
            .navigationTitle("Random Cat Facts")
            .toolbar {
                Button(action: {
                    Task {
                        await loadData()
                    }
                }, label: {
                    Image(systemName: "arrow.clockwise")
                })
            }
        }
        .task {
            await loadData()
        }
    }
    
    func loadData() async {
        if let url = URL(string: "https://meowfacts.herokuapp.com/?count=20") {
            if let (data, _) = try? await URLSession.shared.data(from: url) {
                if let decodedResponce = try? JSONDecoder().decode(Facts.self, from: data) {
                    facts = decodedResponce.facts
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
 ContentView()
    }
}

struct Facts: Identifiable, Codable {
    var id = UUID()
    var facts: [String]
    
    enum CodingKeys: String, CodingKey {
        case facts = "data"
    }
}
