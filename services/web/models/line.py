class Line:
    @classmethod
    def _get_line_next_task(cls, device_id):
        """
        Return first rule to execute
        :param device_id:
        :return: array of further tasks
        """
        q = """
            SELECT * from rules_line
            WHERE exec_time > now()
            AND device_id = %(device_id)s
            ORDER BY exec_time ASC
            LIMIT 1
            """

        records = Db.execute(query=q, params={"device_id": device_id}, method='fetchone')

        tasks = list()
        for rec in records:
            tasks.append(rec)

        tasks.sort(key=lambda e: e["exec_time"])
        return tasks

    def __init__(self, id, name, description, relay_num, settings, state=-1):
        self.id = id
        self.name = name
        self.description = description
        self.settings = settings
        self.relay_num = relay_num
        self.state = state

        self.tasks = dict(desired_state=-1)
        self._init_task()

    def _init_task(self):
        records = Line._get_line_next_task(device_id=self.id)

        for rec in records:
            self.tasks = Task(**rec)

        return self


    def to_json(self):
        return {
            "id": self.id,
            "name": self.name,
            "description": self.description,
            "settings": self.settings,
            "relay_num": self.relay_num,
            "state": self.state,
        }

    serialize = to_json
