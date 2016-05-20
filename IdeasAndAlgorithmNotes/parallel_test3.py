__author__ = 'kesj'

import multiprocessing
from glob import glob
import os


def worker(num):
    print 'Worker:', num
    return


def wordcount(fname, num):
    file = open(fname, "r+")
    wcount = {}
    for word in file.read().split(','):
        if word not in wcount:
            wcount[word] = 1
        else:
            wcount[word] += 1
    for k, v in wcount.items():
        if v > 50 & k.startswith('M'):
            print k, v, num


mypath = 'C:\\Users\\kesj\\Documents\\projects\\CENT\\'

if __name__ == '__main__':
    jobs = []
    os.chdir(mypath)
    flist = glob('*.csv')
    print len(flist)
    for i in flist:  # range(5):
        for j in range(5):
            p = multiprocessing.Process(target=wordcount, args=(i, j,))
        jobs.append(p)
        p.start()