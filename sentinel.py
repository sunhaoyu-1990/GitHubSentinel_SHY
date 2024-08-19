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
