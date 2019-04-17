class BaseRule:
    
    def __init__(self, rule_type, line_id, time, iterations=1, time_sleep=0):
        self.rule_type=rule_type
        self.line_id=line_id
        self.time=time
        self.iterations=iterations
        self.time_sleep=time_sleep
    
    @property
    def duration(self):
        return iterations * time + (iterations - 1) * time_sleep

    def to_dict(self):
        return dict(rule_type=self.rule_type,
            line_id=self.line_id,
            time=self.time,
            iterations=self.iterations,
            time_sleep=self.time_sleep,
            )
