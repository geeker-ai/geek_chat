# from github import Github, InputFileContent
# from github import Auth
# from datetime import datetime, timezone
# import os
# import json

# def download_file(url, file_name , token):
#     command = "curl -L " + \
#         "-H 'Accept: application/octet-stream' " + \
#         "-H 'Authorization: Bearer {}' ".format(token) + \
#         "-H 'X-GitHub-Api-Version: 2022-11-28' " + \
#         "-o '{}' ".format(file_name) + "{}".format(url)
#     return do_command(command=command)

# def do_command(command):
#     process = os.popen(command)
#     output = process.read()
#     process.close()
#     return output


# if __name__ == '__main__':
#     github_token = os.environ.get("GEEK_CHAT_GITHUB_TOKEN")
#     base_dir ="./tmp"
#     base_url = "https://pub-6be131b6553c4ce5a6f736f91a7d011a.r2.dev"

#     if (github_token == None):
#         exit(1)

#     auth = Auth.Token(github_token)
#     g = Github(auth=auth)

#     repo_name = 'geeker-ai/geek_chat'
#     print("repo_name: {}".format(repo_name))

#     repo = g.get_repo(repo_name)

#     last_release = repo.get_latest_release()
#     tag_name = last_release.tag_name
#     assets = last_release.get_assets()

#     # releases = repo.get_releases()

#     print("repo name: {}, tag_name: {} ".format(repo.name, tag_name))

#     save_dir = "{}/{}".format(base_dir, tag_name)
#     os.makedirs(save_dir, exist_ok=True)
#     files = []
#     for asset in assets:
#         print("aesst -> name: {}, id: {}, url: {}".format(asset.name, asset.id, asset.url))
#         files.append({"name": asset.name, "url": f"{base_url}/{tag_name}/{asset.name}"})
#         print(download_file(asset.url, "{}/{}".format(save_dir, asset.name), github_token))

#     r2dir = "r2:geekchat/{}".format(tag_name)
#     print(do_command("rclone mkdir {}".format(r2dir)))
#     print(do_command("rclone copy -P {} {}".format(save_dir, r2dir)))


#     latest = {
#         "version": tag_name,
#         "assets": files
#     }
#     print(latest)
#     latest_file = f"{base_dir}/latest.json"
#     with open(latest_file, 'w') as f:
#         f.write(json.dumps(latest))

#     ### generate changelog.json
#     releases = repo.get_releases()
#     change_log = []
#     for release in releases:
#         print(f"name: {release.tag_name}, content: {release.body}, pub_date: {release.published_at}")
#         change_log.append({"version": release.tag_name, "content": release.body, "publish_at": f"{release.published_at}"})
#     change_log_file = f"{base_dir}/changelog.json"
#     change_log_json = {"versions": change_log}
#     with open(change_log_file, 'w') as f1:
#         f1.write(json.dumps(change_log_json))


#     print(do_command(f"rclone copy {latest_file} r2:geekchat"))
#     print(do_command(f"rclone copy {change_log_file} r2:geekchat"))

#     gist = g.get_gist("52a66708a59c6f7501c01bb43e3adcbd")
#     print(gist.files['latest.json'])
#     gist.edit(description="", files={'latest.json': InputFileContent(json.dumps(latest))})
#     gist.edit(description="", files={'changelog.json': InputFileContent(json.dumps(change_log_json))})
#     gist.update()

#     do_command(f"rm -rf {base_dir}")
