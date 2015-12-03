#!/usr/bin/python

import argparse
import shutil
import os
from os import mkdir
from os import listdir
from os.path import abspath, isfile, join
from PIL import Image
from PyQt4 import QtGui, QtCore
import sys


def parse_arguments():
	''' parse input args '''
	parser = argparse.ArgumentParser(description='shows all images in a directory to label')
	parser.add_argument('target', help='directory to parse')
	return parser.parse_args()

def get_user_id_from_file(f):
	''' get user id from a file '''
	return f.split('_')[0]


def get_user_ids(target_dir):
	''' get all user ids in a directory '''
	return {get_user_id_from_file(f) for f in listdir(abspath(target_dir)) if isfile(join(target_dir, f))}
	
class SwipeGui(QtGui.QWidget):
    
    def __init__(self, dir, ids):
        super(SwipeGui, self).__init__()
        self.ids = list(ids)
	self.num = len(self.ids)
	self.curr_id = 'whatever'
	self.dir = dir
        self.initUI()
	self.disp_next_image()	

        
    def initUI(self):      
        self.label = QtGui.QLabel(self)

	self.layout = QtGui.QVBoxLayout(self)
        self.layout.addWidget(self.label)
        
        self.move(300, 200)
        self.setWindowTitle('Mikes Sick GUI')
        self.show()  


    def changeImage(self, pathToImage):
        pixmap = QtGui.QPixmap(pathToImage)
        self.label.setPixmap(pixmap)

	
    def update_id(self):
	if (self.curr_id > 0):
		self.num -= 1
	else:
		print 'NO MORE IMAGES!!'
	self.curr_id = self.ids[self.num]
	self.update()


    def disp_next_image(self):
	self.update_id()
	self.changeImage(join(self.dir, self.curr_id) + '_label.png')


    def keyPressEvent(self, event):
    	key = event.key()
    	if key == QtCore.Qt.Key_Left:
		self.move_f(self.curr_id, self.dir + '_' + os.environ['USER'] + '_no')
        	self.disp_next_image()

	if key == QtCore.Qt.Key_Right:
		self.move_f(self.curr_id, self.dir + '_' + os.environ['USER'] + '_yes')
		self.disp_next_image()

	if key == QtCore.Qt.Key_Down:
		self.move_f(self.curr_id, self.dir + '_' + os.environ['USER'] +  '_notface')
		self.disp_next_image()

    def move_f(self, id, target):
	shutil.move(join(self.dir, self.curr_id) + '_face.png', target)
	shutil.move(join(self.dir, self.curr_id) + '_faceLarge.png', target)
	shutil.move(join(self.dir, self.curr_id) + '_orig.png', target)
	shutil.move(join(self.dir, self.curr_id) + '_label.png', target)

def main():
	args = parse_arguments()
	user_ids = get_user_ids(args.target)
	if not os.path.exists(args.target + '_' + os.environ['USER'] + '_no'): mkdir(args.target + '_' + os.environ['USER'] + '_no')
	if not os.path.exists(args.target + '_' +  os.environ['USER'] + '_yes'): mkdir(args.target + '_' + os.environ['USER'] + '_yes')
	if not os.path.exists(args.target + '_' + os.environ['USER'] + '_noface'): mkdir(args.target + '_' + os.environ['USER'] + '_noface')
	app = QtGui.QApplication(sys.argv)
    	prgrm = SwipeGui(args.target, user_ids)
    	sys.exit(app.exec_())

if __name__ == '__main__':
	main()
