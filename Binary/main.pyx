import os
import sys
import fnmatch
import json

modes = []
apps = []

def prepare_location(location):
    
    location_list = list(location)

    for char in location_list:
        if char == " ":
            location_list[location_list.index(char)] = "\ "
            location = "".join(location_list)

    return location


def get_options(args,flag):

        flag = flag + "*"
        arg_options = fnmatch.filter(args,flag)
 
        if arg_options != []:

            arg_options = arg_options[0].replace("-git","").replace("[","").replace("]","")
            arg_options = arg_options.split(",")

            return arg_options

        else:
            return []

        
def config(args):

    args = args[2:len(args)]

    for arg in args:
        if arg == "-mode":
            
            mode = args[args.index(arg)+1]
            mode = mode.replace("]","").split("[")
            mode[1] = mode[1].split(",")
            print(mode)


class GetConfigs():

    def __init__(self,args):

        self.args = args
        

    def get_modes(self):

        for mode in self.args["modes"]:

            modes.append(mode["mode_name"])
         
        #print(modes)


    def get_apps (self,mode):

        for _mode in self.args["modes"]:
            if _mode["mode_name"] == mode:
                apps.append(_mode["applications"])

        # print(apps)
        return apps


class Main():

    mode = "default"
    location = prepare_location(os.getcwd())
    list_exceptions = []
    list_new_apps = []
    f = open('config.json',"r")
    config_json = json.loads(f.read())
    conf = GetConfigs(config_json)
    config_mode = False

    def __init__(self,args):

        self.args = args
        

    def determine(self):
        

        for arg in self.args:

            if arg == "--config":

                self.config_mode = True
                config(self.args)

            if arg == "-m":
                self.mode = self.args[self.args.index(arg)+1]


            if arg == "-l":
                self.location = prepare_location(self.args[self.args.index(arg)+1])


            if arg == "-e":
    
                self.list_exceptions = self.args[self.args.index(arg)+1].split(",")



            if arg == "-git":

                os.popen("git init")


            git_options = get_options(self.args,"-git")

            if arg == "-add":

                if self.args[self.args.index(arg)+1] == "-a":
                    list_new_apps = self.args[self.args.index(arg)+2].split(",")
                    print(list_new_apps)

    def run(self):
        tem_app = []


        if self.config_mode == False:

            print("Location :- " +"cd "+self.location+" "+";"+" "+"code .")
            
            print("***** Exceptions ******")    
            
            print(self.list_exceptions)

            if "code" not in self.list_exceptions :

                os.popen("cd "+self.location+" "+";"+" "+"code .")

            for app in self.conf.get_apps(self.mode)[0]:
                tem_app.append(app)

            print("***** Apps to open ******")    
            print(tem_app)


app = Main(sys.argv)
app.determine()
app.run()