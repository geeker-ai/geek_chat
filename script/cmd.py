import os
import getopt, sys
import yaml
import dotenv
import shutil

def version_to_build_number(version:str):
    vlist = version.split(".")
    number = int(vlist[0]) * 100000 + int(vlist[1]) * 1000 + int(vlist[2])
    return number

def change_pubspec_version (version: str, build_number: int):
    with open("./pubspec.yaml", 'r') as f:
        list_doc = yaml.safe_load(f)
        list_doc["version"] = f"{version}+{build_number}"
        print(list_doc["version"])
        with open("./pubspec.yaml", "w") as fw:
            yaml.dump(list_doc, fw)
    f.close()
    fw.close()

def change_channel (value):
    dotenv.set_key(".env", "CHANNEL", value)

def change_tracker_key (value):
    dotenv.set_key(".env", "TRACKER_KEY", value)

if __name__ == '__main__':
    version = os.environ.get("VERSION", "0.0.1")
    channel = os.environ.get("CHANNEL", "site")
    tracker_key = os.environ.get("INSIGHT_KEY")
    argument_list = sys.argv[1:]
    options = "vci"
    long_options = ["verion", "channel", "init"]
    try:
        arguments, values = getopt.getopt(argument_list, options, long_options)
        for curren_arg, arg_value in arguments:
            if curren_arg in ("-v", "--version"):
                print("version")
                # change_version(version)
                build_number = version_to_build_number(version)
                change_pubspec_version(version, build_number)

            elif curren_arg in ("-c", "--channel"):
                change_channel(channel)
                print(f"channel: {channel}")
            elif curren_arg in ("-i", '--init'):
                shutil.copyfile("env", ".env")
                change_tracker_key(tracker_key)
                print("init .env")
    except getopt.error as err:
        print(str(err))