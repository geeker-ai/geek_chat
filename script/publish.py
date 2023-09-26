from github import Github, Download
from github import Auth
from datetime import datetime, timezone
import os

def download_file(url, file_name , token):
    command = "curl -L " + \
        "-H 'Accept: application/octet-stream' " + \
        "-H 'Authorization: Bearer {}' ".format(token) + \
        "-H 'X-GitHub-Api-Version: 2022-11-28' " + \
        "-o '{}' ".format(file_name) + "{}".format(url)
    print(command)
    process = os.popen(command)
    output = process.read()
    process.close()
    return output


if __name__ == '__main__':
    github_token = os.environ.get("GEEK_CHAT_GITHUB_TOKEN")

    if (github_token == None):
        exit(1)

    auth = Auth.Token(github_token)
    g = Github(auth=auth)

    repo_name = 'geeker-ai/geek_chat'
    print("repo_name: {}".format(repo_name))

    repo = g.get_repo(repo_name)

    last_release = repo.get_latest_release()
    tag_name = last_release.tag_name
    assets = last_release.get_assets()

    print("repo name: {}, tag_name: {} ".format(repo.name, tag_name))


    save_dir = "./dist/{}".format(tag_name)
    os.mkdir(save_dir)

    for asset in assets:
        print("aesst -> name: {}, id: {}, url: {}".format(asset.name, asset.id, asset.url))
        download_file(asset.url, "{}/{}".format(save_dir, asset.name), github_token)
