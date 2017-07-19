///
//  ViewController.m
//  CreatePDF
//
//  Created by Vishal Kalola on 14/07/17.
//  Copyright © 2017 Vishal Kalola. All rights reserved.
//

#import "ViewController.h"
#import <CoreText/CoreText.h>
#import "MyPDFGenerator.h"
@interface ViewController ()
{
    MyPDFGenerator *objMyPDF;
    int PageFilled;
    int rowHeight;
    BOOL isRequireHeaderInSecondPage;
    int rowCount;
    NSMutableArray *arrayNotesForPDF;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    rowCount = 0;
    isRequireHeaderInSecondPage = NO;
    
    objMyPDF = [[MyPDFGenerator alloc] init];
    objMyPDF.delegate = self;
    
    [objMyPDF setupPDFDocumentNamed:@"PunchListPDF" Width:PageWidth Height:PageHeight];
    
    [self preparePDFForPunchList];
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)preparePDFForPunchList{
    
    arrayNotesForPDF =@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",@"60",@"60",@"61",@"62",@"63",@"64",@"65",@"66",@"67",@"68",@"69",@"70"].mutableCopy;
    
    if(!arrayNotesForPDF || arrayNotesForPDF.count == 0){
        return;
    }
    
    //===================================================
    //Generating PDF...
    [objMyPDF beginPDFPage];
    
    //----------------------------------
    //Draw table
    rowHeight = 35;
    int numberOfRows =(int)arrayNotesForPDF.count;
    int totalPage = ceil(numberOfRows / 20.0);
    int numberOfColumns = 7;
    CGPoint to22;
    CGPoint from1;
    
    to22 = [self makeHeaderTable]; //make Header
    from1 = CGPointMake(kPadding, 70);
    
    [objMyPDF drawLineFromPoint:from1 toPoint:to22];
    int k = 0;
    for (int i = 0; i < totalPage; i++)
    {
        NSArray *arr = [self getPageData:i+1];
        if (i>0) {
            if (isRequireHeaderInSecondPage) {
                to22 = [self makeHeaderTable];
                from1 = CGPointMake(kPadding, 70);
            }else{
                to22 = CGPointMake(objMyPDF._pageSize.width - kPadding, kPadding);
                from1 = CGPointMake(kPadding, kPadding);
            }
            [objMyPDF drawLineFromPoint:from1 toPoint:to22];
        }
        
        for (int j = 0; j < arr.count; j++) {
            
            int y = to22.y;
            
            //For Column-1
            NSString *strAddress = [NSString stringWithFormat:@"%@",arrayNotesForPDF[k]];
            int column1Width = Column1 - Column0;
            [objMyPDF addText:strAddress withFrame:CGRectMake(Column0, y, column1Width, rowHeight) fontSize:12.0f textAlignment:NSTextAlignmentCenter isHeader:NO];
            
            //For Column - 2
            int column2Width = Column2 - Column1;
            [objMyPDF addImage:[UIImage imageNamed:@"ring.jpg"] withRect:CGRectMake(Column1 + 5 , y+2, column2Width-10, 30)];
            
            //For Column - 3
            NSString *strCompany = arrayNotesForPDF[k];
            int column3Width = Column3 - Column2;
            [objMyPDF addText:strCompany withFrame:CGRectMake(Column2+2, y, column3Width-4, rowHeight) fontSize:12.0f textAlignment:NSTextAlignmentCenter isHeader:NO];
            
            //For Column - 4
            NSString *strCompany1 = arrayNotesForPDF[k];
            int column4Width = Column4 - Column3;
            [objMyPDF addText:strCompany1 withFrame:CGRectMake(Column3+2, y, column4Width-4, rowHeight) fontSize:12.0f textAlignment:NSTextAlignmentCenter isHeader:NO];
            
            //For Column - 5
            NSString *strCompany2 = arrayNotesForPDF[k];
            int column5Width = Column5 - Column4;
            [objMyPDF addText:strCompany2 withFrame:CGRectMake(Column4+2, y,column5Width-4, rowHeight) fontSize:12.0f textAlignment:NSTextAlignmentCenter isHeader:NO];
            
            //For Column - 6
            NSString *strCompany3 = arrayNotesForPDF[k];
            int column6Width = Column6 - Column5;
            [objMyPDF addText:strCompany3 withFrame:CGRectMake(Column5+2, y, column6Width-4, rowHeight) fontSize:12.0f textAlignment:NSTextAlignmentCenter isHeader:NO];
            
            //For Column - 7
            int column7Width = Column7 - Column6;
            [objMyPDF addImage:[UIImage imageNamed:@"bangles.png"] withRect:CGRectMake(Column6 + column7Width/2-15, y+2, 30, 30)];
            
            CGPoint from1 = CGPointMake(kPadding, y+rowHeight);
            CGPoint to2 = CGPointMake(objMyPDF._pageSize.width - kPadding, y+rowHeight);
            to22 = to2;
            [objMyPDF drawLineFromPoint:from1 toPoint:to2];
            
            if (j==arr.count-1) {
                [self makeColumn:to22 numberOfColumns:numberOfColumns];
                y = to22.y = 20;
            }
            k++;
        }
        
        if (i == totalPage-1) {
            [self finishedPDF];
        }else{
            [objMyPDF beginPDFPage];
        }
    }
}

-(NSArray *)getPageData:(int)pageNumber
{
    NSMutableArray *arr = [NSMutableArray new];
    int totalPagedata = 20;
    if (pageNumber > 1) {
        if (isRequireHeaderInSecondPage) {
            totalPagedata = 20;
        }else
        {
            totalPagedata = 21;
        }
    }
    
    for (int i = (pageNumber-1)*totalPagedata; i< totalPagedata * pageNumber; i++) {
        if (arrayNotesForPDF.count > i) {
            [arr addObject:[arrayNotesForPDF objectAtIndex:i]];
        }else{
            NSLog(@"Index beyond bound");
        }
    }
    NSLog(@"%@",arr);
    return arr.copy;
}
float fontSize = 13.0f;

