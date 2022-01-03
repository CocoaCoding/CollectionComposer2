//  FolderInfoRepository.swift
//  CollectionComposer2
//  Created by Holger Hinzberg on 03.01.22.

import Foundation

public class FolderInfoRepository
{
    private  var filename : URL
    public var folderInfos = [FolderInfo]()
    
    init()
    {
        self.filename = FileHelper.shared.getDocumentsDirectory().appendingPathComponent("folderinfo")
    }
    
    public func Add(info : FolderInfo)
    {
        self.folderInfos.append(info)
    }
    
    public func GetCount() -> Int
    {
        return self.folderInfos.count
    }
    
    public func GetItemAt(index : Int) -> FolderInfo
    {
        return self.folderInfos[index]
    }

    public func removeItemAt(index : Int)
    {
        if index >= 0 && index < folderInfos.count
        {
            self.folderInfos.remove(at: index)
        }
    }
    
    public func removeItemById(id: UUID)
    {
        var index = 0
        for info in folderInfos
        {
            if info.id == id
            {
                self.folderInfos.remove(at: index)
                return
            }
            index += 1
        }
    }
        
    public func Load()
    {
        do {
            guard let nsdata = NSData(contentsOf: self.filename) else { return }
            let data = Data(referencing: nsdata)
            
            if let loadedInfos = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [FolderInfo] {
                self.folderInfos.removeAll()
                
                for info in loadedInfos
                {
                    self.folderInfos.append(info)
                }
                print("Repository loaded")
            }
        }
        catch
        {
            print("Couldn't read file.")
        }
    }
    
    public func Save()
    {
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: self.folderInfos, requiringSecureCoding: false)
                try data.write(to: self.filename)
                print("Repository saved")
            } catch {
                print("Repository not saved")
            }
    }
}
