//
//  CreateCode.h
//  相册
//
//  Created by liquan on 2017/3/8.
//  Copyright © 2017年 liquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreateCode : NSObject

/**
 生成二维码图片

 @param string 二维码包含的信息
 @return 生成的二维码拖图片
 */
+(UIImage *)createCodeImageWithString:(NSString *)string;

/**
 生成的二维码图片 使用iOS 7后的CIFilter对象操作，生成二维码图片imgQRCode（会拉伸图片，比较模糊，效果不佳）
 @param string 二维码包含的信息
 @return 生成的二维码图片
 */
+(CIImage *)createCIFileterCodeImageWithString:(NSString *)string;



/**
 使用核心绘图框架CG（Core Graphics）对象操作，进一步针对大小生成二维码图片imgAdaptiveQRCode（图片大小适合，清晰，效果好）
 Core Image提供了为图片分析常见缺陷并自动调整修复的方法. 提供一系列用来纠正这些不足的滤镜. 通过为滤镜预设相关值, 实现如变更色调, 饱合度, 对比度, 阴影, 去除红眼或其它闪光伪迹, 来提高图片的质量.
 @param image CIImage
 @param size 图片大小
 @return 生成的二维码图片
 */
+(UIImage *)createCodeImageWithImage:(CIImage*)image withSize:(CGFloat)size;


/**
将默认产生的黑白色的二维码图片生成其它颜色的二维码图片

 @param image 二维码图片
 @param red 红色（0~255）
 @param green 绿色（0~255）
 @param blue 蓝色（0~255）
 @return 重新生成的二维码图片
 */
+(UIImage *)createCodeImageWithImage:(UIImage *)image withRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

//给二维码添加logo的2个方法
///使用核心绘图框架CG（Core Graphics）对象操作，合并二维码图片和用于中间显示的图标图片


/**
 自定义中间图标的大小

 @param image 生成的二维码图片
 @param icon 中间图片
 @param iconSize 图片的大小
 @return 合并后的二维码
 */
+ (UIImage *)addIconToCodeImage:(UIImage *)image withIcon:(UIImage *)icon withIconSize:(CGSize)iconSize;


/**
 按比例设置中间图片的大小

 @param image 生成的二维码图片
 @param icon 中间图片的大小
 @param scale 图片的比例 (原图/现图 = scale)
 @return 合并后的二维码
 */
+ (UIImage *)addIconToCodeImage:(UIImage *)image withIcon:(UIImage *)icon withScale:(CGFloat)scale;


@end
