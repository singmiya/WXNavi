//
//  Constants.h
//  WXNavi
//
//  Created by Somiya on 06/06/2018.
//  Copyright © 2018 Somiya. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.width

#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

// log
#define Log_f(f) NSLog(@"%f", f)
#define Log_str(str) NSLog(@"%@", str)

#endif /* Constants_h */
