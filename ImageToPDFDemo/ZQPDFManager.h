//
//  ZQPDFManager.h
//  TroubleCheckSystem
//
//  Created by zhangqq on 2018/9/29.
//  Copyright © 2018年 张强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZQPDFManager : NSObject

//设置输出PDF名字，PDF宽高
- (void)setupPDFDocumentNamed:(NSString*)name width:(float)width height:(float)height;

//添加转PDF文件的图片 point是图片的xy轴起始点
- (void)addImage:(UIImage*)image atPoint:(CGPoint)point;

//以上两个方法可以画出PDF，配合保存图片的路径可以在模拟器上找到输出文件。

//下面的是为PDF添加文字title，线条等 frame你自己设置，在顶部在底部等等
- (CGRect)addText:(NSString*)text withFrame:(CGRect)frame fontSize:(float)fontSize ;
-  (CGRect)addLineWithFrame:(CGRect)frame withColor:(UIColor*)color ;


@end

NS_ASSUME_NONNULL_END
