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
