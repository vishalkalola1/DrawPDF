//
//  MyPDFGenerator.m
//  ConstructionApp
//
//  Created by bviadmin on 09/03/16.
//
//

#import "MyPDFGenerator.h"

@implementation MyPDFGenerator

@synthesize delegate, _pageSize, pdfPath;

#pragma mark - Open Reader Methods

-(NSString *)getPDFPath{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pdfPaths = [documentsDirectory stringByAppendingPathComponent:@"PunchListPDF.pdf"];
    
    return pdfPaths;
}

- (void)openPDF {
    
    NSString *pdfPaths = [self getPDFPath];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:pdfPaths]) {
        
        UIDocumentInteractionController *documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:pdfPaths]];
        documentInteractionController.delegate = self;        
        
        [documentInteractionController presentPreviewAnimated:YES];
    }
}

-(void)openEmailComposser:(NSString *)strSubject{
    
    if ([MFMailComposeViewController canSendMail]){
        
        NSString *pdfPaths = [self getPDFPath];
        NSURL *fileURL = [NSURL fileURLWithPath:pdfPaths];
        NSData *attachment = [NSData dataWithContentsOfURL:fileURL options:(NSDataReadingMapped|NSDataReadingUncached) error:nil];
        
        if (attachment != nil) // Ensure that we have valid document file attachment data available
        {
            
            UIViewController *refVC;
            if([delegate presentedViewController])
                refVC = [delegate presentedViewController];
            else
                refVC = delegate;
            
            MFMailComposeViewController *mailComposer = [MFMailComposeViewController new];
            
            [mailComposer addAttachmentData:attachment mimeType:@"application/pdf" fileName:@"PunchListPDF.pdf"];
            
            [mailComposer setSubject:strSubject]; // Use the document file name for the subject
            
            //mailComposer.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            //mailComposer.modalPresentationStyle = UIModalPresentationFormSheet;
            
            mailComposer.mailComposeDelegate = self; // MFMailComposeViewControllerDelegate
            
            [refVC presentViewController:mailComposer animated:YES completion:NULL];
        }
        else{
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid document" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        
    }
    else{
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Not able to send email. Please check email account in device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

#pragma mark - MFMailComposeViewControllerDelegate methods
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
#ifdef DEBUG
    if ((result == MFMailComposeResultFailed) && (error != NULL)) NSLog(@"%@", error);
#endif
    
    
    UIViewController *refVC;
    if([delegate presentedViewController])
        refVC = [delegate presentedViewController];
    else
        refVC = delegate;
    
    [refVC dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UIDocumentInteractionController Delegate methods

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller{
    return delegate;
}

#pragma mark - Setup PDF Methods
- (void)setupPDFDocumentNamed:(NSString*)name Width:(float)width Height:(float)height {
    _pageSize = CGSizeMake(width, height);
    
    NSString *newPDFName = [NSString stringWithFormat:@"%@.pdf", name];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    pdfPath = [documentsDirectory stringByAppendingPathComponent:newPDFName];
    
    UIGraphicsBeginPDFContextToFile(pdfPath, CGRectZero, nil);
}

- (void)beginPDFPage {
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, _pageSize.width, _pageSize.height), nil);
}

- (void)finishPDF {
    UIGraphicsEndPDFContext();
}

-(UIFont *)fontForPDFWithSize:(float)fontSize{
    
    return [UIFont systemFontOfSize:fontSize];
}

-(UIFont *)fontBoldForPDFWithSize:(float)fontSize{
    
    return [UIFont boldSystemFontOfSize:fontSize];
}

-(CGRect)checkForDrawPositionExceedPageSize:(CGRect)drawFrame{
    
    CGRect newRect = drawFrame;
//    
//    if(drawFrame.origin.y + drawFrame.size.height > _pageSize.height - kPadding * 2){
//        
//        newRect.origin.y = kPadding;
//        [self beginPDFPage];
//    }
    
    return newRect;
}

#pragma mark - Draw controlls on PDF Methods

- (CGRect)addText:(NSString*)text withFrame:(CGRect)frame fontSize:(float)fontSize textAlignment:(NSTextAlignment)alignment isHeader:(BOOL)isHeader{
    
    ///*
    
    UIFont *font;
    if (isHeader) {
        font = [self fontBoldForPDFWithSize:fontSize];
    }else{
        font = [self fontForPDFWithSize:fontSize];
    }
    
    CGSize stringSize;
    
    NSString *visibleText = [text stringVisibleInRect:frame withFont:[self fontForPDFWithSize:fontSize]];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{ NSFontAttributeName: font,
                                  NSParagraphStyleAttributeName: paragraphStyle };
    stringSize = [visibleText boundingRectWithSize:CGSizeMake(frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    NSLog(@"%d",(int)stringSize.height);
    
    if (!isHeader) {
        if ((int)stringSize.height > 14) {
            CGRect renderingRect = CGRectMake(frame.origin.x, frame.origin.y+2, frame.size.width, 50);
            [visibleText drawInRect:renderingRect withAttributes:attributes];
            
        }else{
            CGRect renderingRect = CGRectMake(frame.origin.x, frame.origin.y+10, frame.size.width, 50);
            [visibleText drawInRect:renderingRect withAttributes:attributes];
            
        }
    }else{
        CGRect renderingRect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 50);
        [visibleText drawInRect:renderingRect withAttributes:attributes];
    }
    
    
    frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, stringSize.height);
    return frame;
}

- (CGRect) addTextLink:(NSString *) text inFrame:(CGRect) frameRect url:(NSString *)strUrl{
    
    frameRect = [self checkForDrawPositionExceedPageSize:frameRect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGAffineTransform ctm = CGContextGetCTM(context);
    
    // Translate the origin to the bottom left.
    // Notice that 842 is the size of the PDF page.
    CGAffineTransformTranslate(ctm, 0.0, 842);
    
    // Flip the handedness of the coordinate system back to right handed.
    CGAffineTransformScale(ctm, 1.0, -1.0);
    
    // Convert the update rectangle to the new coordiante system.
    CGRect xformRect = CGRectApplyAffineTransform(frameRect, ctm);
    
    NSURL *url = [NSURL URLWithString:strUrl];
    UIGraphicsSetPDFContextURLForRect( url, xformRect );
    
    CGContextSaveGState(context);
    NSDictionary *attributesDict;
    NSMutableAttributedString *attString;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    
    NSNumber *underline = [NSNumber numberWithInt:NSUnderlineStyleSingle];
    attributesDict = @{NSUnderlineStyleAttributeName : underline, NSForegroundColorAttributeName : [UIColor blueColor], NSParagraphStyleAttributeName : paragraphStyle};
    
    attString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributesDict];
    
    [attString drawInRect:frameRect];
    
    CGContextRestoreGState(context);
    
    return frameRect;
}

- (CGRect)addImage:(UIImage*)image withRect:(CGRect)rect {
    
    //rect = [self checkForDrawPositionExceedPageSize:rect];
    
    [image drawInRect:rect];
    
    return rect;
}

- (CGRect)addLineWithFrame:(CGRect)frame withColor:(UIColor*)color {
    
    frame = [self checkForDrawPositionExceedPageSize:frame];
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(currentContext, color.CGColor);
    
    // this is the thickness of the line
    CGContextSetLineWidth(currentContext, frame.size.height);
    
    CGPoint startPoint = frame.origin;
    CGPoint endPoint = CGPointMake(frame.origin.x + frame.size.width, frame.origin.y);
    
    CGContextBeginPath(currentContext);
    CGContextMoveToPoint(currentContext, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(currentContext, endPoint.x, endPoint.y);
    
    CGContextClosePath(currentContext);
    CGContextDrawPath(currentContext, kCGPathFillStroke);
    
    return frame;
}

-(void)drawLineFromPoint:(CGPoint)from toPoint:(CGPoint)to {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1.0);
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat components[] = {0.2, 0.2, 0.2, 0.3};
    
    CGColorRef color = CGColorCreate(colorspace, components);
    
    CGContextSetStrokeColorWithColor(context, color);
    
    
    CGContextMoveToPoint(context, from.x, from.y);
    CGContextAddLineToPoint(context, to.x, to.y);
    
    CGContextStrokePath(context);
    CGColorSpaceRelease(colorspace);
    CGColorRelease(color);
    
}
int Count = 0;
-(void)drawTableAt:(CGPoint)origin withRowHeight:(int)rowHeight andColumnWidth:(int)columnWidth andRowCount:(int)numberOfRows andColumnCount:(int)numberOfColumns {
    

    for (int i = 0; i <= numberOfColumns; i++)
    {
        switch (i) {
            case 0: {
                int newOrigin = Column0;
                CGPoint from = CGPointMake(newOrigin, origin.y);
                CGPoint to = CGPointMake(newOrigin, origin.y +(numberOfRows*rowHeight));
                
                [self drawLineFromPoint:from toPoint:to];
                break;
            }
            case 1:{
                int newOrigin = Column1;
                CGPoint from = CGPointMake(newOrigin, origin.y);
                CGPoint to = CGPointMake(newOrigin, origin.y +(numberOfRows*rowHeight));
                
                [self drawLineFromPoint:from toPoint:to];
                break;
            }
            case 2:{
                int newOrigin = Column2;
                CGPoint from = CGPointMake(newOrigin, origin.y);
                CGPoint to = CGPointMake(newOrigin, origin.y +(numberOfRows*rowHeight));
                
                [self drawLineFromPoint:from toPoint:to];
                break;
            }
            case 3:{
                int newOrigin = Column3;
                CGPoint from = CGPointMake(newOrigin, origin.y);
                CGPoint to = CGPointMake(newOrigin, origin.y +(numberOfRows*rowHeight));
                
                [self drawLineFromPoint:from toPoint:to];
                break;
            }
            case 4:{
                int newOrigin = Column4;
                CGPoint from = CGPointMake(newOrigin, origin.y);
                CGPoint to = CGPointMake(newOrigin, origin.y +(numberOfRows*rowHeight));
                
                [self drawLineFromPoint:from toPoint:to];
                break;
            }
            case 5:{
                int newOrigin = Column5;
                CGPoint from = CGPointMake(newOrigin, origin.y);
                CGPoint to = CGPointMake(newOrigin, origin.y +(numberOfRows*rowHeight));
                
                [self drawLineFromPoint:from toPoint:to];
                break;
            }
            case 6:{
                int newOrigin = Column6;
                CGPoint from = CGPointMake(newOrigin, origin.y);
                CGPoint to = CGPointMake(newOrigin, origin.y +(numberOfRows*rowHeight));
                
                [self drawLineFromPoint:from toPoint:to];
                break;
            }
            case 7:{
                int newOrigin = Column7;
                CGPoint from = CGPointMake(newOrigin, origin.y);
                CGPoint to = CGPointMake(newOrigin, origin.y +(numberOfRows*rowHeight));
                
                [self drawLineFromPoint:from toPoint:to];
                break;
            }
            default:
                break;
        }
    }
    
    for (int i = 0; i <= numberOfRows; i++)
    {
        int newOrigin = origin.y + (rowHeight*i);
        CGPoint from = CGPointMake(origin.x, newOrigin);
        CGPoint to = CGPointMake(origin.x + (numberOfColumns*columnWidth), newOrigin);
        
        [self drawLineFromPoint:from toPoint:to];
        
    }
}
@end
