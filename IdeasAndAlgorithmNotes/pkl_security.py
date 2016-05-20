class WhatEvenIsSecurity(object):
    def __reduce__(self):
        return (os.listdir, ('.',),)
