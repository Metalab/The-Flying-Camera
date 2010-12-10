//
//  main.m
//  CtF
//
//  Created by Thomas R. Koll on 09.12.10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <MacRuby/MacRuby.h>

int main(int argc, char *argv[])
{
    return macruby_main("rb_main.rb", argc, argv);
}
