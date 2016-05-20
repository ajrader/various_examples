__author__ = 'kesj'

import multiprocessing
from glob import glob
import os


def worker(num):
    print 'Worker:', num
    return

mypath='C:\\Users\\kesj\\Documents\\projects\\CENT\\'


if __name__ == '__main__':
    jobs = []
    os.chdir(mypath)
    flist = glob('*.csv'')
    for i in range(5):
        p = multiprocessing.Process(target=worker, args=(i,))
        jobs.append(p)
        p.start()