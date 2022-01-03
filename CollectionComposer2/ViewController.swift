//  ViewController.swift
//  CollectionComposer2
//  Created by Holger Hinzberg on 03.01.22.

import SwiftUI

public class ViewController : ObservableObject {
    
    @AppStorage("destinationPath") var destinationPath: String = ""
    @AppStorage("keywords") var keywords: String = ""
    @AppStorage("numbersOfFilesToCopy") var numbersOfFilesToCopy: String = ""
    @AppStorage("deleteOriginal") var deleteOriginal: Bool = true
    
    @Published public var folderInfos = [FolderInfo]()
    
    private let folderInfoRepository = FolderInfoRepository()
    
    init() {
        folderInfoRepository.Load()
        self.folderInfos = folderInfoRepository.folderInfos
    }
        
    func openFileDialog() -> URL?
    {
        let fileDialog = NSOpenPanel()
        fileDialog.canChooseFiles = false
        fileDialog.canChooseDirectories = true
        fileDialog.runModal()
        return fileDialog.url
    }
    
    // MARK: - Button Actions
    
    public func addSourceFolder() {
        if let folderUrl = self.openFileDialog()
        {
            if folderUrl.path != ""
            {
                let fileHelper = HHFileHelper()
                let foldersInfo = FolderInfo()
                foldersInfo.Folder = folderUrl.path
                foldersInfo.FileCount = fileHelper.getFilesCount(folderPath: folderUrl.path)
                self.folderInfoRepository.Add(info: foldersInfo)
                self.folderInfoRepository.Save()
                self.folderInfos = folderInfoRepository.folderInfos
            }
        }
    }
    
    public func countSourceFoldersFiles() {
        
    }
    
    public func pickDestinationFolder() {
        if let url = self.openFileDialog()
        {
            self.destinationPath = url.path
        }
    }
    
    public func copyFiles() {
        
    }
}
