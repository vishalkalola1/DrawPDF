//
//  MyPDFGenerator.h
//  ConstructionApp
//
//  Created by bviadmin on 09/03/16.
//
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import "NSString+VisibleText.h"

#define PageWidth 612
#define PageHeight 792
#define kPadding 20

#define Column0 20
#define Column1 60
#define Column2 130
#define Column3 270
#define Column4 370
#define Column5 460
#define Column6 528
#define Column7 592



@interface MyPDFGenerator : NSObject<UIDocumentInteractionControllerDelegate, MFMailComposeViewControllerDelegate>

@property(nonatomic, assign) CGSize _pageSize;
@property(nonatomic, weak) UIViewController *delegate;
@property(nonatomic, retain) NSString *pdfPath;

#pragma mark - Open Reader Methods
-(NSString *)getPDFPath;
- (void)openPDF;
-(void)openEmailComposser:(NSString *)strSubject;

#pragma mark - Setup PDF Methods
- (void)setupPDFDocumentNamed:(NSString*)name Width:(float)width Height:(float)height;
- (void)beginPDFPage;
- (void)finishPDF;
-(UIFont *)fontForPDFWithSize:(float)fontSize;
-(CGRect)checkForDrawPositionExceedPageSize:(CGRect)drawFrame;

#pragma mark - Draw controlls on PDF Methods
- (CGRect)addText:(NSString*)text withFrame:(CGRect)frame fontSize:(float)fontSize textAlignment:(NSTextAlignment)alignment isHeader:(BOOL)isHeader;
- (CGRect) addTextLink:(NSString *) text inFrame:(CGRect) frameRect url:(NSString *)strUrl;
- (CGRect)addImage:(UIImage*)image withRect:(CGRect)rect;
- (CGRect)addLineWithFrame:(CGRect)frame withColor:(UIColor*)color;
-(void)drawLineFromPoint:(CGPoint)from toPoint:(CGPoint)to;
-(void)drawTableAt:(CGPoint)origin withRowHeight:(int)rowHeight andColumnWidth:(int)columnWidth andRowCount:(int)numberOfRows andColumnCount:(int)numberOfColumns;

@end
