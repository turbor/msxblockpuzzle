#!/usr/bin/python

"""
Copyright 2017 (c) David Heremans 
Licensed under the terms of the GNU GPL License version 2

This script rearranges the chars in a *.SC2 file so that duplicate chars
are eliminated. all empty chars will be replaced by char(255) in nametable.

Usage:
  Specify the SC2 file to be adjusted.
  We currently check filesize (14343) and 7 bytes header to be
  'fe 00 00 ff 37 00 00' to determine a valid sc2 file
"""

import sys,os

#To be placed in front of all other chars
tofront=[33,34,65,66, # black
                 35,36,67,68, # yellow
                 37,38,69,70, # red 

                 97,98,129,130, # blue
                 99,100,131,132, #blue ani 1
                 101,102,133,134, #blue ani 2
                 103,104,135,136, #blue ani 3
                 105,106,137,138, #blue ani 4
                 107,108,139,140, #blue ani 5
                 109,110,141,142, #blue ani 6
                 111,112,143,144, #blue ani 7
                 113,114,145,146, #blue ani 8

                 56,57,58                # small black,yellow,blu char 48,49,50
                 ]
donotdeduplicated=range(0,51)
tofrontnumbers=[33,34,65,66,
                 35,36,67,68,
                 37,38,69,70,

                 97,98,129,130,
                 99,100,131,132,
                 101,102,133,134,
                 103,104,135,136,
                 105,106,137,138,
                 107,108,139,140,
                 109,110,141,142,
                 111,112,143,144,
                 113,114,145,146,

                 56,57,58,

                 170,171,172,173,174,175,176,177,178,179,180,
                 202,203,204,205,206,207,208,209,210,211,212
                ]
donotdeduplicatednumbers=range(0,73)

vram=list()
character=[None]*256
table=[None]*256
expectheader = [chr(0xfe),chr(0),chr(0),chr(0xff),chr(0x37),chr(0),chr(0)]

def readfile(filename):
        global vram
        global expectheader
        print "Testing filename " + filename

        statinfo = os.stat(filename)
        if statinfo.st_size != 14343 :
                        print"wrong filezsize for SC2 file"
                        sys.exit(1)

        file = open(filename,"r")
        header = file.read(7)

        for i in range(7):
                        if header[i] !=expectheader[i]:
                                        print"wrong header"
                                        sys.exit(1)
        vram=list(file.read())

def buildcharset(offsetchars,offsetcolor):
    global vram
    for i in range(256):
        data=""
        for y in range(8):
                      data += '%02x'%ord(vram[i*8+y+offsetchars])
                      data += '%02x'%ord(vram[i*8+y+offsetcolor])
        character[i]=data

def setfromcharset(offsetchars,offsetcolor):
        global vram
        global character
        for i in range(256):
                data=character[i]
                for y in range(8):
                      ca=int(data[0:2],16)
                      co=int(data[2:4],16)
                      #print "   " + data[0:4]+ "  " + str(ca) + "  " + str(co)
                      data=data[4:]
                      vram[i*8+y+offsetchars] = chr(ca)
                      vram[i*8+y+offsetcolor] = chr(co)
                data=character[i]

def buildtable(offsetchars):
        global table
        for i in range(256):
                table[i]=vram[i+offsetchars]

def setfromtable(offsetchars):
        global vram
        for i in range(256):
                vram[i+offsetchars] = table[i]


def replaceintable(oldval,newval):
        global table
        for i in range(256):
                if table[i] == chr(oldval):
                        table[i]=chr(newval)
def swapintable(oldval,newval):
        global table
        for i in range(256):
                if table[i] == chr(oldval):
                        table[i]=chr(newval)
                elif table[i] == chr(newval):
                    table[i]=chr(oldval)

def naarvoren():
    global tofront
    global character
    if len(tofront) == 0:
        return
    for i in range(len(tofront)):
        j = tofront[i]
        print 'swapping ' + str(i) + " en " + str(j)
        character[i],character[j] = character[j],character[i]
        swapintable(i , j)


def herschik():
    #first eliminate doubles
    global character
    global donotdeduplicated
    doublefound=0
    for i in range(255):
        print str(i) + ':  ' + character[i]
        j=i+1;
        while j<256:
            if ( not (j in donotdeduplicated )
                 and ( character[j] != '00'*16 )
                 and ( character[j] == character[i] ) ):
                print "replace " + str(j) + " with " +str(i)
                character[j]='00'*16
                replaceintable(j,i)
                doublefound=1
            j=j+1

    if doublefound==0:
            print "no doubles found"
            sys.exit(0)
            return
        #now move '00'*16chars to back of char def list
    print "doubles found"
    j=255
    while (j>0) and (character[j]=='00'*16):
        j=j-1
    for i in range(255):
            if (character[i] == '00'*16) and (j>i):
                character[i],character[j] = character[j],character[i]
                swapintable(j,i)
                #since we are sure the 0 value will also be in char255 in the end
                replaceintable(j,255)
                print "made "+str(j)+" a '00'*16"
                while (j > 0) and (character[j] == '00' * 16):
                    j = j - 1

def laatsteinfo():
    global character
    for i in range(255):
        if (character[i] == '00'*16):
                        print "-------------- first zero char is " + str(i)
                        return
def main():
    global vram
    global character
    global expectheader
    global tofrontnumbers
    global tofront
    global donotdeduplicated
    global donotdeduplicatednumbers
    if len(sys.argv) < 2:
        print "specify file to alter"
        sys.exit(1)
    filename=sys.argv[1]

    outfilename=''
    if len(sys.argv) > 2:
        outfilename=sys.argv[2]
    readfile(filename)
    #build the chars an table for the first 1/3 of the screen
    buildcharset(0,0x2000)
    buildtable(0x1800)
    naarvoren()
    herschik()
    laatsteinfo()
    setfromcharset(0,0x2000)
    setfromtable(0x1800)

    buildcharset(0+256*8,0x2000+256*8)
    buildtable(0x1800+256)
    naarvoren()
    herschik()
    laatsteinfo()
    setfromcharset(0+256*8,0x2000+256*8)
    setfromtable(0x1800+256)

    tofront=tofrontnumbers
    donotdeduplicated=donotdeduplicatednumbers
    buildcharset(0+512*8,0x2000+512*8)
    buildtable(0x1800+512)
    naarvoren()
    herschik()
    laatsteinfo()
    setfromcharset(0+512*8,0x2000+512*8)
    setfromtable(0x1800+512)
    if outfilename != '':
        file = open(outfilename,"w")
        file.write(''.join(expectheader))
        file.write(''.join(vram))
    adr=0
    charcnt=0
    dblen=8
    while len(vram) > 0 :
        if adr == 0:
            print ";Pattern generator table"
            charcnt = 0
            dblen = 8
        elif adr == 0x1800:
            print ";Pattern name table"
            charcnt = 0
            dblen = 32
        elif adr == 0x1B00:
            print ";Sprite attribute color"
            charcnt = 0
            dblen = 8
        elif adr == 0x2000:
            print ";Color table"
            charcnt = 0
            dblen = 8
        elif adr == 0x3800:
            charcnt = 0
            dblen = 8
            print ";Sprite pattern generator table"
        print "\tdb " + ','.join("#%02x"%ord(e) for e in vram[0:dblen]) + "   ; %04x"%adr + "  - %02x"%charcnt
        vram=vram[dblen:]
        adr = adr + dblen
        charcnt = charcnt + 1


if __name__ == "__main__":
    main()
