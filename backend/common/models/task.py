class Task:
    def __init__(self, id, rule_id, line_id, device_id, action, exec_time, state=""):
        self.id = id
        self.rule_id = rule_id
        self.line_id = line_id
        self.device_id = device_id
        self.action = action
        self.exec_time = exec_time
        self.state = state

    def to_json(self):
        return dict(
            id=self.id,
            rule_id=self.rule_id,
            line_id=self.line_id,
            device_id=self.device_id,
            action=self.action,
            exec_time=self.exec_time,
            state=self.state,
        )

    serialize = to_json