-(CGPoint)makeHeaderTable{
    
    //isRequireHeaderInSecondPage = false;
    CGPoint from = CGPointMake(kPadding, kPadding);
    CGPoint to = CGPointMake(objMyPDF._pageSize.width - kPadding, kPadding);
    [objMyPDF drawLineFromPoint:from toPoint:to];
    
    //For Column-1
    NSString *strAddress = [NSString stringWithFormat:@"Sr"];
    int column1Width = Column1 - Column0;
    [objMyPDF addText:strAddress withFrame:CGRectMake(Column0, 35, column1Width, rowHeight) fontSize:fontSize textAlignment:NSTextAlignmentCenter isHeader:YES];
    
    //For Column - 2
    NSString *strSqft = [NSString stringWithFormat:@"Image"];
    int column2Width = Column2 - Column1;
    [objMyPDF addText:strSqft withFrame:CGRectMake(Column1, 35,column2Width, rowHeight) fontSize:fontSize textAlignment:NSTextAlignmentCenter isHeader:YES];
    
    //For Column - 3
    NSString *strCompany = @"Name";
    int column3Width = Column3 - Column2;
    [objMyPDF addText:strCompany withFrame:CGRectMake(Column2, 35, column3Width, rowHeight) fontSize:fontSize textAlignment:NSTextAlignmentCenter isHeader:YES];
    
    //For Column - 4
    NSString *strCompany1 = @"H. number";
    int column4Width = Column4 - Column3;
    [objMyPDF addText:strCompany1 withFrame:CGRectMake(Column3, 35, column4Width, rowHeight) fontSize:fontSize textAlignment:NSTextAlignmentCenter isHeader:YES];
    
    //For Column - 5
    NSString *strCompany2 = @"P. number";
    int column5Width = Column5 - Column4;
    [objMyPDF addText:strCompany2 withFrame:CGRectMake(Column4, 35,column5Width, rowHeight) fontSize:fontSize textAlignment:NSTextAlignmentCenter isHeader:YES];
    
    //For Column - 6
    NSString *strCompany3 = @"pincode";
    int column6Width = Column6 - Column5;
    [objMyPDF addText:strCompany3 withFrame:CGRectMake(Column5, 35, column6Width, rowHeight) fontSize:fontSize textAlignment:NSTextAlignmentCenter isHeader:YES];
    
    //For Column - 7
    NSString *strCompany4 = @"Image";
    int column7Width = Column7 - Column6;
    [objMyPDF addText:strCompany4 withFrame:CGRectMake(Column6, 35, column7Width, rowHeight) fontSize:fontSize textAlignment:NSTextAlignmentCenter isHeader:YES];
    
    CGPoint to2 = CGPointMake(objMyPDF._pageSize.width - kPadding, 70);
    return to2;
}

-(void)makeColumn:(CGPoint)to22 numberOfColumns:(int)numberOfColumns
{
    
    for (int i = 0; i <= numberOfColumns; i++)
    {
        switch (i) {
            case 0: {
                int newOrigin = Column0;
                CGPoint from = CGPointMake(newOrigin, kPadding);
                CGPoint to = CGPointMake(newOrigin,  to22.y);
                
                [objMyPDF drawLineFromPoint:from toPoint:to];
                break;
            }
            case 1:{
                int newOrigin = Column1;
                CGPoint from = CGPointMake(newOrigin, kPadding);
                CGPoint to = CGPointMake(newOrigin, to22.y);
                
                [objMyPDF drawLineFromPoint:from toPoint:to];
                break;
            }
            case 2:{
                int newOrigin = Column2;
                CGPoint from = CGPointMake(newOrigin, kPadding);
                CGPoint to = CGPointMake(newOrigin, to22.y);
                
                [objMyPDF drawLineFromPoint:from toPoint:to];
                break;
            }
            case 3:{
                int newOrigin = Column3;
                CGPoint from = CGPointMake(newOrigin, kPadding);
                CGPoint to = CGPointMake(newOrigin, to22.y);
                
                [objMyPDF drawLineFromPoint:from toPoint:to];
                break;
            }
            case 4:{
                int newOrigin = Column4;
                CGPoint from = CGPointMake(newOrigin, kPadding);
                CGPoint to = CGPointMake(newOrigin, to22.y);
                
                [objMyPDF drawLineFromPoint:from toPoint:to];
                break;
            }
            case 5:{
                int newOrigin = Column5;
                CGPoint from = CGPointMake(newOrigin, kPadding);
                CGPoint to = CGPointMake(newOrigin, to22.y);
                
                [objMyPDF drawLineFromPoint:from toPoint:to];
                break;
            }
            case 6:{
                int newOrigin = Column6;
                CGPoint from = CGPointMake(newOrigin, kPadding);
                CGPoint to = CGPointMake(newOrigin, to22.y);
                
                [objMyPDF drawLineFromPoint:from toPoint:to];
                break;
            }
            case 7:{
                int newOrigin = Column7;
                CGPoint from = CGPointMake(newOrigin, kPadding);
                CGPoint to = CGPointMake(newOrigin, to22.y);
                
                [objMyPDF drawLineFromPoint:from toPoint:to];
                break;
            }
            default:
                break;
        }
    }
}


-(void)finishedPDF{
    
    [objMyPDF finishPDF];
    //Open PDF...
    [objMyPDF openPDF];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showPdf:(UIButton *)sender {
    [objMyPDF openPDF];
}
@end
