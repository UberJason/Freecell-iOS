//
//  AppKitBridging.h
//  Freecell
//
//  Created by Jason Ji on 4/4/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AppKitBridging <NSObject>
-(instancetype)init;
-(void)showStatisticsWindow;
@end

NS_ASSUME_NONNULL_END
