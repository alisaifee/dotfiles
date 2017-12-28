#!/usr/bin/env python
import sys
import json
import os

command = sys.argv[1]
class I3Tree(object):
    def __init__(self):
        self.i3_tree = json.loads(os.popen("i3-msg -t get_tree").read())

    def get_focussed_window(self):
        for window in self.get_all_windows():
            if window['focused'] == True:
                return window

    def find_window(self, kls):
        for window in self.get_all_windows():
            if window['window_properties']['class'] == kls:
                return window

    def get_all_windows(self):
        def get_windows(root):
            if 'window_properties' in root:
                return [root]
            elif root.get('nodes', []):
                win = []
                [win.extend(get_windows(n)) for n in root['nodes']]
                return win
            return []
        return get_windows(self.i3_tree)

tree = I3Tree()

class MediaKeyProcessor(object):
    def __init__(self, key):
        self.key = key
    def process(self):
        return {'play': self.process_play, 'stop': self.process_stop, 'prev': self.process_prev, 'next': self.process_next}[self.key]()
    def process_play(self):
        self.std_command('PlayPause')
    def process_stop(self):
        self.std_command('Stop')
    def process_next(self):
        self.std_command('Next')
    def process_prev(self):
        self.std_command('Previous')
    def std_command(self, cmd):
        os.popen("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.%s" % cmd)


MediaKeyProcessor(command).process()

