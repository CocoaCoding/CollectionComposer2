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
    @Published public var selectedFolderInfoIds = Set<FolderInfo.ID>()
    
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
    
    private func getFilesURLFromFolder(_ folderURL: URL) -> [URL]?
    {
        let options: FileManager.DirectoryEnumerationOptions =
            [.skipsHiddenFiles, .skipsSubdirectoryDescendants, .skipsPackageDescendants]
        
        let fileManager = FileManager.default
        let resourceValueKeys = [URLResourceKey.isRegularFileKey, URLResourceKey.typeIdentifierKey]
        
        guard let directoryEnumerator = fileManager.enumerator(at: folderURL, includingPropertiesForKeys: resourceValueKeys,
                                                               options: options, errorHandler: { url, error in
                                                                print("`directoryEnumerator` error: \(error).")
                                                                return true
        }) else { return nil }
        
        var urls: [URL] = []
        for case let url as URL in directoryEnumerator
        {
            do {
                let resourceValues = try (url as NSURL).resourceValues(forKeys: resourceValueKeys)
                guard let isRegularFileResourceValue = resourceValues[URLResourceKey.isRegularFileKey] as? NSNumber else { continue }
                guard isRegularFileResourceValue.boolValue else { continue }
                guard let fileType = resourceValues[URLResourceKey.typeIdentifierKey] as? String else { continue }
                guard UTTypeConformsTo(fileType as CFString, "public.image" as CFString) else { continue }
                urls.append(url)
            }
            catch
            {
                print("Unexpected error occured: \(error).")
            }
        }
        return urls
    }
    
    // MARK: - Button Actions
    
    public func addSourceFolder()
    {
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
                
                FileBookmarkHandler.shared.storeFolderInBookmark(url: folderUrl)
                FileBookmarkHandler.shared.saveBookmarksData()
            }
        }
    }
    
    public func removeSourceFolder()
    {
        for id in selectedFolderInfoIds {
            folderInfoRepository.removeItemById(id: id)
        }
        self.folderInfoRepository.Save()
        self.folderInfos = folderInfoRepository.folderInfos
    }
        
    public func countSourceFoldersFiles() {
        let filesHelper = HHFileHelper()
        let count = self.folderInfoRepository.GetCount()
        
        for index in 0..<count
        {
            let info = self.folderInfoRepository.GetItemAt(index: index)
            info.FileCount = filesHelper.getFilesCount(folderPath: info.Folder)
        }
        self.folderInfos = folderInfoRepository.folderInfos
    }
    
    private func getRandomFileUrls(_ fileURLs:[URL], count:Int, containingKeywords:[String]) -> [URL]
    {
        // You can not get more files than avalible
        var randomFilesCount = count
        if fileURLs.count < randomFilesCount
        {
            randomFilesCount = fileURLs.count
        }
        
        // Fill Dictionary with random entries
        var randomFileUrlsDict = [String:URL]()
        while randomFileUrlsDict.count < randomFilesCount
        {
            let randomPosition = arc4random_uniform( UInt32(fileURLs.count - 1))
            let url = fileURLs[Int(randomPosition)]
            
            var containingAllKeywords = true
            
            for keyword in containingKeywords
            {
                if url.path.caseInsensitiveContains(substring: keyword) == false && keyword != ""
                {
                    containingAllKeywords = false
                    break
                }
            }
            
            if containingAllKeywords == true
            {
                randomFileUrlsDict[url.path] = url
            }
        }
        
        // Transfer Dictionary Keys to Array
        let randomFileUrlsArray = Array(randomFileUrlsDict.values)
        return randomFileUrlsArray
    }
    
    public func pickDestinationFolder() {
        if let url = self.openFileDialog()
        {
            self.destinationPath = url.path
            FileBookmarkHandler.shared.storeFolderInBookmark(url: url)
            FileBookmarkHandler.shared.saveBookmarksData()
        }
    }
    
    public func copyFiles() {
        
        //self.UpdateConfigValuesAndSave()
        //self.copyButton.isEnabled = false
        //self.copyCounterLabel.stringValue = ""
        
        // Assign all the Files in the Folders to the FolderInfos
        let count = self.folderInfoRepository.GetCount()
        for index in 0..<count
        {
            let info = self.folderInfoRepository.GetItemAt(index: index)
            let url = URL(fileURLWithPath: info.Folder)
            info.FilesInFolder = self.getFilesURLFromFolder(url)
        }
        
        // Collect random URLs from the Folders
        var itemIndex = 0
        var randomFileUrls = [URL]()
        let keywords = self.keywords.components(separatedBy: ",")
        let countNeeded = Int(self.numbersOfFilesToCopy)! // todo
        
        for _ in 0...countNeeded
        {
            let info = self.folderInfoRepository.GetItemAt(index: itemIndex)
            if let files = info.FilesInFolder
            {
                if files.count  > 0
                {
                    // Pick one random File
                    let randFiles = self.getRandomFileUrls(files, count: 1, containingKeywords: keywords)
                    randomFileUrls.append(contentsOf: randFiles)
                }
            }
            
            // The next FolderInfo
            itemIndex = itemIndex + 1
            if itemIndex == self.folderInfoRepository.GetCount()
            {
                itemIndex = 0
            }
        }
        
        // Copy the random Files to the Destination
        let fileHelper = HHFileHelper()
        let destinationUrl = URL(fileURLWithPath: destinationPath);
        let copyCounter = fileHelper.copyFiles(sourceUrls: randomFileUrls, toUrl: destinationUrl)
        //self.copyCounterLabel.stringValue = "\(copyCounter) files copied"
        //self.copyButton.isEnabled = true
        
        // Delete original files
        if deleteOriginal == true
        {
            for url in randomFileUrls
            {
                let _ = fileHelper.deleteItemAtPath(sourcePath: url.path)
            }
        }
    }
}
