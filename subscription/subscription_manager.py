class SubscriptionManager:
    def __init__(self):
        self.subscriptions = {}  # 简单字典替代数据库

    def add_subscription(self, user, repo):
        self.subscriptions[user] = repo

    def remove_subscription(self, user):
        if user in self.subscriptions:
            del self.subscriptions[user]

    def get_subscriptions(self):
        return self.subscriptions
