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
    
    @StateObject var controller = ContentViewController()
        
    func GetTitleText()  -> String {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        return "Collection Composer - Version \(appVersion!)" 
    }
    
    var body: some View {

        VStack {
            Text("Sourcepaths")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Table(controller.folderInfos ,selection: $controller.selectedFolderInfoIds  ) {
                TableColumn("Path", value: \.FolderDisplayValue)
               TableColumn("Files", value: \.FileCountDisplayValue).width(50)
            }
            
            HStack {
                Button("Add Folder") { controller.addSourceFolder() }
                Button("Count Files") { controller.countSourceFoldersFiles() }
                Spacer()
                Button("Remove Folder") { controller.removeSourceFolder() }
            }.padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                   
            VStack {
                Text("Destinationpath")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    TextField("", text: $controller.destinationPath)
                    Button("...") { controller.pickDestinationFolder() }
                }
                
                Text("Number of files to copy")
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextField("", text: $controller.numbersOfFilesToCopy)
                
                Text("Contains Keywords (seperate with comma)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextField("", text: $controller.keywords)
                            
                Toggle("Delete Original Files", isOn: $controller.deleteOriginal)
                    .frame(maxWidth: .infinity, alignment: .leading)
            
                Text(controller.copyCounterLabel)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                HStack {
                    Spacer()
                    Button("Copy Files") { controller.copyFiles() }
                }
            }

        }.padding()
            .navigationTitle(self.GetTitleText())

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
