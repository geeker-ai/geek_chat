from github import Github, GitRelease, GitReleaseAsset
from github import Auth
import os
import yaml
import re

def download(url, fileName):
    pass

def do_command(command):
    # return os.system(command)
    process = os.popen(command)
    output = process.read()
    process.close()
    return output

def generate_appcast_xml(system_os, appcast_file, version, pub_date, sign, release_notes_url, download_url):
    with open('script/appcast_template.xml', 'r') as f:
        file_content = f.read()
        content = file_content.format(version = version, release_notes_url = release_notes_url, system_os = system_os, \
                            pub_date = pub_date, sign = sign, download_url = download_url)
        # print(content)
        fw = open(appcast_file, 'w')
        fw.write(content)
        fw.close()

def get_repo_name(system = 'macos'):
    f = open("./distribute_options.yaml", 'r', encoding='utf-8')
    data = yaml.load(f.read(),Loader=yaml.FullLoader)
    repo_name = 'geeker-ai/geek_chat'
    for release in data['releases']:
        if (release['name'] == system):
            publish = release['jobs'][0]['publish']
            repo_name = "{}/{}".format(publish['args']['repo-owner'], publish['args']['repo-name'])

    return repo_name

def get_release_file_path(root_path = './dist', system = 'macos'):
    files = os.listdir(root_path)
    version_dir = ''
    file_name = ''
    for file in files:
        if (re.match(r'[\d]\.[\d]\.[\d].*', file)):
            version_dir = file
            sub_files = os.listdir("{}/{}".format(root_path, version_dir))
            print(sub_files)
            ext = 'zip'
            if (system == 'windows'):
                ext = 'exe'
            for sub in sub_files:
                if (re.match('.*({}).*.{}'.format(system, ext), sub)):
                    print("file: {} ".format(sub))
                    file_name = sub
    return "{}/{}/{}".format(root_path, version_dir, file_name)

if __name__ == '__main__':
    github_token = os.environ.get("GEEK_CHAT_GITHUB_TOKEN")
    system = os.environ.get("SYSTEM_OS_NAME")
    version = os.environ.get("VERSION")

    if (github_token == None):
        exit(1)

    auth = Auth.Token(github_token)
    g = Github(auth=auth)

    repo_name = get_repo_name()
    print("repo_name: {}".format(repo_name))

    file_path = get_release_file_path()

    print("file path: {}".format(file_path))

    sign = do_command("dart run auto_updater:sign_update {}".format(file_path))

    print("sign: {}".format(sign))

    cast_file_name = "{}cast.xml".format(system)
    appcast_file = './dist/{}'.format(cast_file_name)

    pub_date='Sun, 16 Feb 2022 12:00:00 +0800'

    generate_appcast_xml(system_os=system, appcast_file=appcast_file, version=version, \
                         pub_date=pub_date, sign=sign, \
                         release_notes_url = 'https://apps.macgeeker.com', \
                         download_url= "https://apps.macgeeker.com")

    repo = g.get_repo(repo_name)

    last_release = repo.get_latest_release()
    tag_name = last_release.tag_name
    assets = last_release.get_assets()
    last_release.upload_asset(appcast_file, cast_file_name)

    # print("repo name: {}, tag_name: {} ".format(repo.name, tag_name))

    # for asset in assets:
    #     print("aesst -> name: {}, id: {}, url: {}".format(asset.name, asset.id, asset.url))
