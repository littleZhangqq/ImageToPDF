//
//  PDFViewController.h
//  ImageToPDFDemo
//
//  Created by zhangqq on 2018/9/30.
//  Copyright © 2018年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum: NSUInteger{
    ShowPDFTypeOrigin,
    ShowPDFTypeWithTitleLine
}ShowPDFType;

@interface PDFViewController : UIViewController

@property(nonatomic, unsafe_unretained) ShowPDFType showType;

@end

NS_ASSUME_NONNULL_END
