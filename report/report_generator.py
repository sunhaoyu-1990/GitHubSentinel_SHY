class ReportGenerator:
    def generate_report(self, events):
        # 简单示例，汇总更新事件
        report = "GitHub Updates Report:\n\n"
        for event in events:
            report += f"- {event.type} by {event.actor.login} on {event.created_at}\n"
        return report
