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
