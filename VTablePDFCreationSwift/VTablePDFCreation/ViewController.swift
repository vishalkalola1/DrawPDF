//
//  ViewController.swift
//  VTablePDFCreation
//
//  Created by vishal on 11/22/17.
//  Copyright © 2017 vishal. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIDocumentInteractionControllerDelegate {

    
    var docController:UIDocumentInteractionController!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var finalArray = [[String]]()
        for i in 0..<1000 {
            var arrColumnData = [String]()
            arrColumnData.append("\(i+1)")
            for _ in 0..<4{
                arrColumnData.append("abc")
            }
            finalArray.append(arrColumnData)
        }
        
        var arrHeaderArray = [String]()
        for _ in 0...4{
            arrHeaderArray.append("abc")
        }
        let objPdfView = VPDFTableCreation()
        objPdfView.CreatePDFAndSaveDocumentDirectory(pdfName: "vishal", width: 500, height: 580)
        objPdfView.DrawPDF(TotalData:finalArray, headerData: arrHeaderArray, EachColumnWidth: [50,50,50,50,260], fontSize: 12.0, textAlignment: .center, Viewcontroller: self)
        let path1 = objPdfView.getPDFFile()
        //print(path1)
        let objPdfView1 = VPDFTableCreation()
        objPdfView1.CreatePDFAndSaveDocumentDirectory(pdfName: "Kalola", width: 500, height: 580)
        objPdfView1.DrawPDF(TotalData:finalArray, headerData: arrHeaderArray, EachColumnWidth: [50,50,50,50,260], fontSize: 12.0, textAlignment: .center, Viewcontroller: self)
        let path = objPdfView1.getPDFFile() // optional code
        //print(path)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

