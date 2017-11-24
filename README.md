# DrawPDF

# Requirements

Xcode 8+                                            
Swift 3.0, Swift 4.0                                 
iOS 8+                                  
ARC                                                  

## Basic Usage ##
### DRAG & DROP VPDFTableCreation FOLDER TO YOUR PROJECT ###
#### Make array of row and ColumnData Like Below Formate ####
```[[1,'abc',.....],[2,'abc',...],......]
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
```
#### Create an instance of VPDFTableCreation call below method ####
```
let objPdfView = VPDFTableCreation()
objPdfView.CreatePDFAndSaveDocumentDirectory(pdfName: "VPDFTableCreation", width: 500, height: 580)
objPdfView.DrawPDF(TotalData:finalArray, headerData: arrHeaderArray, EachColumnWidth: [50,50,50,50,260], fontSize: 12.0, textAlignment: .center, Viewcontroller: self)
```
**Get the PDFFile Path.**
```
let path = objPdfView.getPDFFile() 
print(path)

```
