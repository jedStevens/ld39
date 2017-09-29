# Import system modules
import sys, os
import gdheroku
# default port: 4202
gdheroku.create_port_file()

# Boot Web Server
# ============================

port = 3000
try:
   port = int(os.environ["PORT"])
except KeyError:
   print "Please set the environment variable PORT"
   sys.exit(1)

os.system("python2 -m  SimpleHTTPServer "+str(port)+ " &")

os.system("export DREAMLIGHTSERVER=666")




# Boot Game Server
# ================

# Locate the tarball, it should be a neighbor
tarball = os.path.join(os.path.dirname(os.path.realpath(__file__)), "server.tar.gz")

os.system("cp " + tarball + " " + tarball + ".old")
os.system("tar -zxvf " + tarball)

os.system("mv " + tarball + ".old " + tarball)

os.system('echo "Server magic code set to: `echo $DREAMLIGHTSERVER`"')


server = os.path.join(os.path.dirname(os.path.realpath(__file__)), "heroku_server.sh")

os.system("chmod +x "+server)
os.system(server)
