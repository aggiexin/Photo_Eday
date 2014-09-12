//
//  FaceTool.m
//  Photo_Eday
//
//  Created by dongl on 14-7-22.
//  Copyright (c) 2014年 dongl. All rights reserved.
//

#import "FaceTool.h"
#import "CoreDataTool.h"
#define _API_KEY @"8e89c910e982956080f58be19a721489"
#define _API_SECRET @"ev1oncbMghwSO0Ab_YL-hDwF6ukh6I33"

@implementation FaceTool

+(NSDictionary*)ChickFace:(NSData*)img{
    [FaceppAPI initWithApiKey:_API_KEY andApiSecret:_API_SECRET andRegion:APIServerRegionCN];
    FaceppResult *result = [[FaceppAPI detection] detectWithURL:nil orImageData:img mode:FaceppDetectionModeOneFace attribute:FaceppDetectionAttributeAll];
    //这个是下来后的数据  json 要取的数据就从 result content 里取
//    FaceppResult * result = [[FaceppAPI group] deleteWithGroupName: @"GROUP_NAME" orGroupId: nil];
    NSLog(@"%@",[result content]);
    return [result content];
    
    
}

+(NSString*)getDescriptionSentence:(NSDictionary*)img{
    NSArray * sectences = [NSArray new];
        NSArray *faceArr  = [img objectForKey:@"face"];
         if ([faceArr count] !=0) {
        NSDictionary *faceDicFollowFA = [faceArr objectAtIndex:0];
        NSDictionary *faceAttribute = [faceDicFollowFA objectForKey:@"attribute"];
        NSDictionary *faceAge = [faceAttribute objectForKey:@"age"];
        NSInteger ageValue = [[faceAge objectForKey:@"value"]integerValue];
        NSDictionary *faceSmile = [faceAttribute objectForKey:@"smiling"];
        NSInteger smileValue = [[faceSmile objectForKey:@"smiling"] integerValue];
        
        if (ageValue<=12 && smileValue <15) {
            sectences =  [CoreDataTool getSentences:1 andsmile:1];
        }else if (ageValue<=12 && smileValue <30) {
            sectences =  [CoreDataTool getSentences:1 andsmile:2];
        }else if (ageValue<=12 && smileValue >30) {
            sectences =  [CoreDataTool getSentences:1 andsmile:3];
        }else if(ageValue >12 && ageValue<=18 && smileValue<15){
            sectences =  [CoreDataTool getSentences:2 andsmile:1];
        }else if(ageValue >12 && ageValue<=18 && smileValue<30){
            sectences =  [CoreDataTool getSentences:2 andsmile:2];
        }else if(ageValue >12 && ageValue<=18 && smileValue>30){
            sectences =  [CoreDataTool getSentences:2 andsmile:3];
        }else if(ageValue >18 && ageValue<=40 && smileValue<15){
            sectences =  [CoreDataTool getSentences:3 andsmile:1];
        }else if(ageValue >18 && ageValue<=40 && smileValue<30){
            sectences =  [CoreDataTool getSentences:3 andsmile:2];
        }else if(ageValue >18 && ageValue<=40 && smileValue>30){
            sectences =  [CoreDataTool getSentences:3 andsmile:3];
        }else if(ageValue >40 && smileValue<15){
            sectences =  [CoreDataTool getSentences:4 andsmile:1];
        }else if(ageValue >40 && smileValue<30){
            sectences =  [CoreDataTool getSentences:4 andsmile:2];
        }else if(ageValue >40 && smileValue>30){
            sectences =  [CoreDataTool getSentences:4 andsmile:3];
        }
        
    
    int i = arc4random()%([sectences count]-1);
             return [sectences objectAtIndex:i];
         
    }else return @"";
}


+(NSInteger)getAge:(NSDictionary*)img{
    NSInteger ageValue = 0;
    NSArray *faceArr  = [img objectForKey:@"face"];
    if ([faceArr count] !=0) {
        NSDictionary *faceDicFollowFA = [faceArr objectAtIndex:0];
        NSDictionary *faceAttribute = [faceDicFollowFA objectForKey:@"attribute"];
        NSDictionary *faceAge = [faceAttribute objectForKey:@"age"];
        ageValue = [[faceAge objectForKey:@"value"]integerValue];
        
    }
    
    return ageValue;
}

