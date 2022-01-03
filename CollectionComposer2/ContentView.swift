//  ContentView.swift
//  CollectionComposer2
//  Created by Holger Hinzberg on 03.01.22.

import SwiftUI

struct Person: Identifiable {
    let givenName: String
    let familyName: String
    let id = UUID()
}

struct ContentView: View {
    
    @State var delete : Bool = true
    @State var text : String = "Hello World"
    
    private var people = [
        Person(givenName: "Juan", familyName: "Chavez"),
        Person(givenName: "Mei", familyName: "Chen"),
        Person(givenName: "Tom", familyName: "Clark"),
        Person(givenName: "Gita", familyName: "Kumar"),
    ]
        
    var body: some View {

        VStack {
            Text("Sourcepaths")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Table(people) {
               TableColumn("Path", value: \.givenName)
               TableColumn("Files", value: \.familyName)
            }
            
            HStack {
                Button("Add Source") {}
                Button("Count Files") {}
                Spacer()
            }
                   
            VStack {
                Text("Destinationpath")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    TextField("", text: $text)
                    Button("...") {}
                }
                
                Text("Number of files to copy")
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextField("", text: $text)
                
                Text("Contains Keywords (seperate with comma)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    TextField("", text: $text)
                            
                Toggle("Delete Original Files", isOn: $delete)
                    .frame(maxWidth: .infinity, alignment: .leading)
            
                HStack {
                    Spacer()
                    Button("Copy Files") {}
                }
            }

        }.padding()

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
