#!/usr/bin/python3
import sys
from hashlib import sha256


class User:
    def __init__(self, user, passw):
        self.user = user
        self.passw = passw

    def __str__(self):
        hash_target = "".join(["{", self.user, "}", self.passw])
        print(hash_target)
        pass_column = sha256(hash_target.encode("ascii")).hexdigest()
        print(pass_column)
        return f"{self.user},{pass_column}"


def chunks(lst, n):
    for i in range(0, len(lst), n):
        yield lst[i:i + n]


def users(args):
    if len(args) % 1:
        raise Exception(f"Received an odd number of arguments, which is not allowed.")
    for [a, b] in chunks(args, 2):
        yield User(a, b)


rows = "\n".join([str(x) for x in users(sys.argv[1:])])
print(rows)