+(NSInteger)getHappy:(NSDictionary*)img{
    NSInteger happy = 0;
    NSArray *faceArr  = [img objectForKey:@"face"];
    if ([faceArr count] !=0) {
        NSDictionary *faceDicFollowFA = [faceArr objectAtIndex:0];
        NSDictionary *faceAttribute = [faceDicFollowFA objectForKey:@"attribute"];
        NSDictionary *faceAge = [faceAttribute objectForKey:@"smiling"];
        happy = [[faceAge objectForKey:@"value"]integerValue];
        
    }
    
    return happy;
}


+(UIImage*)getImage:(NSDictionary*)img{
    UIImage *imaged = [UIImage new];
    NSArray *faceArr  = [img objectForKey:@"face"];
    if ([faceArr count] !=0) {
        NSDictionary *faceDicFollowFA = [faceArr objectAtIndex:0];
        NSDictionary *faceAttribute = [faceDicFollowFA objectForKey:@"attribute"];
        
        NSDictionary *faceAge = [faceAttribute objectForKey:@"age"];
        NSDictionary *faceGender = [faceAttribute objectForKey:@"gender"];
        NSDictionary *glass = [faceAttribute objectForKey:@"glass"];
        NSDictionary *smile = [faceAttribute objectForKey:@"smiling"];
        
        NSInteger ageValue = [[faceAge objectForKey:@"value"]integerValue];
        NSString *genderValue = [faceGender objectForKey:@"value"];
        NSString *glassValue = [glass objectForKey:@"value"];
        float smileValue = [[smile objectForKey:@"value"] floatValue];
        
        if (ageValue <12 && [genderValue isEqualToString:@"Male"]&& smileValue <15)
             imaged = [UIImage imageNamed:@"gender1age1smile1glass2.png"];
        else if (ageValue <12 && [genderValue isEqualToString:@"Female"]&& smileValue <15)
            imaged = [UIImage imageNamed:@"gender2age1smile1glass2.png"];
        else if (ageValue <12 && [genderValue isEqualToString:@"Female"]&& smileValue <30)
            imaged = [UIImage imageNamed:@"gender2age1smile2glass2.png"];
        else if (ageValue <12 && [genderValue isEqualToString:@"Male"]&&smileValue <30)
            imaged = [UIImage imageNamed:@"gender1age1smile2glass2.png"];
        else if (ageValue <12 && [genderValue isEqualToString:@"Female"]&& smileValue >30)
            imaged = [UIImage imageNamed:@"gender2age1smile3glass2.png"];
        else if (ageValue <12 && [genderValue isEqualToString:@"Male"]&& smileValue >30)
            imaged = [UIImage imageNamed:@"gender1age1smile3glass2.png"];
        else if(ageValue <19 && ageValue > 11 && [genderValue isEqualToString:@"Female"]&& smileValue <15&&[glassValue isEqualToString:@"Normal"])imaged = [UIImage imageNamed:@"gender2age2smile1glass1.png"];
        else if(ageValue <19 && ageValue > 11 && [genderValue isEqualToString:@"Female"]&& smileValue <15&&[glassValue isEqualToString:@"None"])imaged = [UIImage imageNamed:@"gender2age2smile1glass2.png"];
        else if(ageValue <19 && ageValue > 11 && [genderValue isEqualToString:@"Female"]&& smileValue <30&&[glassValue isEqualToString:@"Normal"])imaged = [UIImage imageNamed:@"gender2age2smile2glass1.png"];
        else if(ageValue <19 && ageValue > 11 && [genderValue isEqualToString:@"Female"]&& smileValue <30&&[glassValue isEqualToString:@"None"])imaged = [UIImage imageNamed:@"gender2age2smile2glass2.png"];
        else if(ageValue <19 && ageValue > 11 && [genderValue isEqualToString:@"Female"]&& smileValue >30&&[glassValue isEqualToString:@"Normal"])imaged = [UIImage imageNamed:@"gender2age2smile3glass1.png"];
        else if(ageValue <19 && ageValue > 11 && [genderValue isEqualToString:@"Female"]&& smileValue >30&&[glassValue isEqualToString:@"None"])imaged = [UIImage imageNamed:@"gender2age2smile3glass2.png"];
        else if(ageValue <40 && ageValue > 18 && [genderValue isEqualToString:@"Female"]&& smileValue <15&&[glassValue isEqualToString:@"Normal"])imaged = [UIImage imageNamed:@"gender2age3smile1glass1.png"];
        else if(ageValue <40 && ageValue > 18 && [genderValue isEqualToString:@"Female"]&& smileValue <15&&[glassValue isEqualToString:@"None"])imaged = [UIImage imageNamed:@"gender2age3smile1glass2.png"];
        else if(ageValue <40 && ageValue > 18 && [genderValue isEqualToString:@"Female"]&& smileValue <30&&[glassValue isEqualToString:@"Normal"])imaged = [UIImage imageNamed:@"gender2age3smile2glass1.png"];
        else if(ageValue <40 && ageValue > 18 && [genderValue isEqualToString:@"Female"]&& smileValue <30&&[glassValue isEqualToString:@"None"])imaged = [UIImage imageNamed:@"gender2age3smile2glass2.png"];
        else if(ageValue <40 && ageValue > 18 && [genderValue isEqualToString:@"Female"]&& smileValue >30&&[glassValue isEqualToString:@"Normal"])imaged = [UIImage imageNamed:@"gender2age3smile3glass1.png"];
        else if(ageValue <40 && ageValue > 18 && [genderValue isEqualToString:@"Female"]&& smileValue >30&&[glassValue isEqualToString:@"None"])imaged = [UIImage imageNamed:@"gender2age3smile3glass2.png"];
        else if(ageValue > 40 && [genderValue isEqualToString:@"Female"]&& smileValue <15&&[glassValue isEqualToString:@"Normal"])imaged = [UIImage imageNamed:@"gender2age4smile1glass1.png"];
        else if(ageValue > 40 && [genderValue isEqualToString:@"Female"]&& smileValue <15&&[glassValue isEqualToString:@"None"])imaged = [UIImage imageNamed:@"gender2age4smile1glass2.png"];
        else if(ageValue > 40 && [genderValue isEqualToString:@"Female"]&& smileValue <30&&[glassValue isEqualToString:@"Normal"])imaged = [UIImage imageNamed:@"gender2age4smile2glass1.png"];
        else if(ageValue > 40 && [genderValue isEqualToString:@"Female"]&& smileValue <30&&[glassValue isEqualToString:@"None"])imaged = [UIImage imageNamed:@"gender2age4smile2glass2.png"];
        else if(ageValue > 40 && [genderValue isEqualToString:@"Female"]&& smileValue >30&&[glassValue isEqualToString:@"Normal"])imaged = [UIImage imageNamed:@"gender2age4smile3glass1.png"];
        else if(ageValue > 40 && [genderValue isEqualToString:@"Female"]&& smileValue >30&&[glassValue isEqualToString:@"None"])imaged = [UIImage imageNamed:@"gender2age4smile3glass2.png"];
        
        else if(ageValue <19 && ageValue > 11 && [genderValue isEqualToString:@"Male"]&& smileValue <15&&[glassValue isEqualToString:@"Normal"])imaged = [UIImage imageNamed:@"gender1age2smile1glass1.png"];
        else if(ageValue <19 && ageValue > 11 && [genderValue isEqualToString:@"Male"]&& smileValue <15&&[glassValue isEqualToString:@"None"])imaged = [UIImage imageNamed:@"gender1age2smile1glass2.png"];
        else if(ageValue <19 && ageValue > 11 && [genderValue isEqualToString:@"Male"]&& smileValue <30&&[glassValue isEqualToString:@"Normal"])imaged = [UIImage imageNamed:@"gender1age2smile2glass1.png"];
        else if(ageValue <19 && ageValue > 11 && [genderValue isEqualToString:@"Male"]&& smileValue <30&&[glassValue isEqualToString:@"None"])imaged = [UIImage imageNamed:@"gender1age2smile2glass2.png"];
        else if(ageValue <19 && ageValue > 11 && [genderValue isEqualToString:@"Male"]&& smileValue >30&&[glassValue isEqualToString:@"Normal"])imaged = [UIImage imageNamed:@"gender1age2smile3glass1.png"];
        else if(ageValue <19 && ageValue > 11 && [genderValue isEqualToString:@"Male"]&& smileValue >30&&[glassValue isEqualToString:@"None"])imaged = [UIImage imageNamed:@"gender1age2smile3glass2.png"];
        else if(ageValue <40 && ageValue > 18 && [genderValue isEqualToString:@"Male"]&& smileValue <15&&[glassValue isEqualToString:@"Normal"])imaged = [UIImage imageNamed:@"gender1age3smile1glass1.png"];
        else if(ageValue <40 && ageValue > 18 && [genderValue isEqualToString:@"Male"]&& smileValue <15&&[glassValue isEqualToString:@"None"])imaged = [UIImage imageNamed:@"gender1age3smile1glass2.png"];
        else if(ageValue <40 && ageValue > 18 && [genderValue isEqualToString:@"Male"]&& smileValue <30&&[glassValue isEqualToString:@"Normal"])imaged = [UIImage imageNamed:@"gender1age3smile2glass1.png"];
        else if(ageValue <40 && ageValue > 18 && [genderValue isEqualToString:@"Male"]&& smileValue <30&&[glassValue isEqualToString:@"None"])imaged = [UIImage imageNamed:@"gender1age3smile2glass2.png"];
        else if(ageValue <40 && ageValue > 18 && [genderValue isEqualToString:@"Male"]&& smileValue >30&&[glassValue isEqualToString:@"Normal"])imaged = [UIImage imageNamed:@"gender1age3smile3glass1.png"];
        else if(ageValue <40 && ageValue > 18 && [genderValue isEqualToString:@"Male"]&& smileValue >30&&[glassValue isEqualToString:@"None"])imaged = [UIImage imageNamed:@"gender1age3smile3glass2.png"];
        
        else if(ageValue > 40 && [genderValue isEqualToString:@"Male"]&& smileValue <15&&[glassValue isEqualToString:@"Normal"])imaged = [UIImage imageNamed:@"gender1age4smile1glass1.png"];
        else if(ageValue > 40 && [genderValue isEqualToString:@"Male"]&& smileValue <15&&[glassValue isEqualToString:@"None"])imaged = [UIImage imageNamed:@"gender1age4smile1glass2.png"];
        else if(ageValue > 40 && [genderValue isEqualToString:@"Male"]&& smileValue <30&&[glassValue isEqualToString:@"Normal"])imaged = [UIImage imageNamed:@"gender1age4smile2glass1.png"];
        else if(ageValue > 40 && [genderValue isEqualToString:@"Male"]&& smileValue <30&&[glassValue isEqualToString:@"None"])imaged = [UIImage imageNamed:@"gender1age4smile2glass2.png"];
        else if(ageValue > 40 && [genderValue isEqualToString:@"Male"]&& smileValue >30&&[glassValue isEqualToString:@"Normal"])imaged = [UIImage imageNamed:@"gender1age4smile3glass1.png"];
        else if(ageValue > 40 && [genderValue isEqualToString:@"Male"]&& smileValue >30&&[glassValue isEqualToString:@"None"])imaged = [UIImage imageNamed:@"gender1age4smile3glass2.png"];
    }
    
    return imaged;

}
+(NSString*)getDescriptionTitle:(NSDictionary*)img{
    NSArray *title = [NSArray new];
    
        NSArray *faceArr  = [img objectForKey:@"face"];
    if ([faceArr count] !=0) {
        NSDictionary *faceDicFollowFA = [faceArr objectAtIndex:0];
        NSDictionary *faceAttribute = [faceDicFollowFA objectForKey:@"attribute"];
        
        NSDictionary *faceAge = [faceAttribute objectForKey:@"age"];
        NSDictionary *faceGender = [faceAttribute objectForKey:@"gender"];

        NSInteger ageValue = [[faceAge objectForKey:@"value"]integerValue];
        NSString *genderValue = [faceGender objectForKey:@"value"];
        
        if (ageValue < 12 && [genderValue isEqualToString:@"Male"])
            title = [CoreDataTool getTitle:1 andgender:1];
        else if (ageValue <12 && [genderValue isEqualToString:@"Female"])
            title = [CoreDataTool getTitle:1 andgender:2];
        else if (11 < ageValue && ageValue < 19 && [genderValue isEqualToString:@"Male"])
            title = [CoreDataTool getTitle:2 andgender:1];
        else if (11 < ageValue && ageValue< 19 && [genderValue isEqualToString:@"Female"])
            title = [CoreDataTool getTitle:2 andgender:2];
        else if (18 < ageValue && ageValue< 40 && [genderValue isEqualToString:@"Male"])
            title = [CoreDataTool getTitle:3 andgender:1];
        else if (18 < ageValue && ageValue< 40 && [genderValue isEqualToString:@"Female"])
            title = [CoreDataTool getTitle:3 andgender:2];
        else if (ageValue >=40 && [genderValue isEqualToString:@"Female"])
            title = [CoreDataTool getTitle:4 andgender:2];
        else if (ageValue >=40 && [genderValue isEqualToString:@"Male"])
            title = [CoreDataTool getTitle:4 andgender:1];

        int i = arc4random()%([title count]-1);
        return [title objectAtIndex:i];
        
    }else return @" ";
    
}
@end
