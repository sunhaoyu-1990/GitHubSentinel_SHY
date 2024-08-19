#!/bin/bash

# 创建主目录
mkdir -p GitHubSentinel_SHY/{subscription,fetcher,notification,report,scheduler}

# 创建 sentinel.py 文件
cat > GitHubSentinel_SHY/sentinel.py <<EOL
from config import GITHUB_TOKEN
from subscription.subscription_manager import SubscriptionManager
from fetcher.update_fetcher import UpdateFetcher
from notification.notification_system import NotificationSystem
from report.report_generator import ReportGenerator
from scheduler.scheduler import Scheduler

class Sentinel:
    def __init__(self):
        self.subscription_manager = SubscriptionManager()
        self.update_fetcher = UpdateFetcher(GITHUB_TOKEN)
        self.notification_system = NotificationSystem()
        self.report_generator = ReportGenerator()

    def run_daily_updates(self):
        subscriptions = self.subscription_manager.get_subscriptions()
        for user, repo in subscriptions.items():
            updates = self.update_fetcher.fetch_updates(repo)
            report = self.report_generator.generate_report(updates)
            self.notification_system.send_email(user, "Daily GitHub Updates", report)

    def start(self):
        scheduler = Scheduler(self.run_daily_updates)
        scheduler.schedule_daily_task()

if __name__ == "__main__":
    sentinel = Sentinel()
    sentinel.start()
EOL

# 创建 config.py 文件
cat > GitHubSentinel_SHY/config.py <<EOL
GITHUB_TOKEN = "your_github_token"

# 邮件配置
EMAIL_HOST = "smtp.example.com"
EMAIL_PORT = 587
EMAIL_USER = "your_email@example.com"
EMAIL_PASS = "your_password"

# Slack 配置
SLACK_WEBHOOK_URL = "https://hooks.slack.com/services/your_webhook_url"
EOL

# 创建 requirements.txt 文件
cat > GitHubSentinel_SHY/requirements.txt <<EOL
PyGithub
schedule
requests
EOL

# 创建 subscription_manager.py 文件
cat > GitHubSentinel_SHY/subscription/subscription_manager.py <<EOL
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
EOL

# 创建 update_fetcher.py 文件
cat > GitHubSentinel_SHY/fetcher/update_fetcher.py <<EOL
from github import Github

class UpdateFetcher:
    def __init__(self, github_token):
        self.github = Github(github_token)

    def fetch_updates(self, repo_name):
        repo = self.github.get_repo(repo_name)
        events = repo.get_events()  # 获取仓库的事件
        return events
EOL

# 创建 notification_system.py 文件
cat > GitHubSentinel_SHY/notification/notification_system.py <<EOL
import smtplib
from config import EMAIL_HOST, EMAIL_PORT, EMAIL_USER, EMAIL_PASS, SLACK_WEBHOOK_URL
import requests

class NotificationSystem:
    def send_email(self, to_address, subject, content):
        try:
            with smtplib.SMTP(EMAIL_HOST, EMAIL_PORT) as server:
                server.starttls()
                server.login(EMAIL_USER, EMAIL_PASS)
                message = f"Subject: {subject}\n\n{content}"
                server.sendmail(EMAIL_USER, to_address, message)
        except Exception as e:
            print(f"Failed to send email: {e}")

    def send_slack_message(self, message):
        try:
            response = requests.post(SLACK_WEBHOOK_URL, json={"text": message})
            if response.status_code != 200:
                print(f"Failed to send Slack message: {response.status_code}")
        except Exception as e:
            print(f"Failed to send Slack message: {e}")
EOL

# 创建 report_generator.py 文件
cat > GitHubSentinel_SHY/report/report_generator.py <<EOL
class ReportGenerator:
    def generate_report(self, events):
        # 简单示例，汇总更新事件
        report = "GitHub Updates Report:\n\n"
        for event in events:
            report += f"- {event.type} by {event.actor.login} on {event.created_at}\n"
        return report
EOL

# 创建 scheduler.py 文件
cat > GitHubSentinel_SHY/scheduler/scheduler.py <<EOL
import schedule
import time

class Scheduler:
    def __init__(self, task):
        self.task = task

    def schedule_daily_task(self):
        schedule.every().day.at("09:00").do(self.task)
        
        while True:
            schedule.run_pending()
            time.sleep(60)
EOL

# 创建 __init__.py 文件（用于标记模块）
touch GitHubSentinel_SHY/subscription/__init__.py
touch GitHubSentinel_SHY/fetcher/__init__.py
touch GitHubSentinel_SHY/notification/__init__.py
touch GitHubSentinel_SHY/report/__init__.py
touch GitHubSentinel_SHY/scheduler/__init__.py

echo "All files and directories have been created successfully in GitHubSentinel_SHY!"
