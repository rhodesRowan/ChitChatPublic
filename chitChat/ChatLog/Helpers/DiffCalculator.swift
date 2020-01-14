//
//  DiffCalculator.swift
//  chitChat
//
//  Created by Rowan Rhodes on 16/12/2019.
//  Copyright © 2019 Rowan Rhodes. All rights reserved.
//

import Foundation

class SectionChanges {
    
    // MARK:- Properties
    
    var insertsInts = [Int]()
    var deletesInts = [Int]()
    var updates = CellChanges()
    var inserts: IndexSet {
        return IndexSet(insertsInts)
    }
    var deletes: IndexSet {
        return IndexSet(deletesInts)
    }
}

class CellChanges {
    
    // MARK:- Properties
    
    var inserts = [IndexPath]()
    var deletes = [IndexPath]()
    var reloads = [IndexPath]()
}


class DiffCalculator {
    
    // MARK:- Public
    
    static func calculate<N>(oldSectionItems: [ReloadableSection<N>], newSectionItems: [ReloadableSection<N>]) -> SectionChanges {
        let sectionChanges = SectionChanges()
        let uniqueSectionKeys = (oldSectionItems + newSectionItems).map { $0.key}.filterDuplicates()
        let cellChanges = CellChanges()
        for sectionKey in uniqueSectionKeys {
            let oldSectionItem = ReloadableSectionData(items: oldSectionItems)[sectionKey]
            let newSectionItem = ReloadableSectionData(items: newSectionItems)[sectionKey]
            
            
            if let oldSectionItem = oldSectionItem, let newSectionItem = newSectionItem {
                if oldSectionItem != newSectionItem {
                    // we need to go inside the section and find the difference between the cells
                    let oldCellData =  ReloadableCellData(items: oldSectionItem.value)
                    let newCellData = ReloadableCellData(items: newSectionItem.value)
                    let uniqueCellKeys = (oldCellData.items + newCellData.items).map {$0.key}.filterDuplicates()
                    for cellKey in uniqueCellKeys {
                        let oldCellItem = oldCellData[cellKey]
                        let newCellItem = newCellData[cellKey]
                        if let oldCellItem = oldCellItem, let newCellItem = newCellItem {
                            if oldCellItem != newCellItem {
                                // reload cell
                                cellChanges.reloads.append(IndexPath(row: oldCellItem.index, section: oldSectionItem.index))
                            }
                        } else if let oldItem = oldCellItem {
                            // delete cell
                            cellChanges.deletes.append(IndexPath(row: oldItem.index, section: oldSectionItem.index))
                        } else if let newItem = newCellItem {
                            // insert cell
                            cellChanges.inserts.append(IndexPath(row: newItem.index, section: newSectionItem.index))
                        }
                    }
                }
            } else if let oldSectionItem = oldSectionItem {
                // delete sections
                sectionChanges.deletesInts.append(oldSectionItem.index)
            } else if let newSectionItem = newSectionItem {
                // insert sections
                sectionChanges.insertsInts.append(newSectionItem.index)
            }
        }
        sectionChanges.updates = cellChanges
        return sectionChanges
    }
}
