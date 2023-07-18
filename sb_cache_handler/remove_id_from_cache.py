import os
import sys
import json
from sb_cache_handler.sb_cache import SBRemoteCache

args = sys.argv[1:]

fname = "vidcache.json"

if len(args) == 0:
    bn = os.path.basename(sys.argv[0])
    print (f"Usage: python {bn} youtubeID\n")
    sys.exit(1)

sbcache = SBRemoteCache()
sbcache.remove_id_from_cache(args[0])