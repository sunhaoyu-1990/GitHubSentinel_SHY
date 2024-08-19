from github import Github

class UpdateFetcher:
    def __init__(self, github_token):
        self.github = Github(github_token)

    def fetch_updates(self, repo_name):
        repo = self.github.get_repo(repo_name)
        events = repo.get_events()  # 获取仓库的事件
        return events
