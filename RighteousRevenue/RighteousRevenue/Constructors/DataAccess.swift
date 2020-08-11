//
//  DataAccess.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/3/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import Foundation
import SQLite

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
               let createPieDataTable = "CREATE TABLE PieData(DataID INTEGER PRIMARY KEY AUTOINCREMENT, Section INTEGER, BillName STRING, BillAmount DOUBLE)"
               let createLessonDataTable = "CREATE TABLE LessonData(LessonID INTEGER PRIMARY KEY AUTOINCREMENT, LessonImg STRING, LessonTitle STRING, LessonInfo STRING)"
               let createPurchaseDataTable = "CREATE TABLE PurchaseData(PurchaseID INTEGER PRIMARY KEY AUTOINCREMENT, UserPayed STRING, ConfirmationNum STRING)"
               let createIconChoiceTable = "CREATE TABLE IconChoice(IconID INTEGER PRIMARY KEY AUTOINCREMENT,Section INTEGER, IconName STRING, SectionColor STRING)"
               let createDefaultStyleValues = "INSERT INTO IconChoice (Section,IconName,SectionColor)VALUES (1,'Debt','DebtColor'),(2,'Bills','BillsColor'),(3,'Recreation','RecreationColor'),(4,'Saving','SavingColor'),(5,'Giving','GivingColor'),(6,'Investment','InvestmentColor');"
            do
               {
                    try self.database.run(createPieDataTable)
                    try self.database.run(createLessonDataTable)
                    try self.database.run(createPurchaseDataTable)
                    try self.database.run(createIconChoiceTable)
                    try self.database.run(createDefaultStyleValues)
               }catch{print(error)}
           }
    
    public func getPieData(Section: Int) -> ChartSectionInfo
    {
        var result = ChartSectionInfo(section: Section, sectionAmount: 0, sectionBillAmount: 0)
        let query = "SELECT BillAmount FROM PieData WHERE Section = \(Section)"
        
        for row in try! database.prepare(query){
            result.sectionAmount = result.sectionAmount + (row[0] as! Double)
            result.sectionBillAmount = result.sectionBillAmount + 1
        }
        
        return result
    }
    
    public func addUserInformation(input: UserSectionInput)
    {
        let query = "INSERT INTO PieData (Section,BillName,BillAmount)VALUES (\(input.section),'\(input.billName)',\(input.billAmount))"
        
        do{
            try database.run(query)
        }catch{print(error)}
        
    }
    
    public func grabMoreInfoForSection(Section: Int) -> [MoreInfoForPieSection]
    {
        var result:[MoreInfoForPieSection] = []
        let query = "SELECT BillName,BillAmount FROM PieData WHERE Section = \(Section)"
        
        for row in try! database.prepare(query){
            let billNames = row[0] as? String ?? ""
            let billAmounts = row[1] as? Double ?? 0.0
            result.append(MoreInfoForPieSection(billName: billNames, billAmount: billAmounts))
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
    
}
