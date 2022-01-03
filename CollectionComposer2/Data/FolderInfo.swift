//  FolderInfo.swift
//  CollectionComposer2
//  Created by Holger Hinzberg on 03.01.22.

import Foundation

public class FolderInfo: NSObject, NSCoding, Identifiable
{
    public var Folder = "";
    public var FileCount = 0;
    public var FilesInFolder:[URL]? = nil
    public var id = UUID()

    public var FolderDisplayValue : String { return Folder }
    public var FileCountDisplayValue : String { return "\(FileCount)" }
        
    public override init()
    {
    }
    
    public func encode(with aCoder: NSCoder)
    {
        aCoder.encode(self.Folder, forKey: "Folder")
    }
    
    public required init?(coder aDecoder: NSCoder)
    {
        self.Folder = aDecoder.decodeObject(forKey:"Folder") as! String
    }
}
