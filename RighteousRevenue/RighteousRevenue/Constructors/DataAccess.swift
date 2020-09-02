//
//  DataAccess.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/3/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import Foundation
import SQLite
import UIKit
import SwiftTheme

extension String {
    var bool: Bool? {
        switch self.lowercased() {
        case "true":
            return true
        case "false":
            return false
        default:
            return nil
        }
    }
}

class dataAccess{
    private var database: Connection!

       init(){
           makeConnectionToDB();
       }

   private func makeConnectionToDB()
       {
           do{
                  //this creates a folder in the users phone to where we can store the database
                  let documentDirectory = try FileManager.default.url(for: .documentDirectory,
                  in: .userDomainMask, appropriateFor: nil, create: true)
                  //this creates the database name in the file or folder we created above
                  let fileUrl = documentDirectory.appendingPathComponent("RighteousRevenueData").appendingPathExtension("sqlite3")
                  let database = try Connection(fileUrl.path)//this creates a connection to the database
                  self.database = database//this makes the connection that we made to the database global so that we can make calls and changes in the lines below
               }catch{
                  print(error)
               }

           //Check To See if Table has been Created
           var TableCreated:Int64 = 0
           let Query = "SELECT COUNT(*) FROM sqlite_master WHERE type='table' AND name='PieData'"
           do{
               let tableHere = try database.prepare(Query)
               TableCreated = try tableHere.scalar() as! Int64
           }catch{}
           
           if(TableCreated == 0)
           {
               createTables()
           }
           
       }

   private func createTables()
       {
        var defaultColorsIndexes:[String] = []
        if(ThemeManager.currentThemeIndex == 1){
            for i in 0...5{
                defaultColorsIndexes.append(ColorNames[i])
            }
        }else{
            for i in 6...11{
                defaultColorsIndexes.append(ColorNames[i])
            }
        }
           let createPieDataTable = "CREATE TABLE PieData(DataID INTEGER PRIMARY KEY AUTOINCREMENT, Section INTEGER, BillName STRING, BillAmount DOUBLE, BillPayed STRING)"
           let createIconChoiceTable = "CREATE TABLE IconChoice(IconID INTEGER PRIMARY KEY AUTOINCREMENT,Section INTEGER,SectionName STRING, IconName STRING, SectionColor STRING, IncomeSymbol STRING)"
           let createDefaultStyleValues = "INSERT INTO IconChoice (Section,SectionName,IconName,SectionColor,IncomeSymbol)VALUES (1,'Debt','Debt','\(defaultColorsIndexes[0])','-'),(2,'Bills','Bills','\(defaultColorsIndexes[1])','-'),(3,'Recreation','Recreation','\(defaultColorsIndexes[2])','-'),(4,'Saving','Saving','\(defaultColorsIndexes[3])','+'),(5,'Giving','Giving','\(defaultColorsIndexes[4])','-'),(6,'Investments','Investment','\(defaultColorsIndexes[5])','+');"
        
        do
           {
                try self.database.run(createPieDataTable)
                try self.database.run(createIconChoiceTable)
                try self.database.run(createDefaultStyleValues)
           }catch{print(error)}
        print("Tables Created")
       }
    
    public func getPieData(Section: Int) -> ChartSectionInfo
    {
        var result = ChartSectionInfo(section: Section, sectionAmount: 0, sectionBillAmount: 0, symbol: "-")
        let query = "SELECT BillAmount FROM PieData WHERE Section = \(Section)"
        let query2 = "SELECT IncomeSymbol FROM IconChoice WHERE Section = \(Section)"
        
        for row in try! database.prepare(query){
            result.sectionAmount = result.sectionAmount + (row[0] as! Double)
            result.sectionBillAmount = result.sectionBillAmount + 1
        }
        
        for row in try! database.prepare(query2){
            result.symbol = row[0] as! String
        }
        
        return result
    }
    
    public func addUserInformation(input: UserSectionInput)
    {
        let query = "INSERT INTO PieData (Section,BillName,BillAmount,BillPayed)VALUES (\(input.section),'\(input.billName)',\(input.billAmount),'false')"
        
        do{
            try database.run(query)
        }catch{print(error)}
        
    }
    
    public func grabMoreInfoForSection(Section: Int) -> [MoreInfoForPieSection]
    {
        var result:[MoreInfoForPieSection] = []
        let query = "SELECT BillName,BillAmount,DataID,BillPayed FROM PieData WHERE Section = \(Section)"
        let query2 = "SELECT IncomeSymbol FROM IconChoice WHERE Section = \(Section)"
        
        for row in try! database.prepare(query){
            let billNames = row[0] as? String ?? ""
            let billAmounts = row[1] as? Double ?? 0.0
            let id = row[2] as? Int64 ?? 0
            let payed = row[3] as? String ?? ""
            result.append(MoreInfoForPieSection(DataId: Int(id), billName: billNames, billAmount: billAmounts, payed: payed.bool!, symbol: ""))
        }
        
        if(result.count != 0){
            for row in try! database.prepare(query2){
                result[0].symbol = row[0] as? String ?? ""
            }
        }
        
        return result
    }
    
    public func getIconForSection(Section: Int) -> IconChoice
    {
        var result = IconChoice(iconID: Section,section: Section, iconName: "", sectionColor: "")
        
        let query = "SELECT IconID,IconName,SectionColor FROM IconChoice WHERE Section = \(Section)"
        
        for row in try! database.prepare(query){
            let iconID = row[0] as? Int ?? 0
            let iconName = row[1] as? String ?? ""
            let sectionColor = row[2] as? String ?? ""
            result = IconChoice(iconID: iconID, section: Section, iconName: iconName, sectionColor: sectionColor)
        }
        
        return result
    }
    
    public func updatePieCustomization(type: Int,section: Int, item: String){
        var query = ""
        
        switch type {
        case 1:
            query =
            "UPDATE IconChoice SET SectionColor = '\(item)' WHERE Section = '\(section)'"
        case 2:
            query =
            "UPDATE IconChoice SET IconName = '\(item)' WHERE Section = '\(section)'"
        case 3:
            query =
            "UPDATE IconChoice SET SectionName = '\(item)' WHERE Section = '\(section)'"
        case 4:
            query =
            "UPDATE IconChoice SET IncomeSymbol = '\(item)' WHERE Section = '\(section)'"
        default:
            break
        }
        
        do {
            try database.run(query)
        } catch {
            print(error)
        }
        
    }
    
    public func getSectionNames() -> [String]{
        var result:[String] = []
        let query = "SELECT SectionName FROM IconChoice"
        
        for row in try! database.prepare(query){
            result.append(row[0] as! String)
        }
        
        return result
    }
    
    public func removeBillFromDB(ID: Int){
        let deleteBill = "DELETE FROM PieData WHERE DataID = \(ID);"
        
        do
        {
            try database.run(deleteBill)
        }catch{print(error)}
        
    }
    
    public func updateUserPayed(payed: Bool, ID:Int){
        let query = "UPDATE PieData SET BillPayed = '\(String(payed))' WHERE DataID = \(ID)"
        
        do {
            try database.run(query)
        } catch {
            print(error)
        }
        
    }
    
}
