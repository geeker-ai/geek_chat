from github import Github, GitRelease, GitReleaseAsset
from github import Auth
import os

def download(url, fileName):
    pass

def do_command(command):
    pass

def generate_appcast_xml(windows_key, macos_key):
    pass

if __name__ == '__main__':
    github_token = os.environ.get("GEEK_CHAT_GITHUB_TOKEN")

    if (github_token == None):
        exit(1)

    auth = Auth.Token(github_token)
    g = Github(auth=auth)

    repo = g.get_repo('geeker-ai/geek_chat')

    last_release = repo.get_latest_release()
    tag_name = last_release.tag_name
    assets = last_release.get_assets()

    print("repo name: {}, tag_name: {} ".format(repo.name, tag_name))

    for asset in assets:
        print("aesst -> name: {}, id: {}, url: {}".format(asset.name, asset.id, asset.url))
